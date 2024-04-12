Function CalcularHorarios {
    <#
    .SYNOPSIS
        Calculates exit time
    .DESCRIPTION
        Receives entrance and lunch times and calculates estimated exit time
    .LINK
        https://github.com/rodcordeiro/PSROD/blob/main/Public/Authoral/CalcularSaida.ps1
    .PARAMETER Entrada
        Entrance time
    .PARAMETER Almoco
        Exit for lunch time
    .PARAMETER Retorno
        Lunch time returns
    .PARAMETER Output
        Outputs only time without friendly message
    .EXAMPLE
        PS> CalcularSaida -Entrada 9:10 -Almoco 12:15 -Retorno 13:35
    #>
    param(
        [parameter(ValueFromPipelineByPropertyName)]
        [ValidateNotNullOrEmpty()]
        [datetime]$Entrada,
        [parameter(ValueFromPipelineByPropertyName)]
        [ValidateNotNullOrEmpty()]
        [datetime]$Almoco,
        [parameter(ValueFromPipelineByPropertyName)]
        [datetime]$Retorno,
        [parameter(ValueFromPipelineByPropertyName)]
        [Switch]$Output
    )
    Begin {
        $OutputEncoding = [Console]::OutputEncoding = New-Object System.Text.Utf8Encoding

        Function CalcTimer {
            param([datetime]$Hora)
            return $Hora.Hour * 60 + $Hora.Minute 
        }
        Function GetTime {
            param([int]$Hora)
            return Get-Date -Hour $([System.Math]::Floor( $Hora / 60 )) -Minute $($Hora % 60)
        }


        # $TOTAL_MINUTES_PER_DAY = $(24 * 60)
        $HOURS_PER_DAY = $(CalcTimer -Hora 8:48)
        $CALCULATE_LUNCH_TIME = $false
        if (!$Almoco) {
            $CALCULATE_LUNCH_TIME = $true
        }
        if ($Almoco -and !$Retorno) {
            throw "Retorno obrigatorio para calculo do horario de saida.\n"
        }

    }
    Process {
        
        $Entrada_MinuteSpan = $(CalcTimer -Hora $Entrada)
        if ($CALCULATE_LUNCH_TIME) {
            $ESTIMATED_LUNCH_TIME = $(GetTime $(CalcTimer -Hora $Entrada.AddHours(4)))
            Write-Output $ESTIMATED_LUNCH_TIME
            return
        }
        else {

            $Almoco_MinuteSpan = $(CalcTimer -Hora $Almoco)
            $Retorno_MinuteSpan = $(CalcTimer -Hora $Retorno)
        
            $FirstRound = $($HOURS_PER_DAY - ($Almoco_MinuteSpan - $Entrada_MinuteSpan))

            $ExitEstimated = $($Retorno_MinuteSpan + $FirstRound)
            $ExitTime = GetTime $ExitEstimated
            if ($Output) {
                Write-Output $ExitTime
                return
            }
        
            Write-Output "O Horario de saida sera: $($ExitTime.Hour):$(([string]$ExitTime.Minute).PadLeft(2,'0'))"
        }
    }
}
