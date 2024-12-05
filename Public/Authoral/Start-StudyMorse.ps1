
function Start-StudyMorse {
    param()
    begin {
        [int]$speed = 1;
        [int]$d100 = (Get-Random -Minimum 0 -Maximum 100)
        [bool]$beeping = $d100 -gt 75;
        [bool]$translating = ($d100 -gt 30) -and ($d100 -lt 75);
        [bool]$transcripting = ($d100 -lt 30);
        $d100
        function Get-RandomWord {
            param (
                [int]$length = 5
            )

            $chars = "abcdefghijklmnopqrstuvwxyz".ToCharArray()
            $word = -join ((1..$length) | ForEach-Object { $chars | Get-Random })

            return $word
        }


        function gap {
            param([int]$Length)
            if ($tranlating) {
                for ([int]$i = 1; $i -lt $Length; $i++) {
                    Write-Output " " # -nonewline
                    continue;
                }
            }
            start-sleep -milliseconds ($Length * $speed)
        }

        function dot {
            if ($beeping) { [console]::beep(440, 150) }
            if ($translating) {
                Write-Output "." # -nonewline}
            }
            start-sleep -milliseconds $speed # signal
        }

        function dash {
            if ($beeping) { [console]::beep(440, 300) }
            if ($translating) {
                Write-Output "_" # -nonewline}
                start-sleep -milliseconds (3 * $speed) # signal
            }
        }

        function Char2MorseCode {
            param([string]$Char)
            switch ($Char) {
                'A' { dot; dash; gap 2 }
                'B' { dash; dot; dot; dot; gap 2 }
                'C' { dash; dot; dash; dot; gap 2 }
                'D' { dash; dot; dot; gap 2 }
                'E' { dot; gap 2 }
                'F' { dot; dot; dash; dot; gap 2 }
                'G' { dash; dash; dot; gap 2 }
                'H' { dot; dot; dot; dot; gap 2 }
                'I' { dot; dot; gap 2 }
                'J' { dot; dash; dash; dash; gap 2 }
                'K' { dash; dot; dash; gap 2 }
                'L' { dot; dash; dot; dot; gap 2 }
                'M' { dash; dash; gap 2 }
                'N' { dash; dot; gap 2 }
                'O' { dash; dash; dash; gap 2 }
                'P' { dot; dash; dash; dot; gap 2 }
                'Q' { dash; dash; dot; dash; gap 2 }
                'R' { dot; dash; dot; gap 2 }
                'S' { dot; dot; dot; gap 2 }
                'T' { dash; gap 2 }
                'U' { dot; dot; dash; gap 2 }
                'V' { dot; dot; dot; dash; gap 2 }
                'W' { dot; dash; dash; gap 2 }
                'X' { dash; dot; dot; dash; gap 2 }
                'Y' { dash; dot; dash; dash; gap 2 }
                'Z' { dash; dash; dot; dot; gap 2 }
                '1' { dot; dash; dash; dash; dash; gap 2 }
                '2' { dot; dot; dash; dash; dash; gap 2 }
                '3' { dot; dot; dot; dash; dash; gap 2 }
                '4' { dot; dot; dot; dot; dash; gap 2 }
                '5' { dot; dot; dot; dot; dot; gap 2 }
                '6' { dash; dot; dot; dot; dot; gap 2 }
                '7' { dash; dash; dot; dot; dot; gap 2 }
                '8' { dash; dash; dash; dot; dot; gap 2 }
                '9' { dash; dash; dash; dash; dot; gap 2 }
                '0' { dash; dash; dash; dash; dash; gap 2 }
                default { gap 7 } # medium gap (between words)
            }
        }
        $MorseToText = @{
            "._"    = "A";
            "_..."  = "B";
            "_._."  = "C";
            "_.."   = "D";
            "."     = "E";
            ".._."  = "F";
            "__."   = "G";
            "...."  = "H";
            ".."    = "I";
            ".___"  = "J";
            "_._"   = "K";
            "._.."  = "L";
            "__"    = "M";
            "_."    = "N";
            "___"   = "O";
            ".__."  = "P";
            "__._"  = "Q";
            "._."   = "R";
            "..."   = "S";
            "_"     = "T";
            ".._"   = "U";
            "..._"  = "V";
            ".__"   = "W";
            "_.._"  = "X";
            "_.__"  = "Y";
            "__.."  = "Z";

            ".____" = "1";
            "..___" = "2";
            "...__" = "3";
            "...._" = "4";
            "....." = "5";

            "_...." = "6";
            "__..." = "7";
            "___.." = "8";
            "____." = "9";
            "_____" = "0";

        }
    }
    process {
        # Generate a random word of length 7
        $randomWord = Get-RandomWord -length 7

        # Output the random word
        Write-Host "======================"
        Write-Host "beeping: $beeping"
        Write-Host "translating: $translating"
        Write-Host "transcripting: $transcripting"
        Write-Host "randomWord: $randomWord"
        if ($translating) {
            [char[]]$ArrayOfChars = $randomWord.ToUpper()
            foreach ($Char in $ArrayOfChars) {
                $morse += Char2MorseCode $Char
            }
            Write-Host "Morse Code: $morse"
        }
        # $response = (Read-Host "Escreva a resposta")
        # $valid = if ($translating) { $response -eq $randomWord } else { (ConvertFrom-MorseCode $response) -eq $randomWord }
        # # exit 0 # success
        # Write-Host "response: $response"
        # Write-Host "valid: $valid"
    }
}
# Start-StudyMorse