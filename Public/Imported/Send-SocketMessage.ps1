function Send-SocketMessage {
    <#
    .Notes
        https://www.jesusninoc.com/01/02/server-and-client-sockets-tcp/
    #>
    param(
        [parameter(ValueFromPipelineByPropertyName, Mandatory = $true)][String]$Content,    
        [parameter(ValueFromPipelineByPropertyName)][int]$Port = 2050,
        [parameter(ValueFromPipelineByPropertyName)]$IPAddress = [IPAddress]::Loopback

    )   
    Begin {
        $TcpClient = New-Object System.Net.Sockets.TcpClient($IPAddress, $port)

        #The TcpListener class provides simple methods that listen for and accept incoming connection requests in blocking synchronous mode. You can use either a TcpClient or a Socket to connect with a TcpListener. Create a TcpListener using an IPEndPoint, a Local IP address and port number, or just a port number. Specify Any for the local IP address and 0 for the local port number if you want the underlying service provider to assign those values for you. If you choose to do this, you can use the LocalEndpoint property to identify the assigned information, after the socket has connected.
    }
    Process {
        $GetStream = $TcpClient.GetStream()
        $StreamWriter = New-Object System.IO.StreamWriter $GetStream
        
        $StreamWriter.Write($Content)
    }
    End {
        $StreamWriter.Dispose()
        $GetStream.Dispose()
        $TcpClient.Dispose()
    }    
}
