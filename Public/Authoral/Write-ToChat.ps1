class ChatAuthor {
    [string]$username;
    [AllowNull()][string]$avatar_url;
}

class ChatMessage {
    [string]$content;
    [datetime]$createdAt;
    [ChatAuthor]$author;
}
function Write-ToChat {
    [CmdletBinding()]
    param(
        [Parameter(Mandatory = $true, ValueFromRemainingArguments)]
        [string]$content
    )
    begin {
        [ChatAuthor]$author = [ChatAuthor]::new()
        $author.username = $env:RabbitMQ_User
        $strPass = ConvertTo-SecureString -String $env:RabbitMQ_Password -AsPlainText -Force
        $Cred = New-Object -TypeName System.Management.Automation.PSCredential -ArgumentList ($env:RabbitMQ_User, $strPass)

        New-RabbitMqConnectionFactory -ComputerName 82.180.136.148 -Credential $Cred -Port 3340 | Out-Null
    }
    process {
        
        $message = [pscustomobject]@{
            content   = [String]::Join(", ", $content).Trim();
            createdAt = [datetime]::Now.ToUniversalTime();
            author    = [pscustomobject]@{
                username   = $author.username;
                avatar_url = Get-Random -InputObject @(
                    $PSScriptRoot.ToString().Replace("\Public\Authoral", "\assets\psyduck.webp"),
                    $PSScriptRoot.ToString().Replace("\Public\Authoral", "\assets\attack.png"),
                    $PSScriptRoot.ToString().Replace("\Public\Authoral", "\assets\GrimReaper.png")
                );
            }
        }

        Send-RabbitMQMessage -Exchange Chat -Key 'chat_communication' -InputObject $($message | ConvertTo-Json -depth 10 -Compress ) -Credential $Cred -ComputerName 82.180.136.148 -Port 3340
    }
}

Set-Alias speak Write-ToChat