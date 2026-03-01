# Inno Setup Package for Dev PowerShell Utility

This directory contains the Inno Setup installer script for Dev PowerShell Utility.

## Prerequisites

1. Download and install Inno Setup Compiler from: https://jrsoftware.org/isdl.php

## Building the Installer

1. Open `setup.iss` in Inno Setup Compiler

2. Click **Build** > **Compile** (or press Ctrl+F9)

3. The installer will be created in the `Output` directory as `dev-tools-1.1.0.exe`

## Testing the Installer

1. Run the generated installer:
   ```
   .\Output\dev-tools-1.1.0.exe
   ```

2. Follow the installation wizard to install the Dev PowerShell Utility

3. Test the `dev` command in a new PowerShell window:
   ```powershell
   # Reload your profile first
   . $PROFILE
   
   # Test the command
   dev
   ```

4. To uninstall, use Windows "Add or Remove Programs"

## Installer Behavior

### Installation:
- Installs the entire `src` directory with all modules to Program Files
- Creates configuration directory at `%APPDATA%\SzaBee13\dev\`
- Copies `licenses.json` to the configuration directory
- Creates default `config.json` and `roots.json` files
- Prompts user to add the dev function to their PowerShell profile
- Supports both PowerShell Core and Windows PowerShell

### Uninstallation:
- Prompts to remove the dev function from PowerShell profile
- Prompts whether to remove configuration files (preserves user data by default)
- Removes installed files from Program Files

## File Structure

The installer includes:
```
{app}/
├── src/
│   ├── dev.ps1              # Main entry point
│   ├── core/
│   │   ├── Helpers.ps1      # Helper functions
│   │   └── Config.ps1       # Configuration management
│   └── commands/
│       ├── Open.ps1         # Open command
│       ├── Create.ps1       # Create command
│       ├── Remove.ps1       # Remove command
│       ├── List.ps1         # List command
│       ├── Git.ps1          # Git commands
│       └── Set.ps1          # Set command
├── README.md
├── LICENSE.md
└── licenses.json
```

## Updating the Version

When releasing a new version:

1. Update the version in `setup.iss`:
   ```
   #define MyAppVersion "X.X.X"
   ```

2. Update the version in:
   - `chocolatey/dev-powershell-utility.nuspec`
   - Any relevant documentation

3. Rebuild the installer

## Customization

Key sections in `setup.iss`:

- **[Setup]**: Application metadata and installer behavior
- **[Files]**: Files to include in the installation
- **[Dirs]**: Directories to create during installation
- **[Code]**: Pascal script for custom installation logic
