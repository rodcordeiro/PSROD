class MessagesReceiver {
    [System.Collections.ArrayList]$Observers
    [bool]$Running

    MessagesReceiver() {
        $this.Observers = [System.Collections.ArrayList]::new()
        $this.Running = $true
    }

    [void] Listen (
        [string]$QueueName ,
        [string]$Exchange ,
        [string]$ExchangeType ,
        [string]$RoutingKey
    ) {
        try {
            Write-Output 'Listening for RabbitMQ messages...'

            # Credenciais para conectar ao RabbitMQ
            $strPass = ConvertTo-SecureString -String $env:RabbitMQ_Password -AsPlainText -Force
            $Cred = New-Object -TypeName System.Management.Automation.PSCredential -ArgumentList ($env:RabbitMQ_User, $strPass)

            $Conn = New-RabbitMqConnectionFactory -ComputerName 82.180.136.148 -Credential $Cred -Port 3340

            $Params = @{
                ComputerName = '82.180.136.148';
                Timeout      = 100000;
                Credential   = $Cred;
                QueueName    = $QueueName;
                Exchange     = $Exchange;
                ExchangeType = $ExchangeType;
                Ssl          = "None";
                Key          = $RoutingKey;
                Port         = 3340
            }

            Connect-RabbitMqChannel -Connection $Conn  -QueueName $QueueName -Exchange $Exchange -ExchangeType $ExchangeType -Key $RoutingKey | Out-Null
            while ($this.Running) {
                $message = $(Wait-RabbitMqMessage @Params | convertfrom-json)

                if ($message.pattern) {
                    $message = $message.data;
                }

                if ($message.title -eq "STOP_LISTENER") {
                    $this.Running = $false
                    return;
                }

                $this.NotifyObservers($message);
            }
        }
        catch {
            Write-Error $_
            Start-Sleep -Seconds 5
            Write-Output 'Retrying...'
            $this.Listen()
        }
        finally {
            if ($this.Running -eq $true) {
                $this.Listen()
            }
            # start-job -Name RabbitListener -ScriptBlock { $this.Listen() }
        }
    }

    # Notifica todos os observadores registrados
    [void]  NotifyObservers($message) {
        foreach ($observer in $this.Observers) {
            $observer.Invoke($this, $message)
        }
    }

    # Registra um observador
    [void] RegisterObserver([scriptblock]$observer) {
        $this.Observers.Add($observer) | Out-Null
    }

    # Remove um observador
    [void] UnregisterObserver([scriptblock]$observer) {
        $this.Observers.Remove($observer) | Out-Null
    }
}

