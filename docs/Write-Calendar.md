---
external help file: psrod-help.xml
Module Name: psrod
online version: https://github.com/fleschutz/PowerShell
schema: 2.0.0
---

# Write-Calendar

## SYNOPSIS
Writes out calendar elements, either a single month or an entire year depending on the inputs.

## SYNTAX

```
Write-Calendar [[-Month] <Int32>] [[-Year] <Int32>] [-ShowHolidays] [-ObservedHolidays]
 [[-DateColors] <ConsoleColor[]>] [[-TodayColors] <ConsoleColor[]>] [[-HolidayColors] <ConsoleColor[]>]
 [<CommonParameters>]
```

## DESCRIPTION
{{ Fill in the Description }}

## EXAMPLES

### EXEMPLO 1
```
Write-Calendar
```

Outputs the current month.

### EXEMPLO 2
```
Write-Calendar 2013
```

Outputs the calendar for 2013.

### EXEMPLO 3
```
Write-Calendar 04 2011
```

Outputs the calendar for April, 2011.

### EXEMPLO 4
```
Write-Calendar 7
```

Outputs the calendar for September of this year.

## PARAMETERS

### -Month
If specified, will limit output to a single month with this numeral value.

```yaml
Type: Int32
Parameter Sets: (All)
Aliases:

Required: False
Position: 1
Default value: (Get-Date).Month
Accept pipeline input: False
Accept wildcard characters: False
```

### -Year
If specified, will output an entire year.

```yaml
Type: Int32
Parameter Sets: (All)
Aliases:

Required: False
Position: 2
Default value: (Get-Date).Year
Accept pipeline input: False
Accept wildcard characters: False
```

### -ShowHolidays
If specified, holidays for the year and month are shown.

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

### -ObservedHolidays
If specified with the ShowHolidays flag, observed holidays will be shown instead of the actual dates.

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

### -DateColors
{{ Fill DateColors Description }}

```yaml
Type: ConsoleColor[]
Parameter Sets: (All)
Aliases:
Accepted values: Black, DarkBlue, DarkGreen, DarkCyan, DarkRed, DarkMagenta, DarkYellow, Gray, DarkGray, Blue, Green, Cyan, Red, Magenta, Yellow, White

Required: False
Position: 3
Default value: @([ConsoleColor]::White, [Console]::BackgroundColor)
Accept pipeline input: False
Accept wildcard characters: False
```

### -TodayColors
{{ Fill TodayColors Description }}

```yaml
Type: ConsoleColor[]
Parameter Sets: (All)
Aliases:
Accepted values: Black, DarkBlue, DarkGreen, DarkCyan, DarkRed, DarkMagenta, DarkYellow, Gray, DarkGray, Blue, Green, Cyan, Red, Magenta, Yellow, White

Required: False
Position: 4
Default value: @([ConsoleColor]::Red, [Console]::BackgroundColor)
Accept pipeline input: False
Accept wildcard characters: False
```

### -HolidayColors
{{ Fill HolidayColors Description }}

```yaml
Type: ConsoleColor[]
Parameter Sets: (All)
Aliases:
Accepted values: Black, DarkBlue, DarkGreen, DarkCyan, DarkRed, DarkMagenta, DarkYellow, Gray, DarkGray, Blue, Green, Cyan, Red, Magenta, Yellow, White

Required: False
Position: 5
Default value: @([ConsoleColor]::White, [ConsoleColor]::DarkCyan)
Accept pipeline input: False
Accept wildcard characters: False
```

### CommonParameters
This cmdlet supports the common parameters: -Debug, -ErrorAction, -ErrorVariable, -InformationAction, -InformationVariable, -OutVariable, -OutBuffer, -PipelineVariable, -Verbose, -WarningAction, and -WarningVariable. For more information, see [about_CommonParameters](http://go.microsoft.com/fwlink/?LinkID=113216).

## INPUTS

## OUTPUTS

## NOTES
https://github.com/krispharper/Powershell-Scripts/blob/master/Write-Calendar.ps1
This script has some functionality which many would consider weird or inconsistent.
Specifically, if a month is specifed and a year is not, then the output is typically the calendar for the input month and the current year.
However, if the specified month is greater than 12, then it's treated as a year and the whole year is outputted.

The reason for this is to emulate the *NIX cal function, which behaves similarly.
That is, cal outputs the current month, cal 2012 outpus the calendar for 2012 and cal 05 2012 outputs the calendar for May 2012.

That is pretty much how Write-Calendar works with the exception that Write-Calendar 05 will write out the calendar for May of the current year whereas cal will output the calendar for the year 5.

Since the point of this script is to emulate cal's functionality I will probably not change it to make it more consistent.

## RELATED LINKS
