<#
 .DESCRIPTION
  Here lies the functions that I'm not the author but they're really usefull on my daily activities,
  or just for some interesting works. Some of them I remembered to keep the author name/url.
  Sorry for those who I didn't credited enough.
#>
$Scripts = @( Get-ChildItem -Path $PSScriptRoot\Public\Imported\*.ps1 -ErrorAction SilentlyContinue -Recurse )
$FoundErrors = @(Foreach ($Import in $Scripts) {
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