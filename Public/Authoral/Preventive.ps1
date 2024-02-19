Function Preventiva() {
    <#
    .SYNOPSIS
        Execute preventive scripts
    .DESCRIPTION
        Execute preventive scripts on computer, cleaning temp files, trash and running recover tools.
    .PARAMETER Complete
        Executa o processo completo, incluindo dism, sfc, instalação de atualizações e limpeza. Caso o reboot seja passado, a limpeza não será executada.;
    .PARAMETER Cleaner
        Executa apenas a limpeza;
    .PARAMETER DiskEvents
        Verifica se há eventos de disco;
    .PARAMETER Updates
        Executa a instalação de atualizações;
    .PARAMETER Reboot
        Reinicia o computador ao finalizar a execução do script
    
    .EXAMPLE
        PS> ./Preventiva 
    .EXAMPLE
        PS> ./Preventiva -Complete
    .EXAMPLE
        PS> ./Preventiva -Cleaner
    .EXAMPLE
        PS> ./Preventiva -DiskEvents
    .EXAMPLE
        PS> ./Preventiva -Updates
    .EXAMPLE
        PS> ./Preventiva -Updates -Reboot
    .LINK
        https://github.com/rodcordeiro/PSROD/blob/main/Public/Authoral/Preventive.ps1
    .NOTES
        Author: Rodrigo M. Cordeiro
    #>
    param(
        [Switch]$Complete,
        [Switch]$Cleaner,
        [Switch]$DiskEvents,
        [Switch]$Updates,
        [Switch]$Reboot
    )

    $action = [Manutencao]::new()
    
    if ($Complete) {
        $action.repair();
        $action.Updates($Reboot);
        $action.cleaner();
        $action.DiskEvents();
    }
    if ($Cleaner) {
        $action.cleaner();
    }
    if ($DiskEvents) {
        $action.DiskEvents();
    }
    if ($Updates) {
        $action.Updates($Reboot);
    }
    if ($Reboot) {
        shutdown -r -f -t 0
    }
    return $action
}