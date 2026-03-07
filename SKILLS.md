# SKILLS

This file documents reusable implementation skills for this repository.
Each skill includes trigger conditions, key files, and completion checks.

## Skill: Command Workflow Changes

Use when:

- Adding or changing a `dev` command.
- Updating command arguments or dispatch logic.

Touchpoints:

- `src/dev.ps1`
- `src/commands/*.ps1`

Checklist:

- Keep action routing in `switch ($action)` consistent.
- Update help text when command syntax changes.
- Keep command functions in their dedicated module file.
- Preserve existing action names unless migration is explicit.

Validation:

- Dot-source entry point: `. .\src\dev.ps1`
- Run `dev help` and verify updated usage text.

## Skill: Config and Roots Management

Use when:

- Editing settings behavior (`code`, `explorer`, roots, defaults).
- Modifying config read/write logic.

Touchpoints:

- `src/core/Config.ps1`
- `src/commands/Set.ps1`

Checklist:

- Keep config schema backward compatible where possible.
- Handle missing config files with safe defaults.
- Validate root names and paths before persisting.

Validation:

- Test `dev set --code=true/false`.
- Test `dev set --explorer=true/false`.
- Test `dev set root <name> <path>` and removal flow.

## Skill: Git Command Flows

Use when:

- Updating `pull`, `release`, `local-release`, `status`, or `init`.

Touchpoints:

- `src/commands/Git.ps1`
- `src/dev.ps1`

Checklist:

- Keep destructive operations explicit and user-visible.
- Preserve branch handling behavior for `dev init`.
- Keep local and remote release behavior clearly separated.

Validation:

- Test commands in a temporary git repo.
- Verify failure messaging for invalid repo states.

## Skill: Release and Version Sync

Use when:

- Shipping a new version.
- Updating installer/package metadata.

Touchpoints:

- `inno/setup.iss`
- `chocolatey/dev-ps-utils.nuspec`
- `web/app/releases/releases.json`
- `release-notes/RELEASE-NOTE-v*.md`

Checklist:

- Sync version string across all release files.
- Add release note file for the new version.
- Add release entry to website releases JSON.

Validation:

- Confirm all version references match exactly.
- Ensure release notes mention user-facing changes.

## Skill: Docs and Website Updates

Use when:

- Updating user documentation or docs pages.
- Adding command examples or installation changes.

Touchpoints:

- `README.md`
- `web/app/docs/page.tsx`
- `web/components/*.tsx`

Checklist:

- Keep examples executable as shown.
- Reflect current CLI options and defaults.
- Preserve existing site architecture and component boundaries.

Validation:

- Check that docs do not contradict command help text.
- Run web build/test flow when making substantial web changes.

## Skill: Chrome Native Host Integration

Use when:

- Updating browser extension behavior or host messaging.

Touchpoints:

- `chrome-extension/background.js`
- `chrome-extension/popup.js`
- `chrome-extension/native-host/*.ps1`
- `chrome-extension/native-host/install.ps1`

Checklist:

- Keep message payload shapes stable.
- Ensure native host scripts are path-safe on Windows.
- Maintain manifest permissions at minimum required scope.

Validation:

- Verify extension startup and popup actions.
- Verify host connection and command execution flow.
