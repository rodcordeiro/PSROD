#https://stackoverflow.com/questions/73000957/powershell-form-to-convert-string-to-base64-and-back-and-write-to-file

Function ConvertTo-B64 {
    param(
        [parameter(ValueFromPipelineByPropertyName)]
        [ValidateNotNullOrEmpty()]
        [String]$Content
    )
    # write-param
    $encoded = [Convert]::ToBase64String([System.Text.Encoding]::Unicode.GetBytes($Content))
    return  $encoded

}
Function ConvertFrom-B64 {
    param(
        [parameter(ValueFromPipelineByPropertyName)]
        [ValidateNotNullOrEmpty()]
        [String]$Content
    )
    $encoded = [System.Text.Encoding]::ASCII.GetString([System.Convert]::FromBase64String($Content))
    return  $encoded

}
