function Invoke-Loop {
    param(
        [int]$seconds = 5,
        [scriptblock]$action
    )

    if (!$action) {
        throw "Passa o script burro"
    }

    while ($true) {
        $action.Invoke()
        timer $seconds
    }
}

Set-Alias loop Invoke-Loop