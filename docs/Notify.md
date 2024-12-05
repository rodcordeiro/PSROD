---
external help file: psrod-help.xml
Module Name: psrod
online version: http://gallery.technet.microsoft.com/Get-UserSessions-Parse-b4c97837
schema: 2.0.0
---

# Notify

## SYNOPSIS
Shows a notification

## SYNTAX

```
Notify [[-Title] <String>] [[-Message] <String>] [-Quiet] [<CommonParameters>]
```

## DESCRIPTION
Shows a notification modal on terminal, allowing to use as alert.

## EXAMPLES

### EXEMPLO 1
```
notify -Title "Title" -Message "Some usefull message"
```

### EXEMPLO 2
```
notify -Title Title -Message Usefull_message
```

### EXEMPLO 3
```
notify Title "Some usefull message"
```

## PARAMETERS

### -Title
Please, enter the message title

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

### -Message
Please, inform the message

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

### -Quiet
\[parameter(ValueFromPipelineByPropertyName, HelpMessage = "Please, inform the notification type")\]\[ValidateSet("Warning", "Info", "Error")\]\[string\]$Type

```yaml
Type: SwitchParameter
Parameter Sets: (All)
Aliases: s, q

Required: False
Position: Named
Default value: False
Accept pipeline input: False
Accept wildcard characters: False
```

### CommonParameters
This cmdlet supports the common parameters: -Debug, -ErrorAction, -ErrorVariable, -InformationAction, -InformationVariable, -OutVariable, -OutBuffer, -PipelineVariable, -Verbose, -WarningAction, and -WarningVariable. For more information, see [about_CommonParameters](http://go.microsoft.com/fwlink/?LinkID=113216).

## INPUTS

## OUTPUTS

## NOTES

## RELATED LINKS
