#requires -Version 2.0 -Modules PowerShellGet
function Remove-OldModule {
    <#
.SYNOPSIS
    This function removes old versions of PowerShell modules which are installed.

.EXAMPLE
        Remove-OldModules

.NOTES
    # Get the latest version of all installed modules
    authors: [Luke] Murray (Luke.Geek.NZ)
    Version: 0.1
    Purpose: Basic function to remove old PowerShell modules which are installed
    url: https://luke.geek.nz/2021/06/18/remove-old-powershell-modules-versions-using-powershell/
#>


    $Latest = Get-InstalledModule
    foreach ($module in $Latest) {

        Write-Verbose -Message "Uninstalling old versions of $($module.Name) [latest is $( $module.Version)]" -Verbose
        Get-InstalledModule -Name $module.Name -AllVersions | Where-Object { $_.Version -ne $module.Version } | Uninstall-Module -Verbose
    }
}
