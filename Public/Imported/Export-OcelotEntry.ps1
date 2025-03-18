
class OcelotEntryKeys {
    [int] $Porta
    [string]$Chave
}

function Export-OcelotEntry {
    param(
        [OcelotEntryKeys[]]$keys,
        [switch]$Prod,
        [string]$SourceFile,
        [switch]$KeepExistingRoutes
    )

    begin {
        if ($KeepExistingRoutes -and -not $SourceFile) {
            throw "Invalid parameters set. KeepExistingRoutes is only available when SourceFile is informed"
        }
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
                };
                "RateLimitOptions"     = @{
                    "QuotaExceededMessage" = "Limite de consultas por segundo excedida! Aguarde e tente novamente mais tarde.";
                    "ClientWhitelist"      = @(); # array of strings
                }
            }
        }
        if ($SourceFile) {
            if (Test-Path $SourceFile) {
                try {
                    Write-Host "Carregando rotas do arquivo de origem: $SourceFile"
                    $existingConfig = Get-Content -Path $SourceFile | ConvertFrom-Json
                    $existingRoutes = $existingConfig.Routes | Where-Object { -not $_.SwaggerKey -or $KeepExistingRoutes }
                    $dictionary.Routes.AddRange($existingRoutes) | Out-Null
                    if ($KeepExistingRoutes) {
                        $dictionary.SwaggerEndPoints.AddRange($existingConfig.SwaggerEndPoints) | Out-Null
                    }
                }
                catch {
                    Write-Error "Erro ao carregar o arquivo de origem: $_"
                }
            }
            else {
                Throw "Arquivo de origem não encontrado: $SourceFile"
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

        $dictionary.Routes = ConvertTo-FlattenArray $dictionary.Routes
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
