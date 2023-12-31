function ConvertTo-MorseCode {
    <#
.SYNOPSIS
	Writes text in Morse code
.DESCRIPTION
	This PowerShell script writes text in Morse code.
.PARAMETER text
	Specifies the text to write
.PARAMETER speed
	Specifies the speed of one time unit (100 ms per default)
.EXAMPLE
	PS> ./write-morse-code "Hello World"
.NOTES
	Author: Markus Fleschutz / License: CC0
.LINK
	https://github.com/fleschutz/PowerShell
#>

    param([string]$text = "", [int]$speed = 10) # one time unit in milliseconds

    function gap {
        param([int]$Length)
        for ([int]$i = 1; $i -lt $Length; $i++) {
            write-host " " -nonewline
        }
        start-sleep -milliseconds ($Length * $speed)
    }

    function dot {
        write-host "." -nonewline
        start-sleep -milliseconds $speed # signal
    }

    function dash {
        write-host "_" -nonewline
        start-sleep -milliseconds (3 * $speed) # signal
    }

    function Char2MorseCode {
        param([string]$Char)
        switch ($Char) {
            'A' { dot; gap 2; dash; gap 4 }
            'B' { dash; gap 2; dot; gap 2; dot; gap 2; dot; gap 4 }
            'C' { dash; gap 2; dot; gap 2; dash; gap 2; dot; gap 4 }
            'D' { dash; gap 2; dot; gap 2; dot; gap 4 }
            'E' { dot; gap 4 }
            'F' { dot; gap 2; dot; gap 2; dash; gap 2; dot; gap 4 }
            'G' { dash; gap 2; dash; gap 2; dot; gap 4 }
            'H' { dot; gap 2; dot; gap 2; dot; gap 2; dot; gap 4 }
            'I' { dot; gap 2; dot; gap 4 }
            'J' { dot; gap 2; dash; gap 2; dash; gap 2; dash; gap 4 }
            'K' { dash; gap 2; dot; gap 2; dash; gap 4 }
            'L' { dot; gap 2; dash; gap 2; dot; gap 2; dot; gap 4 }
            'M' { dash; gap 2; dash; gap 4 }
            'N' { dash; gap 2; dot; gap 4 }
            'O' { dash; gap 2; dash; gap 2; dash; gap 4 }
            'P' { dot; gap 2; dash; gap 2; dash; gap 2; dot; gap 4 }
            'Q' { dash; gap 2; dash; gap 2; dot; gap 2; dash; gap 4 }
            'R' { dot; gap 2; dash; gap 2; dot; gap 4 }
            'S' { dot; gap 2; dot; gap 2; dot; gap 4 }
            'T' { dash; gap 4 }
            'U' { dot; gap 2; dot; gap 2; dash; gap 4 }
            'V' { dot; gap 2; dot; gap 2; dot; gap 2; dash; gap 4 }
            'W' { dot; gap 2; dash; gap 2; dash; gap 4 }
            'X' { dash; gap 2; dot; gap 2; dot; gap 2; dash; gap 4 }
            'Y' { dash; gap 2; dot; gap 2; dash; gap 2; dash; gap 4 }
            'Z' { dash; gap 2; dash; gap 2; dot; gap 2; dot; gap 4 }
            '1' { dot; gap 2; dash; gap 2; dash; gap 2; dash; gap 2; dash; gap 4 }
            '2' { dot; gap 2; dot; gap 2; dash; gap 2; dash; gap 2; dash; gap 4 }
            '3' { dot; gap 2; dot; gap 2; dot; gap 2; dash; gap 2; dash; gap 4 }
            '4' { dot; gap 2; dot; gap 2; dot; gap 2; dot; gap 2; dash; gap 4 }
            '5' { dot; gap 2; dot; gap 2; dot; gap 2; dot; gap 2; dot; gap 4 }
            '6' { dash; gap 2; dot; gap 2; dot; gap 2; dot; gap 2; dot; gap 4 }
            '7' { dash; gap 2; dash; gap 2; dot; gap 2; dot; gap 2; dot; gap 4 }
            '8' { dash; gap 2; dash; gap 2; dash; gap 2; dot; gap 2; dot; gap 4 }
            '9' { dash; gap 2; dash; gap 2; dash; gap 2; dash; gap 2; dot; gap 4 }
            '0' { dash; gap 2; dash; gap 2; dash; gap 2; dash; gap 2; dash; gap 4 }
            default { gap 7 } # medium gap (between words)
        }
    }

    try {
        if ($text -eq "" ) { [string]$text = read-host "Enter text to write" }

        [char[]]$ArrayOfChars = $text.ToUpper()
        foreach ($Char in $ArrayOfChars) {
            Char2MorseCode $Char 
        }
        # exit 0 # success
    }
    catch {
        "Error in line $($_.InvocationInfo.ScriptLineNumber): $($Error[0])"
        # exit 1
    }
}
