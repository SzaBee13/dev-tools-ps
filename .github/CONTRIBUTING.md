# Contributing to Dev PowerShell Utility

Thank you for considering contributing! Here are a few guidelines to help you get started.

## How to Contribute

### Reporting Bugs

If you find a bug, please [open an issue](https://github.com/SzaBee13/dev-tools-ps/issues/new) and include:

- A clear and descriptive title
- Steps to reproduce the problem
- Expected vs. actual behavior
- Your OS and PowerShell version (`$PSVersionTable`)
- Any relevant error output

### Suggesting Features

Feature requests are welcome. [Open an issue](https://github.com/SzaBee13/dev-tools-ps/issues/new) and describe:

- The use case and motivation
- What the feature should do
- Any alternatives you considered

### Submitting Pull Requests

1. Fork the repository and create a branch from `main`:

   ```bash
   git checkout -b feature/your-feature-name
   ```

2. Make your changes in the appropriate files under `src/`.
3. Test your changes manually by sourcing the script:

   ```bash
   . ./src/dev.ps1
   ```

4. Keep commits focused and write clear commit messages.
5. Open a pull request against `main` and describe what your change does and why.

## Code Style

- Follow existing PowerShell conventions in the codebase (verb-noun naming, consistent indentation).
- Commands should be added as separate files under `src/commands/`.
- Core utilities belong in `src/core/`.
- Keep functions focused and documented with inline comments where the logic is non-obvious.

## Project Structure

| Path | Purpose |
| ------ | --------- |
| `src/dev.ps1` | Entry point — argument parsing and command dispatch |
| `src/commands/` | Individual command implementations |
| `src/core/` | Config and shared helper utilities |
| `chrome-extension/` | Browser extension for quick project access |
| `web/` | Documentation website (Next.js) |

## License

By contributing, you agree that your contributions will be licensed under the project's [MIT License](../LICENSE.md).
