# AGENTS

This file defines recommended agent roles for this repository.
Use these as working modes when planning or reviewing changes.

## 1) Core Maintainer Agent

Purpose: maintain the PowerShell utility in `src/`.

Primary scope:

- `src/dev.ps1`
- `src/commands/*.ps1`
- `src/core/*.ps1`

Responsibilities:

- Keep command behavior consistent with `dev help` output.
- Prefer small, modular command changes over monolithic edits.
- Preserve backward compatibility for existing CLI actions.
- Follow PowerShell approved verbs and PascalCase naming.

Done criteria:

- Commands load with `. .\src\dev.ps1`.
- Updated flows are reflected in help text when needed.
- No broken dot-sourcing or missing module imports.

## 2) Docs and Website Agent

Purpose: maintain docs and release visibility on the Next.js site.

Primary scope:

- `README.md`
- `release-notes/*.md`
- `web/app/**`
- `web/components/**`

Responsibilities:

- Keep command examples aligned with actual behavior.
- Add new release entries to `web/app/releases/releases.json`.
- Preserve existing site style and navigation conventions.
- Validate docs for clear install and usage paths.

Done criteria:

- Documentation matches current command syntax.
- Release pages include latest release details.
- Site files remain build-safe TypeScript/Next.js code.

## 3) Packaging and Distribution Agent

Purpose: prepare and validate installer and package outputs.

Primary scope:

- `chocolatey/dev-ps-utils.nuspec`
- `chocolatey/tools/*.ps1`
- `inno/setup.iss`
- `release-notes/*.md`

Responsibilities:

- Keep versions synchronized across packaging files.
- Ensure install scripts point to `src/dev.ps1`.
- Preserve non-interactive install and uninstall behavior.
- Keep release notes consistent with shipped changes.

Done criteria:

- Version is aligned in all required files.
- Packaging metadata is valid and internally consistent.
- Release notes exist for the shipped version.

## 4) Chrome Integration Agent

Purpose: maintain browser integration and native host bridge.

Primary scope:

- `chrome-extension/*.js`
- `chrome-extension/*.html`
- `chrome-extension/*.css`
- `chrome-extension/native-host/*`
- `chrome-extension/manifest.json`

Responsibilities:

- Keep extension behavior aligned with native host contract.
- Maintain safe message handling between extension and PowerShell.
- Avoid breaking manifest compatibility for supported Chrome versions.

Done criteria:

- Manifest and scripts remain valid.
- Extension can communicate with native host scripts.
- Core popup/background flows remain functional.

## 5) Review Agent

Purpose: perform risk-focused reviews before release.

Review priorities:

- Behavior regressions in command dispatch and git flows.
- Path handling and file deletion safety.
- Config compatibility and migration concerns.
- Missing docs/tests for user-visible behavior changes.

Review output format:

- List findings first, ordered by severity.
- Include precise file references.
- State assumptions and testing gaps.
