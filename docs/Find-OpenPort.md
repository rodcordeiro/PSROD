---
external help file: psrod-help.xml
Module Name: psrod
online version: https://github.com/fleschutz/PowerShell
schema: 2.0.0
---

# Find-OpenPort

## SYNOPSIS
Scans the network for open/closed ports

## SYNTAX

```
Find-OpenPort [[-Network] <String>] [[-Ips] <String[]>] [[-Ports] <Int32[]>] [<CommonParameters>]
```

## DESCRIPTION
This PowerShell script scans the network for open or closed ports.

## EXAMPLES

### EXEMPLO 1
```
./scan-ports
```

## PARAMETERS

### -Network
{{ Fill Network Description }}

```yaml
Type: String
Parameter Sets: (All)
Aliases:

Required: False
Position: 1
Default value: None
Accept pipeline input: True (ByPropertyName)
Accept wildcard characters: False
```

### -Ips
{{ Fill Ips Description }}

```yaml
Type: String[]
Parameter Sets: (All)
Aliases:

Required: False
Position: 2
Default value: None
Accept pipeline input: True (ByPropertyName)
Accept wildcard characters: False
```

### -Ports
{{ Fill Ports Description }}

```yaml
Type: Int32[]
Parameter Sets: (All)
Aliases:

Required: False
Position: 3
Default value: @(8080)
Accept pipeline input: True (ByPropertyName)
Accept wildcard characters: False
```

### CommonParameters
This cmdlet supports the common parameters: -Debug, -ErrorAction, -ErrorVariable, -InformationAction, -InformationVariable, -OutVariable, -OutBuffer, -PipelineVariable, -Verbose, -WarningAction, and -WarningVariable. For more information, see [about_CommonParameters](http://go.microsoft.com/fwlink/?LinkID=113216).

## INPUTS

## OUTPUTS

## NOTES
Author: Markus Fleschutz / License: CC0

## RELATED LINKS

[https://github.com/fleschutz/PowerShell](https://github.com/fleschutz/PowerShell)

