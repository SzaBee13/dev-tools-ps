# Native Messaging Host for Dev Tool Chrome Extension
# Communicates with Chrome via stdin/stdout using the native messaging protocol

function Send-NativeMessage {
    param([object]$message)
    $json = $message | ConvertTo-Json -Compress -Depth 10
    $bytes = [System.Text.Encoding]::UTF8.GetBytes($json)
    $writer = New-Object System.IO.BinaryWriter([System.Console]::OpenStandardOutput())
    $writer.Write([System.BitConverter]::GetBytes([uint32]$bytes.Length))
    $writer.Write($bytes)
    $writer.Flush()
}

function Read-NativeMessage {
    $stdin = [System.Console]::OpenStandardInput()
    $lengthBytes = New-Object byte[] 4
    $read = $stdin.Read($lengthBytes, 0, 4)
    if ($read -lt 4) { return $null }
    $length = [System.BitConverter]::ToUInt32($lengthBytes, 0)
    if ($length -eq 0 -or $length -gt 1MB) { return $null }
    $msgBytes = New-Object byte[] $length
    $stdin.Read($msgBytes, 0, $length) | Out-Null
    return [System.Text.Encoding]::UTF8.GetString($msgBytes)
}

# Load dev utility - use the same path the profile uses
$devScript = "C:\ProgramData\chocolatey\lib\dev-ps-utils\tools\src\dev.ps1"
if (-not (Test-Path $devScript)) {
    # Fallback: check AppData
    $devScript = "$env:APPDATA\SzaBee13\dev\src\dev.ps1"
}

if (-not (Test-Path $devScript)) {
    Send-NativeMessage @{ success = $false; error = "Dev utility not found. Is dev-ps-utils installed?" }
    exit 1
}

try {
    . $devScript
} catch {
    Send-NativeMessage @{ success = $false; error = "Failed to load dev utility: $_" }
    exit 1
}

# Main message loop
while ($true) {
    $raw = Read-NativeMessage
    if ($null -eq $raw) { break }

    try {
        $request = $raw | ConvertFrom-Json
        $args = @($request.args)
        $command = if ($args.Count -gt 0) { $args[0] } else { "" }

        switch ($command) {
            "list" {
                # Return repos as JSON for the extension
                $output = dev list --json
                $parsed = $output | ConvertFrom-Json
                Send-NativeMessage $parsed
            }
            "repos:scan" {
                $result = dev repos:scan
                try {
                    $parsed = $result | ConvertFrom-Json
                    Send-NativeMessage $parsed
                } catch {
                    Send-NativeMessage @{ success = $true; synced = 0 }
                }
            }
            "config:read" {
                $configFile = "$env:APPDATA\SzaBee13\dev\config.json"
                if (Test-Path $configFile) {
                    $cfg = Get-Content $configFile -Raw | ConvertFrom-Json
                    Send-NativeMessage @{ config = $cfg }
                } else {
                    Send-NativeMessage @{ config = @{ pullPath = "D:\pull"; code = $true; explorer = $true } }
                }
            }
            "open" {
                $folderName = $args[1]
                dev open $folderName 2>&1 | Out-Null
                Send-NativeMessage @{ success = $true }
            }
            "pull" {
                $url = $args[1]
                $name = $args[2]
                $result = dev pull $url $name 2>&1
                Send-NativeMessage @{ success = $true; output = ($result -join "`n") }
            }
            default {
                Send-NativeMessage @{ success = $false; error = "Unknown command: $command" }
            }
        }
    } catch {
        Send-NativeMessage @{ success = $false; error = $_.Exception.Message }
    }
}
