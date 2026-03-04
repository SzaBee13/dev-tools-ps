# v1.2.1

## Release Notes

### Fixed

- Fixed an issue where the `dev open` command would not pull the latest changes from a git repository before opening it.
- Fixed an issue where the `dev open` command didn't open the folder in VSCode and Explorer based on the configuration settings.

### Added

- Added a check in the `dev open` command to see if the folder is a git repository with a remote URL, and if so, it will pull the latest changes before opening the folder.

## Download and Install

### Chocolatey

NOTE: The Chocolatey package may not be updated immediately with the latest release. Please check the [Chocolatey page](https://community.chocolatey.org/packages/dev-ps-utils) for the most recent version.

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

### Inno Setup (RECOMMENDED)

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
