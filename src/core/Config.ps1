# Configuration management for dev utility

function Get-DevConfig {
    $ConfigFile = Join-Path $env:APPDATA "SzaBee13\dev\config.json"
    $config = @{
        code = $true
        explorer = $true
        pullPath = "D:\pull"
        driveRoot = "D:\"
    }
    
    if (Test-Path $ConfigFile) {
        try {
            $cfg = Get-Content $ConfigFile | ConvertFrom-Json
            $config.code = $cfg.code
            $config.explorer = $cfg.explorer
            if ($cfg.pullPath) { $config.pullPath = $cfg.pullPath } else { $config.pullPath = "C:\\Users\\$env:USERNAME\\Downloads" }
            if ($cfg.driveRoot) { $config.driveRoot = $cfg.driveRoot } else { $config.driveRoot = "C:\\Users\\$env:USERNAME\\Documents" }
        }
        catch {
            Write-Host "Failed to load config.json, using defaults." -ForegroundColor Yellow
        }
    }
    
    return $config
}

function Get-DevRoots {
    $RootsFile = Join-Path $env:APPDATA "SzaBee13\dev\roots.json"
    $roots = @{}

    if (Test-Path $RootsFile) {
        try {
            $json = Get-Content $RootsFile -Raw | ConvertFrom-Json
            $roots = @{}
            foreach ($p in $json.PSObject.Properties) {
                $roots[$p.Name] = $p.Value
            }
        }
        catch {
            Write-Host "Failed to load roots.json, using empty roots." -ForegroundColor Yellow
            $roots = @{}
        }
    }
    else {
        # Create directory and file if missing
        $dir = Split-Path $RootsFile
        if (-not (Test-Path $dir)) { New-Item -ItemType Directory -Path $dir -Force | Out-Null }
        '{}' | Out-File -Encoding utf8 $RootsFile
        Write-Host "Created new roots.json at $RootsFile" -ForegroundColor Yellow
    }
    
    return $roots
}

function Save-DevRoots {
    param([hashtable]$roots)
    
    $RootsFile = Join-Path $env:APPDATA "SzaBee13\dev\roots.json"
    $roots | ConvertTo-Json | Out-File -Encoding utf8 $RootsFile
}

function Get-DevLicenses {
    $LicensesPath = Join-Path $env:APPDATA "SzaBee13\dev\licenses.json"
    
    if (Test-Path $LicensesPath) {
        return Get-Content $LicensesPath | ConvertFrom-Json
    }
    else {
        Write-Host "No local licenses found. Downloading from GitHub..." -ForegroundColor Yellow
        $url = "https://raw.githubusercontent.com/SzaBee13/dev-tools-ps/refs/heads/main/licenses.json"

        try {
            $licensesJson = Invoke-RestMethod -Uri $url

            # Prompt user for their name to replace [name]
            $userName = Read-Host "Enter your name for the license copyright"

            # Replace [name] placeholders in all license entries
            foreach ($key in $licensesJson.PSObject.Properties.Name) {
                $licensesJson[$key] = $licensesJson[$key] -replace "\[name\]", $userName
            }

            # Save locally for future use
            $licensesJson | ConvertTo-Json -Compress | Set-Content -Path $LicensesPath
            Write-Host "Licenses downloaded, updated with your name, and saved to $LicensesPath" -ForegroundColor Green
            return $licensesJson
        }
        catch {
            Write-Host "Failed to download licenses JSON. Proceeding without it." -ForegroundColor Red
            return @{ }
        }
    }
}

function Get-DevRepositories {
    $ReposFile = Join-Path $env:APPDATA "SzaBee13\dev\repos.json"
    $repos = @{}

    if (Test-Path $ReposFile) {
        try {
            $json = Get-Content $ReposFile -Raw | ConvertFrom-Json
            foreach ($p in $json.PSObject.Properties) {
                # Skip metadata properties
                if (-not $p.Name.StartsWith("_")) {
                    $repos[$p.Name] = $p.Value
                }
            }
        }
        catch {
            Write-Host "Failed to load repos.json" -ForegroundColor Yellow
            $repos = @{}
        }
    }
    else {
        $dir = Split-Path $ReposFile
        if (-not (Test-Path $dir)) { New-Item -ItemType Directory -Path $dir -Force | Out-Null }
        '{}' | Out-File -Encoding utf8 $ReposFile
    }
    
    return $repos
}

function Save-DevRepositories {
    param([hashtable]$repos)
    
    $ReposFile = Join-Path $env:APPDATA "SzaBee13\dev\repos.json"
    $dir = Split-Path $ReposFile
    if (-not (Test-Path $dir)) { New-Item -ItemType Directory -Path $dir -Force | Out-Null }
    
    $repos | ConvertTo-Json | Out-File -Encoding utf8 $ReposFile
}

function Search-GitRepositories {
    param(
        [string[]]$paths = @()
    )
    
    $foundRepos = @{}
    
    # Add default pull path if not already in paths
    $pullPath = "D:\pull"
    if ($paths -notcontains $pullPath) {
        $paths += $pullPath
    }
    
    # Scan each path for git repositories
    foreach ($scanPath in $paths) {
        if (Test-Path $scanPath) {
            Write-Verbose "Scanning: $scanPath"
            
            # Find all .git folders (directories or files)
            $gitDirs = Get-ChildItem -Path $scanPath -Filter ".git" -Recurse -ErrorAction SilentlyContinue -Force
            
            foreach ($gitDir in $gitDirs) {
                $repoPath = $gitDir.Parent.FullName
                
                try {
                    # Get git repo info
                    $gitConfig = Join-Path $repoPath ".git\config"
                    
                    if (Test-Path $gitConfig) {
                        $url = $null
                        $content = Get-Content $gitConfig -ErrorAction SilentlyContinue
                        
                        # Parse git config to get repo URL
                        foreach ($line in $content) {
                            if ($line -match 'url = (.+)') {
                                $url = $matches[1]
                                break
                            }
                        }
                        
                        if ($url) {
                            # Extract owner and repo name from URL
                            $repoName = Split-Path -Leaf $repoPath
                            $owner = $null
                            $platform = 'github'
                            
                            if ($url -match 'github\.com[:/]([^/]+)/(.+?)(?:\.git)?$') {
                                $owner = $matches[1]
                                $platform = 'github'
                            }
                            elseif ($url -match 'gitlab\.com[:/]([^/]+)/(.+?)(?:\.git)?$') {
                                $owner = $matches[1]
                                $platform = 'gitlab'
                            }
                            elseif ($url -match 'bitbucket\.org[:/]([^/]+)/(.+?)(?:\.git)?$') {
                                $owner = $matches[1]
                                $platform = 'bitbucket'
                            }
                            else {
                                # Extract last path component as owner
                                $urlParts = $url -split '/' | Where-Object { $_ }
                                if ($urlParts.Count -ge 2) {
                                    $owner = $urlParts[-2]
                                }
                            }
                            
                            if ($owner) {
                                $key = "$owner/$repoName"
                                $foundRepos[$key] = @{
                                    url = $url.TrimEnd('.git')
                                    path = $repoPath
                                    localName = $repoName
                                    platform = $platform
                                    owner = $owner
                                    lastPulled = (Get-Item $repoPath).LastWriteTime.ToUniversalTime().ToString('o')
                                }
                            }
                        }
                    }
                }
                catch {
                    Write-Verbose "Error scanning repo at $repoPath : $_"
                }
            }
        }
    }
    
    return $foundRepos
}
