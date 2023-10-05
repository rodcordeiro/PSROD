Function Discord {
    <#
    .SYNOPSIS
        Sends a discord message through webhook
    .DESCRIPTION
        Calls a discord wehbook, sending text content through it.
    .PARAMETER Content
        Content of the message
    .PARAMETER Username
        Username that sent the message. Defaults to: Lord Vader
    .PARAMETER Avatar
        User avatar url. Defaults to: Lord vader image.
    .EXAMPLE
        PS> ./Discord -Content 'Some hello'
    .LINK
        https://github.com/rodcordeiro/psrod
    .NOTES
        Author: Rodrigo M. Cordeiro
    #>
    param(
        [parameter(ValueFromPipelineByPropertyName)]
        [ValidateNotNullOrEmpty()]
        [String]$Content,
        [parameter(ValueFromPipelineByPropertyName)][String]$Username,
        [parameter(ValueFromPipelineByPropertyName)][String]$Avatar,
        [parameter(ValueFromPipelineByPropertyName)]
        [ValidateNotNullOrEmpty()]
        [String]$Webhook,
        [Switch]$Silent
    )
    Begin {
        if (!$Webhook -and !$env:DISCORD_WEBHOOK) {
            Write-Error 'No discord webhook provided. It must be passed as argument or set as environment variable DISCORD_WEBHOOK.' -ErrorAction Stop
            # $host.SetShouldExit(1)
            # Exit;
        }
        # if (!$Silent) {
        #     $Silent = $false
        # }
        
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
            $Webhook = $env:DISCORD_WEBHOOK
        }
    
        $request = $(Invoke-WebRequest -Uri $Webhook -Method POST -Headers $headers -WebSession $session -Body "$($body | ConvertTo-Json)" -UseBasicParsing -ErrorAction SilentlyContinue)
        
        if (!$Silent) {
            $request
        }
        
    }
}
