# AGENTS.md

Guidance for AI coding agents working in this repository.

## Project Overview

KIB in Batch is a lightweight UNIX-like environment installer for Microsoft Windows. The implementation in this repository is primarily Windows Batch, with GitHub Actions workflows used for Windows-based installation and package-manager validation.

Key files:

- `src/kib_in_batch.bat` is the main installer/launcher.
- `uninstall.bat` removes an installed KIB environment and optionally backs up the user's home directory.
- `removeignoredfiles.bat` runs `git clean -fdX` to remove ignored build artifacts.
- `README.md`, `CONTRIBUTING.md`, `SECURITY.md`, and `VERSION.txt` are the main project metadata files.
- `.github/workflows/cicd.yml` is the broadest CI workflow and installs KIB on `windows-2025`.
- `.github/workflows/teststandalone.yml` and `.github/workflows/release.yml` reference `mkstandalone.py`; verify that file exists before relying on those workflows locally.

## Working Rules

- Prefer small, focused changes. This project has a narrow batch-script surface area, so avoid broad rewrites unless the task explicitly calls for one.
- Preserve Windows Batch compatibility. Do not replace batch behavior with PowerShell, Python, or shell scripts unless the project direction changes.
- Keep paths and commands Windows-aware. Use backslashes in user-facing Windows commands when that matches the surrounding docs.
- Be careful with user data paths such as `%USERPROFILE%\kib`, `%APPDATA%\kib_in_batch`, `%USERPROFILE%\kalihome.bak.d`, and any `subst` drive mappings.
- Do not run destructive cleanup commands casually. `removeignoredfiles.bat` invokes `git clean -fdX`; only run it when explicitly requested or clearly needed.
- Keep generated binaries, archives, and build outputs out of git. The `.gitignore` excludes common binary/package artifacts and `build/`.

## Batch Style Notes

- Use `@echo off` for scripts unless there is a reason to echo commands.
- Quote paths that can contain spaces, especially anything under `%USERPROFILE%`, `%APPDATA%`, or a selected drive root.
- Use `setlocal enabledelayedexpansion` when working with values changed inside blocks or loops, and use `!VAR!` consistently in those contexts.
- Check `%errorlevel%` or `if errorlevel 1` after commands that can fail, especially network downloads, `subst`, `curl`, PowerShell calls, and package installation steps.
- Keep prompts clear because the installer is interactive. If adding automation behavior, preserve interactive behavior for normal users.

## Testing

This project is meant to be tested on Windows.

Useful checks:

```cmd
src\kib_in_batch.bat
```

For CI-like validation, inspect and mirror the relevant steps in:

```text
.github\workflows\cicd.yml
.github\workflows\teststandalone.yml
```

The full CI install touches real user-scoped locations and creates/removes a substituted drive, so do not run it on a user's machine without confirming the expected side effects.

## Contribution Expectations

- Follow `CONTRIBUTING.md`; it instructs contributors to work from the `dev` branch.
- Keep PRs mergeable and make sure relevant checks pass.
- Security-sensitive changes should respect `SECURITY.md` and avoid exposing tokens, user paths beyond what is already necessary, or private installation details.
