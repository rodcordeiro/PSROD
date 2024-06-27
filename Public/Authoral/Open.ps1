function Open {
    <#
        .Description
        Open the specified path in editor or file explorer
        .Example
        Open ./desktop
        .Example 
        Open Project/Project.sln
        .Example
        Open archive.json
        .Example
        Open Project -AsFolder
        #>
    Param (
        [string]
        [parameter(ValueFromPipelineByPropertyName, Mandatory = $false)]
        $Path,
        [switch]
        [parameter(ValueFromPipelineByPropertyName, Mandatory = $false)]
        $AsFolder
    )

    Begin {
        if (!$Path) {
            $Path = Get-Location
        }
            
            
    }
    Process {
        # Test if path exists
        if ($(Test-Path $Path) -eq $false) { throw [System.IO.FileNotFoundException]::new("Invalid path or file not exists.") }
            
        # Resolve path to destination
        $Path = Resolve-Path $Path
        
        if ($AsFolder) {
            explorer.exe $Path
            return
        }
        
        # Test if path is a dotnet solution
        if (Test-Path -Path $Path -Include *.sln ) {
            Invoke-Item $Path
            return
        }
        
        # Test if path has a dotnet solution
        if ( $(Resolve-Path -Path $Path\*.sln  -ErrorAction SilentlyContinue) ) {
            Invoke-Item $(Resolve-Path -Path $Path\*.sln )
            return
        }

        # Test if path has package.json
        if ($(Resolve-Path -Path $Path\package.json -ErrorAction SilentlyContinue)) {
            code $Path
            return
        }

        # $path_details = $(Get-Item -Path $Path)
        # # Test if path is a file
        # if ($path_details.Attributes -eq 'Archive') {
        #     code $Path
        #     return
        # }

        
        # Test if path is a directory
        if (Test-Path -Path $Path -PathType Container) {
            explorer.exe $Path
            return
        }
        
        # Open in VSCode
        code $Path
    }        
}
