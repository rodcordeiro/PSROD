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
                    "ClientWhitelist"    = @(); # array of strings
                    "EnableRateLimiting" = $true;
                    "Period"             = "1s"; # seconds; minutes; hours; days
                    "PeriodTimespan"     = 30; # only seconds
                    "Limit"              = 3
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

class OcelotEntryKeys {
    [int] $Porta
    [string]$Chave
}

function Export-OcelotEntries {
    param(
        [OcelotEntryKeys[]]$keys,
        [switch]$Prod
    )

    begin {
        $dictionary = [PSCustomObject]@{
            Routes                = [System.Collections.ArrayList]::new();
            SwaggerEndPoints      = [System.Collections.ArrayList]::new();
            "GlobalConfiguration" = @{
                "AddHeadersToResponse" = @{
                    "X-Paginacao-Total-Itens"   = "X-Paginacao-Total-Itens";
                    "X-Paginacao-Total-Paginas" = "X-Paginacao-Total-Paginas"
                };
                "Cors"                 = @{
                    "ExposedHeaders" = @(
                        "X-Paginacao-Total-Itens",
                        "X-Paginacao-Total-Paginas"
                    )
                }
            }
        }
    }

    process {
        foreach ($key in $keys) {
            try {
                $dict = $(Export-SwaggerAsOcelot -porta $key.porta -chave $key.chave -ReturnAsObject -Prod:$Prod)
                $dictionary.Routes.Add($dict.Routes) | Out-Null
                $dictionary.SwaggerEndPoints.Add($dict.SwaggerEndPoints) | Out-Null
            }
            catch {
                Write-Error "
:: Falha ao consultar $($key.Chave).
$_"
            }
        }

        $dictionary.Routes = Flatten-Array $dictionary.Routes
        $jsonOutput = $dictionary | ConvertTo-Json -Depth 10 -Compress
        
        # Write the JSON output to a file
        try {
            Set-Content -Path ocelot.json -Value $jsonOutput -Force
            Write-Host "Formatted paths written to ./ocelot.json"
        }
        catch {
            Throw "Failed to write to file: $_"
        }
    }
}