
function Notify {
    <#
    .SYNOPSIS
        Shows a notification
    .DESCRIPTION
        Shows a notification modal on terminal, allowing to use as alert.
    .Parameter <Title>
        The modal title
    .Parameter <Message>
        The modal message
    .Parameter <Quiet>
        Allows to run silently
    .EXAMPLE
        notify -Title "Title" -Message "Some usefull message"
    .EXAMPLE
        notify -Title Title -Message Usefull_message
    .EXAMPLE
        notify Title "Some usefull message"
    #>

    param(
        [parameter(ValueFromPipelineByPropertyName, HelpMessage = "Please, enter the message title")][string]$Title,
        [parameter(ValueFromPipelineByPropertyName, HelpMessage = "Please, inform the message")][string]$Message,
        [parameter(HelpMessage = "Allows to run quietly")][Alias('s', 'q')][Switch]$Quiet
        # [parameter(ValueFromPipelineByPropertyName, HelpMessage = "Please, inform the notification type")][ValidateSet("Warning", "Info", "Error")][string]$Type
    )
    Begin {

        [void][Reflection.Assembly]::LoadWithPartialName('Microsoft.VisualBasic')
    }
    Process {

        if (!$Title) {
            $Title = "Alerta !!"
        }
        if (!$Message) {
            $Message = "Terminei algo!"
        }


        #$msgBody = "Reboot the computer now?"
        # $msgTitle = "Confirm Reboot"
        # $msgButton = 'YesNoCancel'
        # $msgImage = 'Question'
        # $Result = [System.Windows.MessageBox]::Show($msgBody,$msgTitle,$msgButton,$msgImage)
        # Write-Host "The user chose: $Result [" ($result).value__ "]"
        if (-not $Quiet) {
            # [console]::beep(440, 1000)
            (New-Object System.Media.SoundPlayer "C:\Windows\Media\chimes.wav").Play()
        }

        [System.Windows.MessageBox]::Show($Message, $Title, 0, 0)

    }
}
