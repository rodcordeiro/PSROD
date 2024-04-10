function Get-Weather {
    param(
        [Switch]$Complete
    )
    Begin {
        $Endpoint = 'https://wttr.in/?lang=pt-br&format=%22%l:+%C+%t+%T\n"'
        if ($Complete) {
            $Endpoint = 'https://wttr.in/?lang=pt-br'
        }
    }
    Process {
        Invoke-RestMethod $Endpoint
    }
}