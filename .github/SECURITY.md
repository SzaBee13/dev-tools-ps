# Security Policy

## Supported Versions

Security fixes are applied to the latest stable release only.

| Version | Supported |
| --- | --- |
| Latest | Yes |
| Older | No |

## Reporting a Vulnerability

If you discover a security vulnerability, do not open a public issue.

Report it privately by using GitHub Security Advisories:

- [GitHub Security Advisories](https://github.com/SzaBee13/dev-tools-ps/security/advisories/new)

If that is not possible, contact the maintainer through GitHub and share details privately.

Please include:

- A clear description of the vulnerability and impact
- Steps to reproduce (or a proof-of-concept)
- Any suggested mitigations or patches

Response target:

- Acknowledgement within 72 hours
- Status update or remediation plan within 14 days

## Scope

This policy covers:

- PowerShell source files in `src/`
- Chrome extension code in `chrome-extension/`
- Native host scripts in `chrome-extension/native-host/`
- Packaging scripts in `chocolatey/` and `inno/`

The documentation website in `web/` is static and has no user authentication or server-side data storage.
