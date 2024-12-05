Function Get-isInsideGit() {
    try {
        if (git rev-parse --is-inside-work-tree) {
            return $true
        }
        return $false
    }
    catch {
        return $false
    }
}