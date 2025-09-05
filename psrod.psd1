#
# Manifesto de módulo para o módulo 'psrod'
#
# Gerado por: Rodrigo Cordeiro
#
# Gerado em: 05/10/2023
#

@{
    RootModule        = '.\psrod.psm1'
    ModuleVersion     = '1.11.0'
    # CompatiblePSEditions = @()
    GUID              = '75c2e6dc-8300-44d2-9b28-f48d5d35cf64'
    Author            = 'Rodrigo Cordeiro'
    CompanyName       = 'RodCordeiro'
    Copyright         = '(c) 2025 Rodrigo Cordeiro. Todos os direitos reservados.'
    Description       = 'Module for automating daily tasks'
    PowerShellVersion = '5.1'
    # PowerShellHostName = ''
    # PowerShellHostVersion = ''
    # DotNetFrameworkVersion = ''
    # CLRVersion = ''
    # ProcessorArchitecture = ''
    RequiredModules   = @('NameIT', 'CredentialManager', 'PSRabbitMQ')
    # RequiredAssemblies = @()
    # ScriptsToProcess  = @('private/classes.ps1', 'private/preventiva.ps1')
    # TypesToProcess = @()
    # FormatsToProcess = @()
    NestedModules     = @('Public/Modules/MySQL.psm1')
    # FunctionsToExport = '*'
    # CmdletsToExport   = '*'
    VariablesToExport = '*' #@("PDAEnvironmentConfig", "PDAConfig", "Repository", "Repositories")
    # AliasesToExport   = '*' # @()
    # DscResourcesToExport = @()
    # ModuleList = @()
    # FileList = @()
    PrivateData       = @{
        PSData = @{
            # Tags applied to this module. These help with module discovery in online galleries.
            Tags       = 'CLI', 'Automation', 'CI'
            # A URL to the license for this module.
            LicenseUri = 'https://raw.githubusercontent.com/rodcordeiro/PSROD/main/License'
            # A URL to the main website for this project.
            ProjectUri = 'https://github.com/rodcordeiro/PSROD'
            # A URL to an icon representing this module.
            IconUri    = 'https://raw.githubusercontent.com/rodcordeiro/PSROD/main/assets/psyduck.webp'
            # ReleaseNotes of this module
            # ReleaseNotes = ''
            # Prerelease string of this module
            # Prerelease = ''
            # Flag to indicate whether the module requires explicit user acceptance for install/update/save
            # RequireLicenseAcceptance = $false
            # External dependent modules of this module
            # ExternalModuleDependencies = @()
        } # End of PSData hashtable
    } # End of PrivateData hashtable
    HelpInfoURI       = 'https://raw.githubusercontent.com/rodcordeiro/PSROD/main/psrod-help.xml'
    # DefaultCommandPrefix = ''
}