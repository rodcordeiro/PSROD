function ConvertTo-MarkdownTable {
    [CmdletBinding()]
    param(
        [Parameter(ValueFromPipelineByPropertyName, Mandatory)]
        [ValidateNotNullOrEmpty()]
        [string[]]$Columns,
        [Parameter(ValueFromPipelineByPropertyName, Mandatory = $false)]
        [string[]]$RowsLabel,
        [Parameter(ValueFromPipelineByPropertyName, Mandatory)]
        [ValidateNotNullOrEmpty()]
        [PSCustomObject[]]$Rows,
        [Parameter(ValueFromPipelineByPropertyName, Mandatory = $false)]
        [string]$OutFile
    )
    process {
        $table = @()
        $table += $(if ($RowsLabel) { '| ' }) + [String]::Join("", $($Columns | foreach-Object { "|$($_)" })) + "|"
        $table += $(if ($RowsLabel) { '|:- ' }) + [String]::Join("", $($Columns | foreach-Object { "|:-:" })) + "|"
        if ($RowsLabel) {
            $table += $RowsLabel | foreach-object {
                $app = $_
                return "|$app" + [String]::Join("", $($Columns | foreach-Object { "|$($Rows.$_.$app)" })) + "|"
            }

        }
        else {
            $table += $Rows | foreach-object {
                $row = $_
                return [String]::Join("", $($Columns | foreach-Object { "|$($row.$_)" })) + "|"
            }
        }
        if ($OutFile) {
            New-Item -Type file -Path $OutFile | Out-Null
            $table | ForEach-Object {
                Add-Content  -Path $OutFile -Value $_
            }
        }
        else {
            return $table
        }
    }

}
