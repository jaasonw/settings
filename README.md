# Settings

Portable, script-based dotfiles for Linux. No Stow or administrator access is required.

## Sync

Run `./sync.sh` with no arguments for a direction/package menu.

```sh
./sync.sh apply --dry-run nvim  # preview just Neovim, repo -> home
./sync.sh apply                 # back up and apply every module
./sync.sh import fish terminals # import selected modules from home
```

Modules are one line each in `modules.conf`; adding one needs no `sync.sh`
changes. `apply` stores overwritten files under `~/.local/state/settings-backups/`
and does not delete destination-only files.

## Managed settings

- `nvim/` → `~/.config/nvim/`
- `fish/` → a minimal Fish config plus optional CachyOS integration
- `terminals/` → Ghostty, Fastfetch, and Rofi under `~/.config/`
- `shell/.gitconfig` → `~/.gitconfig`
- `agents/pi/` → portable `~/.pi/agent/` settings
- `agents/claude/` → portable `~/.claude/` settings

`terminals/.config/fastfetch/config.jsonc` is intentionally CachyOS/Arch-themed.
See `CACHYOS.txt` and `KDE.txt` for manual recreation notes; KDE state/layouts,
package lists, bundled Micro syntax files, and generated caches are excluded.
