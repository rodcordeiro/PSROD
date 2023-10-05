---
external help file: psrod-help.xml
Module Name: psrod
online version: https://github.com/rodcordeiro/psrod
schema: 2.0.0
---

# Discord

## SYNOPSIS
Sends a discord message through webhook

## SYNTAX

```
Discord [[-Content] <String>] [[-Username] <String>] [[-Avatar] <String>] [[-Webhook] <String>] [-Silent]
 [<CommonParameters>]
```

## DESCRIPTION
Calls a discord wehbook, sending text content through it.

## EXAMPLES

### EXEMPLO 1
```
./Discord -Content 'Some hello'
```

## PARAMETERS

### -Content
Content of the message

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

### -Username
Username that sent the message.
Defaults to: Lord Vader

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

### -Avatar
User avatar url.
Defaults to: Lord vader image.

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

### -Webhook
{{ Fill Webhook Description }}

```yaml
Type: String
Parameter Sets: (All)
Aliases:

Required: False
Position: 4
Default value: None
Accept pipeline input: True (ByPropertyName)
Accept wildcard characters: False
```

### -Silent
{{ Fill Silent Description }}

```yaml
Type: SwitchParameter
Parameter Sets: (All)
Aliases:

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
Author: Rodrigo M.
Cordeiro

## RELATED LINKS

[https://github.com/rodcordeiro/psrod](https://github.com/rodcordeiro/psrod)

