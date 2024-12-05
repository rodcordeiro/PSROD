Function Get-RandomSecret {
    [Convert]::ToBase64String((1..64|ForEach-Object{[byte](Get-Random -Max 256)}))
}
