Function New-Appointment {
    [CmdletBinding(SupportsShouldProcess, ConfirmImpact = 'medium')]
    param()
    Begin {
        if (-not $PSBoundParameters.ContainsKey('Verbose')) {
            $VerbosePreference = $PSCmdlet.SessionState.PSVariable.GetValue('VerbosePreference')
        }
        if (-not $PSBoundParameters.ContainsKey('Confirm')) {
            $ConfirmPreference = $PSCmdlet.SessionState.PSVariable.GetValue('ConfirmPreference')
        }
        if (-not $PSBoundParameters.ContainsKey('WhatIf')) {
            $WhatIfPreference = $PSCmdlet.SessionState.PSVariable.GetValue('WhatIfPreference')
        }
    }
    Process {
        function global:Stop-Appointment([switch] $NonDestructive) {
            $appoint = [System.Environment]::GetEnvironmentVariable('Appointment', "Machine")
            if (Test-Path function:_old_virtual_prompt) {
                $function:prompt = $function:_old_virtual_prompt
                Remove-Item function:\_old_virtual_prompt
            }

            if ($appoint) {
                $appointment = $(New-Timespan $([datetime]$appoint) $([DateTime]::UtcNow))
                Write-Output "Time ellapsed: [$($appointment.Hours.toString('00')):$($appointment.Minutes.toString('00')):$($appointment.Seconds.toString('00'))]"
                [Environment]::SetEnvironmentVariable('Appointment', $null, "Machine")
            }

            if (!$NonDestructive) {
                # Self destruct!
                Remove-Item function:Stop-Appointment -ErrorAction SilentlyContinue
                # Remove-Item function:deactivate  -ErrorAction SilentlyContinue
            }
        }

        function global:_old_virtual_prompt {
            ""
        }
        $function:_old_virtual_prompt = $function:prompt


        [System.Environment]::SetEnvironmentVariable('Appointment', [DateTime]::UtcNow, "Machine")
        function global:prompt {
            # Add a prefix to the current prompt, but don't discard it.
            $previous_prompt_value = & $function:_old_virtual_prompt

            $appointment = if ($(New-Timespan [System.Environment]::GetEnvironmentVariable('Appointment', "Machine") $([DateTime]::Now)).TotalHours -lt 1) {
                @{
                    Time   = $(New-Timespan [System.Environment]::GetEnvironmentVariable('Appointment', "Machine") $([DateTime]::Now))
                    Color  = 'green';
                    Letter = if ($(New-Timespan [System.Environment]::GetEnvironmentVariable('Appointment', "Machine") $([DateTime]::Now)).Minutes -lt 1) { 's' } else { 'm' };
                }
            }
            elseif ($(New-Timespan [System.Environment]::GetEnvironmentVariable('Appointment', "Machine") $([DateTime]::Now)).TotalHours -lt 8) {
                @{
                    Time   = $(New-Timespan [System.Environment]::GetEnvironmentVariable('Appointment', "Machine") $([DateTime]::Now))
                    Color  = 'blue';
                    Letter = if ($(New-Timespan [System.Environment]::GetEnvironmentVariable('Appointment', "Machine") $([DateTime]::Now)).Minutes -lt 1) { 's' } else { 'm' };
                }
            }
            else {
                @{
                    Time   = $(New-Timespan [System.Environment]::GetEnvironmentVariable('Appointment', "Machine") $([DateTime]::Now))
                    Color  = 'red';
                    Letter = 'h';
                }
            }
            $new_prompt_value = Write-Output "[$($appointment.Time.Hours.toString('00')):$($appointment.Time.Minutes.toString('00')):$($appointment.Time.Seconds.toString('00'))] " -ForegroundColor $appointment.Color -NoNewline

            ($new_prompt_value + $previous_prompt_value)
        }


    }
    End {}
}