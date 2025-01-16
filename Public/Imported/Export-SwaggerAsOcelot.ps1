function Export-SwaggerAsOcelot {
    param(
        [Parameter(Mandatory, ValueFromPipelineByPropertyName)]
        [int]$Porta,
        [Parameter(Mandatory, ValueFromPipelineByPropertyName)]
        [string]$Chave,
        [switch]$Prod,
        [switch]$ReturnAsObject
    )

    begin {
        $url = "backend.torratorra.com.br"
        if (!$Prod) {
            $url = "hml.backend.torratorra.com.br"

        }
        # Define the OpenAPI endpoint URL
        $openApiUrl = "http://$($url):$($Porta)/swagger/v1/swagger.json"
        # Output JSON file
        $outputFile = "$Chave.json"
    }

    process {
        # Fetch the OpenAPI JSON schema
        try {
            Write-Host "Fetching OpenAPI schema from $openApiUrl..."
            $openApiSchema = Invoke-RestMethod -Uri $openApiUrl -Method GET
        }
        catch {
            Throw "Failed to fetch OpenAPI schema: $_"
        }

        # Extract paths and format them
        $formattedPaths = @()

        foreach ($path in $openApiSchema.paths.PSObject.Properties) {
            $methods = @()

            foreach ($method in $path.Value.PSObject.Properties) {
                $methods += $method.Name.ToUpper()
            }

            $formattedPaths += @{
                DownstreamPathTemplate   = $path.Name;
                "DownstreamScheme"       = "http";
                "DownstreamHostAndPorts" = @(
                    @{
                        "Host" = $url;
                        "Port" = $Porta
                    }
                );
                UpstreamPathTemplate     = $path.Name;
                UpstreamHttpMethod       = $methods;
                SwaggerKey               = $Chave;
                "RateLimitOptions"       = @{
                    "ClientWhitelist"      = @(); # array of strings
                    "EnableRateLimiting"   = $true;
                    "Period"               = "1s"; # seconds; minutes; hours; days
                    "PeriodTimespan"       = 30; # only seconds
                    "Limit"                = 15;
                    "QuotaExceededMessage" = "Limite de consultas por segundo excedida! Aguarde e tente novamente mais tarde."
                }
            }
        }

        $dictionary = [PSCustomObject]@{
            Routes           = $formattedPaths;
            SwaggerEndPoints = @{
                Key    = $Chave;
                Config = @(@{
                        Name    = $Chave;
                        Version = "v1";
                        Url     = $openApiUrl;
                    })
            }
        }
    }

    end {
        # Convert to JSON
        $jsonOutput = $dictionary | ConvertTo-Json -Depth 10 -Compress

        if ($ReturnAsObject) { return $dictionary }

        # Write the JSON output to a file
        try {
            Set-Content -Path $outputFile -Value $jsonOutput -Force
            Write-Host "Formatted paths written to $outputFile"
        }
        catch {
            Throw "Failed to write to file: $_"
        }
    }
}
