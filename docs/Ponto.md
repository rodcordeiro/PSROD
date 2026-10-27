---
external help file: psrod-help.xml
Module Name: psrod
online version: https://github.com/rodcordeiro/PSROD/blob/main/Public/Authoral/Ponto.ps1
schema: 2.0.0
---

# Ponto

## SYNOPSIS
Registra e analisa o ponto (batidas de entrada, almoço, retorno e saída).

## SYNTAX

### Registrar (Default)
```
Ponto [-Action] <String> [-Date <DateTime>] [<CommonParameters>]
```

### Dash
```
Ponto [-Action] <String> [-Inicio <DateTime>] [-Fim <DateTime>] [-Monthly] [[-Mes] <Int32>] [-PassThru]
 [<CommonParameters>]
```

### Alertas
```
Ponto [-Action] <String> [-Date <DateTime>] [<CommonParameters>]
```

### Falta
```
Ponto [-Action] <String> [-Date <DateTime>] [<CommonParameters>]
```

### Listar
```
Ponto [-Action] <String> [-Date <DateTime>] [<CommonParameters>]
```

## DESCRIPTION
Mantém as batidas em ~/.pontos.tsf (uma por linha, separada por TAB) e oferece as ações:

- Registrar: grava uma batida; o rótulo segue a ordem do dia (Entrada, Almoço, Retorno, Saída, Extra).
- Listar: mostra as batidas de um dia.
- Falta: sinaliza falta num dia útil sem batidas; o Dash desconta a jornada inteira do banco de horas.
- Alertas: lista as batidas a ajustar nos 7 dias anteriores a -Date, no formato
  "matricula;data;horario-esperado;horario-marcado".
- Dash: calcula banco de horas, atrasos, saídas antecipadas, médias e alertas da CLT
  (intervalo \< 1h, jornada \> 10h, descanso \< 11h). Com -Monthly, resume um mês e compara com o anterior.

A jornada é configurável em ~/.pontos.config.json (chaves Entrada, Saida, Almoco, Tolerancia,
IntervaloMinimo, LimiteSemIntervalo, Interjornada, JornadaMaxima, InicioAlmoco e Matricula).
Sem o arquivo, vale 07:30-17:15 com 1h de almoço, tolerância de 5 min e a matrícula $env:USERNAME.

## EXAMPLES

### EXEMPLO 1
```
Ponto Registrar
```

Registra uma batida com o horário atual.

### EXEMPLO 2
```
Ponto Registrar -Date "2026-10-27T07:40:00"
```

Registra uma batida retroativa.

### EXEMPLO 3
```
Ponto Listar -Date 2026-10-26
```

Lista as batidas de 26/10/2026.

### EXEMPLO 4
```
Ponto Falta -Date 2026-10-21
```

Sinaliza falta em 21/10/2026; o dia passa a descontar a jornada do banco de horas.

### EXEMPLO 5
```
Ponto Alertas | Set-Clipboard
```

Copia os incidentes dos últimos 7 dias para enviar ao RH.

### EXEMPLO 6
```
Ponto Dash -Inicio 2026-10-01 -Fim 2026-10-31
```

Mostra os últimos 10 dias do período e o resumo de banco de horas, atrasos e alertas.

### EXEMPLO 7
```
Ponto Dash -Monthly 9
```

Resume setembro, com saldo transportado e comparação com agosto.

### EXEMPLO 8
```
(Ponto Dash -Monthly -PassThru).Dias | Export-Csv mes.csv -NoTypeInformation
```

Exporta os dias do mês atual para CSV.

## PARAMETERS

### -Action
Ação a executar: Registrar, Listar, Falta, Alertas ou Dash.

```yaml
Type: String
Parameter Sets: (All)
Aliases:

Required: True
Position: 1
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -Date
Data/hora de referência.
Registrar: horário da batida.
Listar: dia exibido.
Falta: dia da falta.
Alertas: os 7 dias anteriores a esta data são analisados.
Padrão: agora.

```yaml
Type: DateTime
Parameter Sets: Registrar, Alertas, Falta, Listar
Aliases:

Required: False
Position: Named
Default value: (Get-Date)
Accept pipeline input: False
Accept wildcard characters: False
```

### -Inicio
Dash: primeiro dia do período analisado.
Padrão: início do histórico.

```yaml
Type: DateTime
Parameter Sets: Dash
Aliases:

Required: False
Position: Named
Default value: [datetime]::MinValue
Accept pipeline input: False
Accept wildcard characters: False
```

### -Fim
Dash: último dia do período analisado.
Padrão: fim do histórico.

```yaml
Type: DateTime
Parameter Sets: Dash
Aliases:

Required: False
Position: Named
Default value: [datetime]::MaxValue
Accept pipeline input: False
Accept wildcard characters: False
```

### -Monthly
Dash: resume um mês inteiro (o atual ou o informado em -Mes), com saldo de meses anteriores e comparação com o mês anterior.

```yaml
Type: SwitchParameter
Parameter Sets: Dash
Aliases:

Required: False
Position: Named
Default value: False
Accept pipeline input: False
Accept wildcard characters: False
```

### -Mes
Dash: número do mês (1-12) para o resumo mensal.
Mês ainda não chegado no ano corrente é do ano anterior.
Informar -Mes já ativa o modo mensal.

```yaml
Type: Int32
Parameter Sets: Dash
Aliases:

Required: False
Position: 2
Default value: 0
Accept pipeline input: False
Accept wildcard characters: False
```

### -PassThru
Dash: além de exibir, devolve um objeto com Dias, Resumo (valores em minutos) e MesAnterior.

```yaml
Type: SwitchParameter
Parameter Sets: Dash
Aliases:

Required: False
Position: Named
Default value: False
Accept pipeline input: False
Accept wildcard characters: False
```

### CommonParameters
This cmdlet supports the common parameters: -Debug, -ErrorAction, -ErrorVariable, -InformationAction, -InformationVariable, -OutVariable, -OutBuffer, -PipelineVariable, -Verbose, -WarningAction, and -WarningVariable. For more information, see [about_CommonParameters](http://go.microsoft.com/fwlink/?LinkID=113216).

## INPUTS

### Nenhum.
## OUTPUTS

### System.String. Mensagens de Registrar, Falta e as linhas de Alertas.
### PontoEntry. Batidas exibidas por Listar.
### System.Management.Automation.PSCustomObject. Dash com -PassThru.
## NOTES
Regras de tolerância (5 min por batida, até 10 min no dia) seguem o art.
58, §1º, da CLT.
Dia com número ímpar de batidas fica fora do saldo; o dia de hoje só entra a partir da 4ª batida.

## RELATED LINKS

[https://github.com/rodcordeiro/PSROD/blob/main/Public/Authoral/Ponto.ps1](https://github.com/rodcordeiro/PSROD/blob/main/Public/Authoral/Ponto.ps1)

