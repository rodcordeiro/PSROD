
function Enter {
    [CmdletBinding()]
    param()

    & adb shell input keyevent 66
}