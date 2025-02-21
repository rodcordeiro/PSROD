class ChatAuthor {
    [string]$username;
    [AllowNull()][string]$avatar_url;
}

class ChatMessage {
    [string]$content;
    [datetime]$createdAt;
    [ChatAuthor]$author;
}



function Read-FromChat {
    param(
    )
    begin {
        class NotificationHandler {
            [void] Handler($listener, $params) {
                [PSCustomObject]$message = $params;

                if ($message.author.username -ne $env:RabbitMQ_User) {
                    $message_params = @{
                        ToastTitle = $message.content;
                        Group      = $message.author.username
                    }
                    if ($null -ne $message.author.avatar_url) {
                        $message_params.Add("IconUri", $message.author.avatar_url)
                    }

                    Show-Notification @message_params
                }
            }
        }

        $receiver = New-Object MessagesReceiver
        $notificationHandler = New-Object NotificationHandler
    }
    process {
        $handleRabbitMessage = {
            param($listener, $params)
            $notificationHandler.Handler($listener, $params)
        }

        $receiver.RegisterObserver($handleRabbitMessage)

        $receiver.Listen(
            "chat",
            "Chat",
            "Direct",
            "chat_communication"
        )
    }
}

Set-Alias listen Read-FromChat
