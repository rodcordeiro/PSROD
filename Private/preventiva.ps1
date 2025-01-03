﻿[Console]::OutputEncoding = [System.Text.Encoding]::UTF8

# Verificar se a pasta de preventiva existe
# Verificar se os arquivos estão na pasta
# Executar
class Manutencao {

    hidden [void]clear_folder([string]$folder) {
        Get-ChildItem  $folder | ForEach-Object { Remove-Item "$($folder)\$($_)" -Force -Recurse | Out-Null }
        Remove-Item $folder -Force -Recurse | Out-Null
        New-Item -ItemType Directory $folder | Out-Null
    }
    hidden [void]delete_folder([string]$folder) {
        Get-ChildItem  $folder | ForEach-Object {
            Remove-Item "$($folder)\$($_)" -Force -Recurse | Out-Null
        }
        Remove-Item $folder -Force -Recurse | Out-Null
    }

    [void]ClearDisk() {
        Write-Log -Message 'Clearing CleanMgr.exe automation settings.'

        $getItemParams = @{
            Path        = 'HKLM:\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer\VolumeCaches\*'
            Name        = 'StateFlags0001'
            ErrorAction = 'SilentlyContinue'
        }
        Get-ItemProperty @getItemParams | Remove-ItemProperty -Name StateFlags0001 -ErrorAction SilentlyContinue

        $enabledSections = @(
            'Active Setup Temp Folders'
            'BranchCache'
            'Content Indexer Cleaner'
            'Device Driver Packages'
            'Downloaded Program Files'
            'GameNewsFiles'
            'GameStatisticsFiles'
            'GameUpdateFiles'
            'Internet Cache Files'
            'Memory Dump Files'
            'Offline Pages Files'
            'Old ChkDsk Files'
            'Previous Installations'
            'Recycle Bin'
            'Service Pack Cleanup'
            'Setup Log Files'
            'System error memory dump files'
            'System error minidump files'
            'Temporary Files'
            'Temporary Setup Files'
            'Temporary Sync Files'
            'Thumbnail Cache'
            'Update Cleanup'
            'Upgrade Discarded Files'
            'User file versions'
            'Windows Defender'
            'Windows Error Reporting Archive Files'
            'Windows Error Reporting Queue Files'
            'Windows Error Reporting System Archive Files'
            'Windows Error Reporting System Queue Files'
            'Windows ESD installation files'
            'Windows Upgrade Log Files'
        )

        Write-Verbose -Message 'Adding enabled disk cleanup sections...'
        foreach ($keyName in $enabledSections) {
            $newItemParams = @{
                Path         = "HKLM:\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer\VolumeCaches\$keyName"
                Name         = 'StateFlags0001'
                Value        = 1
                PropertyType = 'DWord'
                ErrorAction  = 'SilentlyContinue'
            }
            $null = New-ItemProperty @newItemParams
        }

        Write-Verbose -Message 'Starting CleanMgr.exe...'
        Start-Process -FilePath CleanMgr.exe -ArgumentList '/sagerun:1 /d C' -NoNewWindow -Wait

        Write-Verbose -Message 'Waiting for CleanMgr and DismHost processes...'
        Get-Process -Name cleanmgr, dismhost -ErrorAction SilentlyContinue | Wait-Process
        Optimize-Volume -ReTrim -Defrag -SlabConsolidate -TierOptimize -DriveLetter C

    }


