﻿function Confirm-Choice {
# Author: Adam the Automator
# URL: https://github.com/adbertram/Random-PowerShell-Work/blob/master/Random%20Stuff/Confirm-Choice.ps1

	[OutputType('boolean')]
	[CmdletBinding()]
	param
	(
		[Parameter()]
		[ValidateNotNullOrEmpty()]
		[string]$Title,

		[Parameter(Mandatory)]
		[ValidateNotNullOrEmpty()]
		[string]$PromptMessage
	)

	$yes = New-Object System.Management.Automation.Host.ChoiceDescription "&Yes"
	$no = New-Object System.Management.Automation.Host.ChoiceDescription "&No"
	$options = [System.Management.Automation.Host.ChoiceDescription[]]($yes, $no)

	if ($PSBoundParameters.ContainsKey('Title')) {
		Write-Host -Object $Title -ForegroundColor Cyan
	}

	Write-Host -Object $PromptMessage -ForegroundColor Cyan
	$result = $host.ui.PromptForChoice($null, $null, $Options, 1)

	switch ($result) {
		0 {
			$true
		}
		1 {
			$false
		}
	}
}