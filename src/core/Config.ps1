# Configuration management for dev utility

function Get-DevConfig {
    $ConfigFile = Join-Path $env:APPDATA "SzaBee13\dev\config.json"
    $config = @{
        code = $true
        explorer = $true
    }
    
    if (Test-Path $ConfigFile) {
        try {
            $cfg = Get-Content $ConfigFile | ConvertFrom-Json
            $config.code = $cfg.code
            $config.explorer = $cfg.explorer
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