    [void]cleaner() {
        $this.delete_folder("$($Env:SystemRoot)\temp")
        $this.delete_folder("$($Env:SystemRoot)\Prefetch")
        $this.delete_folder($Env:TEMP)
        $this.delete_folder("$($Env:SystemRoot)\tempor~1")# rd /s /q $($Env:SystemRoot)\tempor~1
        $this.delete_folder("$($Env:SystemRoot)\tmp")
        $this.delete_folder("c:\ff*.tmp")
        $this.delete_folder("$($Env:SystemRoot)\history")
        $this.delete_folder("$($Env:SystemRoot)\cookies")
        $this.delete_folder("$($Env:SystemRoot)\recent")
        $this.delete_folder("$($Env:SystemRoot)\spool\printers")
        $this.delete_folder("$($Env:SystemRoot)\repair")
        $this.delete_folder("$($Env:SystemRoot)\system32\dllcache") # rd /s /q c:\windows\system32\dllcache
        $this.delete_folder("C:\MSOCache") # rd /s /q c:\MSOCache
        # rd /s /q c:\windows\Installer
        $this.delete_folder("$($Env:SystemRoot)\system32\ReinstallBackups")# rd /s /q c:\windows\system32\ReinstallBackups
        $this.delete_folder("C:\WIN386.SWP") # del c:\WIN386.SWP
        if (Test-Path -Path "$($env:APPDATA)\*.zip") {
            Remove-Item "$($env:APPDATA)\*.zip" -Force -Recurse | Out-Null
        }
        if (Test-Path -Path "$($env:APPDATA)\*.exe") {
            Remove-Item "$($env:APPDATA)\*.exe" -Force -Recurse | Out-Null
        }
        if (Test-Path -Path "$($env:APPDATA)\*.gif") {
            Remove-Item "$($env:APPDATA)\*.gif" -Force -Recurse | Out-Null
        }
        if (Test-Path -Path "$($env:APPDATA)\*.jpg") {
            Remove-Item "$($env:APPDATA)\*.jpg" -Force -Recurse | Out-Null
        }
        if (Test-Path -Path "$($env:APPDATA)\*.png") {
            Remove-Item "$($env:APPDATA)\*.png" -Force -Recurse | Out-Null
        }
        if (Test-Path -Path "$($env:APPDATA)\*.jpeg") {
            Remove-Item "$($env:APPDATA)\*.jpeg" -Force -Recurse | Out-Null
        }
        if (Test-Path -Path "$($env:APPDATA)\*.bmp") {
            Remove-Item "$($env:APPDATA)\*.bmp" -Force -Recurse | Out-Null
        }
        if (Test-Path -Path "$($env:APPDATA)\*.avi") {
            Remove-Item "$($env:APPDATA)\*.avi" -Force -Recurse | Out-Null
        }
        if (Test-Path -Path "$($env:APPDATA)\*.mpg") {
            Remove-Item "$($env:APPDATA)\*.mpg" -Force -Recurse | Out-Null
        }
        if (Test-Path -Path "$($env:APPDATA)\*.mpeg") {
            Remove-Item "$($env:APPDATA)\*.mpeg" -Force -Recurse | Out-Null
        }
        if (Test-Path -Path "$($env:APPDATA)\*.m4a") {
            Remove-Item "$($env:APPDATA)\*.m4a" -Force -Recurse | Out-Null
        }
        if (Test-Path -Path "$($env:APPDATA)\*.ra") {
            Remove-Item "$($env:APPDATA)\*.ra" -Force -Recurse | Out-Null
        }
        if (Test-Path -Path "$($env:APPDATA)\*.ram") {
            Remove-Item "$($env:APPDATA)\*.ram" -Force -Recurse | Out-Null
        }
        if (Test-Path -Path "$($env:APPDATA)\*.mp3") {
            Remove-Item "$($env:APPDATA)\*.mp3" -Force -Recurse | Out-Null
        }
        if (Test-Path -Path "$($env:APPDATA)\*.mov") {
            Remove-Item "$($env:APPDATA)\*.mov" -Force -Recurse | Out-Null
        }
        if (Test-Path -Path "$($env:APPDATA)\*.qt") {
            Remove-Item "$($env:APPDATA)\*.qt" -Force -Recurse | Out-Null
        }
        if (Test-Path -Path "$($env:APPDATA)\*.asf") {
            Remove-Item "$($env:APPDATA)\*.asf" -Force -Recurse | Out-Null
        }
        if (Test-Path -Path "$($env:APPDATA)\*.mp4") {
            Remove-Item "$($env:APPDATA)\*.mp4" -Force -Recurse | Out-Null
        }
        if (Test-Path -Path "$($env:APPDATA)\*.rar") {
            Remove-Item "$($env:APPDATA)\*.rar" -Force -Recurse | Out-Null
        }
        if (Test-Path -Path "$($Env:SystemRoot)\ff*.tmp") {
            Remove-Item "$($Env:SystemRoot)\ff*.tmp" -Force -Recurse | Out-Null
        }
        if (Test-Path -Path "$($Env:SystemRoot)\ShellIconCache") {
            $this.delete_folder("$($Env:SystemRoot)\ShellIconCache")
        }

        # Limpar a lixeira
        Clear-RecycleBin -Force
        $this.ClearDisk()
    }

