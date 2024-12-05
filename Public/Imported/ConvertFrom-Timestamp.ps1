function ConvertFrom-Timestamp {
    param (
        [String]$unixTimeStamp,
        [Alias('V')][Switch]$Verbose
    )
    $epochStart = Get-Date 01.01.1970
    $millisStamp = ($epochStart + ([System.TimeSpan]::frommilliseconds($unixTimeStamp))).ToLocalTime()
    $millisStampOutput = $millisStamp.ToString("yyyy-MM-dd HH:mm:ss.ffffff")
    # $millisStampClipboard = $millisStamp.ToString("HH:mm:ss.ffffff")
    if ($Verbose) {
        Write-Host "~~~~~~~~~~~~~~~~~~~~~~~~~~~~"
        Write-Host "Datetime: $millisStampOutput" -ForegroundColor Cyan
        # Write-Host "Clipping: $millisStampClipboard" -ForegroundColor Cyan
        Write-Host "~~~~~~~~~~~~~~~~~~~~~~~~~~~~~"
    }
    else {
        Write-Host $millisStampOutput
    }

    # $millisStampClipboard = $millisStamp.ToString("HH:mm:ss.ffffff") | clip
}
