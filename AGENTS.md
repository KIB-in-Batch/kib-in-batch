# AGENTS.md

Guidance for AI coding agents working in this repository.

## Project Overview

KIB in Batch is a lightweight UNIX-like environment installer for Microsoft Windows. The repository is primarily Windows Batch, with documentation and project metadata in Markdown.

Key files:

- `src/kib_in_batch.bat` is the main installer and launcher.
- `uninstall.bat` removes an installed KIB environment and optionally backs up the user's home directory.
- `removeignoredfiles.bat` removes ignored build artifacts by running `git clean -fdX`.
- `README.md`, `CONTRIBUTING.md`, `SECURITY.md`, `CODE_OF_CONDUCT.md`, `LICENSE.txt`, and `VERSION.txt` are the main project metadata files.

## Branch And PR Workflow

- Work from the `dev` branch.
- Commit changes to `dev` or to a feature branch based on `dev`.
- Create pull requests targeting `dev`.
- Do not commit directly to `master`, base new work on `master`, or open pull requests that target `master` unless a maintainer explicitly requests it.
- Keep pull requests small and focused so they are easy to review.

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

Useful manual check:

```cmd
src\kib_in_batch.bat
```

The full installer touches real user-scoped locations, downloads files, and creates/removes a substituted drive. Do not run it on a user's machine without confirming the expected side effects.

## Contribution Expectations

- Follow `CONTRIBUTING.md`; it instructs contributors to check out `dev` before making changes.
- Make sure relevant manual checks or CI checks pass before opening a pull request.
- Security-sensitive changes should respect `SECURITY.md` and avoid exposing tokens, user paths beyond what is already necessary, or private installation details.
