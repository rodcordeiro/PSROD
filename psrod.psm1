[Console]::OutputEncoding = [System.Text.Encoding]::UTF8

$AuthoralFunctions = Get-ChildItem -Path "$PSScriptRoot\Public\Authoral" -Filter *.ps1
$ImportedFunctions = Get-ChildItem -Path "$PSScriptRoot\Public\Imported" -Filter *.ps1
$Private = Get-ChildItem -Path "$PSScriptRoot\Private" -Filter *.ps1
$AssemblyFolders = Get-ChildItem -Path $PSScriptRoot\Lib -Directory -ErrorAction SilentlyContinue

Add-Type -AssemblyName PresentationCore, PresentationFramework

if ($AssemblyFolders.BaseName -contains 'Standard') {
    $Assembly = @( Get-ChildItem -Path $PSScriptRoot\Lib\Standard\*.dll -ErrorAction SilentlyContinue )
}
else {
    if ($PSEdition -eq 'Core') {
        $Assembly = @( Get-ChildItem -Path $PSScriptRoot\Lib\Core\*.dll -ErrorAction SilentlyContinue )
    }
    else {
        $Assembly = @( Get-ChildItem -Path $PSScriptRoot\Lib\Default\*.dll -ErrorAction SilentlyContinue )
    }
}

$FoundErrors = @(
    Foreach ($Import in @($Assembly)) {
        try {
            Add-Type -Path $Import.Fullname -ErrorAction Stop
        }
        catch [System.Reflection.ReflectionTypeLoadException] {
            Write-Warning "Processing $($Import.Name) Exception: $($_.Exception.Message)"
            $LoaderExceptions = $($_.Exception.LoaderExceptions) | Sort-Object -Unique
            foreach ($E in $LoaderExceptions) {
                Write-Warning "Processing $($Import.Name) LoaderExceptions: $($E.Message)"
            }
            $true
            #Write-Error -Message "StackTrace: $($_.Exception.StackTrace)"
        }
        catch {
            Write-Warning "Processing $($Import.Name) Exception: $($_.Exception.Message)"
            $LoaderExceptions = $($_.Exception.LoaderExceptions) | Sort-Object -Unique
            foreach ($E in $LoaderExceptions) {
                Write-Warning "Processing $($Import.Name) LoaderExceptions: $($E.Message)"
            }
            $true
            #Write-Error -Message "StackTrace: $($_.Exception.StackTrace)"
        }
    }
    #Dot source the files
    Foreach ($Import in @($AuthoralFunctions + $ImportedFunctions + $Private)) {
        Try {
            . $Import.Fullname
        }
        Catch {
            Write-Error -Message "Failed to import functions from $($import.Fullname): $_"
            $true
        }
    }
)

if ($FoundErrors.Count -gt 0) {
    $ModuleName = (Get-ChildItem $PSScriptRoot\*.psd1).BaseName
    Write-Warning "Importing module $ModuleName failed. Fix errors before continuing."
    break
}

# Export-ModuleMember -Function (($AuthoralFunctions + $ImportedFunctions) | ForEach-Object { $_.BaseName }) -Alias '*'
Export-ModuleMember -Function (Get-ChildItem -Path "$PSScriptRoot\Public\Authoral" -Filter *.ps1 | ForEach-Object { $_.BaseName }) -Alias '*'
Export-ModuleMember -Function (Get-ChildItem -Path "$PSScriptRoot\Public\Imported" -Filter *.ps1 | ForEach-Object { $_.BaseName }) -Alias '*'

