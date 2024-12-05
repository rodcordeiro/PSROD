Function Read-NetworkSpeed {
    $adapter = (Get-NetAdapter | Where-Object { $_.Status -eq 'Up' })
    Show-Notification "Network Adapter" "Network $($adapter.InterfaceDescription) connected at $($adapter.LinkSpeed)"
}

Set-Alias 'Check-Network' Read-NetworkSpeed