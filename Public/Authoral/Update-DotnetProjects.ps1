# Update one project packages
function Update-DotnetPackages {
    param (
        [string]
        [parameter(ValueFromPipelineByPropertyName, Mandatory = $true)]
        $project
    )

    $return = $false

    # Get outdated packages
    $packageLineList = dotnet list $project package --outdated

    foreach ($line in $packageLineList) {
        Write-Host $line

        $match = $line -match '>\s(\S*)\s*\S*\s*\S*\s*(\S*)'
        if (!$match) {
            # the line doesn't contain a package information, continue
            continue
        }

        $added = dotnet add $project package $Matches.1 --version $Matches.2
        if ($? -ne 0) {
            # error while updating the package
            Write-Error "dotnet add $project package $($Matches.1) --version $($Matches.2) exit with code $($?)"
            Write-Host $added
            break
        }

        $return = $true
    }

    return $return
}

function Update-DotnetProjects {

    begin {
        # Restore dependencies
        dotnet restore --interactive  
        $updated = $false
    }

    process {

        # Get all project list in the solution
        $projectList = dotnet sln list

        foreach ($path in $projectList) {
            if ($path -eq "Projetos" -or $path -eq "--------") {
                # The line doesn't contain a path, continue
                continue
            }

            $path
            # Update project dependencies
            $projectUpdated = Update-DotnetPackages -project $path

            if ($LASTEXITCODE -ne 0) {
                #The update fail, exit
                throw
                # exit $LASTEXITCODE
            }

            $updated = $updated -or $projectUpdated
        }

        if (!$updated) {
            # No packages to update found, exit
            Write-Host "Nothing to update"
        }
    }
}