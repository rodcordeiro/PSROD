function Update-Repos {
    
    $folders = Get-Repositories
    Discord -Avatar "https://rodcordeiro.github.io/shares/img/eu.jpg" -Username "Script do rod" -Webhook $env:disc_testes -Content "Ignorem. Estou rodando um script de atualizacao automatica dos repositorios"
    $folders | ForEach-Object {
        $folder = $_
        $($Folder.repos | ConvertFrom-Json) | ForEach-Object {
            $repos = $_
            $repo = Resolve-Path -Path "$($folder.Parent)/$($repos.Alias)"
            Write-Output "Repo $repo"    
            Set-Location $repo
            $git = isInsideGit
            if ($git -and $(git remote -v | Select-String 'fetch')) {
                $branches = $(git branch | select-string -NotMatch "remote")
                $currentBranch = ''
                $branches | ForEach-Object {
                    if ($(git status | select-string "Changes not staged for commit") -or $(git status | select-string "Changes to be committed:")) {
                        git add .
                        git commit -m '[skip ci] Automatic repositories update'
                    }
                    git checkout $branch
                    $branch = $_.ToString().Replace(' ', '')
                    if ($branch -match '\*') {
                        $branch = $branch.split(" ")[1]
                        $currentBranch = $branch
                    }
                    
                    git add .
                    git commit -m '[skip ci] Automatic repositories update'
                    git pull origin 
                    git push -u origin $branch
                }
                Write-Output $currentBranch

                
                # UpdatePDAlib
                $git_dir = $(Split-Path -Path $(git rev-parse --show-toplevel) -Leaf)
                $git_index = $PWD.ToString().IndexOf($git_dir)
                $CmdPromptCurrentFolder = $PWD.ToString().Substring($git_index)

                Discord -Avatar "https://rodcordeiro.github.io/shares/img/eu.jpg" -Content "Atualizado o $CmdPromptCurrentFolder" -Username "Script do rod" -Webhook $env:disc_testes
            }
        }
    }
}
