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

# Determine PowerShell profile path
$profilePath = $PROFILE.CurrentUserAllHosts
if ([string]::IsNullOrEmpty($profilePath)) {
    $profilePath = $PROFILE
}

# Ensure profile directory exists
$profileDir = Split-Path -Parent $profilePath
if (-not (Test-Path $profileDir)) {
    Write-Host "Creating PowerShell profile directory: $profileDir"
    New-Item -ItemType Directory -Path $profileDir -Force | Out-Null
}

# Add dev function to PowerShell profile
$dotSourceLine = ". `"$scriptFile`""
$profileContent = ''

if (Test-Path $profilePath) {
    $profileContent = Get-Content $profilePath -Raw -ErrorAction SilentlyContinue
    if ($null -eq $profileContent) {
        $profileContent = ''
    }
}

if ($profileContent -notmatch [regex]::Escape($scriptFile)) {
    Write-Host "Adding dev function to PowerShell profile: $profilePath" -ForegroundColor Green
    $addition = @"

# Dev PowerShell Utility
$dotSourceLine
"@
    Add-Content -Path $profilePath -Value $addition -Force
    Write-Host ""
    Write-Host "✓ Dev PowerShell Utility has been installed successfully!" -ForegroundColor Green
    Write-Host ""
    Write-Host "To start using the 'dev' command, either:" -ForegroundColor Yellow
    Write-Host "  1. Restart your PowerShell session, or" -ForegroundColor Yellow
    Write-Host "  2. Run: . `$PROFILE" -ForegroundColor Yellow
    Write-Host ""
} else {
    Write-Host "Dev function is already present in PowerShell profile." -ForegroundColor Yellow
    Write-Host "✓ Installation complete!" -ForegroundColor Green
}
