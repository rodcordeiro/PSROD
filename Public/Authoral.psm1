$Scripts = @( Get-ChildItem -Path $PSScriptRoot\Public\Authoral\*.ps1 -ErrorAction SilentlyContinue -Recurse )
$FoundErrors = @(Foreach ($Import in @($Private + $Public )) {
        #+ $Classes + $Enums
        Try {
            . $Import.Fullname
        }
        Catch {
            Write-Error -Message "Failed to import functions from $($import.Fullname): $_"
            $true
        }
    }
    if ($FoundErrors.Count -gt 0) {
        $ModuleName = (Get-ChildItem $PSScriptRoot\*.psd1).BaseName
        Write-Warning "Importing module $ModuleName failed. Fix errors before continuing."
        break
    })

Export-ModuleMember -Function '*' -Alias '*'