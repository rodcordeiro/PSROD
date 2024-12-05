function Get-SocketMessage {
    <#
    .Notes
        https://www.jesusninoc.com/01/02/server-and-client-sockets-tcp/
    #>
    param(
        [parameter(ValueFromPipelineByPropertyName)][int]$Port = 2050,
        [parameter(ValueFromPipelineByPropertyName)]$IPAddress = [IPAddress]::Any
    )
    Begin {
        $IPEndPoint = New-Object System.Net.IPEndPoint($IPAddress, $port)
        #The TcpListener class provides simple methods that listen for and accept incoming connection requests in blocking synchronous mode. You can use either a TcpClient or a Socket to connect with a TcpListener. Create a TcpListener using an IPEndPoint, a Local IP address and port number, or just a port number. Specify Any for the local IP address and 0 for the local port number if you want the underlying service provider to assign those values for you. If you choose to do this, you can use the LocalEndpoint property to identify the assigned information, after the socket has connected.
        $TcpListener = New-Object System.Net.Sockets.TcpListener $IPEndPoint
        $keepAlive = $True
    }
    Process {
        #Use the Start method to begin listening for incoming connection requests. Start will queue incoming connections until you either call the Stop method or it has queued MaxConnections. Use either AcceptSocket or AcceptTcpClient to pull a connection from the incoming connection request queue. These two methods will block. If you want to avoid blocking, you can use the Pending method first to determine if connection requests are available in the queue.
        $TcpListener.Start()

        While ($keepAlive) {
            $AcceptTcpClient = $TcpListener.AcceptTcpClient()
            $GetStream = $AcceptTcpClient.GetStream()
            $StreamReader = New-Object System.IO.StreamReader $GetStream
            $content = $StreamReader.ReadLine()

            $StreamReader.Dispose()
            $GetStream.Dispose()
            $AcceptTcpClient.Dispose()
            Write-Output $content
            if ($content -eq 'quit') {
                $keepAlive = $False
            }
        }
    }
    End {
        $StreamReader.Dispose()
        $GetStream.Dispose()
        $AcceptTcpClient.Dispose()

        #Call the Stop method to close the TcpListener.
        $TcpListener.Stop()
    }
}