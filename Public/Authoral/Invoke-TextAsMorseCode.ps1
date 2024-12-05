function Invoke-TextAsMorseCode {
    param(
        [Parameter(Mandatory = $true, ValueFromPipelineByPropertyName)]
        [string]
        $text
    )
    begin {
        [int]$speed = 1;

        function gap {
            param([int]$Length)
            for ([int]$i = 1; $i -lt $Length; $i++) {
                Write-Output " " -nonewline
                continue;
            }
            start-sleep -milliseconds ($Length * $speed)
        }

        function dot {
            [console]::beep(440, 150)
            Write-Output "." -nonewline
            start-sleep -milliseconds $speed # signal
        }

        function dash {
            [console]::beep(440, 300)
            Write-Output "_" -nonewline
            start-sleep -milliseconds (3 * $speed) # signal
        }
        function Char2MorseCode {
            param([string]$Char)
            switch ($Char) {
                'A' { dot; gap 1; dash; gap 2 }
                'B' { dash; gap 1; dot; gap 1; dot; gap 1; dot; gap 2 }
                'C' { dash; gap 1; dot; gap 1; dash; gap 1; dot; gap 2 }
                'D' { dash; gap 1; dot; gap 1; dot; gap 2 }
                'E' { dot; gap 2 }
                'F' { dot; gap 1; dot; gap 1; dash; gap 1; dot; gap 2 }
                'G' { dash; gap 1; dash; gap 1; dot; gap 2 }
                'H' { dot; gap 1; dot; gap 1; dot; gap 1; dot; gap 2 }
                'I' { dot; gap 1; dot; gap 2 }
                'J' { dot; gap 1; dash; gap 1; dash; gap 1; dash; gap 2 }
                'K' { dash; gap 1; dot; gap 1; dash; gap 2 }
                'L' { dot; gap 1; dash; gap 1; dot; gap 1; dot; gap 2 }
                'M' { dash; gap 1; dash; gap 2 }
                'N' { dash; gap 1; dot; gap 2 }
                'O' { dash; gap 1; dash; gap 1; dash; gap 2 }
                'P' { dot; gap 1; dash; gap 1; dash; gap 1; dot; gap 2 }
                'Q' { dash; gap 1; dash; gap 1; dot; gap 1; dash; gap 2 }
                'R' { dot; gap 1; dash; gap 1; dot; gap 2 }
                'S' { dot; gap 1; dot; gap 1; dot; gap 2 }
                'T' { dash; gap 2 }
                'U' { dot; gap 1; dot; gap 1; dash; gap 2 }
                'V' { dot; gap 1; dot; gap 1; dot; gap 1; dash; gap 2 }
                'W' { dot; gap 1; dash; gap 1; dash; gap 2 }
                'X' { dash; gap 1; dot; gap 1; dot; gap 1; dash; gap 2 }
                'Y' { dash; gap 1; dot; gap 1; dash; gap 1; dash; gap 2 }
                'Z' { dash; gap 1; dash; gap 1; dot; gap 1; dot; gap 2 }
                '1' { dot; gap 1; dash; gap 1; dash; gap 1; dash; gap 1; dash; gap 2 }
                '2' { dot; gap 1; dot; gap 1; dash; gap 1; dash; gap 1; dash; gap 2 }
                '3' { dot; gap 1; dot; gap 1; dot; gap 1; dash; gap 1; dash; gap 2 }
                '4' { dot; gap 1; dot; gap 1; dot; gap 1; dot; gap 1; dash; gap 2 }
                '5' { dot; gap 1; dot; gap 1; dot; gap 1; dot; gap 1; dot; gap 2 }
                '6' { dash; gap 1; dot; gap 1; dot; gap 1; dot; gap 1; dot; gap 2 }
                '7' { dash; gap 1; dash; gap 1; dot; gap 1; dot; gap 1; dot; gap 2 }
                '8' { dash; gap 1; dash; gap 1; dash; gap 1; dot; gap 1; dot; gap 2 }
                '9' { dash; gap 1; dash; gap 1; dash; gap 1; dash; gap 1; dot; gap 2 }
                '0' { dash; gap 1; dash; gap 1; dash; gap 1; dash; gap 1; dash; gap 2 }
                default { gap 7 } # medium gap (between words)
            }
        }
        if ($text -eq "" ) { [string]$text = read-host "Enter text to write" }
    }
    process {
        try {
            if ($text -eq "" ) { [string]$text = read-host "Enter text to write" }

            [char[]]$ArrayOfChars = $text.ToUpper()
            foreach ($Char in $ArrayOfChars) {
                Char2MorseCode $Char
            }
            # exit 0 # success
            Write-Output $ArrayOfChars
        }
        catch {
            throw "Error in line $($_.InvocationInfo.ScriptLineNumber): $($Error[0])"
            # exit 1
        }

    }

}


