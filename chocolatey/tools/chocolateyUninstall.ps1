$ErrorActionPreference = 'Stop'

$packageName = 'dev-powershell-utility'
$toolsDir = "$(Split-Path -parent $MyInvocation.MyCommand.Definition)"
$scriptFile = Join-Path $toolsDir 'src\dev.ps1'

Write-Host "Uninstalling Dev PowerShell Utility..." -ForegroundColor Cyan

# Determine PowerShell profile path
$profilePath = $PROFILE.CurrentUserAllHosts
if ([string]::IsNullOrEmpty($profilePath)) {
    $profilePath = $PROFILE
}

# Remove dev function from PowerShell profile
if (Test-Path $profilePath) {
    Write-Host "Checking PowerShell profile: $profilePath"
    $profileContent = Get-Content $profilePath -Raw -ErrorAction SilentlyContinue
    
    if ($null -ne $profileContent -and $profileContent -match [regex]::Escape($scriptFile)) {
        Write-Host "Removing dev function from PowerShell profile..." -ForegroundColor Yellow
        
        # Remove the dev utility section
        $pattern = "(?m)^\r?\n?# Dev PowerShell Utility\r?\n\. `"[^`"]+dev\.ps1`"\r?\n?"
        $newContent = $profileContent -replace $pattern, ''
        
        # Also try a more lenient pattern in case formatting differs
        if ($newContent -eq $profileContent) {
            $pattern = "(?m)# Dev PowerShell Utility.*?\.ps1`"[\r\n]+"
            $newContent = $profileContent -replace $pattern, ''
        }
        
        Set-Content -Path $profilePath -Value $newContent -Force
        Write-Host "✓ Dev function removed from PowerShell profile." -ForegroundColor Green
    } else {
        Write-Host "Dev function not found in PowerShell profile (or already removed)." -ForegroundColor Yellow
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
Write-Host "✓ Dev PowerShell Utility has been uninstalled." -ForegroundColor Green
Write-Host "Please restart your PowerShell session for changes to take effect." -ForegroundColor Yellow
