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
            [void] Handler($listener, $params) {

                [RabbitMessage]$message = $params;
                # Write-Host "Running $($listener.Running)"
                if ($message.type -eq 'notification') {
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
            [void] Handler($listener, $params) {
                [RabbitMessage]$message = $params;
                if ($message.type -eq 'action') {
                    $message.actions | ForEach-Object {
                        $action = $_.action
                        $scriptBlock = [Scriptblock]::Create($action)
                        $scriptBlock.Invoke()
                    }
                }
            }
        }

        $receiver = New-Object MessagesReceiver
        $notificationHandler = New-Object NotificationHandler
        $actionsHandler = New-Object ActionsHandler
        if ($null -eq $env:RabbitMQ_User) {
            throw "Voce deve criar as variaveis de usuario e senha da conexao ao rabbit no seu perfil powershell antes de utilizar este commando!

            Crie as variaves abaixo:
            [string]$env:RabbitMQ_User = 'username'
            [string]$env:RabbitMQ_Password = 'userpassword'
            "
        }
    }
    process {
        $handleRabbitMessage = {
            param($listener, $params)

            $notificationHandler.Handler($listener, $params)
            $actionsHandler.Handler($listener, $params)
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
