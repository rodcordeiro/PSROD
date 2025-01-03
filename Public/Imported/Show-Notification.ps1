﻿function Show-Notification {
    [cmdletbinding()]
    Param (
        [string]
        $ToastTitle,
        [string]
        [parameter(ValueFromPipeline)]
        $ToastText,
        [datetime]
        [parameter(ValueFromPipeline, Mandatory = $false)]
        $Schedule
    )

    # https://den.dev/blog/powershell-windows-notification/
    [Windows.UI.Notifications.ToastNotificationManager, Windows.UI.Notifications, ContentType = WindowsRuntime] > $null
    $Template = [Windows.UI.Notifications.ToastNotificationManager]::GetTemplateContent([Windows.UI.Notifications.ToastTemplateType]::ToastText02)

    $RawXml = [xml] $Template.GetXml()
    ($RawXml.toast.visual.binding.text | Where-Object { $_.id -eq "1" }).AppendChild($RawXml.CreateTextNode($ToastTitle)) > $null
    ($RawXml.toast.visual.binding.text | Where-Object { $_.id -eq "2" }).AppendChild($RawXml.CreateTextNode($ToastText)) > $null
    # $RawXml.toast.visual.binding.AppendChild('<image id="1" src="https://rodcordeiro.github.io/shares/img/GrimReaper.png" placement="appLogoOverride"/>') > $null

    $SerializedXml = New-Object Windows.Data.Xml.Dom.XmlDocument
    $SerializedXml.LoadXml($RawXml.OuterXml)

    if ($Schedule) {
        $Toast = [Windows.UI.Notifications.ScheduledToastNotification]::new($SerializedXml, $Schedule)
        $Toast.Id = 'scheduled_toasd'
    }
    else {
        $Toast = [Windows.UI.Notifications.ToastNotification]::new($SerializedXml)
    }

    $Toast.Tag = "PowerShell"
    $Toast.Group = "PowerShell"
    $Toast.ExpirationTime = [DateTimeOffset]::Now.AddMinutes(1)



    $Notifier = [Windows.UI.Notifications.ToastNotificationManager]::CreateToastNotifier("PowerShell")
    if ($Schedule) {
        $Notifier.addToSchedule($Toast);
        return;
    }
    $Notifier.Show($Toast);
}
