<#
.SYNOPSIS
Consulta o status de uma execução de pipeline no Azure DevOps até que ela seja concluída.

.PARAMETER ExecutionUrl
URL da execução do pipeline no Azure DevOps, contendo o buildId na rota de resultados.

.OUTPUTS
PSCustomObject com identificador da build, status, resultado, horário de entrada na fila, início e término.

.NOTES
Usa a variável de ambiente PAT para autenticação Basic na API de builds do Azure DevOps.
#>
function Get-AdoPipelineStatus {
    [CmdletBinding()]
    param (
        [Parameter(Mandatory = $true)]
        [string]$ExecutionUrl
    )
    $run = $true;
    while ($run) {
        try {
            if ($ExecutionUrl -match "https:\/\/dev\.azure\.com\/([^\/]+)\/([^\/]+)\/_build\/results\?buildId=(\d+)") {
                $org = $matches[1]
                $project = $matches[2]
                $buildId = $matches[3]
            }
            else {
                throw "Invalid Azure DevOps pipeline URL format."
            }
            $apiUrl = "https://dev.azure.com/$org/$project/_apis/build/builds/$($buildId)?api-version=7.0"
            $encodedPAT = [Convert]::ToBase64String([Text.Encoding]::ASCII.GetBytes(":$($env:PAT)"))
            $headers = @{
                "Authorization" = "Basic $encodedPAT"
            }
            $response = Invoke-RestMethod -Uri $apiUrl -Headers $headers -Method Get
            $payload = [PSCustomObject]@{
                BuildId    = $response.id
                Status     = $response.status
                Result     = $response.result
                QueueTime  = $response.queueTime
                StartTime  = $response.startTime
                FinishTime = $response.finishTime
            }

            if ($response.status -eq 'completed') {
                $run = $false
                return $payload
            }
            timer 30
        }
        catch {
            Write-Error "Failed to retrieve pipeline status: $($_.Exception.Message)"
            $run = $false
        }
    }
}