# Native Messaging Host Installer for Dev Tool Chrome Extension
# Run this script to set up the native messaging host
# Usage: .\install.ps1 -ExtensionId "YOUR_EXTENSION_ID"
#
# To find your Extension ID:
#   1. Go to chrome://extensions/
#   2. Enable Developer Mode (top right toggle)
#   3. Find "Dev Tool Repo Opener" and copy the ID shown below its name

param(
    [Parameter(Mandatory = $true)]
    [string]$ExtensionId
)

$hostDir = "$env:APPDATA\SzaBee13\dev\native-host"
$scriptDir = Split-Path -Parent $MyInvocation.MyCommand.Definition
$batPath = Join-Path $hostDir "dev-host.bat"
$manifestPath = Join-Path $hostDir "manifest.json"
$regPath = "HKCU:\Software\Google\Chrome\NativeMessagingHosts\com.dev_tool.host"

Write-Host "Installing native messaging host..." -ForegroundColor Cyan

# Create host directory
New-Item -ItemType Directory -Path $hostDir -Force | Out-Null

# Copy host files
Copy-Item "$scriptDir\dev-host.ps1" $hostDir -Force
Copy-Item "$scriptDir\dev-host.bat" $hostDir -Force

# Write manifest.json
$manifest = @{
    name        = "com.dev_tool.host"
    description = "Native host for Dev Tool Chrome Extension"
    path        = $batPath
    type        = "stdio"
    allowed_origins = @("chrome-extension://$ExtensionId/")
} | ConvertTo-Json -Depth 3

Set-Content -Path $manifestPath -Value $manifest -Encoding UTF8 -Force

# Register in Windows Registry
New-Item -Path $regPath -Force | Out-Null
Set-ItemProperty -Path $regPath -Name "(Default)" -Value $manifestPath -Force

Write-Host "[OK] Native host files copied to: $hostDir" -ForegroundColor Green
Write-Host "[OK] Manifest created at: $manifestPath" -ForegroundColor Green
Write-Host "[OK] Registry key registered: $regPath" -ForegroundColor Green
Write-Host ""
Write-Host "Setup complete! Reload the Chrome extension for changes to take effect." -ForegroundColor Yellow
Write-Host "  1. Go to chrome://extensions/" -ForegroundColor Yellow
Write-Host "  2. Click the reload button on 'Dev Tool Repo Opener'" -ForegroundColor Yellow
