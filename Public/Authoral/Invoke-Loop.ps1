function Invoke-Loop {
    param(
        [int]$seconds,
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