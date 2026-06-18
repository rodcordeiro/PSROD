---
external help file: psrod-help.xml
Module Name: psrod
online version: https://github.com/fleschutz/PowerShell
schema: 2.0.0
---

# Get-AdoPullRequestsCreatedLastWeek

## SYNOPSIS
Obt ©m pull requests criados em reposit ³rios do Azure DevOps dentro de uma janela recente.

## SYNTAX

```
Get-AdoPullRequestsCreatedLastWeek [-Organization] <String> [-Project] <String> [-Repositories] <String[]>
 [[-Pat] <String>] [[-Status] <String>] [[-DaysBack] <Int32>] [<CommonParameters>]
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

### -Organization
Nome da organiza § £o no Azure DevOps.

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

### -Project
Nome do projeto no Azure DevOps.

```yaml
Type: String
Parameter Sets: (All)
Aliases:

Required: True
Position: 2
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -Repositories
Lista de reposit ³rios que ser £o consultados.

```yaml
Type: String[]
Parameter Sets: (All)
Aliases:

Required: True
Position: 3
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -Pat
Personal Access Token usado na autentica § £o Basic.
Por padr £o, usa a vari ¡vel de ambiente PAT.

```yaml
Type: String
Parameter Sets: (All)
Aliases:

Required: False
Position: 4
Default value: $env:PAT
Accept pipeline input: False
Accept wildcard characters: False
```

### -Status
Status dos pull requests retornados: all, active, completed ou abandoned.

```yaml
Type: String
Parameter Sets: (All)
Aliases:

Required: False
Position: 5
Default value: All
Accept pipeline input: False
Accept wildcard characters: False
```

### -DaysBack
Quantidade de dias retroativos usada para calcular a data m -nima de cria § £o.

```yaml
Type: Int32
Parameter Sets: (All)
Aliases:

Required: False
Position: 6
Default value: 7
Accept pipeline input: False
Accept wildcard characters: False
```

### CommonParameters
This cmdlet supports the common parameters: -Debug, -ErrorAction, -ErrorVariable, -InformationAction, -InformationVariable, -OutVariable, -OutBuffer, -PipelineVariable, -Verbose, -WarningAction, and -WarningVariable. For more information, see [about_CommonParameters](http://go.microsoft.com/fwlink/?LinkID=113216).

## INPUTS

## OUTPUTS

### PSCustomObject com reposit ³rio, identificador, t -tulo, descri § £o, status, autor, data de cria § £o, branches e URL do pull request.
## NOTES

## RELATED LINKS
