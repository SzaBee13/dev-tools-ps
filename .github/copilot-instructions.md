# Dev PowerShell Utils - Workspace Guidelines

## Project Overview

This is a PowerShell-based development utility that manages project folders and Git operations. The project includes:
- Core PowerShell module (`src/`)
- Next.js documentation website (`web/`)
- Chrome extension with native messaging (`chrome-extension/`)
- Chocolatey package (`chocolatey/`)
- Inno Setup installer (`inno/`)

## Code Style

### PowerShell Conventions
- Use approved verbs (Get, Set, Remove, etc.) for function names
- Follow PascalCase for functions and parameters
- Use explicit parameter types
- Include comment-based help for exported functions
- Modular structure: separate commands in `src/commands/`
- Core utilities in `src/core/`

### File Organization
- Command modules: `src/commands/*.ps1` (Create, Git, List, Open, Remove, Set)
- Core functions: `src/core/*.ps1` (Config, Helpers)
- Entry point: `src/dev.ps1`

## Configuration

Config stored at `~\.dev\config.json` with structure:
```json
{
  "projectsRoot": "path",
  "openInVSCode": true/false,
  "openInExplorer": true/false
}
```

## Build and Release

### Version Updates
Update version numbers in:
- `inno/setup.iss` - AppVersion field
- `chocolatey/dev-ps-utils.nuspec` - version field
- `web/app/releases/releases.json` - add new release entry

### Building
- Inno Setup: Compile `inno/setup.iss` for Windows installer
- Chocolatey: Package from `chocolatey/` directory
- Chrome Extension: Build in `chrome-extension/builds/`

### Release Notes
- Create new file: `release-notes/RELEASE-NOTE-v{version}.md`
- Follow existing template structure (Fixed, Added sections)
- Use git log to identify changes since last tag

## Testing

Manual testing workflow:
1. Import module: `. .\src\dev.ps1`
2. Test commands: `dev create`, `dev list`, `dev open`, etc.
3. Verify config operations
4. Test git operations with actual repos

## Conventions

- Keep PowerShell commands in separate modular files
- Use dot-sourcing to load modules in main script
- Chrome extension uses native messaging for PowerShell integration
- Website deployment via Vercel
- Documentation includes installation methods (Chocolatey, Inno, source)
