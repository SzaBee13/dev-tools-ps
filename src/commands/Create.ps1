# Create command implementation

function Invoke-DevCreate {
    param(
        [string]$typeOrName,
        [string]$name,
        [hashtable]$roots
    )
    
    if (-not $roots.ContainsKey($typeOrName) -and $typeOrName -ne "vite" -and $typeOrName -ne "alpha-vite") {
        Write-Host "Invalid project type. Use: dev help" -ForegroundColor Red
        return
    }

    $rootPath = $roots[$typeOrName] 
    if ($typeOrName -eq "vite" -or $typeOrName -eq "alpha-vite") {
        $rootPath = if ($typeOrName -eq "vite") { $roots["web"] } else { $roots["alpha-web"] }
        Set-Location $rootPath
        npm create vite@latest $name
        Set-Location "$rootPath\$name"
        npm install
    }
    else {
        Set-Location $rootPath
        New-Item -Name $name -ItemType Directory | Out-Null
        Set-Location "$rootPath\$name"
    }

    code .
    explorer.exe .
}

Export-ModuleMember -Function Invoke-DevCreate
