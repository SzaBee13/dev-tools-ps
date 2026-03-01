$ErrorActionPreference = 'Stop'

$packageName = 'dev-powershell-utility'
$toolsDir = "$(Split-Path -parent $MyInvocation.MyCommand.Definition)"
$scriptFile = Join-Path $toolsDir 'src\dev.ps1'

Write-Host "Installing Dev PowerShell Utility..." -ForegroundColor Cyan

# Create appdata directory structure
$appdataPath = Join-Path $env:APPDATA 'SzaBee13\dev'
if (-not (Test-Path $appdataPath)) {
    Write-Host "Creating configuration directory: $appdataPath"
    New-Item -ItemType Directory -Path $appdataPath -Force | Out-Null
}

# Copy licenses.json to appdata if it doesn't exist
$licensesSource = Join-Path $toolsDir 'licenses.json'
$licensesTarget = Join-Path $appdataPath 'licenses.json'
if (-not (Test-Path $licensesTarget)) {
    Write-Host "Copying licenses.json to configuration directory..."
    Copy-Item $licensesSource $licensesTarget -Force
}

# Create default config.json if it doesn't exist
$configFile = Join-Path $appdataPath 'config.json'
if (-not (Test-Path $configFile)) {
    Write-Host "Creating default configuration file..."
    $defaultConfig = @{
        code = $true
        explorer = $true
    } | ConvertTo-Json
    Set-Content -Path $configFile -Value $defaultConfig -Force
}

# Create empty roots.json if it doesn't exist
$rootsFile = Join-Path $appdataPath 'roots.json'
if (-not (Test-Path $rootsFile)) {
    Write-Host "Creating roots configuration file..."
    Set-Content -Path $rootsFile -Value '{}' -Force
}

# Determine profile paths - cover both Windows PowerShell 5.1 and PowerShell 7+
$profilePaths = @(
    # Windows PowerShell 5.1
    (Join-Path $env:USERPROFILE "Documents\WindowsPowerShell\Microsoft.PowerShell_profile.ps1"),
    # PowerShell 7+
    (Join-Path $env:USERPROFILE "Documents\PowerShell\Microsoft.PowerShell_profile.ps1")
)

$dotSourceLine = ". `"$scriptFile`""
$addition = @"

# Dev PowerShell Utility
$dotSourceLine
"@

Write-Host ""
Write-Host "=== Profile Installation ===" -ForegroundColor Cyan
Write-Host "Script File: $scriptFile" -ForegroundColor Gray

# Check if script file exists
if (-not (Test-Path $scriptFile)) {
    Write-Host "[ERROR] Script file not found: $scriptFile" -ForegroundColor Red
    throw "Installation failed: dev.ps1 not found in tools directory"
}

foreach ($profilePath in $profilePaths) {
    Write-Host "Profile: $profilePath" -ForegroundColor Gray

    # Ensure profile directory exists
    $profileDir = Split-Path -Parent $profilePath
    if (-not (Test-Path $profileDir)) {
        New-Item -ItemType Directory -Path $profileDir -Force | Out-Null
    }

    $profileContent = ''
    if (Test-Path $profilePath) {
        $profileContent = Get-Content $profilePath -Raw -ErrorAction SilentlyContinue
        if ($null -eq $profileContent) { $profileContent = '' }
    }

    if ($profileContent -notmatch [regex]::Escape($scriptFile)) {
        try {
            Add-Content -Path $profilePath -Value $addition -Force -ErrorAction Stop
            Write-Host "[OK] Added to $profilePath" -ForegroundColor Green
        }
        catch {
            Write-Host "[WARNING] Could not update profile $profilePath`: $_" -ForegroundColor Yellow
        }
    } else {
        Write-Host "[SKIP] Already present in $profilePath" -ForegroundColor Gray
    }
}

Write-Host ""
Write-Host "[OK] Dev PowerShell Utility has been installed successfully!" -ForegroundColor Green
Write-Host ""
Write-Host "To start using the 'dev' command, either:" -ForegroundColor Yellow
Write-Host "  1. Restart your PowerShell session, or" -ForegroundColor Yellow
Write-Host "  2. Run: . `$PROFILE" -ForegroundColor Yellow
Write-Host ""
