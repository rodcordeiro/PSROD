function Show-Notification {
    [cmdletbinding()]
    Param (
        [string]
        $ToastTitle,
 
        [string]
        [parameter(ValueFromPipeline)]
        $ToastText,
 
        [datetime]
        [parameter(ValueFromPipeline, Mandatory = $false)]
        $Schedule,
 
        [string]
        [parameter(ValueFromPipeline, Mandatory = $false)]
        $IconUri,
 
        [string]
        [parameter(ValueFromPipeline, Mandatory = $false)]
        $Group = "Powershell",
 
        [string]
        [parameter(ValueFromPipeline, Mandatory = $false)]
        $Tag = "Powershell"
    )

    # https://den.dev/blog/powershell-windows-notification/
    [Windows.UI.Notifications.ToastNotificationManager, Windows.UI.Notifications, ContentType = WindowsRuntime] > $null
    $Template = [Windows.UI.Notifications.ToastNotificationManager]::GetTemplateContent([Windows.UI.Notifications.ToastTemplateType]::ToastImageAndText02)

    $RawXml = [xml] $Template.GetXml()
    ($RawXml.toast.visual.binding.text | Where-Object { $_.id -eq "1" }).AppendChild($RawXml.CreateTextNode($ToastTitle)) > $null
    ($RawXml.toast.visual.binding.text | Where-Object { $_.id -eq "2" }).AppendChild($RawXml.CreateTextNode($ToastText)) > $null



    $image = ($RawXml.toast.visual.binding.image | Where-Object { $_.id -eq "1" })
    $image.setAttribute("id", "1");
    if ($IconUri) {
        if ($IconUri -match "^https?:\/\/") {
            $TempImagePath = "$env:TEMP\$(Split-Path $IconUri -Leaf)"
            try {
                Invoke-WebRequest -Uri $IconUri -OutFile $TempImagePath -ErrorAction Stop
                $IconUri = "$TempImagePath"
                Write-Output "Imagem remota baixada para: $TempImagePath"
            }
            catch {
                Write-Output "Erro ao baixar a imagem remota: $_.Message"
                $IconUri = ""
            }
        }
        $image.setAttribute("src", $IconUri);
    }
    else {
        $LocalImagePath = $PSScriptRoot.ToString().Replace("\Public\Imported", "\assets\psyduck.webp")
        $image.setAttribute("src", $LocalImagePath);
    }
    $image.setAttribute("alt", "Psyduck Icon");
    $image.setAttribute("placement", "hero");
    $RawXml.toast.visual.binding.AppendChild($image) > $null

    $SerializedXml = New-Object Windows.Data.Xml.Dom.XmlDocument
    $SerializedXml.LoadXml($RawXml.OuterXml)

    if ($Schedule) {
        $Toast = [Windows.UI.Notifications.ScheduledToastNotification]::new($SerializedXml, $Schedule)
        $Toast.Id = 'scheduled_toast'
    }
    else {
        $Toast = [Windows.UI.Notifications.ToastNotification]::new($SerializedXml)
    }

    $Toast.Tag = $Tag
    $Toast.Group = $Group
    $Toast.ExpirationTime = [DateTimeOffset]::Now.AddMinutes(1)



    $Notifier = [Windows.UI.Notifications.ToastNotificationManager]::CreateToastNotifier($Group)
    if ($Schedule) {
        $Notifier.addToSchedule($Toast);
        return;
    }
    $Notifier.Show($Toast);
}