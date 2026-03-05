# Dev PowerShell Utility

[![GitHub contributors](https://img.shields.io/github/contributors/SzaBee13/dev-tools-ps)](https://github.com/SzaBee13/dev-tools-ps/graphs/contributors)
[![GitHub release](https://img.shields.io/github/v/release/SzaBee13/dev-tools-ps?include_prereleases)](https://github.com/SzaBee13/dev-tools-ps/releases)
[![License](https://img.shields.io/github/license/SzaBee13/dev-tools-ps.md)](https://github.com/SzaBee13/dev-tools-ps/blob/main/LICENSE)

`dev` is a PowerShell function designed to simplify and streamline development workflows on Windows. It allows you to quickly open, create, manage, and version-control projects across multiple development types including web, Python, Discord bots, and more.

## Table of Contents

* [Features](#features)
* [Installation](#installation)
* [Usage](#usage)
* [Commands](#commands)
* [Configuration](#configuration)

## Features

* Open project folders in VSCode and/or Windows Explorer
* Create new projects for various frameworks and languages (Vite, Python, Discord bots, C++, etc.)
* Remove folders easily
* Clone or pull Git repositories
* Commit and push changes to Git
* Initialize Git repositories with optional license
* List existing project folders by category
* Save default preferences for opening VSCode and Explorer

## Installation

1. Copy the `dev` function into your PowerShell profile (usually located at `~\Documents\PowerShell\Microsoft.PowerShell_profile.ps1`).
2. Restart your PowerShell session or run the profile script:

   ```powershell
   . $PROFILE
   ```
  
3. Ensure VSCode (`code`) and Git are installed and added to your PATH.

## Usage

```powershell
dev <action> [typeOrName] [name] [--code] [--explorer]
```

* `<action>`: The operation you want to perform.
* `[typeOrName]`: Depends on action (folder name, project type, root name, or Git URL).
* `[name]`: Optional name for new project, commit message, folder, or root subfolder.
* `[--code]`, `[--explorer]`: Override default behavior to open VSCode or Explorer.

## Commands

### Define roots

```powershell
dev set root web "path-to-ur-folder like D:/web"
```

### Open a folder

```powershell
dev open <folder-name>
```

Opens a folder in VSCode and Explorer. Supports subpaths using `/`.

```powershell
dev open <root-name> [folder-name]
```

Opens a configured root path directly, or a folder inside that root.

### Create a new project

```powershell
dev create <type> <project-name>
```

### Remove a folder

```powershell
dev rm <folder-name>
```

Removes a folder from the root directories.

### Git operations

```powershell
dev pull [<git-repo-url>] [folder-name]  # Clone or pull a repository
```

```powershell
dev release <commit-message> [detailed-message]  # Commit and push
```

```powershell
dev local-release <commit-message> [detailed-message]  # Commit locally without pushing
```

```powershell
dev init [<git-repo-url>]  # Initialize Git repo with optional remote
```

```powershell
dev status  # Show git status
```

### List project folders

```powershell
dev ls <type>
```

Valid types: `web`, `python`, `home`, `discord`, `alpha-cpp`, `alpha-web`

### List configured roots

```powershell
dev roots
```

### Set default behavior

```powershell
dev set --code=true/false
```

```powershell
dev set --explorer=true/false
```

Saves default preferences in `%appdata%\SzaBee13\dev\config.json`.

You can also override these defaults per command:

```powershell
dev open <folder-name> --code=false
dev create <type> <project-name> --explorer=false
```

### Help

```powershell
dev help
```

Displays usage information.

## Configuration

The tool stores default preferences in:

```bash
%APPDATA%\SzaBee13\dev\config.json
```

Example:

```json
{
  "code": true,
  "explorer": true
}
```

You can toggle these defaults using the `dev set` command.

Developed for Windows environments, `dev` centralizes development tasks to save time and reduce repetitive operations.
