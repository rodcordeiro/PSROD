function Update-Repos {
    
    $folders = Get-Repositories
    Discord -Avatar "https://rodcordeiro.github.io/shares/img/eu.jpg" -Username "Script do rod" -Webhook $env:DISCORD_WEBHOOK -Content "Ignorem. Estou rodando um script de atualizacao automatica dos repositorios"
    for ($i = 0; $i -le ($folders.length - 1); $i += 1) {
        $folder = $folders[$i]
        Write-Progress -Activity "Folder: $($folder.Parent).  $($i) of $($folders.length)" -Id 0
        Write-Output $Folder.Parent
        $repos = $($Folder.repos | ConvertFrom-Json)
        for ($j = 0; $j -le ($repos.length - 1); $j += 1) {
            $repo = Resolve-Path -Path "$($folder.Parent)/$($repos[$j].Alias)"
            Write-Output $repo.Alias
            Write-Progress -Activity "Repo: $($repo.Alias).  $($j) of $($repos.length)" -ParentId 0 -Id 1
            Set-Location $repo
            $git = isInsideGit
            if ($git -and $(git remote -v | Select-String 'fetch')) {
                $branches = $(git branch | select-string -NotMatch "remote")
                [string]$currentBranch = $branches.ForEach({
                        if ($_ -match '\*') {
                            $branch = $_.ToString().Split(' ')[1]
                            $branch
                        }
                    })
                Write-Output "Current Branch: $currentBranch"

                $branches | ForEach-Object {
                    if ($(git status | select-string "Changes not staged for commit") -or $(git status | select-string "Changes to be committed:")) {
                        git add .
                        git commit -m '[skip ci] Automatic repositories update'
                    }
                    git checkout $branch
                    $branch = $_.ToString().Replace(' ', '').Replace('*', '')
                    
                    git add .
                    git commit -m '[skip ci] Automatic repositories update'
                    git pull origin $branch
                    git push origin $branch
                }
                git checkout $currentBranch

                
                # UpdatePDAlib
                $git_dir = $(Split-Path -Path $(git rev-parse --show-toplevel) -Leaf)
                $git_index = $PWD.ToString().IndexOf($git_dir)
                $CmdPromptCurrentFolder = $PWD.ToString().Substring($git_index)

                Discord -Avatar "https://rodcordeiro.github.io/shares/img/eu.jpg" -Content "Atualizado o $CmdPromptCurrentFolder" -Username "Script do rod" -Webhook $env:DISCORD_WEBHOOK
            }
        }    
    }
    
    # $folders | ForEach-Object {
    #     $folder = $_
    #     $($Folder.repos | ConvertFrom-Json) | ForEach-Object {
    #         $repos = $_
    #         $repo = Resolve-Path -Path "$($folder.Parent)/$($repos.Alias)"
    #         Write-Output "Repo $repo"    
    #         Set-Location $repo
    #         $git = isInsideGit
    #         if ($git -and $(git remote -v | Select-String 'fetch')) {
    #             $branches = $(git branch | select-string -NotMatch "remote")
    #             [string]$currentBranch = $branches.ForEach({
    #                     if ($_ -match '\*') {
    #                         $branch = $_.ToString().Split(' ')[1]
    #                         $branch
    #                     }
    #                 })

    #             $branches | ForEach-Object {
    #                 if ($(git status | select-string "Changes not staged for commit") -or $(git status | select-string "Changes to be committed:")) {
    #                     git add .
    #                     git commit -m '[skip ci] Automatic repositories update'
    #                 }
    #                 git checkout $branch
    #                 $branch = $_.ToString().Replace(' ', '')
                    
    #                 git add .
    #                 git commit -m '[skip ci] Automatic repositories update'
    #                 git pull origin $branch
    #                 git push origin $branch
    #             }
    #             git checkout $currentBranch

                
    #             # UpdatePDAlib
    #             $git_dir = $(Split-Path -Path $(git rev-parse --show-toplevel) -Leaf)
    #             $git_index = $PWD.ToString().IndexOf($git_dir)
    #             $CmdPromptCurrentFolder = $PWD.ToString().Substring($git_index)

    #             Discord -Avatar "https://rodcordeiro.github.io/shares/img/eu.jpg" -Content "Atualizado o $CmdPromptCurrentFolder" -Username "Script do rod" -Webhook $env:DISCORD_WEBHOOK
    #         }
    #     }
    # }
}
