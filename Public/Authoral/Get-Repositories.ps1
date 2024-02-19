


function Get-Repositories {
    param([Switch]$AsJson)
    $CurrentLocation = $PWD
    $projectFolders = $(Get-ChildItem -Path "~/projetos" -depth 0 -Recurse)
    $repos = $($projectFolders | ForEach-Object {
            $f = $_
            $folders = $(Get-ChildItem -Path "~/projetos/$_" -depth 0 -Recurse) | ForEach-Object { "~/projetos/$f/$_" }
            $repositories = @()
            $folders | ForEach-Object {
                $folder = $_
                Set-Location $folder
                $git = isInsideGit
                if ($(git remote -v | Select-String 'fetch')) {
                    $remote = $($(git remote -v | Select-String 'fetch').ToString().split('')[1])
                    $branches = $(git branches | select-string -Pattern "  remotes")
                    $result = [Repository]::new()
                    # $result = [Repository]@{
                    #     "repo"     = "$remote";
                    #     "branches" = @($branches | select-string -Pattern "HEAD" -NotMatch | ForEach-Object { $_.ToString().Replace("  remotes/origin/", '') });
                    #     "alias"    = "$(Split-Path -Path $(Resolve-Path -Path $folder) -Leaf)"
                    # }
        
                    $result.repo = "$remote";
                    $result.branches = @($branches | select-string -Pattern "HEAD" -NotMatch | ForEach-Object { $_.ToString().Replace("  remotes/origin/", '') });
                    $result.alias = "$(Split-Path -Path $(Resolve-Path -Path $folder) -Leaf)"

                    $repositories += $result
                }
            }
            # $data = [Repositories]@{
            #     "Parent" = "~/projetos/$_";
            #     "repos"  = $($repositories | ConvertTo-Json)
            # }
            $folderRepos = [Repositories]::new()
            $folderRepos.Parent = "~/projetos/$_";
            $folderRepos.repos = $repositories
            $folderRepos
            # $data
        })
    Set-Location $CurrentLocation
    if ($AsJson) {
        $repos | ConvertTo-Json -Depth 6
    }
    else {
        $repos
    }
}