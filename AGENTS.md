# Repository guide

This repository stores portable dotfiles and agent settings. It is not an application project.

## Layout

- `modules.conf` maps module names to repository directories and home-relative targets.
- `sync.sh` applies repository files to home or imports existing managed files from home.
- `agents/pi/` stores portable Pi settings, keybindings, extensions, and Pi-only skills.
- `agents/pi/AGENTS.md` contains canonical personal agent rules. This root file contains repository guidance, not global rules.
- `agents/claude/` and `agents/codex/` store other agent settings. Applying these modules links their instruction files to the deployed Pi rules.
- `agents/skills/` contains locally maintained shared skills. `agents/install-skills.sh` installs public skills and agent packages.
- Editor, shell, and terminal settings live in their corresponding module directories. Read `README.md` and `agents/README.md` for setup details.

## Editing and syncing

- Keep changes small and preserve existing configuration style. Do not reformat unrelated files.
- Store portable preferences only. Never copy credentials, provider keys, sessions, caches, downloaded packages, or machine-specific paths into the repository.
- Compare live configuration with managed files before importing. `sync.sh import` imports only files already represented in the repository; inspect new files separately.
- Add a module through `modules.conf`, not a new branch in `sync.sh`.
- When changing Pi packages, keep `agents/pi/settings.json`, `agents/install-skills.sh`, and the explicit install commands in `agents/README.md` consistent.
- Change global agent rules in `agents/pi/AGENTS.md`, not this file. Deploy rule changes with `./sync.sh apply pi claude codex`.
- Preview deployments with `./sync.sh apply --dry-run <module>`. Applying settings changes home files and backs up overwritten files; it does not delete destination-only files.
- `sync.sh` requires Bash. It uses rsync when present and falls back to `cp` otherwise (e.g. Git Bash on Windows). Do not run the full installer or deploy unrelated modules merely to validate edits.
- Put draft plans in a gitignored `plans/` directory.
- Commit only when explicitly requested. Never add a `Co-authored-by` trailer.

## Validation

- Run `git diff --check` before committing.
- Check shell changes with `bash -n sync.sh agents/install-skills.sh`.
- Parse edited JSON files and verify relevant package declarations match install commands.
- Use focused checks for changed modules. There is no repository-wide application build or test suite.
