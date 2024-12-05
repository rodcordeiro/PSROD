
class OcelotEntryKeys {
    [int] $Porta
    [string]$Chave
}

function Export-OcelotEntry {
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
