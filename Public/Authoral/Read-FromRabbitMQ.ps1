class RabbitMessageAction {
    [string]$name;
    [string]$action;
}

class RabbitMessage {
    [string]$type;
    [string]$title;
    [datetime]$schedule;
    [string]$description;
    [RabbitMessageAction[]]$actions;
}



function Read-FromRabbitMQ {
    param(
        [parameter(ValueFromPipelineByPropertyName, Mandatory = $false)]
        [string]
        $QueueName = 'Powershell',

        [parameter(ValueFromPipelineByPropertyName, Mandatory = $false)]
        [string]
        $Exchange = "Notifications",

        [parameter(ValueFromPipelineByPropertyName, Mandatory = $false)]
        [string]
        $ExchangeType = "Direct",

        [parameter(ValueFromPipelineByPropertyName, Mandatory = $false)]
        [string]
        $RoutingKey = "notification"
    )
    begin {
        class NotificationHandler {
            [void] Handler($listener, $message) {
                if ($message.type -eq 'notification') {
                    Write-Host "[notifications][$([DateTime]::UtcNow.ToString())] " -ForegroundColor Green -NoNewline 
                    Write-Host "[$($message.title)] " -NoNewline -ForegroundColor Cyan
                    Write-Host $message.description
                    $message_params = @{
                        ToastTitle = $message.title;
                        ToastText  = $message.description;
                    }
                    if ($message.schedule.Year -ne '0001') {
                        $message_params.Add("Schedule", $message.schedule);
                    }
                    Show-Notification @message_params
                }
            }
        }

        class ActionsHandler {
            [void] Handler($listener, $message) {
               
                if ($message.type -eq 'action') {
                    $message.actions | ForEach-Object {
                        $action = $_.action
                        Write-Host "[actions][$([DateTime]::UtcNow.ToString())] " -ForegroundColor Green -NoNewline 
                        Write-Host "[$($_.name)] " -NoNewline -ForegroundColor Cyan
                        Write-Host $action 
                        $scriptBlock = [Scriptblock]::Create($action)
                        $scriptBlock.InvokeReturnAsIs() 

                    }
                }
            }
        }

        $receiver = New-Object MessagesReceiver
        $notificationHandler = New-Object NotificationHandler
        $actionsHandler = New-Object ActionsHandler
        
    }
    process {
        $handleRabbitMessage = {
            param($listener, $params)
            Write-Host $params;

            [RabbitMessage]$message = $params;

            $notificationHandler.Handler($listener, $message)
            $actionsHandler.Handler($listener, $message)
        }

        $receiver.RegisterObserver($handleRabbitMessage)

        $receiver.Listen(
            $QueueName,
            $Exchange,
            $ExchangeType,
            $RoutingKey
        )
    }
}

Set-Alias rabbit Read-FromChat
