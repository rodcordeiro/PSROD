Function CalcularSaida {
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
        [ValidateNotNullOrEmpty()]
        [datetime]$Retorno,
        [parameter(ValueFromPipelineByPropertyName)]
        [ValidateNotNullOrEmpty()]
        [Switch]$Output
    )
    Begin {
        $OutputEncoding = [Console]::OutputEncoding = New-Object System.Text.Utf8Encoding

        Function CalcTimer {
            param([datetime]$Hora)
            return $Hora.Hour * 60 + $Hora.Minute
        }

        # $TOTAL_MINUTES_PER_DAY = $(24 * 60)
        $HOURS_PER_DAY = $(CalcTimer -Hora 8:48)

    }
    Process {

        $Entrada_MinuteSpan = $(CalcTimer -Hora $Entrada)
        $Almoco_MinuteSpan = $(CalcTimer -Hora $Almoco)
        $Retorno_MinuteSpan = $(CalcTimer -Hora $Retorno)

        $FirstRound = $($HOURS_PER_DAY - ($Almoco_MinuteSpan - $Entrada_MinuteSpan))

        $ExitEstimated = $($Retorno_MinuteSpan + $FirstRound)
        $ExitTime = Get-Date -Hour $([System.Math]::Floor( $ExitEstimated / 60 )) -Minute $($ExitEstimated % 60)
        if ($Output) {
            Write-Output $ExitTime
            return
        }

        Write-Output "O Horario de saida sera: $($ExitTime.Hour):$($ExitTime.Minute)"


    }
}
