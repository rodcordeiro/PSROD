Function Discord {
    param(
        [parameter(ValueFromPipelineByPropertyName)]
        [ValidateNotNullOrEmpty()]
        [String]$Content,
        [parameter(ValueFromPipelineByPropertyName)][String]$Username,
        [parameter(ValueFromPipelineByPropertyName)][String]$Avatar,
        [parameter(ValueFromPipelineByPropertyName)]
        [ValidateNotNullOrEmpty()]
        [String]$Webhook
    )
    Begin {
        if (!$Webhook -and !$env:DISCORD_WEBHOOK) {
            Write-Error 'No discord webhook provided. It must be passed as argument or set as environment variable DISCORD_WEBHOOK.' -ErrorAction Stop
            # $host.SetShouldExit(1)
            # Exit;
        }
    }
    Process {
        $headers = @{}
        $headers.Add("Content-Type", "application/json")
        
        $session = New-Object Microsoft.PowerShell.Commands.WebRequestSession
        
        if (!$Content) {
            $Content = "Some hello"
        }
        if (!$Avatar) {
            $Avatar = "https://rodcordeiro.github.io/shares/img/vader.png"
        }
        if (!$Username) {
            $Username = "Lord Vader"
        }
        $body = @{
            "content"    = $Content;
            "username"   = $Username;
            "avatar_url" = $Avatar
        }    
        if (!$Webhook) {
            $Webhook = $env:disc_testes
        }
    
        Invoke-WebRequest -Uri $Webhook -Method POST -Headers $headers -WebSession $session -Body "$($body | ConvertTo-Json)" -UseBasicParsing -ErrorAction SilentlyContinue
    
    }
}
