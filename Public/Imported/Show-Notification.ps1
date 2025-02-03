function Show-Notification {
    [cmdletbinding()]
    Param (
        [string] $ToastTitle = "Powershell",
        [string] [parameter(ValueFromPipeline)] $ToastText = "Powershell, Uma notificação do",
        [datetime] [parameter(ValueFromPipeline, Mandatory = $false)] $Schedule,
        [string] [parameter(ValueFromPipeline, Mandatory = $false)] $IconUri,
        [string] [parameter(ValueFromPipeline, Mandatory = $false)] $Group = "Powershell",
        [string] [parameter(ValueFromPipeline, Mandatory = $false)] $Tag = "Powershell"
    )

    try {
        $TempImagePath = ""

        # Se for uma URL remota, baixa a imagem localmente
        if ($IconUri -match "^https?:\/\/") {
            $TempImagePath = "$env:TEMP\toast_image.png"
            try {
                Invoke-WebRequest -Uri $IconUri -OutFile $TempImagePath -ErrorAction Stop
                $IconUri = "file:///$($TempImagePath -replace '\\', '/')"
                Write-Output " Imagem remota baixada para: $TempImagePath"
            }
            catch {
                Write-Output " Erro ao baixar a imagem remota: $_.Message"
                $IconUri = ""
            }
        }
        # Definição da imagem padrão local
        if (-not $IconUri) {
            $LocalImagePath = "$PSScriptRoot\psyduck.webp".Replace("\Public\Imported\", "\assets\")
            if (Test-Path $LocalImagePath) {
                $IconUri = "file:///$($LocalImagePath -replace '\\', '/')"
            }
            else {
                Write-Output "Arquivo de imagem local não encontrado: $LocalImagePath"
            }
        }

        # Validação da URI da imagem
        if ($IconUri -and $IconUri -notmatch "^(https?:\/\/|file:\/\/\/)") {
            throw "O caminho da imagem '$IconUri' não é válido. Use um URL HTTPS ou um caminho local válido."
        }

        # Criando XML da notificação
        $ToastXml = @"
<toast activationType="protocol">
    <visual>
        <binding template='ToastGeneric'>
            <text>$ToastTitle</text>
            <text>$ToastText</text>
            <image placement='appLogoOverride' src='$IconUri' alt='Notification Icon'/>
        </binding>
    </visual>
</toast>
"@

        # Criar documento XML
        $XmlDoc = New-Object Windows.Data.Xml.Dom.XmlDocument
        $XmlDoc.LoadXml($ToastXml)

        # Criar a notificação
        if ($Schedule) {
            $Toast = [Windows.UI.Notifications.ScheduledToastNotification]::new($XmlDoc, $Schedule)
            $Toast.Id = 'scheduled_toast'
        }
        else {
            $Toast = [Windows.UI.Notifications.ToastNotification]::new($XmlDoc)
        }

        $Toast.Tag = $Tag
        $Toast.Group = $Group
        $Toast.ExpirationTime = [DateTimeOffset]::Now.AddMinutes(1)

        # Criar e exibir a notificação
        $Notifier = [Windows.UI.Notifications.ToastNotificationManager]::CreateToastNotifier($Group)
        if ($Schedule) {
            $Notifier.addToSchedule($Toast)
        }
        else {
            $Notifier.Show($Toast)
        }
    }
    catch {
        Write-Error " Erro ao enviar a notificação: $_"
    }
}
