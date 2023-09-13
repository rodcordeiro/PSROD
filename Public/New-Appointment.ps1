Function New-Appointment {
    [CmdletBinding(SupportsShouldProcess, ConfirmImpact = 'medium')]
    param()
    Begin {}
    Process {
        function global:Stop-Appointment([switch] $NonDestructive) {
            if (Test-Path function:_old_virtual_prompt) {
                $function:prompt = $function:_old_virtual_prompt
                Remove-Item function:\_old_virtual_prompt
            }
        
            if ($env:Appointment) {
                $appointment = $(New-Timespan $env:Appointment $([DateTime]::Now))
                Write-Output "Time ellapsed: [$($appointment.Hours.toString('00')):$($appointment.Minutes.toString('00')):$($appointment.Seconds.toString('00'))]"
                [Environment]::SetEnvironmentVariable('Appointment', $null)
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
        
        # [System.Environment]::SetEnvironmentVariable('Appointment', [DateTime]::Now)
        $env:Appointment = [DateTime]::Now
        function global:prompt {
            # Add a prefix to the current prompt, but don't discard it.
            $previous_prompt_value = & $function:_old_virtual_prompt
            $appointment = if ($(New-Timespan $env:Appointment $([DateTime]::Now)).TotalHours -lt 1) {
                @{
                    Time   = $(New-Timespan $env:Appointment $([DateTime]::Now))
                    Color  = 'blue';
                    Letter = if ($(New-Timespan $env:Appointment $([DateTime]::Now)).Minutes -lt 1) { 's' } else { 'm' };
                }
            }
            else {
                @{
                    Time   = $(New-Timespan $env:Appointment $([DateTime]::Now))
                    Color  = 'red';
                    Letter = 'h';
                }
            }
            $new_prompt_value = Write-Host "[$($appointment.Time.Hours.toString('00')):$($appointment.Time.Minutes.toString('00')):$($appointment.Time.Seconds.toString('00'))] " -ForegroundColor $appointment.Color -NoNewline
            ($new_prompt_value + $previous_prompt_value)
        }
        
        
    }
    End {}
}