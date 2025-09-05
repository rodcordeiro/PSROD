function New-Slug {
    <#
    .SYNOPSIS
        Generates a simple, readable slug (alias) from input text.

    .DESCRIPTION
        Converts a string into a URL/alias-safe slug:
        - Lowercases everything
        - Replaces spaces/underscores with dashes
        - Removes invalid characters
        - Collapses multiple dashes
        - Ensures max length (default: 16 chars) cutting at the nearest dash if possible

    .PARAMETER InputString
        The text you want to convert into a slug.

    .PARAMETER MaxLen
        Maximum allowed length of the slug (default: 16).

    .EXAMPLE
        New-Slug "Hello World! This is an Alias"
        # hello-world

    .EXAMPLE
        New-Slug "Daily Check In" -MaxLen 12
        # daily-check
    #>
    param(
        [Parameter(Mandatory = $true)]
        [string]$InputString,

        [int]$MaxLen = 16
    )

    # Normalize
    $slug = $InputString.ToLower().Trim()
    $slug = $slug -replace '[\s_]+', '-'      # spaces/underscores → dash
    $slug = $slug -replace '[^a-z0-9-]', ''   # keep only alphanumeric/dash
    $slug = $slug -replace '-{2,}', '-'       # collapse multiple dashes
    $slug = $slug.Trim('-')                   # remove leading/trailing dashes

    if ($slug.Length -gt $MaxLen) {
        # Try to cut at the last dash before max length
        $cut = $slug.Substring(0, $MaxLen)
        $lastDash = $cut.LastIndexOf('-')
        if ($lastDash -gt 0) {
            $slug = $cut.Substring(0, $lastDash)
        }
        else {
            $slug = $cut.TrimEnd('-')
        }
    }

    return $slug
}
