# Agent settings

`pi`, `claude`, and `codex` are optional sync modules:

```sh
./sync.sh apply pi claude codex
```

`agents/pi/AGENTS.md` is canonical. Claude Code and Codex receive symlinks to the deployed Pi file.

They contain only portable preferences, prompts, and hook configuration.
Authenticate separately on every machine.

Excluded on purpose: OAuth/API credentials, model catalogs with provider keys,
sessions, history, caches, task state, plugin downloads, and project trust data.

The Claude Herdr hook is safe when Herdr is absent: it exits unless Herdr's
runtime environment is present. Pi packages listed in `pi/settings.json` are
installed/resolved by Pi after it starts; do not copy `~/.pi/agent/npm`.
