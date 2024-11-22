function Invoke-TextToSpeech {
    param(
        [Parameter(Mandatory, ValueFromRemainingArguments)]
        [string[]]$texto
    )
    begin {
        Add-Type -AssemblyName System.speech
        $narrador = New-Object System.Speech.Synthesis.SpeechSynthesizer
    }
    process {
        $narrador.Speak($texto -join " ")
        $narrador.Dispose()
    }
}