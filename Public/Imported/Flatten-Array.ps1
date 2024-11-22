function Flatten-Array ($array) {
    $result = @()
    foreach ($item in $array) {
        if ($item -is [System.Collections.IEnumerable] -and $item -isnot [System.Collections.Hashtable]) {
            $result += Flatten-Array -array $item
        }
        else {
            $result += $item
        }
    }
    return $result
}