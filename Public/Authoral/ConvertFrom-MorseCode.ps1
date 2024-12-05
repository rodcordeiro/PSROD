
function ConvertFrom-MorseCode {
    <#
.SYNOPSIS
	Writes text from Morse code
.DESCRIPTION
	This PowerShell script writes text from Morse code.
.PARAMETER text
	Specifies the text to write
.EXAMPLE
	PS> ./ConvertFrom-MorseCode "._. ___ _..   _._. ___ ._. _.. . .. ._. ___"
.NOTES
	Author: Rodrigo Cordeiro.
    Reference: [Markus Fleschutz](https://github.com/fleschutz/PowerShell)
#>

    param(
        [Parameter(Mandatory, ValueFromPipelineByPropertyName)]
        [string]$MorseCode
    )

    begin {
        if (!$MorseCode) { throw "MorseCode is required" }

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
        $Words = $MorseCode -split "   "
    }

    process {
        $DecodedText = $Words | ForEach-Object {

            $Characters = $_ -split " "

            return ($Characters | ForEach-Object {
                    if ($null -ne $MorseToText[$_]) { $MorseToText[$_] } else { "?" }
                }) -join ""
        }

    }

    end {
        Write-Output ($DecodedText -join " ")
    }
}


