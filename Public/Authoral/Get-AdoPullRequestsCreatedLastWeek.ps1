
function Get-AdoPullRequestsCreatedLastWeek {
    <#
.SYNOPSIS
Obtém pull requests criados em repositórios do Azure DevOps dentro de uma janela recente.

.PARAMETER Organization
Nome da organização no Azure DevOps.

.PARAMETER Project
Nome do projeto no Azure DevOps.

.PARAMETER Repositories
Lista de repositórios que serão consultados.

.PARAMETER Pat
Personal Access Token usado na autenticação Basic. Por padrão, usa a variável de ambiente PAT.

.PARAMETER Status
Status dos pull requests retornados: all, active, completed ou abandoned.

.PARAMETER DaysBack
Quantidade de dias retroativos usada para calcular a data mínima de criação.

.OUTPUTS
PSCustomObject com repositório, identificador, título, descrição, status, autor, data de criação, branches e URL do pull request.
#>
    [CmdletBinding()]
    param(
        [Parameter(Mandatory)]
        [string] $Organization,
        [Parameter(Mandatory)]
        [string] $Project,
        [Parameter(Mandatory)]
        [string[]] $Repositories,
        [string] $Pat = $env:PAT,
        [ValidateSet('all', 'active', 'completed', 'abandoned')]
        [string] $Status = 'all',
        [int] $DaysBack = 7
    )
    if ([string]::IsNullOrWhiteSpace($Pat)) {
        throw "Informe o PAT via -Pat ou variável de ambiente PAT."
    }
    $token = [Convert]::ToBase64String([Text.Encoding]::ASCII.GetBytes(":$Pat"))
    $headers = @{ Authorization = "Basic $token"; Accept = "application/json" }
    $since = (Get-Date).AddDays(-$DaysBack).ToUniversalTime().ToString("o")
    foreach ($repo in $Repositories) {
        $skip = 0
        $top = 100
        do {
            $query = @{
                "api-version"                       = "7.1"
                "searchCriteria.status"             = $Status
                "searchCriteria.minTime"            = $since
                "searchCriteria.queryTimeRangeType" = "Created"
                "`$top"                             = $top
                "`$skip"                            = $skip
            }
            $queryString = ($query.GetEnumerator() | ForEach-Object {
                    "{0}={1}" -f [uri]::EscapeDataString($_.Key), [uri]::EscapeDataString([string]$_.Value)
                }) -join "&"

            $repoEncoded = [uri]::EscapeDataString($repo)
            $projectEncoded = [uri]::EscapeDataString($Project)
            $uri = "https://dev.azure.com/$Organization/$projectEncoded/_apis/git/repositories/$repoEncoded/pullrequests?$queryString"

            $response = Invoke-RestMethod -Method Get -Uri $uri -Headers $headers

            foreach ($pr in $response.value) {
                [pscustomobject]@{
                    Repository    = $repo
                    PullRequestId = $pr.pullRequestId
                    Title         = $pr.title
                    Description   = $pr.description
                    Status        = $pr.status
                    CreatedBy     = $pr.createdBy.displayName
                    CreationDate  = [datetime]$pr.creationDate
                    SourceBranch  = $pr.sourceRefName -replace '^refs/heads/', ''
                    TargetBranch  = $pr.targetRefName -replace '^refs/heads/', ''
                    Url           =
                    "https://dev.azure.com/$Organization/$project/_git/$repo/pullrequest/$($pr.pullRequestId)"
                }
            }

            $skip += $top
        } while ($response.value.Count -eq $top)
    }
}