function Start-StudyMorse {
    param()
 
    begin {
 
        [int]$d100 = (Get-Random -Minimum 0 -Maximum 100)
        [bool]$beeping = $d100 -gt 75;
        [bool]$translating = ($d100 -gt 30) -and ($d100 -lt 75);
        [bool]$transcripting = ($d100 -lt 30);
    }

    process {
        # Generate a random word of length 7
        $possibilities = @('verb', 'noun', 'person', 'job', 'synonym', 'adjective', 'color')
        $randomWord = (Invoke-Generate (Get-Random -InputObject $possibilities))
        
        
        if ($beeping) {
            Write-Output "Escute com atenção, vai começar!"
            Invoke-TextAsMorseCode $randomWord -Beep:$beeping
        }
        if ($translating) {
            Write-Output "Vamos lá! traduza o que eu disse aqui!"
            Invoke-TextAsMorseCode $randomWord -Beep:$beeping
        }
        if ($transcripting) {
            Write-Output "Ok, ok. Mas como eu escrevo $randomWord em codigo morse?"
        }
        
        $response = (Read-Host "Escreva a resposta")
        
        $valid = if ($translating) { $response.ToLower() -eq $randomWord.ToLower() } else { (ConvertFrom-MorseCode $response).ToLower() -eq $randomWord.ToLower() }
        
        Write-Output "Palavra da vez: $randomWord"
        
        if ($valid) {
            Write-Output "Nice shoot!"
        }
        else {
            Write-Error "Ainda falta meu caro!" 
        }
    }
}
