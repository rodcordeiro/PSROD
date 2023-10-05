---
external help file: psrod-help.xml
Module Name: psrod
online version: https://github.com/fleschutz/PowerShell
schema: 2.0.0
---

# ConvertTo-MorseCode

## SYNOPSIS
Writes text in Morse code

## SYNTAX

```
ConvertTo-MorseCode [[-text] <String>] [[-speed] <Int32>] [<CommonParameters>]
```

## DESCRIPTION
This PowerShell script writes text in Morse code.

## EXAMPLES

### EXEMPLO 1
```
./write-morse-code "Hello World"
```

## PARAMETERS

### -text
Specifies the text to write

```yaml
Type: String
Parameter Sets: (All)
Aliases:

Required: False
Position: 1
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -speed
Specifies the speed of one time unit (100 ms per default)

```yaml
Type: Int32
Parameter Sets: (All)
Aliases:

Required: False
Position: 2
Default value: 10
Accept pipeline input: False
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

