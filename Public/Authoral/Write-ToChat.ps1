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
        $Cred = Get-StoredCredential -Target "RABBITMQ"
        if (-not $Cred) {
            $Cred = Get-Credential
            New-StoredCredential -Target "RABBITMQ" -UserName $Cred.UserName -Password $Cred.GetNetworkCredential().Password -Persist LocalMachine
        }

        [ChatAuthor]$author = [ChatAuthor]::new()
        $author.username = $Cred.UserName

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