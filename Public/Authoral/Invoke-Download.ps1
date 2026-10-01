function Invoke-Download {
    <#
    .SYNOPSIS
        Baixa um arquivo via BITS, com retomada após intermitência de rede.
    .DESCRIPTION
        Cria ou reutiliza um job do usuário atual com a mesma URL e destino.
        Aguarda a transferência e entrega o arquivo com Complete-BitsTransfer.
        Erros transitórios são tratados pelo BITS com sua política de retry.
        Ctrl+C interrompe a espera sem remover o job; execute novamente com os
        mesmos parâmetros para acompanhar e concluir a transferência pendente.
    .PARAMETER Uri
        URL HTTP ou HTTPS do arquivo.
    .PARAMETER Destination
        Caminho do arquivo de saída, incluindo o nome. A pasta deve existir.
        Arquivos já existentes não são sobrescritos.
    .PARAMETER PollIntervalSeconds
        Intervalo de atualização do progresso. Padrão: 5 segundos.
    .PARAMETER RetryIntervalSeconds
        Intervalo mínimo entre tentativas do BITS. Padrão: 60 segundos.
        Aplica-se somente a jobs novos.
    .PARAMETER RetryTimeoutSeconds
        Prazo de retry após erro transitório. Padrão: 86400 segundos (24 horas).
        Aplica-se somente a jobs novos; não é um limite total do download.
    .EXAMPLE
        Invoke-Download -Uri 'https://isosmint.ic.ufmt.br/stable/22.3/linuxmint-22.3-cinnamon-64bit.iso' -Destination '.\linuxmint-22.3-cinnamon-64bit.iso'
        Baixa a ISO ou acompanha o job pendente para a mesma URL e destino.
    .EXAMPLE
        Invoke-Download -Uri 'https://example.com/file.zip' -Destination 'D:\Downloads\file.zip' -RetryTimeoutSeconds 172800
        Permite até 48 horas de retry após erro transitório em um job novo.
    .OUTPUTS
        System.IO.FileInfo. Arquivo concluído.
    .NOTES
        Requer Windows e o módulo BitsTransfer. A retomada depende do job BITS
        preservado, do servidor e das políticas do serviço. Não importa arquivos
        parciais de outros programas. Fechar a sessão ou reiniciar o computador
        não garante execução contínua; volte a chamar a função ao entrar novamente.
        Jobs em erro são preservados para diagnóstico e retomada explícita via
        Resume-BitsTransfer, ou descarte via Remove-BitsTransfer.
    .LINK
        https://learn.microsoft.com/powershell/module/bitstransfer/start-bitstransfer
    #>
    # Documentação XML auxiliar; Get-Help utiliza o bloco acima.
    <#
    <summary>Baixa um arquivo com retomada gerenciada pelo BITS.</summary>
    <param name="Uri">URL HTTP ou HTTPS de origem.</param>
    <param name="Destination">Caminho completo ou relativo do arquivo de saída.</param>
    <param name="PollIntervalSeconds">Intervalo de atualização do progresso.</param>
    <param name="RetryIntervalSeconds">Intervalo mínimo de retry para jobs novos.</param>
    <param name="RetryTimeoutSeconds">Prazo de retry para jobs novos.</param>
    <returns>System.IO.FileInfo do arquivo concluído.</returns>
    <exception>Falha de validação, erro permanente ou cancelamento do job.</exception>
    #>
    [CmdletBinding()]
    [OutputType([System.IO.FileInfo])]
    param(
        [Parameter(Mandatory, Position = 0)]
        [ValidateScript({ $_.IsAbsoluteUri -and $_.Scheme -in @('http', 'https') })]
        [uri]$Uri,

        [Parameter(Mandatory, Position = 1)]
        [ValidateNotNullOrEmpty()]
        [string]$Destination,

        [ValidateRange(1, 3600)]
        [int]$PollIntervalSeconds = 5,

        [ValidateRange(60, 2147483647)]
        [int]$RetryIntervalSeconds = 60,

        [ValidateRange(60, 2147483647)]
        [int]$RetryTimeoutSeconds = 86400
    )

    if ($RetryTimeoutSeconds -lt $RetryIntervalSeconds) {
        throw 'RetryTimeoutSeconds deve ser maior ou igual a RetryIntervalSeconds.'
    }

    Import-Module BitsTransfer -ErrorAction Stop
    $provider = $null
    $drive = $null
    $targetPath = $ExecutionContext.SessionState.Path.GetUnresolvedProviderPathFromPSPath(
        $Destination, [ref]$provider, [ref]$drive
    )
    if ($provider.Name -ne 'FileSystem') {
        throw 'O destino deve pertencer ao sistema de arquivos.'
    }
    $parentPath = Split-Path -Parent $targetPath
    if (-not (Test-Path -LiteralPath $parentPath -PathType Container)) {
        throw "A pasta de destino não existe: $parentPath"
    }
    if (Test-Path -LiteralPath $targetPath) {
        throw "O destino já existe: $targetPath"
    }

    $jobs = @(Get-BitsTransfer -ErrorAction Stop | Where-Object {
        @($_.FileList | Where-Object { $_.LocalName -ieq $targetPath }).Count -gt 0
    })
    if ($jobs.Count -gt 1) {
        throw 'Mais de um job BITS usa esse destino. Resolva os jobs antes de continuar.'
    }
    if ($jobs.Count -eq 1) {
        $job = $jobs[0]
        $files = @($job.FileList)
        if ($job.TransferType -ne 'Download' -or $files.Count -ne 1 -or
            $files[0].RemoteName -cne $Uri.AbsoluteUri) {
            throw 'Outro job BITS usa esse destino com origem ou configuração diferente.'
        }
    } else {
        $parameters = @{
            Source = $Uri.AbsoluteUri
            Destination = $targetPath
            DisplayName = 'Invoke-Download: ' + [System.IO.Path]::GetFileName($targetPath)
            Description = 'Download resiliente iniciado pelo psrod'
            Asynchronous = $true
            RetryInterval = $RetryIntervalSeconds
            RetryTimeout = $RetryTimeoutSeconds
            ErrorAction = 'Stop'
        }
        $job = Start-BitsTransfer @parameters
    }

    Write-Verbose "Job BITS: $($job.JobId)"
    try {
        while ($true) {
            $job = Get-BitsTransfer -Id $job.JobId -ErrorAction Stop
            $percent = -1
            # BITS usa UInt64.MaxValue quando o tamanho ainda é desconhecido.
            if ($job.BytesTotal -gt 0 -and $job.BytesTotal -lt [uint64]::MaxValue) {
                $percent = [int][math]::Min(100, 100.0 * $job.BytesTransferred / $job.BytesTotal)
            }
            Write-Progress -Activity 'Download via BITS' -Status "$($job.JobState): $($job.BytesTransferred) bytes" -PercentComplete $percent

            switch ([string]$job.JobState) {
                'Transferred' {
                    Complete-BitsTransfer -BitsJob $job -ErrorAction Stop
                    return Get-Item -LiteralPath $targetPath -ErrorAction Stop
                }
                'Suspended' {
                    Resume-BitsTransfer -BitsJob $job -Asynchronous -ErrorAction Stop | Out-Null
                }
                'TransientError' {
                    Write-Verbose 'Falha transitória; aguardando o retry automático do BITS.'
                }
                'Error' {
                    throw "Falha no job $($job.JobId): $($job.ErrorDescription) (código $($job.ErrorCode)). O job foi preservado."
                }
                'Cancelled' { throw 'O download foi cancelado.' }
                'Acknowledged' { throw 'O job foi concluído por outro processo.' }
            }
            Start-Sleep -Seconds $PollIntervalSeconds
        }
    } finally {
        Write-Progress -Activity 'Download via BITS' -Completed
    }
}