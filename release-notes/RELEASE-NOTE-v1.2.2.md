# v1.2.2

## Release Notes

### Fixed

- Fixed license badge link in README.md
- Fixed Next.js rendering errors in documentation and installation pages

### Added

- Added GitHub issue templates (bug report and feature request) with structured forms
- Added pull request template for better contribution workflow
- Added comprehensive documentation website built with Next.js
- Added releases page on website with version history
- Added Vercel Analytics integration for usage tracking
- Improved `dev list` command functionality
- Updated SECURITY.md with enhanced vulnerability reporting process
- Added CODE_OF_CONDUCT.md and CONTRIBUTING.md for community guidelines

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
