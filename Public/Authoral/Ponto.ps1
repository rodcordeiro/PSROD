# Uma linha do arquivo ~/.pontos.tsf: sequência, dia, horário e rótulo (Entrada, Almoço, Retorno, Saída, Extra ou Falta).
class PontoEntry {
    [int]$Id
    [datetime]$Date
    [datetime]$Time
    [string]$Label
}
function Ponto {
    <#
    .SYNOPSIS
        Registra e analisa o ponto (batidas de entrada, almoço, retorno e saída).
    .DESCRIPTION
        Mantém as batidas em ~/.pontos.tsf (uma por linha, separada por TAB) e oferece as ações:

        - Registrar: grava uma batida; o rótulo segue a ordem do dia (Entrada, Almoço, Retorno, Saída, Extra).
        - Listar: mostra as batidas de um dia.
        - Falta: sinaliza falta num dia útil sem batidas; o Dash desconta a jornada inteira do banco de horas.
        - Alertas: lista as batidas a ajustar nos 7 dias anteriores a -Date, no formato
          "matricula;data;horario-esperado;horario-marcado".
        - Dash: calcula banco de horas, atrasos, saídas antecipadas, médias e alertas da CLT
          (intervalo < 1h, jornada > 10h, descanso < 11h). Com -Monthly, resume um mês e compara com o anterior.

        A jornada é configurável em ~/.pontos.config.json (chaves Entrada, Saida, Almoco, Tolerancia,
        IntervaloMinimo, LimiteSemIntervalo, Interjornada, JornadaMaxima, InicioAlmoco e Matricula).
        Sem o arquivo, vale 07:30-17:15 com 1h de almoço, tolerância de 5 min e a matrícula $env:USERNAME.
    .PARAMETER Action
        Ação a executar: Registrar, Listar, Falta, Alertas ou Dash.
    .PARAMETER Date
        Data/hora de referência. Registrar: horário da batida. Listar: dia exibido. Falta: dia da falta.
        Alertas: os 7 dias anteriores a esta data são analisados. Padrão: agora.
    .PARAMETER Inicio
        Dash: primeiro dia do período analisado. Padrão: início do histórico.
    .PARAMETER Fim
        Dash: último dia do período analisado. Padrão: fim do histórico.
    .PARAMETER Monthly
        Dash: resume um mês inteiro (o atual ou o informado em -Mes), com saldo de meses anteriores e comparação com o mês anterior.
    .PARAMETER Mes
        Dash: número do mês (1-12) para o resumo mensal. Mês ainda não chegado no ano corrente é do ano anterior. Informar -Mes já ativa o modo mensal.
    .PARAMETER PassThru
        Dash: além de exibir, devolve um objeto com Dias, Resumo (valores em minutos) e MesAnterior.
    .INPUTS
        Nenhum.
    .OUTPUTS
        System.String. Mensagens de Registrar, Falta e as linhas de Alertas.
        PontoEntry. Batidas exibidas por Listar.
        System.Management.Automation.PSCustomObject. Dash com -PassThru.
    .EXAMPLE
        PS> Ponto Registrar

        Registra uma batida com o horário atual.
    .EXAMPLE
        PS> Ponto Registrar -Date "2026-10-27T07:40:00"

        Registra uma batida retroativa.
    .EXAMPLE
        PS> Ponto Listar -Date 2026-10-26

        Lista as batidas de 26/10/2026.
    .EXAMPLE
        PS> Ponto Falta -Date 2026-10-21

        Sinaliza falta em 21/10/2026; o dia passa a descontar a jornada do banco de horas.
    .EXAMPLE
        PS> Ponto Alertas | Set-Clipboard

        Copia os incidentes dos últimos 7 dias para enviar ao RH.
    .EXAMPLE
        PS> Ponto Dash -Inicio 2026-10-01 -Fim 2026-10-31

        Mostra os últimos 10 dias do período e o resumo de banco de horas, atrasos e alertas.
    .EXAMPLE
        PS> Ponto Dash -Monthly 9

        Resume setembro, com saldo transportado e comparação com agosto.
    .EXAMPLE
        PS> (Ponto Dash -Monthly -PassThru).Dias | Export-Csv mes.csv -NoTypeInformation

        Exporta os dias do mês atual para CSV.
    .NOTES
        Regras de tolerância (5 min por batida, até 10 min no dia) seguem o art. 58, §1º, da CLT.
        Dia com número ímpar de batidas fica fora do saldo; o dia de hoje só entra a partir da 4ª batida.
    .LINK
        https://github.com/rodcordeiro/PSROD/blob/main/Public/Authoral/Ponto.ps1
    #>
    [CmdletBinding(DefaultParameterSetName = "Registrar")]
    param(
        [Parameter(Mandatory = $true, ParameterSetName = "Registrar", Position = 0)]
        [Parameter(Mandatory = $true, ParameterSetName = "Listar", Position = 0)]
        [Parameter(Mandatory = $true, ParameterSetName = "Falta", Position = 0)]
        [Parameter(Mandatory = $true, ParameterSetName = "Alertas", Position = 0)]
        [Parameter(Mandatory = $true, ParameterSetName = "Dash", Position = 0)]
        [ValidateSet("Registrar", "Listar", "Falta", "Alertas", "Dash")]
        [string]$Action,
        [Parameter(Mandatory = $false, ParameterSetName = "Registrar")]
        [Parameter(Mandatory = $false, ParameterSetName = "Listar")]
        [Parameter(Mandatory = $false, ParameterSetName = "Falta")]
        [Parameter(Mandatory = $false, ParameterSetName = "Alertas")]
        [datetime]$Date = (Get-Date),
        [Parameter(Mandatory = $false, ParameterSetName = "Dash")]
        [datetime]$Inicio = [datetime]::MinValue,
        [Parameter(Mandatory = $false, ParameterSetName = "Dash")]
        [datetime]$Fim = [datetime]::MaxValue,
        # Resume um mês inteiro: o mês atual ou o informado em -Mes (ex.: Ponto Dash -Monthly 10).
        [Parameter(Mandatory = $false, ParameterSetName = "Dash")]
        [switch]$Monthly,
        [Parameter(Mandatory = $false, ParameterSetName = "Dash", Position = 1)]
        [ValidateRange(1, 12)]
        [int]$Mes,
        # Além de exibir, devolve os dias e o resumo como objetos (ex.: para Export-Csv).
        [Parameter(Mandatory = $false, ParameterSetName = "Dash")]
        [switch]$PassThru
    )
    begin {
        $FilePath = Join-Path -Path $HOME -ChildPath ".pontos.tsf"
        $ConfigPath = Join-Path -Path $HOME -ChildPath ".pontos.config.json"

        function Get-DiaRegistro {
            <#
            .SYNOPSIS
                Extrai a data (yyyy-MM-dd) de uma linha do arquivo, em qualquer formato já gravado.
            .PARAMETER Linha
                Linha bruta do ~/.pontos.tsf.
            .OUTPUTS
                System.String. A data encontrada, ou nada se a linha não tiver data.
            #>
            param([string]$Linha)
            if ($Linha -match '\d{4}-\d{2}-\d{2}') { $Matches[0] }
        }

        function Get-PontoEntry {
            <#
            .SYNOPSIS
                Lê o ~/.pontos.tsf e converte cada linha (TSV ou formatos antigos) em PontoEntry.
            .DESCRIPTION
                Linhas sem data/hora reconhecível são ignoradas (veja -Verbose). Sem sequência na linha, usa o número da linha como Id.
            .OUTPUTS
                PontoEntry.
            #>
            $numero = 0
            foreach ($linha in @(Get-Content -Path $FilePath -Encoding UTF8)) {
                $numero++
                if ($linha -notmatch '(?<dia>\d{4}-\d{2}-\d{2})\s+(?<hora>\d{2}:\d{2}(:\d{2})?)\s*(?<label>.*)$') {
                    Write-Verbose "Linha $numero ignorada: '$linha'"
                    continue
                }
                $dia = [datetime]::ParseExact($Matches.dia, "yyyy-MM-dd", $null)
                $hora = [timespan]::Parse($Matches.hora)
                $label = $Matches.label.Trim()
                $id = if ($linha -match '^\s*(\d+)\s') { [int]$Matches[1] } else { $numero }
                [PontoEntry]@{
                    Id    = $id
                    Date  = $dia
                    Time  = $dia.Add($hora)
                    Label = $label
                }
            }
        }

        function Format-Minuto {
            <#
            .SYNOPSIS
                Formata uma quantidade de minutos como [+|-]HH:mm.
            .PARAMETER Minutos
                Minutos a formatar; negativos recebem "-".
            .PARAMETER Sinal
                Prefixa "+" em valores positivos.
            .OUTPUTS
                System.String.
            #>
            param([double]$Minutos, [switch]$Sinal)
            $prefixo = if ($Minutos -lt 0) { "-" } elseif ($Sinal -and $Minutos -gt 0) { "+" } else { "" }
            $total = [math]::Abs([math]::Round($Minutos))
            "{0}{1:00}:{2:00}" -f $prefixo, [math]::Floor($total / 60), ($total % 60)
        }

        function Get-PontoConfig {
            <#
            .SYNOPSIS
                Monta a configuração da jornada e dos limites da CLT.
            .DESCRIPTION
                Parte dos padrões (07:30-17:15, almoço 1h, tolerância 5 min, intervalo mínimo 1h acima de 6h, interjornada 11h, jornada máxima 10h, almoço às 12:00, matrícula $env:USERNAME) e sobrescreve com as chaves do ~/.pontos.config.json. Chave desconhecida gera aviso; JSON ou valor inválido gera erro.
            .OUTPUTS
                System.Management.Automation.PSCustomObject. Horários como TimeSpan, Tolerancia em minutos.
            #>
            $valores = [ordered]@{
                Entrada            = "07:30"
                Saida              = "17:15"
                Almoco             = "01:00"
                Tolerancia         = 5
                IntervaloMinimo    = "01:00"
                LimiteSemIntervalo = "06:00"
                Interjornada       = "11:00"
                JornadaMaxima      = "10:00"
                InicioAlmoco       = "12:00"
                Matricula          = $env:USERNAME
            }
            if (Test-Path -Path $ConfigPath) {
                try {
                    $arquivo = Get-Content -Path $ConfigPath -Raw -Encoding UTF8 | ConvertFrom-Json
                }
                catch {
                    throw "Configuração inválida em ${ConfigPath}: $($_.Exception.Message)"
                }
                foreach ($propriedade in $arquivo.PSObject.Properties) {
                    if ($valores.Contains($propriedade.Name)) {
                        $valores[$propriedade.Name] = $propriedade.Value
                    }
                    else {
                        Write-Warning "Chave desconhecida em ${ConfigPath}: '$($propriedade.Name)'."
                    }
                }
            }
            try {
                [pscustomobject]@{
                    Entrada            = [timespan]$valores.Entrada
                    Saida              = [timespan]$valores.Saida
                    Almoco             = [timespan]$valores.Almoco
                    Tolerancia         = [int]$valores.Tolerancia
                    IntervaloMinimo    = [timespan]$valores.IntervaloMinimo
                    LimiteSemIntervalo = [timespan]$valores.LimiteSemIntervalo
                    Interjornada       = [timespan]$valores.Interjornada
                    JornadaMaxima      = [timespan]$valores.JornadaMaxima
                    InicioAlmoco       = [timespan]$valores.InicioAlmoco
                    Matricula          = [string]$valores.Matricula
                }
            }
            catch {
                throw "Valor inválido em ${ConfigPath}: $($_.Exception.Message). Use 'HH:mm' para horários e minutos inteiros para Tolerancia."
            }
        }

        function Get-DiaPonto {
            <#
            .SYNOPSIS
                Calcula trabalho, intervalo, atraso, saída antecipada, saldo e alertas da CLT de cada dia registrado.
            .DESCRIPTION
                Processa o histórico inteiro, para que o alerta de interjornada (art. 66) enxergue o dia anterior mesmo fora do período pedido. Batidas formam pares (1-2, 3-4, ...); dia com falta sinalizada desconta a jornada inteira.
            .PARAMETER Config
                Objeto devolvido por Get-PontoConfig.
            .OUTPUTS
                System.Management.Automation.PSCustomObject. Um por dia, valores em minutos.
            #>
            param($Config)
            $esperado = ($Config.Saida - $Config.Entrada - $Config.Almoco).TotalMinutes
            $hoje = (Get-Date).Date
            $ultimaMarcacao = $null
            $grupos = @(
                Get-PontoEntry |
                Group-Object { $_.Date.ToString("yyyy-MM-dd") } |
                Sort-Object Name
            )
            foreach ($grupo in $grupos) {
                $data = [datetime]::ParseExact($grupo.Name, "yyyy-MM-dd", $null)
                $util = $data.DayOfWeek -notin @([DayOfWeek]::Saturday, [DayOfWeek]::Sunday)
                $falta = [bool]($grupo.Group | Where-Object Label -eq "Falta")
                $marcacoes = @($grupo.Group | Where-Object Label -ne "Falta" | Sort-Object Time)
                $horas = @($marcacoes | ForEach-Object { $_.Time.TimeOfDay })

                $trabalhado = 0
                $intervalo = 0
                $atraso = 0
                $saidaAntecipada = 0
                $saldo = $null
                $obs = @()
                $alertas = @()

                if ($falta) {
                    # Falta sinalizada: desconta a jornada inteira do banco.
                    $completo = $true
                    $saldo = if ($util) { -$esperado } else { 0 }
                    $obs += "Falta"
                }
                else {
                    # Dia de hoje só entra no saldo depois da 4ª marcação, para não contar a jornada em andamento como débito.
                    $completo = ($horas.Count % 2 -eq 0) -and ($data -lt $hoje -or $horas.Count -ge 4)
                    for ($i = 0; $i + 1 -lt $horas.Count; $i += 2) { $trabalhado += ($horas[$i + 1] - $horas[$i]).TotalMinutes }
                    for ($i = 1; $i + 1 -lt $horas.Count; $i += 2) { $intervalo += ($horas[$i + 1] - $horas[$i]).TotalMinutes }

                    if ($util) {
                        $desvioEntrada = ($horas[0] - $Config.Entrada).TotalMinutes
                        if ($desvioEntrada -gt $Config.Tolerancia) { $atraso = $desvioEntrada }
                    }
                    else {
                        $obs += "Fim de semana"
                    }

                    if ($completo) {
                        $semIntervaloLegal = $trabalhado -gt $Config.LimiteSemIntervalo.TotalMinutes -and $intervalo -lt $Config.IntervaloMinimo.TotalMinutes
                        if ($util) {
                            $desvioSaida = ($Config.Saida - $horas[-1]).TotalMinutes
                            if ($desvioSaida -gt $Config.Tolerancia) { $saidaAntecipada = $desvioSaida }
                            if ($horas.Count -eq 2 -and -not $semIntervaloLegal) { $obs += "Sem intervalo registrado" }
                        }
                        $saldo = $trabalhado - $(if ($util) { $esperado } else { 0 })
                        # Tolerância diária: 5 min por marcação, até 10 min no dia.
                        if ([math]::Abs($saldo) -le (2 * $Config.Tolerancia)) { $saldo = 0 }

                        if ($semIntervaloLegal) {
                            $alertas += "Intervalo {0} < {1} (art. 71)" -f (Format-Minuto $intervalo), (Format-Minuto $Config.IntervaloMinimo.TotalMinutes)
                        }
                        if ($trabalhado -gt $Config.JornadaMaxima.TotalMinutes) {
                            $alertas += "Jornada {0} > {1} (art. 59)" -f (Format-Minuto $trabalhado), (Format-Minuto $Config.JornadaMaxima.TotalMinutes)
                        }
                    }
                    else {
                        $obs += "Incompleto ($($horas.Count) marcações)"
                    }

                    if ($null -ne $ultimaMarcacao) {
                        $descanso = ($marcacoes[0].Time - $ultimaMarcacao).TotalMinutes
                        if ($descanso -lt $Config.Interjornada.TotalMinutes) {
                            $alertas += "Descanso {0} < {1} (art. 66)" -f (Format-Minuto $descanso), (Format-Minuto $Config.Interjornada.TotalMinutes)
                        }
                    }
                    $ultimaMarcacao = $marcacoes[-1].Time
                }

                [pscustomobject]@{
                    Data            = $data
                    Util            = $util
                    Falta           = $falta
                    Completo        = $completo
                    Entrada         = if ($horas.Count) { $horas[0] } else { $null }
                    Marcacoes       = ($horas | ForEach-Object { $_.ToString("hh\:mm") }) -join " "
                    Trabalhado      = $trabalhado
                    Intervalo       = $intervalo
                    Atraso          = $atraso
                    SaidaAntecipada = $saidaAntecipada
                    Saldo           = $saldo
                    Obs             = $obs -join "; "
                    Alertas         = $alertas -join "; "
                }
            }
        }

        function Get-ResumoPonto {
            <#
            .SYNOPSIS
                Consolida os dias de Get-DiaPonto em totais e médias.
            .PARAMETER Dias
                Dias do período, como devolvidos por Get-DiaPonto.
            .PARAMETER Esperado
                Jornada diária esperada, em minutos.
            .OUTPUTS
                System.Management.Automation.PSCustomObject. Banco, créditos, débitos, atrasos, faltas e médias, em minutos.
            #>
            param([object[]]$Dias, [double]$Esperado)
            $completos = @($Dias | Where-Object Completo)
            $presentes = @($Dias | Where-Object { $_.Util -and -not $_.Falta -and $null -ne $_.Entrada })
            $comAtraso = @($Dias | Where-Object { $_.Atraso -gt 0 })
            $comSaidaAntecipada = @($Dias | Where-Object { $_.SaidaAntecipada -gt 0 })
            $comIntervalo = @($completos | Where-Object { $_.Intervalo -gt 0 })
            $atrasoTotal = [double]($comAtraso | Measure-Object Atraso -Sum).Sum

            [pscustomobject]@{
                Inicio               = $Dias[0].Data
                Fim                  = $Dias[-1].Data
                DiasComRegistro      = $Dias.Count
                DiasNoSaldo          = $completos.Count
                DiasIncompletos      = $Dias.Count - $completos.Count
                Faltas               = @($Dias | Where-Object Falta).Count
                Trabalhado           = [double]($completos | Measure-Object Trabalhado -Sum).Sum
                Esperado             = @($completos | Where-Object Util).Count * $Esperado
                Banco                = [double]($completos | Measure-Object Saldo -Sum).Sum
                Creditos             = [double]($completos | Where-Object { $_.Saldo -gt 0 } | Measure-Object Saldo -Sum).Sum
                Debitos              = [double]($completos | Where-Object { $_.Saldo -lt 0 } | Measure-Object Saldo -Sum).Sum
                DiasUteisPresentes   = $presentes.Count
                Atrasos              = $comAtraso.Count
                AtrasoTotal          = $atrasoTotal
                AtrasoMedio          = if ($comAtraso.Count) { $atrasoTotal / $comAtraso.Count } else { 0 }
                SaidasAntecipadas    = $comSaidaAntecipada.Count
                SaidaAntecipadaTotal = [double]($comSaidaAntecipada | Measure-Object SaidaAntecipada -Sum).Sum
                EntradaMedia         = ($presentes | ForEach-Object { $_.Entrada.TotalMinutes } | Measure-Object -Average).Average
                IntervaloMedio       = ($comIntervalo | Measure-Object Intervalo -Average).Average
                DiasComAlerta        = @($Dias | Where-Object Alertas).Count
            }
        }

        function Registrar {
            <#
            .SYNOPSIS
                Grava uma batida no ~/.pontos.tsf com o rótulo da posição no dia (Entrada, Almoço, Retorno, Saída ou Extra).
            .PARAMETER Date
                Data e hora da batida. Padrão: agora.
            .OUTPUTS
                System.String. Confirmação do registro.
            #>
            param(
                [Parameter(Mandatory = $false)]
                [datetime]$Date = (Get-Date)
            )
            begin {
                if (!(Test-Path -Path $FilePath)) {
                    New-Item -Path $FilePath -ItemType File -Force | Out-Null
                }
                $Labels = @(
                    "Entrada",
                    "Almoço",
                    "Retorno",
                    "Saída"
                )
            }
            process {
                $day = $Date.ToString("yyyy-MM-dd")
                $hour = $Date.ToString("HH:mm:ss")
                $registered = @(Get-Content -Path $FilePath -Encoding UTF8)
                $doDia = @($registered | Where-Object { (Get-DiaRegistro $_) -eq $day })
                if ($doDia | Where-Object { $_ -match '\sFalta\s*$' }) {
                    throw "O dia $day tem falta sinalizada. Remova a linha 'Falta' do arquivo antes de registrar ponto."
                }
                if ($doDia.Count -lt $Labels.Count) {
                    $Label = $Labels[$doDia.Count]
                }
                else {
                    $Label = "Extra"
                    Write-Warning "Já existem $($doDia.Count) pontos em $day. Registrando como '$Label'."
                }
                $DateString = "$($registered.Count + 1)`t$day`t$hour`t$Label"
                Add-Content -Path $FilePath -Value $DateString -Encoding UTF8
                Write-Output "Ponto registrado em: $day $hour $Label"
            }
        }

        function Listar {
            <#
            .SYNOPSIS
                Lista as batidas registradas num dia.
            .PARAMETER Date
                Dia a listar.
            .OUTPUTS
                System.String e PontoEntry.
            #>
            param(
                [Parameter(Mandatory = $false)]
                [datetime]$Date
            )
            begin {
                if (!(Test-Path -Path $FilePath)) {
                    throw "Arquivo não encontrado!"
                }
            }
            process {
                [PontoEntry[]]$registered = @(Get-PontoEntry)
                if ($null -ne $Date) {
                    $day = $Date.ToString("yyyy-MM-dd")
                    $registered = @($registered | Where-Object { $_.Date.ToString("yyyy-MM-dd") -eq $day })
                }
                if ($registered.Count -eq 0) {
                    Write-Output "Nenhum ponto registrado para o dia $day."
                }
                else {
                    Write-Output "Pontos registrados para o dia ${day}:"
                    foreach ($entry in $registered) {
                        Write-Output $entry
                    }
                }
            }
        }

        function Falta {
            <#
            .SYNOPSIS
                Sinaliza falta num dia útil sem batidas; o Dash desconta a jornada inteira do banco de horas.
            .DESCRIPTION
                Recusa fim de semana, dia que já tem batidas e falta repetida. Para desfazer, apague a linha "Falta" do ~/.pontos.tsf.
            .PARAMETER Date
                Dia da falta. Padrão: hoje.
            .OUTPUTS
                System.String. Confirmação.
            #>
            param(
                [Parameter(Mandatory = $false)]
                [datetime]$Date = (Get-Date)
            )
            process {
                if (!(Test-Path -Path $FilePath)) {
                    New-Item -Path $FilePath -ItemType File -Force | Out-Null
                }
                $day = $Date.ToString("yyyy-MM-dd")
                if ($Date.DayOfWeek -in @([DayOfWeek]::Saturday, [DayOfWeek]::Sunday)) {
                    throw "$day é fim de semana; falta só vale para dia útil."
                }
                $doDia = @(Get-PontoEntry | Where-Object { $_.Date -eq $Date.Date })
                if ($doDia | Where-Object Label -eq "Falta") {
                    throw "Falta já sinalizada em $day."
                }
                if ($doDia.Count) {
                    throw "O dia $day já tem $($doDia.Count) marcação(ões). Remova-as antes de sinalizar falta."
                }
                $registered = @(Get-Content -Path $FilePath -Encoding UTF8)
                Add-Content -Path $FilePath -Value "$($registered.Count + 1)`t$day`t00:00:00`tFalta" -Encoding UTF8
                Write-Output "Falta sinalizada em $day (será descontada do banco de horas)."
            }
        }

        function Alertas {
            <#
            .SYNOPSIS
                Lista as batidas a ajustar nos 7 dias anteriores a -Date.
            .DESCRIPTION
                Saída no formato "matricula;data;horario-esperado;horario-marcado", com cabeçalho. Campo vazio indica batida ausente (marcado) ou não prevista (esperado). Considera entrada/saída fora da tolerância, retorno com intervalo diferente do configurado, batidas faltantes, dias úteis sem batida e batidas extras. Ignora fins de semana e faltas sinalizadas.
            .PARAMETER Date
                Data de referência; analisa de Date-7 a Date-1. Padrão: hoje.
            .OUTPUTS
                System.String. Uma linha por incidente.
            #>
            param(
                [Parameter(Mandatory = $false)]
                [datetime]$Date = (Get-Date)
            )
            begin {
                if (!(Test-Path -Path $FilePath)) {
                    throw "Arquivo não encontrado!"
                }
                $Config = Get-PontoConfig
                $fim = $Date.Date.AddDays(-1)
                $inicio = $Date.Date.AddDays(-7)
                $formatar = { param($hora) if ($null -ne $hora) { $hora.ToString("hh\:mm") } else { "" } }
            }
            process {
                $registros = @(Get-PontoEntry | Where-Object { $_.Date -ge $inicio -and $_.Date -le $fim })
                Write-Output "matricula;data;horario-esperado;horario-marcado"
                for ($dia = $inicio; $dia -le $fim; $dia = $dia.AddDays(1)) {
                    if ($dia.DayOfWeek -in @([DayOfWeek]::Saturday, [DayOfWeek]::Sunday)) { continue }
                    $doDia = @($registros | Where-Object { $_.Date -eq $dia })
                    # Falta sinalizada já foi tratada; não é incidente.
                    if ($doDia | Where-Object Label -eq "Falta") { continue }

                    # Posições na ordem do dia: Entrada, Almoço, Retorno, Saída; o retorno esperado é almoço + duração do intervalo.
                    $horas = @($doDia | Sort-Object Time | ForEach-Object { $_.Time.TimeOfDay })
                    $almoco = if ($horas.Count -ge 2) { $horas[1] } else { $Config.InicioAlmoco }
                    $esperados = @($Config.Entrada, $Config.InicioAlmoco, ($almoco + $Config.Almoco), $Config.Saida)

                    for ($i = 0; $i -lt [math]::Max($esperados.Count, $horas.Count); $i++) {
                        $esperado = if ($i -lt $esperados.Count) { $esperados[$i] } else { $null }
                        $marcado = if ($i -lt $horas.Count) { $horas[$i] } else { $null }
                        $incidente = if ($null -eq $marcado -or $null -eq $esperado) {
                            $true
                        }
                        elseif ($i -eq 1) {
                            # Saída para o almoço não tem horário fixo; o intervalo é cobrado no retorno.
                            $false
                        }
                        else {
                            [math]::Abs(($marcado - $esperado).TotalMinutes) -gt $Config.Tolerancia
                        }
                        if ($incidente) {
                            Write-Output ("{0};{1:dd/MM/yyyy};{2};{3}" -f $Config.Matricula, $dia, (& $formatar $esperado), (& $formatar $marcado))
                        }
                    }
                }
            }
        }

        function Dash {
            <#
            .SYNOPSIS
                Exibe a tabela diária e o resumo de banco de horas, atrasos e alertas da CLT de um período.
            .PARAMETER Inicio
                Primeiro dia do período.
            .PARAMETER Fim
                Último dia do período.
            .PARAMETER Limite
                Quantidade de dias exibidos na tabela; 0 mostra todos. O resumo considera o período inteiro.
            .PARAMETER Mensal
                Acrescenta saldo de meses anteriores, banco acumulado e comparação com o mês anterior.
            .PARAMETER PassThru
                Além de exibir, devolve Dias, Resumo e MesAnterior.
            .OUTPUTS
                System.Management.Automation.PSCustomObject, apenas com -PassThru.
            #>
            param(
                [datetime]$Inicio,
                [datetime]$Fim,
                [int]$Limite = 10,
                [switch]$Mensal,
                [switch]$PassThru
            )
            begin {
                if (!(Test-Path -Path $FilePath)) {
                    throw "Arquivo não encontrado!"
                }
                $Config = Get-PontoConfig
                $Esperado = ($Config.Saida - $Config.Entrada - $Config.Almoco).TotalMinutes
            }
            process {
                $todos = @(Get-DiaPonto -Config $Config)
                $dias = @($todos | Where-Object { $_.Data -ge $Inicio.Date -and $_.Data -le $Fim.Date })
                if ($dias.Count -eq 0) {
                    "Nenhum ponto registrado no período." | Out-Host
                    return
                }

                # A tabela mostra só os últimos $Limite dias com registro; o resumo considera o período inteiro.
                $exibidos = if ($Limite -gt 0) { $dias | Select-Object -Last $Limite } else { $dias }
                $exibidos | Format-Table -AutoSize -Wrap @(
                    @{ Label = "Data"; Expression = { $_.Data.ToString("dd/MM ddd") } },
                    @{ Label = "Marcações"; Expression = { $_.Marcacoes } },
                    @{ Label = "Trabalhado"; Expression = { Format-Minuto $_.Trabalhado } },
                    @{ Label = "Intervalo"; Expression = { Format-Minuto $_.Intervalo } },
                    @{ Label = "Atraso"; Expression = { if ($_.Atraso) { Format-Minuto $_.Atraso } } },
                    @{ Label = "Saída antec."; Expression = { if ($_.SaidaAntecipada) { Format-Minuto $_.SaidaAntecipada } } },
                    @{ Label = "Saldo"; Expression = { if ($null -ne $_.Saldo) { Format-Minuto $_.Saldo -Sinal } } },
                    @{ Label = "Obs"; Expression = { $_.Obs } },
                    @{ Label = "Alertas CLT"; Expression = { $_.Alertas } }
                ) | Out-Host

                $r = Get-ResumoPonto -Dias $dias -Esperado $Esperado
                $situacao = if ($r.Banco -gt 0) { "Banco positivo (horas a favor)" } elseif ($r.Banco -lt 0) { "Banco negativo (horas devidas)" } else { "Banco zerado" }
                $resumo = [ordered]@{
                    "Período"                = "{0:dd/MM/yyyy} a {1:dd/MM/yyyy}" -f $r.Inicio, $r.Fim
                    "Jornada"                = "{0:hh\:mm}-{1:hh\:mm}, almoço {2:hh\:mm}, tolerância {3} min ({4}/dia)" -f $Config.Entrada, $Config.Saida, $Config.Almoco, $Config.Tolerancia, (Format-Minuto $Esperado)
                    "Dias com registro"      = $r.DiasComRegistro
                    "Dias no saldo"          = $r.DiasNoSaldo
                    "Dias incompletos"       = $r.DiasIncompletos
                    "Faltas"                 = $r.Faltas
                    "Horas trabalhadas"      = Format-Minuto $r.Trabalhado
                    "Horas esperadas"        = Format-Minuto $r.Esperado
                    "Banco de horas"         = Format-Minuto $r.Banco -Sinal
                    "Situação"               = $situacao
                    "Créditos (extras)"      = Format-Minuto $r.Creditos -Sinal
                    "Débitos"                = Format-Minuto $r.Debitos -Sinal
                    "Atrasos"                = "{0} de {1} dias úteis" -f $r.Atrasos, $r.DiasUteisPresentes
                    "Atraso total"           = Format-Minuto $r.AtrasoTotal
                    "Atraso médio"           = Format-Minuto $r.AtrasoMedio
                    "Saídas antecipadas"     = $r.SaidasAntecipadas
                    "Saída antecipada total" = Format-Minuto $r.SaidaAntecipadaTotal
                    "Entrada média"          = if ($null -ne $r.EntradaMedia) { Format-Minuto $r.EntradaMedia } else { "-" }
                    "Intervalo médio"        = if ($null -ne $r.IntervaloMedio) { Format-Minuto $r.IntervaloMedio } else { "-" }
                    "Dias com alerta CLT"    = $r.DiasComAlerta
                }

                $anterior = $null
                if ($Mensal) {
                    $saldoAntes = [double](@($todos | Where-Object { $_.Data -lt $Inicio.Date -and $null -ne $_.Saldo }) | Measure-Object Saldo -Sum).Sum
                    $resumo["Saldo de meses anteriores"] = Format-Minuto $saldoAntes -Sinal
                    $resumo["Banco acumulado"] = Format-Minuto ($saldoAntes + $r.Banco) -Sinal

                    $inicioAnterior = $Inicio.AddMonths(-1)
                    $diasAnterior = @($todos | Where-Object { $_.Data -ge $inicioAnterior -and $_.Data -lt $Inicio.Date })
                    if ($diasAnterior.Count) {
                        $anterior = Get-ResumoPonto -Dias $diasAnterior -Esperado $Esperado
                        $rotulo = $inicioAnterior.ToString("MMM/yy")
                        $resumo["Saldo vs. $rotulo"] = "{0} (antes {1})" -f (Format-Minuto ($r.Banco - $anterior.Banco) -Sinal), (Format-Minuto $anterior.Banco -Sinal)
                        $resumo["Atraso médio vs. $rotulo"] = "{0} (antes {1})" -f (Format-Minuto ($r.AtrasoMedio - $anterior.AtrasoMedio) -Sinal), (Format-Minuto $anterior.AtrasoMedio)
                        $resumo["Atrasos vs. $rotulo"] = "{0:+0;-0;0} (antes {1})" -f ($r.Atrasos - $anterior.Atrasos), $anterior.Atrasos
                        $resumo["Faltas vs. $rotulo"] = "{0:+0;-0;0} (antes {1})" -f ($r.Faltas - $anterior.Faltas), $anterior.Faltas
                    }
                    else {
                        $resumo["Mês anterior"] = "Sem registros"
                    }
                }

                [pscustomobject]$resumo | Format-List | Out-Host

                if ($PassThru) {
                    [pscustomobject]@{
                        Dias         = $dias
                        Resumo       = $r
                        MesAnterior  = $anterior
                    }
                }
            }
        }
    }
    process {
        switch ($Action) {
            "Registrar" {
                Registrar -Date:$Date
            }
            "Listar" {
                Listar -Date:$Date
            }
            "Falta" {
                Falta -Date:$Date
            }
            "Alertas" {
                Alertas -Date:$Date
            }
            "Dash" {
                if ($Monthly -or $PSBoundParameters.ContainsKey("Mes")) {
                    $hoje = Get-Date
                    $ano = $hoje.Year
                    if (!$PSBoundParameters.ContainsKey("Mes")) {
                        $Mes = $hoje.Month
                    }
                    elseif ($Mes -gt $hoje.Month) {
                        # Mês ainda não chegou neste ano: considera o do ano anterior.
                        $ano--
                    }
                    $primeiroDia = Get-Date -Year $ano -Month $Mes -Day 1 -Hour 0 -Minute 0 -Second 0 -Millisecond 0
                    ("Resumo de {0}" -f $primeiroDia.ToString("MMMM/yyyy")) | Out-Host
                    Dash -Inicio $primeiroDia -Fim $primeiroDia.AddMonths(1).AddDays(-1) -Limite 0 -Mensal -PassThru:$PassThru
                }
                else {
                    Dash -Inicio:$Inicio -Fim:$Fim -PassThru:$PassThru
                }
            }
            default {
                Write-Error "Ação inválida. Use 'Registrar', 'Listar', 'Falta', 'Alertas' ou 'Dash'."
            }
        }
    }
}
