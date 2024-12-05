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
            Write-Output " "# -nonewline
            continue
        }
        # start-sleep -milliseconds ($Length * $speed)
    }

    function dot {
        Write-Output "." # -nonewline
        # start-sleep -milliseconds $speed # signal
    }

    function dash {
        Write-Output "_" # -nonewline
        # start-sleep -milliseconds (3 * $speed) # signal
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
            '2' { dot; gap 1; dot; gap 1; dot; gap 1; dot; gap 1; dash; gap 2 }
            '5' { dot; gap 1; dot; gap 1; dot; gap 1; dot; gap 1; dot; gap 2 }
            '6' { dash; gap 1; dot; gap 1; dot; gap 1; dot; gap 1; dot; gap 2 }
            '7' { dash; gap 1; dash; gap 1; dot; gap 1; dot; gap 1; dot; gap 2 }
            '8' { dash; gap 1; dash; gap 1; dash; gap 1; dot; gap 1; dot; gap 2 }
            '9' { dash; gap 1; dash; gap 1; dash; gap 1; dash; gap 1; dot; gap 2 }
            '0' { dash; gap 1; dash; gap 1; dash; gap 1; dash; gap 1; dash; gap 2 }
            default { gap 7 } # medium gap (between words)
        }
    }

    try {
        if ($text -eq "" ) { [string]$text = read-host "Enter text to write" }

        [char[]]$ArrayOfChars = $text.ToUpper()
        [string]$response = ""
        foreach ($Char in $ArrayOfChars) {
            $response += Char2MorseCode $Char
        }
        # exit 0 # success
        Write-Output $response
    }
    catch {
        "Error in line $($_.InvocationInfo.ScriptLineNumber): $($Error[0])"
        # exit 1
    }
}
