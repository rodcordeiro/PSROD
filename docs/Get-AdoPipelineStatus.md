---
external help file: psrod-help.xml
Module Name: psrod
online version: https://github.com/fleschutz/PowerShell
schema: 2.0.0
---

# Get-AdoPipelineStatus

## SYNOPSIS
Consulta o status de uma execu § £o de pipeline no Azure DevOps at © que ela seja conclu -da.

## SYNTAX

```
Get-AdoPipelineStatus [-ExecutionUrl] <String> [<CommonParameters>]
```

## DESCRIPTION
{{ Fill in the Description }}

## EXAMPLES

### Example 1
```powershell
PS C:\> {{ Add example code here }}
```

{{ Add example description here }}

## PARAMETERS

### -ExecutionUrl
URL da execu § £o do pipeline no Azure DevOps, contendo o buildId na rota de resultados.

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

### CommonParameters
This cmdlet supports the common parameters: -Debug, -ErrorAction, -ErrorVariable, -InformationAction, -InformationVariable, -OutVariable, -OutBuffer, -PipelineVariable, -Verbose, -WarningAction, and -WarningVariable. For more information, see [about_CommonParameters](http://go.microsoft.com/fwlink/?LinkID=113216).

## INPUTS

## OUTPUTS

### PSCustomObject com identificador da build, status, resultado, hor ¡rio de entrada na fila, in -cio e t ©rmino.
## NOTES
Usa a vari ¡vel de ambiente PAT para autentica § £o Basic na API de builds do Azure DevOps.

## RELATED LINKS
