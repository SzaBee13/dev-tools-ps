# Dev Tool Chrome Extension

A Chrome extension that integrates with the [Dev PowerShell Utility](https://github.com/SzaBee13/dev-tools-ps) to manage Git repositories seamlessly from your browser.

## Features

- **One-click Repository Opening**: Click the extension icon while viewing a GitHub, GitLab, or Bitbucket repository to open it with the dev tool
- **Automatic Repository Caching**: Repositories are pulled into your configured pull directory and tracked locally
- **Smart Repository Tracking**: The extension maintains a `repos.json` file in your AppData to track all cloned repositories, preventing redundant pulls
- **Repository Status**: Quickly see if a repository is already cached locally
- **Platform Support**: Works with GitHub, GitLab, and Bitbucket

## Installation

### Prerequisites

- Chrome/Chromium browser
- Dev PowerShell Utility installed and configured
- Git installed and available in PATH
- **Native Messaging Host** (required for full functionality)

### Setup Steps

1. **Enable Developer Mode** in Chrome:
   - Go to `chrome://extensions/`
   - Enable "Developer mode" (toggle in top right)

2. **Load the Extension**:
   - Click "Load unpacked"
   - Navigate to and select the `chrome-extension` folder
   - The extension will appear in your extensions list

3. **Configure AppData Location**:
   - Create the directory: `%APPDATA%\SzaBee13\dev\` (if it doesn't exist)
   - Place `config.json` in this directory (see Configuration section)

4. **Set Up Native Messaging Host** (Required):
   - See [Native Messaging Setup](#native-messaging-setup) section below

### Native Messaging Setup

The extension requires a native messaging host to communicate with PowerShell and execute dev commands. Follow these steps:

#### Option A: Using the Provided Native Host (Recommended)

1. Create a new directory for the native host:
   ```
   %APPDATA%\SzaBee13\dev\native-host\
   ```

2. Create the host executable (`dev-host.ps1`):
   ```powershell
   # %APPDATA%\SzaBee13\dev\native-host\dev-host.ps1
   # Reads from stdin and executes dev commands
   
   Add-Type -AssemblyName System.Web
   
   function Send-NativeMessage($message) {
       $json = ConvertTo-Json -Compress $message
       $bytes = [System.Text.Encoding]::UTF8.GetBytes($json)
       [System.IO.BinaryWriter]$writer = [System.Console]::OpenStandardOutput()
       $writer.Write([System.Convert]::ToUInt32($bytes.Length))
       $writer.Write($bytes)
       $writer.Flush()
   }
   
   function Read-NativeMessage() {
       $lengthBytes = New-Object System.Byte[] 4
       $stdin = [System.Console]::OpenStandardInput()
       if ($stdin.Read($lengthBytes, 0, 4) -eq 4) {
           $length = [System.BitConverter]::ToUInt32($lengthBytes, 0)
           $messageBytes = New-Object System.Byte[] $length
           $stdin.Read($messageBytes, 0, $length) | Out-Null
           return [System.Text.Encoding]::UTF8.GetString($messageBytes)
       }
       return $null
   }
   
   # Load dev utility
   $devScript = "$env:APPDATA\SzaBee13\dev\src\dev.ps1"
   if (Test-Path $devScript) {
       . $devScript
   } else {
       Send-NativeMessage @{success = $false; error = "Dev utility not found at $devScript"}
       exit 1
   }
   
   # Main message loop
   while ($true) {
       $message = Read-NativeMessage
       if ($null -eq $message) { break }
       
       try {
           $request = ConvertFrom-Json $message
           $args = $request.args
           
           # Execute dev command
           & dev @args
           
           Send-NativeMessage @{success = $true; message = "Command executed"}
       } catch {
           Send-NativeMessage @{success = $false; error = $_.Exception.Message}
       }
   }
   ```

3. Register the native host with Chrome in the Windows Registry:
   ```reg
   Windows Registry Editor Version 5.00
   
   [HKEY_CURRENT_USER\Software\Google\Chrome\NativeMessagingHosts\com.dev_tool.host]
   @="C:\\ProgramData\\SzaBee13\\dev\\native-host\\manifest.json"
   ```

4. Create the manifest for the native host:
   ```json
   {
     "name": "com.dev_tool.host",
     "description": "Native host for Dev Tool Chrome Extension",
     "path": "powershell.exe",
     "type": "stdio",
     "allowed_origins": [
       "chrome-extension://YOUR_EXTENSION_ID/popup.html"
     ]
   }
   ```
   
   **Find your extension ID:**
   - Go to `chrome://extensions/`
   - Look for "Dev Tool Repo Opener" and note the ID (long alphanumeric string)

#### Option B: Manual Setup via Command Line

If you want to set up the native host manually via PowerShell:

```powershell
# Run as Administrator
$hostPath = "$env:APPDATA\SzaBee13\dev\native-host"
New-Item -ItemType Directory -Path $hostPath -Force

# Create registry entry
$regPath = "HKCU:\Software\Google\Chrome\NativeMessagingHosts\com.dev_tool.host"
New-Item -Path $regPath -Force
Set-ItemProperty -Path $regPath -Name "(Default)" -Value "$hostPath\manifest.json"
```

## Configuration

### config.json Structure

Located at: `%APPDATA%\SzaBee13\dev\config.json`

```json
{
  "pullPath": "D:\\pull",
  "code": true,
  "explorer": true,
  "defaultRoot": "web"
}
```

**Properties:**
- `pullPath` (string): Directory where repositories will be pulled. Default: `D:\pull`
- `code` (boolean): Whether to open repositories in VSCode. Default: `true`
- `explorer` (boolean): Whether to open repositories in Windows Explorer. Default: `true`
- `defaultRoot` (string): Default root category (optional)

### repos.json Structure

Located at: `%APPDATA%\SzaBee13\dev\repos.json`

The extension automatically maintains this file to track cached repositories:

```json
{
  "owner/repo-name": {
    "url": "https://github.com/owner/repo-name.git",
    "path": "D:\\pull\\repo-name",
    "localName": "repo-name",
    "platform": "github",
    "owner": "owner",
    "lastPulled": "2024-03-01T10:30:00.000Z"
  }
}
```

## Usage

### Opening a Repository

1. Navigate to a repository on GitHub, GitLab, or Bitbucket
2. Click the "Dev Tool" extension icon in your Chrome toolbar
3. A popup will appear showing:
   - Repository name and URL
   - Status (cached or not cached)
   - Available actions

### First Time Opening a Repository

If the repository isn't cached yet:
1. Click "Pull Repository" button
2. The extension will clone the repo into your configured pull directory
3. Once complete, the repository will be tracked and you can click "Open with Dev Tool"

### Opening a Cached Repository

If the repository is already cached:
1. Click "Open with Dev Tool" button
2. The repository will open in VSCode and/or Windows Explorer (based on your config)

## Architecture

### Files

- **manifest.json** - Extension configuration and permissions
- **popup.html/js** - User interface for the extension
- **popup.css** - Styling for the popup
- **background.js** - Service worker handling repository operations
- **content.js** - Content script for extracting repository information from pages
- **example-config.json** - Template for configuration file
- **repos.json** - Repository cache tracking file

### How It Works

1. **Repository Detection**: When you visit a supported git hosting site, the content script extracts repository information
2. **Status Check**: The popup queries the background service worker to check if the repository is cached
3. **Pull/Open**: Based on the status, the user can either pull the repository or open it with the dev tool
4. **Tracking**: All pulled repositories are tracked in `repos.json` to prevent redundant operations

## Supported Platforms

- **GitHub** (`github.com`)
- **GitLab** (`gitlab.com`)
- **Bitbucket** (`bitbucket.org`)

## Troubleshooting

### Extension shows "Processing" for a long time

**Cause**: Native messaging host is not installed or not responding.

**Solution**:
1. Verify native messaging setup is complete (see [Native Messaging Setup](#native-messaging-setup))
2. Check that PowerShell can execute the dev utility:
   ```powershell
   dev status
   ```
3. Verify registry entry exists:
   ```powershell
   Get-ItemProperty -Path "HKCU:\Software\Google\Chrome\NativeMessagingHosts\com.dev_tool.host"
   ```
4. Check Chrome's extension error logs:
   - Go to `chrome://extensions/`
   - Click "Details" on Dev Tool extension
   - Check "Errors" section
5. If using Edge/Chromium, ensure native host path points to correct manifest

### Extension doesn't show popup

- Ensure you're on a supported git hosting platform (GitHub, GitLab, Bitbucket)
- Check that you're viewing a repository page, not a user profile or organization page

### Pull fails or times out (60+ seconds)

**Cause**: Native messaging not configured or repository is very large

**Solution**:
1. Verify native messaging is installed (see above)
2. Ensure git can access the repository without prompting for credentials
3. Try manually cloning the repository to test:
   ```powershell
   git clone [repo-url]
   ```
4. Check `pullPath` is writable:
   ```powershell
   Test-Path D:\pull -PathType Container
   ```

### Repositories not tracked

- Verify `repos.json` exists in `%APPDATA%\SzaBee13\dev\`
- Check that the configuration is properly loaded
- Try refreshing the extension in `chrome://extensions/`

### Opening doesn't work

- Ensure the Dev PowerShell Utility is installed and the `dev` command is available
- Verify the repository path in `repos.json` is correct
- Check that VSCode and/or Windows Explorer are installed (based on your config)
- Test the dev command manually:
   ```powershell
   dev open [folder-name]
   ```

## Native Messaging (Future Enhancement)

For full integration with the PowerShell dev tool, a native messaging host is recommended. This would:

- Directly execute `dev` PowerShell commands from the extension
- Provide real-time feedback on command execution
- Handle Windows-specific operations more reliably

See the [Chrome Native Messaging documentation](https://developer.chrome.com/docs/extensions/mv3/nativeMessaging/) for implementation details.

## License

This extension is part of the Dev PowerShell Utility project and follows the same license.

## Contributing

Issues and pull requests are welcome. Please ensure:
- Code follows the existing style
- Features are tested in the extension environment
- Documentation is updated accordingly
