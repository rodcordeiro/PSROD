Function Get-RandomSecret {
    [Convert]::ToBase64String((1..64|%{[byte](Get-Random -Max 256)}))
}
