# v1.2.0

## Release Notes

### Added

- Auto git pull when opening a folder with `dev open` command
- Automatic repository validation and status checking when opening projects
- Enhanced root handling with improved default configuration system
- Chocolatey package improvements and updates
- Comprehensive markdown documentation

### Improved

- Root path configuration and defaults handling
- Repository opening workflow with automatic git integration
- Application performance and usability across all commands
- Modular structure for better code organization

### Fixed

- Merge conflict resolution in dev.ps1
- Repository check validation logic

## Download and Install

### Chocolatey

1. Install Chocolatey (if you haven't already):
Read the tutorial at [Chocolatey's official website](https://chocolatey.org/install) for detailed instructions.

2. Install the package:

   ```powershell
    choco install dev-ps-utils -y
    ```

3. To uninstall:

   ```powershell
    choco uninstall dev-ps-utils -y
    ```

### Inno Setup

1. Download the installer from the releases page.
2. Run the installer and follow the prompts to complete the installation.
3. To uninstall, go to "Add or Remove Programs" in Windows, find "Dev PowerShell Utility", and click "Uninstall".

### Build from Source

1. Clone the repository:

   ```bash
   git clone https://github.com/SzaBee13/dev-tools-ps.git
   ```
  
2. Navigate to the project directory:

   ```bash
    cd dev-tools-ps
    ```

3. Run the main script:

  ```powershell
    . .\src\dev.ps1
    ```

4. Test the `dev` command:

   ```powershell
    dev
    ```
