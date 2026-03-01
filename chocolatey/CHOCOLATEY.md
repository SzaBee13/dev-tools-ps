# Chocolatey Package for Dev PowerShell Utility

This directory contains the Chocolatey package files for Dev PowerShell Utility.

## Prerequisites

1. Install Chocolatey (if not already installed):
   ```powershell
   Set-ExecutionPolicy Bypass -Scope Process -Force
   [System.Net.ServicePointManager]::SecurityProtocol = [System.Net.ServicePointManager]::SecurityProtocol -bor 3072
   iex ((New-Object System.Net.WebClient).DownloadString('https://community.chocolatey.org/install.ps1'))
   ```

2. Install Chocolatey package builder:
   ```powershell
   choco install checksum -y
   ```

## Building the Package

1. Navigate to the chocolatey directory:
   ```powershell
   cd chocolatey
   ```

2. Pack the Chocolatey package:
   ```powershell
   choco pack dev-powershell-utility.nuspec
   ```

   This will create a file named `dev-powershell-utility.1.1.0.nupkg`.

## Testing the Package Locally

1. Install the package locally for testing (from the chocolatey directory):
   ```powershell
   choco install dev-powershell-utility -s . -y
   ```

2. Test the `dev` command:
   ```powershell
   # Reload your profile first
   . $PROFILE
   
   # Test the command
   dev
   ```

3. Uninstall to test the uninstallation process:
   ```powershell
   choco uninstall dev-powershell-utility -y
   ```

## Publishing to Chocolatey Community Repository

1. Create an account at https://community.chocolatey.org/

2. Get your API key from https://community.chocolatey.org/account

3. Set your API key (only need to do this once):
   ```powershell
   choco apikey --key YOUR_API_KEY --source https://push.chocolatey.org/
   ```

4. Push your package:
   ```powershell
   choco push dev-powershell-utility.1.1.0.nupkg --source https://push.chocolatey.org/
   ```

5. Wait for moderation approval (first-time packages require manual approval).

## Package Structure

```
dev-powershell-utility/
├── dev-powershell-utility.nuspec    # Package specification
├── tools/
│   ├── chocolateyInstall.ps1        # Installation script
│   ├── chocolateyUninstall.ps1      # Uninstallation script
│   └── VERIFICATION.txt             # Verification documentation
├── dev.ps1                          # Main script (copied to tools/)
├── licenses.json                    # License templates (copied to tools/)
├── LICENSE.md                       # License file (copied to tools/)
└── README.md                        # Documentation (copied to tools/)
```

## Installation Behavior

When users install the package with `choco install dev-powershell-utility`, it will:

1. Copy `dev.ps1` to the Chocolatey tools directory
2. Create configuration directory at `%APPDATA%\SzaBee13\dev\`
3. Copy `licenses.json` to the configuration directory
4. Create default `config.json` and `roots.json` files
5. Add the dev function to the user's PowerShell profile
6. Display instructions for activating the command

## Uninstallation Behavior

When users uninstall with `choco uninstall dev-powershell-utility`, it will:

1. Remove the dev function from the PowerShell profile
2. Inform the user about configuration files (doesn't auto-delete to preserve user data)
3. Provide instructions for manual cleanup if desired

## Updating the Package

When releasing a new version:

1. Update the version number in:
   - `dev-powershell-utility.nuspec` (in the `<version>` tag)
   - `setup.iss` (in the `#define MyAppVersion` line)

2. Update the release notes in the nuspec file or link to GitHub releases

3. Rebuild and test the package before publishing
