---
external help file: psrod-help.xml
Module Name: psrod
online version: https://github.com/fleschutz/PowerShell
schema: 2.0.0
---

# New-Slug

## SYNOPSIS
Generates a simple, readable slug (alias) from input text.

## SYNTAX

```
New-Slug [-InputString] <String> [[-MaxLen] <Int32>] [<CommonParameters>]
```

## DESCRIPTION
Converts a string into a URL/alias-safe slug:
- Lowercases everything
- Replaces spaces/underscores with dashes
- Removes invalid characters
- Collapses multiple dashes
- Ensures max length (default: 16 chars) cutting at the nearest dash if possible

## EXAMPLES

### EXEMPLO 1
```
New-Slug "Hello World! This is an Alias"
```

# hello-world

### EXEMPLO 2
```
New-Slug "Daily Check In" -MaxLen 12
```

# daily-check

## PARAMETERS

### -InputString
The text you want to convert into a slug.

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

### -MaxLen
Maximum allowed length of the slug (default: 16).

```yaml
Type: Int32
Parameter Sets: (All)
Aliases:

Required: False
Position: 2
Default value: 16
Accept pipeline input: False
Accept wildcard characters: False
```

### CommonParameters
This cmdlet supports the common parameters: -Debug, -ErrorAction, -ErrorVariable, -InformationAction, -InformationVariable, -OutVariable, -OutBuffer, -PipelineVariable, -Verbose, -WarningAction, and -WarningVariable. For more information, see [about_CommonParameters](http://go.microsoft.com/fwlink/?LinkID=113216).

## INPUTS

## OUTPUTS

## NOTES

## RELATED LINKS
