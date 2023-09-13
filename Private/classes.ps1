class PDAEnvironmentConfig {
    [ValidateNotNullOrEmpty()][string]$env
    [ValidateNotNullOrEmpty()][string]$path
    [ValidateNotNullOrEmpty()][string]$type
    [string]$iisSite
    [string]$scheduledTask
    [string]$winsowsService
}

class PDAConfig {
    [ValidateNotNullOrEmpty()][string]$name
    [ValidateNotNullOrEmpty()][string[]]$files
    [string[]]$exclude
    [PDAEnvironmentConfig[]]$env
}
