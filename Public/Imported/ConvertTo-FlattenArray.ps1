    function ConvertTo-FlattenArray ($array) {
        $result = @()
        foreach ($item in $array) {
            if ($item -is [System.Collections.IEnumerable] -and $item -isnot [System.Collections.Hashtable]) {
                $result += ConvertTo-FlattenArray -array $item
            }
            else {
                $result += $item
            }
        }
        return $result
    }