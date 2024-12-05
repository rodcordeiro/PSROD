---
external help file: psrod-help.xml
Module Name: psrod
online version: https://github.com/rodcordeiro/PSROD/blob/main/Public/Authoral/Preventive.ps1
schema: 2.0.0
---

# Publish-PowerShellGalleryModule

## SYNOPSIS
This script is a script designed to remove all barriers to entry when publishing modules to the PowerShell
Gallery.
Before running, ensure the NuGetApiKey parameter has a default parameter value.

## SYNTAX

```
Publish-PowerShellGalleryModule [-ModuleFilePath] <String> [-RunOptionalTests] [[-NuGetApiKey] <String>]
 [-PublishToGallery] [<CommonParameters>]
```

## DESCRIPTION
This script has two different purposes; to ensure your module meets all official Gallery requirements and to
assist in creating your own "requirements".
As-is, the script ensure your module is Gallery-ready by checking for
all official requirements but also performs a couple extra tests.
It's purpose is to provide a foundation to
add upon to for your own "requirements" for the Gallery.

Each run will ensure a module manifest is in the same folder as the ModuleFilePath and will ensure that manifest 
has all of the required keys.
Also, it will run Test-ModuleManifest to ensure the result passes there as well.

## EXAMPLES

### EXEMPLO 1
```
Publish-PowerShellGalleryModule -ModuleFilePath C:\Foo\Foo.psm1 -NuGetApiKey XXXXXXXXX
```

This example will check the Foo module for all pre-defined requirements and fix as necessary.

### EXEMPLO 2
```
Publish-PowerShellGalleryModule -ModuleFilePath C:\Modules\Foo.psm1 -RunOptionalTests
```

This example assumes that you've included a default value for the NuGetApiKey.

## PARAMETERS

### -ModuleFilePath
A mandatory string parameter representing the file path to a PSM1 file.
The folder path also represents the 
folder that will be searched for a matching module manifest as well.

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

### -RunOptionalTests
A switch parameter to enable if you'd like to run any optional tests.
Currently, the only optional tests is a
Pester tests file.
If a file matching $ModuleName.Tests.ps1 is not in the same folder as the PSM1, it will
notice this and prompt to create a simple template.

To add more tests, just add a hashtable to the $moduleTests array by copying an existing one ensuring
that the Mandatory key value is as expected.

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

### -NuGetApiKey
A optional PowerShell parameter yet required Gallery attribute representing the NuGet API key provided when
signing up for an account with the PowerShell Gallery.
This can be found by going to the URL
https://www.powershellgallery.com/users/account/LogOn?returnUrl=%2F.
It is recommended that your key be placed
as the default parameter value to remove the need of providing it each time.

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

### -PublishToGallery
An optional switch parameter to use if you'd like to automatically published the tested module to the PowerShell Gallery.
If this isn't used, you will be prompted to publish.

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

## RELATED LINKS
