---
external help file: psrod-help.xml
Module Name: psrod
online version: https://github.com/fleschutz/PowerShell
schema: 2.0.0
---

# New-QrCode

## SYNOPSIS
Generates a new QR code image file

## SYNTAX

```
New-QrCode [[-Text] <String>] [[-ImageSize] <String>] [<CommonParameters>]
```

## DESCRIPTION
This PowerShell script generates a new QR code image file.

## EXAMPLES

### EXEMPLO 1
```
./new-qrcode "Fasten seatbelt" 500x500
```

## PARAMETERS

### -Text
Specifies the text to use

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

### -ImageSize
Specifies the image size (width x height)

```yaml
Type: String
Parameter Sets: (All)
Aliases:

Required: False
Position: 2
Default value: None
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

