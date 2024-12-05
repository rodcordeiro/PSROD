function Invoke-TextAsMorseCode {
    param(
        [Parameter(Mandatory = $true, ValueFromPipelineByPropertyName)]
        [string]
        $text,
        # Enables beeping
        [Parameter(Mandatory = $false)]
        [switch]$Beep
    )
    begin {
        [int]$speed = 1;

        function gap {
            param([int]$Length)
            for ([int]$i = 1; $i -lt $Length; $i++) {
                Write-Output " " # -nonewline
                continue;
            }
            start-sleep -milliseconds ($Length * $speed)
        }

        function dot {
            if ($Beep) { [console]::beep(440, 150) }
            Write-Output "." # -nonewline
            start-sleep -milliseconds $speed # signal
        }

        function dash {
            if ($Beep) { [console]::beep(440, 300) }
            Write-Output "_" # -nonewline
            start-sleep -milliseconds (3 * $speed) # signal
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
        if ($text -eq "" ) { [string]$text = read-host "Enter text to write" }
    }
    process {
        try {
            if ($text -eq "" ) { [string]$text = read-host "Enter text to write" }
            $response = ""
            [char[]]$ArrayOfChars = $text.ToUpper()
            foreach ($Char in $ArrayOfChars) {
                $response += Char2MorseCode $Char
            }
            # exit 0 # success
            Write-Output $response
        }
        catch {
            throw "Error in line $($_.InvocationInfo.ScriptLineNumber): $($Error[0])"
            # exit 1
        }

    }

}


