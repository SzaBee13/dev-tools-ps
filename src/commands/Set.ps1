# Set command implementation

function Invoke-DevSet {
    param(
        [string]$typeOrName,
        [string]$name,
        [object]$code
    )
    
    if ($typeOrName -eq "root") {
        if (-not $name) {
            Write-Host "Usage: dev set root <root-name> <path | remove>" -ForegroundColor Yellow
            return
        }

        $RootsFile = Join-Path $env:APPDATA "SzaBee13\dev\roots.json"
        
        if (-not (Test-Path $RootsFile)) {
            $dir = Split-Path $RootsFile
            if (-not (Test-Path $dir)) { New-Item -ItemType Directory -Path $dir -Force | Out-Null }
            '{}' | Out-File -Encoding utf8 $RootsFile
        }

        # Load and ensure it's a hashtable
        $roots = if (Test-Path $RootsFile) {
            $json = Get-Content $RootsFile -Raw
            if ($json.Trim()) {
                try {
                    $tmp = $json | ConvertFrom-Json
                    if ($tmp -is [System.Collections.Hashtable]) { $tmp }
                    else {
                        $h = @{}
                        foreach ($p in $tmp.PSObject.Properties) { $h[$p.Name] = $p.Value }
                        $h
                    }
                }
                catch { @{} }
            }
            else { @{} }
        }
        else { @{} }

        # handle remove or set
        if ($code -eq "remove" -or $code -eq "rm") {
            if ($roots.ContainsKey($name)) {
                $roots.Remove($name)
                Write-Host "Root '$name' removed." -ForegroundColor Yellow
            }
            else {
                Write-Host "Root '$name' not found." -ForegroundColor Red
            }
        }
        else {
            $roots[$name] = $code
            Write-Host "Root '$name' set to path '$code'" -ForegroundColor Green
        }

        # save file
        Save-DevRoots -roots $roots
    }
    else {
        Write-Host "Unknown set type '$typeOrName'" -ForegroundColor Red
    }
}