    [void]Repair() {
        Write-Output 'Starting DISM command with arguments: /Online /Cleanup-image /Restorehealth'
        DISM.exe /Online /Cleanup-image /Restorehealth
        Write-Output 'Starting SFC command with arguments: /scannow'
        sfc /scannow
        Write-Output 'Finished repair.'
    }

    [void]DiskEvents() {
        $DiskDiagnosticOperational = $(Get-WinEvent -ListLog Microsoft-Windows-DiskDiagnostic/Operational  | Select-Object LogName, RecordCount, IsClassicLog, IsEnabled, LogMode, LogType)
        $DiskDiagnosticDataCollector = $(Get-WinEvent -ListLog Microsoft-Windows-DiskDiagnosticDataCollector/Operational  | Select-Object LogName, RecordCount, IsClassicLog, IsEnabled, LogMode, LogType)
        $DiskDiagnosticResolver = $(Get-WinEvent -ListLog Microsoft-Windows-DiskDiagnosticResolver/Operational  | Select-Object LogName, RecordCount, IsClassicLog, IsEnabled, LogMode, LogType)

        if ($DiskDiagnosticOperational.RecordCount -gt 0) { Show-Notification -ToastTitle 'Erro de disco' -ToastText "DiskDiagnosticOperational Record count is : $($DiskDiagnosticOperational.RecordCount)" }
        if ($DiskDiagnosticDataCollector.RecordCount -gt 0) { Show-Notification -ToastTitle 'Erro de disco' -ToastText "DiskDiagnosticDataCollector Record count is : $($DiskDiagnosticDataCollector.RecordCount)" }
        if ($DiskDiagnosticResolver.RecordCount -gt 0) { Show-Notification -ToastTitle 'Erro de disco' -ToastText "DiskDiagnosticResolver Record count is : $($DiskDiagnosticResolver.RecordCount)" }
    }

    [void]Updates([Switch]$Reboot) {
        #search and list all missing Drivers
        $Session = New-Object -ComObject Microsoft.Update.Session
        $Searcher = $Session.CreateUpdateSearcher()

        Write-Host -Object 'Searching Driver-Updates...' -ForegroundColor Green
        $Criteria = "IsInstalled=0 and ISHidden=0"
        $SearchResult = $Searcher.Search($Criteria)
        $Updates = $SearchResult.Updates

        # Show available Drivers
        $Updates | Select-Object -Property Title, DriverModel, DriverVerDate, Driverclass, DriverManufacturer

        # Download the Drivers from Microsoft
        $UpdatesToDownload = New-Object -Com Microsoft.Update.UpdateColl
        $Updates | Foreach-Object -Process {
            [void]$UpdatesToDownload.Add($_)
        }
        Write-Host -Object 'Downloading Drivers...' -ForegroundColor Green
        $UpdateSession = New-Object -Com Microsoft.Update.Session
        $Downloader = $UpdateSession.CreateUpdateDownloader()
        $Downloader.Updates = $UpdatesToDownload
        $Downloader.Download()
        #Check if the Drivers are all downloaded and trigger the Installation
        $UpdatesToInstall = New-Object -Com Microsoft.Update.UpdateColl
        $updates | Foreach-Object -Process {
            if ($_.IsDownloaded) {
                [void]$UpdatesToInstall.Add($_)
            }
        }
        Write-Host -Object 'Installing Drivers...'  -ForegroundColor Green
        $Installer = $UpdateSession.CreateUpdateInstaller()
        $Installer.Updates = $UpdatesToInstall
        $InstallationResult = $Installer.Install()
        if ($InstallationResult.RebootRequired) {
            if ($Reboot) { shutdown -r -f -t 0; return }
            Write-Host -Object 'Reboot required! please reboot now..' -ForegroundColor Red

        }
        else {
            Write-Host -Object 'Done..' -ForegroundColor Green
        }
    }

}