
function Digita {
    [CmdletBinding()]
    param(
        [Parameter(Mandatory, ValueFromRemainingArguments, Position = 0)]
        [string[]]$Text,

        [switch]$SemEnter
    )

    $conteudo = ($Text -join ' ').Trim()
    if ([string]::IsNullOrWhiteSpace($conteudo)) {
        return
    }

    # adb input text usa %s para espaço
    $conteudo = $conteudo -replace ' ', '%s'

    & adb shell input text $conteudo

    if (-not $SemEnter) {
        & adb shell input keyevent 66
    }
}