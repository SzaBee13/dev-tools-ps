$ErrorActionPreference = 'Stop'

$packageName = 'dev-powershell-utility'
$toolsDir = "$(Split-Path -parent $MyInvocation.MyCommand.Definition)"
$scriptFile = Join-Path $toolsDir 'src\dev.ps1'

Write-Host "Uninstalling Dev PowerShell Utility..." -ForegroundColor Cyan

# Target both Windows PowerShell 5.1 and PowerShell 7+ profiles
$profilePaths = @(
    (Join-Path $env:USERPROFILE "Documents\WindowsPowerShell\Microsoft.PowerShell_profile.ps1"),
    (Join-Path $env:USERPROFILE "Documents\PowerShell\Microsoft.PowerShell_profile.ps1")
)

foreach ($profilePath in $profilePaths) {
    if (-not (Test-Path $profilePath)) { continue }

    $profileContent = Get-Content $profilePath -Raw -ErrorAction SilentlyContinue
    if ($null -eq $profileContent) { continue }

    if ($profileContent -match [regex]::Escape($scriptFile)) {
        Write-Host "Removing dev entry from: $profilePath" -ForegroundColor Yellow

        $pattern = "(?m)\r?\n# Dev PowerShell Utility\r?\n\. `"[^`"]+dev\.ps1`""
        $newContent = $profileContent -replace $pattern, ''

        Set-Content -Path $profilePath -Value $newContent -Force
        Write-Host "[OK] Removed from $profilePath" -ForegroundColor Green
    } else {
        Write-Host "[SKIP] Not found in $profilePath" -ForegroundColor Gray
    }
}

# Ask about configuration files
Write-Host ""
Write-Host "Configuration files are located at: $env:APPDATA\SzaBee13\dev" -ForegroundColor Cyan
Write-Host "These files contain your saved roots and preferences." -ForegroundColor Cyan
Write-Host ""
Write-Host "To remove configuration files manually, run:" -ForegroundColor Yellow
Write-Host "  Remove-Item '$env:APPDATA\SzaBee13\dev' -Recurse -Force" -ForegroundColor Yellow
Write-Host ""
Write-Host "[OK] Dev PowerShell Utility has been uninstalled." -ForegroundColor Green
Write-Host "Please restart your PowerShell session for changes to take effect." -ForegroundColor Yellow
