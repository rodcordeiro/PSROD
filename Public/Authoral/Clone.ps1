function clone {
    <# 
    .SYNOPSIS 
        Function to customize repositories cloning with some validations.
    .DESCRIPTION
        Function to customize repositories cloning with some validations. It validates the folder and the repository link.
    .Parameter <Path>
        Repository link
    .Parameter <Folder>
        Provides you the possibility of cloning the repository on a different folder. Pass the desired folder path.
    .Parameter <Alias>
        Provides you the possibility of changing the destiny folder name.
    .Parameter <Confirm>
        Forces execution
    .EXAMPLE
        clone https://github.com/user/repo.git
    .EXAMPLE
        clone https://github.com/user/repo.git -y
    .EXAMPLE
        clone https://github.com/user/repo.git -Folder test
    .EXAMPLE
        clone https://github.com/user/repo.git -Alias someTest
    .EXAMPLE
        clone https://github.com/user/repo.git someTest
    #>

    param(
        [parameter(ValueFromPipelineByPropertyName, HelpMessage = "Please, enter the repository link for download")][string]$Path,
        [parameter(ValueFromPipelineByPropertyName, HelpMessage = "Provides you the possibility of changing the destiny folder name.")][string]$Alias,
        [parameter(ValueFromPipelineByPropertyName, HelpMessage = "Provides you the possibility of cloning the repository on a different folder. Pass the desired folder path.")][string]$Folder,
        [parameter(HelpMessage = "Please, enter the repository link for download")][Alias('y', 'yes')][Switch] $confirm
    )

    if (!$Path) {
        Throw "You must provide a repository to clone!"
    }

    $repository = $Path
    $destiny = if ($Folder) { $Folder } else { $pwd }
    $localFolder = if ($Alias) { $Alias } else { $(Split-Path -Path $repository -Leaf) }

    $project_paths = ((Resolve-Path -Path '~/projetos').Path)
    
    if (!($destiny.Path.Contains($project_paths)) -and !$confirm) {
        $response = (Confirm-Choice -Title "You're outside of the predefined projects folders" -PromptMessage "Are you sure you want to proceed?")
        if (!$response) {
            Throw "Cancelling cloning projects. Have a nice day!"
        }
    }

        
    if ($folder) { Set-Location $(Resolve-Path -Path $Folder) }
    git clone $repository $(if ($Alias) { $Alias })
    Set-Location $(Resolve-Path -Path $localFolder)
    
}
