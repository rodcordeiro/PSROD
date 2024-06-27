Function Find-OpenPorts {
    <#
.SYNOPSIS
	Scans the network for open/closed ports
.DESCRIPTION
	This PowerShell script scans the network for open or closed ports.
.EXAMPLE
	PS> ./scan-ports
.LINK
	https://github.com/fleschutz/PowerShell
.NOTES
	Author: Markus Fleschutz / License: CC0
#>
    param(
        [parameter(ValueFromPipelineByPropertyName, Mandatory = $false)][String]$Network,
        [parameter(ValueFromPipelineByPropertyName, Mandatory = $false)][String[]]$Ips,
        [parameter(ValueFromPipelineByPropertyName, Mandatory = $false)]
        [int[]]$Ports = @(8080)
    )
    begin {
        if (!$Network -and !$Ip) {
            Write-Error "Network or IP must be passed to be executed"
        }
        $ErrorActionPreference = "silentlycontinue"
        $Range = 1..254
        $Response = @()
    }
    process {
        if ($Network) {
            foreach ($endpoint in $range) {
                $ip = "{0}.{1}" -F $Network, $endpoint
                write-progress "Scanning IP $ip" -PercentComplete (($endpoint / $range.Count) * 100)
                $Details = @{
                    "Ip"        = $ip;
                    "Connected" = $false
                }
                if (Test-Connection -BufferSize 32 -Count 1 -quiet -ComputerName $ip) {
                    $Details.Connected = $True;
                    $AvailablePorts = @();                    
                    
                    foreach ($port in $Ports) {
                        $socket = new-object System.Net.Sockets.TcpClient($ip, $port)
                        if ($socket.Connected) {
                            $AvailablePorts.Add($port);
                            # write-output "TCP port $port at $ip is open"
                            $socket.Close()
                        }
                        else {
                            # write-output "TCP port $port at $ip is not open"
                        }
                        $Details.AvailablePorts = $AvailablePorts;
                    }
                }
                $Response.Add($Details);
            }
        }
        if ($Ips) {
            $i = 1;
            foreach ($ip in $Ips) {
                write-progress "Scanning IP $ip" -PercentComplete (($i / $Ips.Count) * 100)
                $Details = @{
                    "Connected" = $false
                }
                if (Test-Connection -BufferSize 32 -Count 1 -quiet -ComputerName $ip) {
                    $Details.Connected = $True;
                    $AvailablePorts = @();                    
                    
                    foreach ($port in $Ports) {
                        $socket = new-object System.Net.Sockets.TcpClient($ip, $port)
                        if ($socket.Connected) {
                            $AvailablePorts += $port;
                            write-output "TCP port $port at $ip is open"
                            $socket.Close()
                        }
                        else {
                            write-output "TCP port $port at $ip is not open"
                        }
                        $Details.AvailablePorts = $AvailablePorts;
                    }
                }
                $Response += @{
                    "Ip"      = $ip;
                    "Details" = $Details
                }
                $i++
            }
        }

    }
    end {
        $Response
    }

    # $range = 1..254
    # $ErrorActionPreference = "silentlycontinue"

    # foreach ($add in $range) {
    #     $ip = "{0}.{1}" -F $network, $add
    #     write-progress "Scanning IP $ip" -PercentComplete (($add / $range.Count) * 100)
    #     if (Test-Connection -BufferSize 32 -Count 1 -quiet -ComputerName $ip) {
    #         $socket = new-object System.Net.Sockets.TcpClient($ip, $port)
    #         if ($socket.Connected) {
    #             write-output "TCP port $port at $ip is open"
    #             $socket.Close()
    #         }
    #         else {
    #             write-output "TCP port $port at $ip is not open"
    #         }
    #     }
    # }
    # exit 0 # success
    # param(
    #     [String]$Network = "192.168.100",
    #     [int]$Port = 8080
    # )
    # $range = 1..254
    # $ErrorActionPreference = "silentlycontinue"

    # foreach ($add in $range) {
    #     $ip = "{0}.{1}" -F $network, $add
    #     write-progress "Scanning IP $ip" -PercentComplete (($add / $range.Count) * 100)
    #     if (Test-Connection -BufferSize 32 -Count 1 -quiet -ComputerName $ip) {
    #         $socket = new-object System.Net.Sockets.TcpClient($ip, $port)
    #         if ($socket.Connected) {
    #             write-output "TCP port $port at $ip is open"
    #             $socket.Close()
    #         }
    #         else {
    #             write-output "TCP port $port at $ip is not open"
    #         }
    #     }
    # }
}