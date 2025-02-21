---
external help file: psrod-help.xml
Module Name: psrod
online version: https://github.com/fleschutz/PowerShell
schema: 2.0.0
---

# ConvertTo-TextToWav

## SYNOPSIS
Converts text to a .WAV audio file

## SYNTAX

```
ConvertTo-TextToWav [[-Text] <String>] [[-WavFile] <String>]
```

## DESCRIPTION
This PowerShell script converts text to a .WAV audio file.

## EXAMPLES

### EXEMPLO 1
```
./convert-txt2wav "Hello World" spoken.wav
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

### -WavFile
Specifies the path to the resulting WAV file

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

## INPUTS

## OUTPUTS

## NOTES
Author: Markus Fleschutz / License: CC0

## RELATED LINKS

[https://github.com/fleschutz/PowerShell](https://github.com/fleschutz/PowerShell)

