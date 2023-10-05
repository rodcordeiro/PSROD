---
external help file: psrod-help.xml
Module Name: psrod
online version: http://gallery.technet.microsoft.com/Get-UserSessions-Parse-b4c97837
schema: 2.0.0
---

# Get-UserSession

## SYNOPSIS
Retrieves all user sessions from local or remote computers(s)

## SYNTAX

```
Get-UserSession [[-computername] <String[]>] [-parseIdleTime] [-timeout <Object>] [<CommonParameters>]
```

## DESCRIPTION
Retrieves all user sessions from local or remote computer(s).

Note:   Requires query.exe in order to run
Note:   This works against Windows Vista and later systems provided the following registry value is in place
        HKEY_LOCAL_MACHINE\SYSTEM\CurrentControlSet\Control\Terminal Server\AllowRemoteRPC = 1
Note:   If query.exe takes longer than 15 seconds to return, an error is thrown and the next computername is processed. 
Suppress this with -erroraction silentlycontinue
Note:   If $sessions is empty, we return a warning saying no users. 
Suppress this with -warningaction silentlycontinue

## EXAMPLES

### EXEMPLO 1
```
Get-usersession -computername "server1"
```

Query all current user sessions on 'server1'

### EXEMPLO 2
```
Get-UserSession -computername $servers -parseIdleTime | ?{$_.idletime -gt [timespan]"1:00"} | ft -AutoSize
```

Query all servers in the array $servers, parse idle time, check for idle time greater than 1 hour.

## PARAMETERS

### -computername
Name of computer(s) to run session query against

```yaml
Type: String[]
Parameter Sets: (All)
Aliases:

Required: False
Position: 1
Default value: Localhost
Accept pipeline input: True (ByValue)
Accept wildcard characters: False
```

### -parseIdleTime
Parse idle time into a timespan object

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

### -timeout
Seconds to wait before ending query.exe process. 
Helpful in situations where query.exe hangs due to the state of the remote system.

```yaml
Type: Object
Parameter Sets: (All)
Aliases:

Required: False
Position: Named
Default value: 15
Accept pipeline input: False
Accept wildcard characters: False
```

### CommonParameters
This cmdlet supports the common parameters: -Debug, -ErrorAction, -ErrorVariable, -InformationAction, -InformationVariable, -OutVariable, -OutBuffer, -PipelineVariable, -Verbose, -WarningAction, and -WarningVariable. For more information, see [about_CommonParameters](http://go.microsoft.com/fwlink/?LinkID=113216).

## INPUTS

## OUTPUTS

## NOTES
Thanks to Boe Prox for the ideas - http://learn-powershell.net/2010/11/01/quick-hit-find-currently-logged-on-users/

## RELATED LINKS

[http://gallery.technet.microsoft.com/Get-UserSessions-Parse-b4c97837](http://gallery.technet.microsoft.com/Get-UserSessions-Parse-b4c97837)

