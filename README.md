# Dev PowerShell Utility

`dev` is a PowerShell function designed to simplify and streamline development workflows on Windows. It allows you to quickly open, create, manage, and version-control projects across multiple development types including web, Python, Discord bots, and more.

---

## Table of Contents

* [Features](#features)
* [Installation](#installation)
* [Usage](#usage)
* [Commands](#commands)
* [Configuration](#configuration)

---

## Features

* Open project folders in VSCode and/or Windows Explorer
* Create new projects for various frameworks and languages (Vite, Python, Discord bots, C++, etc.)
* Remove folders easily
* Clone or pull Git repositories
* Commit and push changes to Git
* Initialize Git repositories with optional license
* List existing project folders by category
* Save default preferences for opening VSCode and Explorer

---

## Installation

1. Copy the `dev` function into your PowerShell profile (usually located at `~\Documents\PowerShell\Microsoft.PowerShell_profile.ps1`).
2. Restart your PowerShell session or run the profile script:

   ```powershell
   . $PROFILE
   ```
3. Ensure VSCode (`code`) and Git are installed and added to your PATH.

---

## Usage

```powershell
dev <action> [typeOrName] [name] [--code] [--explorer]
```

* `<action>`: The operation you want to perform.
* `[typeOrName]`: Depends on action (folder name, project type, or Git URL).
* `[name]`: Optional name for new project, commit message, or folder.
* `[--code]`, `[--explorer]`: Override default behavior to open VSCode or Explorer.

---

## Commands

### Open a folder

```powershell
dev open <folder-name>
```

Opens a folder in VSCode and Explorer. Supports subpaths using `/`.

### Create a new project

```powershell
dev create <type> <project-name>
```

Supported types:

* `vite`, `web`, `python`, `home`, `discord`, `alpha-cpp`, `alpha-web`, `alpha-vite`

Creates the project in the appropriate root folder and opens it in VSCode and Explorer.

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

### Set default behavior

```powershell
dev set --code=true/false
```

```powershell
dev set --explorer=true/false
```

Saves default preferences in `%appdata%\SzaBee13\dev\config.json`.

### Help

```powershell
dev help
```

Displays usage information.

---

## Configuration

The tool stores default preferences in:

```
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

---

Developed for Windows environments, `dev` centralizes development tasks to save time and reduce repetitive operations.
