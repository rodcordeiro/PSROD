---
external help file: rod-help.xml
Module Name: psrod
online version: https://github.com/rodcordeiro/PSROD/blob/main/Public/Authoral/CalcularSaida.ps1
schema: 2.0.0
---

# CalcularHorarios

## SYNOPSIS
Calculates exit time

## SYNTAX

```
CalcularHorarios [[-Entrada] <DateTime>] [[-Almoco] <DateTime>] [[-Retorno] <DateTime>] [-Output]
 [<CommonParameters>]
```

## DESCRIPTION
Receives entrance and lunch times and calculates estimated exit time

## EXAMPLES

### EXEMPLO 1
```
CalcularSaida -Entrada 9:10 -Almoco 12:15 -Retorno 13:35
```

## PARAMETERS

### -Entrada
Entrance time

```yaml
Type: DateTime
Parameter Sets: (All)
Aliases:

Required: False
Position: 1
Default value: None
Accept pipeline input: True (ByPropertyName)
Accept wildcard characters: False
```

### -Almoco
Exit for lunch time

```yaml
Type: DateTime
Parameter Sets: (All)
Aliases:

Required: False
Position: 2
Default value: None
Accept pipeline input: True (ByPropertyName)
Accept wildcard characters: False
```

### -Retorno
Lunch time returns

```yaml
Type: DateTime
Parameter Sets: (All)
Aliases:

Required: False
Position: 3
Default value: None
Accept pipeline input: True (ByPropertyName)
Accept wildcard characters: False
```

### -Output
Outputs only time without friendly message

```yaml
Type: SwitchParameter
Parameter Sets: (All)
Aliases:

Required: False
Position: Named
Default value: False
Accept pipeline input: True (ByPropertyName)
Accept wildcard characters: False
```

### CommonParameters
This cmdlet supports the common parameters: -Debug, -ErrorAction, -ErrorVariable, -InformationAction, -InformationVariable, -OutVariable, -OutBuffer, -PipelineVariable, -Verbose, -WarningAction, and -WarningVariable. For more information, see [about_CommonParameters](http://go.microsoft.com/fwlink/?LinkID=113216).

## INPUTS

## OUTPUTS

## NOTES

## RELATED LINKS

[https://github.com/rodcordeiro/PSROD/blob/main/Public/Authoral/CalcularSaida.ps1](https://github.com/rodcordeiro/PSROD/blob/main/Public/Authoral/CalcularSaida.ps1)

