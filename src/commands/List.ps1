# List command implementation

function Invoke-DevList {
    param(
        [string]$typeOrName,
        [switch]$json,
        [hashtable]$roots
    )
    
    # If --json flag is used, return repositories as JSON
    if ($json) {
        $repos = Get-DevRepositories
        if ($repos.Count -eq 0) {
            $output = @{ repos = @() }
        }
        else {
            $reposArray = @()
            foreach ($key in $repos.Keys) {
                $repo = $repos[$key]
                $reposArray += @{
                    owner = $repo.owner
                    name = $repo.localName
                    url = $repo.url
                    path = $repo.path
                    platform = $repo.platform
                    lastPulled = $repo.lastPulled
                }
            }
            $output = @{ repos = $reposArray }
        }
        return $output | ConvertTo-Json -Depth 10
    }
    
    # List folders in a specific root type
    if ($roots.ContainsKey($typeOrName)) {
        Get-ChildItem -Path $roots[$typeOrName] -Directory -ErrorAction SilentlyContinue | Select-Object Name
    }
    else {
        Write-Host "Please specify a valid type or use --json flag" -ForegroundColor Red
    }
}

function Invoke-ReposScan {
    param(
        [hashtable]$roots
    )
    
    Write-Verbose "Scanning for git repositories..."
    
    # Get all paths to scan (pull path + all roots)
    $pathsToScan = @("D:\pull")
    foreach ($root in $roots.Values) {
        if ($root -and (Test-Path $root)) {
            $pathsToScan += $root
        }
    }
    
    # Scan for repos
    $foundRepos = Search-GitRepositories -paths $pathsToScan
    
    # Get existing repos
    $existingRepos = Get-DevRepositories
    
    # Merge: new repos take priority
    foreach ($key in $foundRepos.Keys) {
        $existingRepos[$key] = $foundRepos[$key]
    }
    
    # Save updated repos
    Save-DevRepositories -repos $existingRepos
    
    return @{
        success = $true
        synced = $foundRepos.Count
        totalRepos = $existingRepos.Count
    } | ConvertTo-Json
}
