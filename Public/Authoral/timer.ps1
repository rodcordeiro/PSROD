function Timer {
    param(
        [parameter(ValueFromPipelineByPropertyName)]
        [ValidateNotNullOrEmpty()]
        [Int]
        $Time
    )
    Begin{
        # $PSStyle.Progress.View = 'Minimal'
    }
    Process{
        for ($i = 1; $i -le $Time; $i++ ) {
            Write-Progress -Activity "Waiting timer" -SecondsRemaining $($Time - $i)
            Start-Sleep -Milliseconds 1000
        }
    }
}