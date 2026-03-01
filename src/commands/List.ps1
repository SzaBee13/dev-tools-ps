# List command implementation

function Invoke-DevList {
    param(
        [string]$typeOrName,
        [hashtable]$roots
    )
    
    if ($roots.ContainsKey($typeOrName)) {
        Get-ChildItem -Path $roots[$typeOrName] -Directory | Select-Object Name
    }
    else {
        Write-Host "Please specify a valid type: web, python, home, discord, alpha-cpp, alpha-web" -ForegroundColor Red
    }
}

Export-ModuleMember -Function Invoke-DevList
