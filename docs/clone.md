---
external help file: psrod-help.xml
Module Name: psrod
online version: https://github.com/rodcordeiro/PSROD/blob/main/Public/Authoral/CalcularSaida.ps1
schema: 2.0.0
---

# clone

## SYNOPSIS
Function to customize repositories cloning with some validations.

## SYNTAX

```
clone [[-Path] <String>] [[-Alias] <String>] [[-Folder] <String>] [-WhatIf] [-Confirm] [<CommonParameters>]
```

## DESCRIPTION
Function to customize repositories cloning with some validations.
It validates the folder and the repository link.

## EXAMPLES

### EXEMPLO 1
```
clone https://github.com/user/repo.git
```

### EXEMPLO 2
```
clone https://github.com/user/repo.git -y
```

### EXEMPLO 3
```
clone https://github.com/user/repo.git -Folder test
```

### EXEMPLO 4
```
clone https://github.com/user/repo.git -Alias someTest
```

### EXEMPLO 5
```
clone https://github.com/user/repo.git someTest
```

## PARAMETERS

### -Path
Please, enter the repository link for download

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

### -Alias
Provides you the possibility of changing the destiny folder name.

```yaml
Type: String
Parameter Sets: (All)
Aliases:

Required: False
Position: 2
Default value: None
Accept pipeline input: True (ByPropertyName)
Accept wildcard characters: False
```

### -Folder
Provides you the possibility of cloning the repository on a different folder.
Pass the desired folder path.

```yaml
Type: String
Parameter Sets: (All)
Aliases:

Required: False
Position: 3
Default value: None
Accept pipeline input: True (ByPropertyName)
Accept wildcard characters: False
```

### -WhatIf
Shows what would happen if the cmdlet runs.
The cmdlet is not run.

```yaml
Type: SwitchParameter
Parameter Sets: (All)
Aliases: wi

Required: False
Position: Named
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -Confirm
Prompts you for confirmation before running the cmdlet.

```yaml
Type: SwitchParameter
Parameter Sets: (All)
Aliases: cf

Required: False
Position: Named
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### CommonParameters
This cmdlet supports the common parameters: -Debug, -ErrorAction, -ErrorVariable, -InformationAction, -InformationVariable, -OutVariable, -OutBuffer, -PipelineVariable, -Verbose, -WarningAction, and -WarningVariable. For more information, see [about_CommonParameters](http://go.microsoft.com/fwlink/?LinkID=113216).

## INPUTS

## OUTPUTS

## NOTES

## RELATED LINKS
