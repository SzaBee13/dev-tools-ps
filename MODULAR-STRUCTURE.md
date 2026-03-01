# Dev PowerShell Utility - Modular Structure

The Dev PowerShell Utility has been refactored into a modular structure for better maintainability and organization.

## Directory Structure

```bash
src/
├── dev.ps1                  # Main entry point - loads all modules and dispatches commands
├── core/                    # Core functionality
│   ├── Helpers.ps1         # Helper functions (Search-Folder, ConvertTo-Hashtable)
│   └── Config.ps1          # Configuration management (Get-DevConfig, Get-DevRoots, etc.)
└── commands/               # Command implementations
    ├── Open.ps1           # Invoke-DevOpen - Opens folders in VSCode/Explorer
    ├── Create.ps1         # Invoke-DevCreate - Creates new projects
    ├── Remove.ps1         # Invoke-DevRemove - Removes folders
    ├── List.ps1           # Invoke-DevList - Lists folders by category
    ├── Git.ps1            # Git commands (pull, release, local-release, status, init)
    └── Set.ps1            # Invoke-DevSet - Configuration settings
```

## Module Organization

### Main Entry Point (`dev.ps1`)

- Imports all core and command modules
- Defines the main `dev` function
- Dispatches commands to appropriate handlers
- Maintains the help text and command-line interface

### Core Modules

#### `core/Helpers.ps1`

- `Search-Folder`: Searches for folders recursively
- `ConvertTo-Hashtable`: Converts PSObjects to hashtables

#### `core/Config.ps1`

- `Get-DevConfig`: Loads user configuration (code/explorer preferences)
- `Get-DevRoots`: Loads root paths from roots.json
- `Save-DevRoots`: Saves root paths to roots.json
- `Get-DevLicenses`: Loads or downloads license templates

### Command Modules

Each command is implemented as a separate function in its own file:

- **Open.ps1**: `Invoke-DevOpen` - Opens project folders
- **Create.ps1**: `Invoke-DevCreate` - Creates new projects
- **Remove.ps1**: `Invoke-DevRemove` - Removes folders
- **List.ps1**: `Invoke-DevList` - Lists folders by category
- **Git.ps1**: Git-related commands
  - `Invoke-DevPull` - Clone or pull repositories
  - `Invoke-DevRelease` - Commit and push changes
  - `Invoke-DevLocalRelease` - Commit without pushing
  - `Invoke-DevStatus` - Show git status
  - `Invoke-DevInit` - Initialize new repository
- **Set.ps1**: `Invoke-DevSet` - Manage configuration settings

## Benefits of Modular Structure

1. **Maintainability**: Each command is isolated in its own file
2. **Readability**: Easier to find and understand specific functionality
3. **Extensibility**: Simple to add new commands or modify existing ones
4. **Testing**: Individual modules can be tested independently
5. **Debugging**: Issues can be isolated to specific modules

## Adding New Commands

To add a new command:

1. Create a new file in `src/commands/` (e.g., `MyCommand.ps1`)
2. Implement your command function (e.g., `Invoke-DevMyCommand`)
3. Export the function: `Export-ModuleMember -Function Invoke-DevMyCommand`
4. Import the module in `src/dev.ps1`: `. "$ScriptDir\commands\MyCommand.ps1"`
5. Add a switch case in the `dev` function to dispatch to your command
6. Update the help text with usage information

## Modifying Existing Commands

1. Navigate to the appropriate file in `src/commands/`
2. Make your changes to the function
3. Test the command: `. .\src\dev.ps1` then use `dev <command>`
4. No changes to other files needed unless you're changing the interface

## Package Distribution

Both Chocolatey and Inno Setup installers have been updated to:

- Include the entire `src` directory structure
- Reference `src\dev.ps1` as the main entry point
- Preserve the modular structure in the installation directory

### Chocolatey Package

- Files are installed to Chocolatey's tools directory
- Profile is updated to source `src\dev.ps1`

### Inno Setup Installer

- Files are installed to Program Files
- Profile is updated to source `{app}\src\dev.ps1`

## Backward Compatibility

The modular structure maintains full backward compatibility:

- Same command-line interface
- Same configuration file locations
- Same behavior for all commands
- Only the internal organization has changed
