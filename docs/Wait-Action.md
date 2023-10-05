---
external help file: psrod-help.xml
Module Name: psrod
online version: https://github.com/fleschutz/PowerShell
schema: 2.0.0
---

# Wait-Action

## SYNOPSIS
A script to wait for an action to finish.

## SYNTAX

```
Wait-Action [-Condition] <ScriptBlock> [-Timeout] <Int32> [[-ArgumentList] <Object[]>]
 [[-RetryInterval] <Int32>] [<CommonParameters>]
```

## DESCRIPTION
This script executes a scriptblock represented by the Condition parameter continually while the result returns 
anything other than $false or $null.

## EXAMPLES

### EXEMPLO 1
```
Wait-Action -Condition { (Get-Job).State | where { $_ -ne 'Running' } -Timeout 10
```

This example will wait for all background jobs to complete for up to 10 seconds.

## PARAMETERS

### -Condition
A mandatory scriptblock parameter representing the code to execute to check the action condition.
This code 
will be continually executed until it returns $false or $null.

```yaml
Type: ScriptBlock
Parameter Sets: (All)
Aliases:

Required: True
Position: 1
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -Timeout
A mandatory integer represneting the time (in seconds) to wait for the condition to complete.

```yaml
Type: Int32
Parameter Sets: (All)
Aliases:

Required: True
Position: 2
Default value: 0
Accept pipeline input: False
Accept wildcard characters: False
```

### -ArgumentList
An optional collection of one or more objects to pass to the scriptblock at run time.
To use this parameter, 
be sure you have a param() block in the Condition scriptblock to accept these parameters.

```yaml
Type: Object[]
Parameter Sets: (All)
Aliases:

Required: False
Position: 3
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -RetryInterval
An optional integer representing the time (in seconds) between the code execution in Condition.

```yaml
Type: Int32
Parameter Sets: (All)
Aliases:

Required: False
Position: 4
Default value: 5
Accept pipeline input: False
Accept wildcard characters: False
```

### CommonParameters
This cmdlet supports the common parameters: -Debug, -ErrorAction, -ErrorVariable, -InformationAction, -InformationVariable, -OutVariable, -OutBuffer, -PipelineVariable, -Verbose, -WarningAction, and -WarningVariable. For more information, see [about_CommonParameters](http://go.microsoft.com/fwlink/?LinkID=113216).

## INPUTS

## OUTPUTS

### System.Void
## NOTES

## RELATED LINKS
