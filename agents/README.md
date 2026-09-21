# Agent settings

`agent-skills`, `pi`, `claude`, and `codex` are optional sync modules:

```sh
./sync.sh apply agent-skills pi claude codex
```

`agents/pi/AGENTS.md` is canonical. Claude Code and Codex receive symlinks to the deployed Pi file.

They contain only portable preferences, prompts, and hook configuration.
Authenticate separately on every machine.

Excluded on purpose: OAuth/API credentials, model catalogs with provider keys,
sessions, history, caches, task state, plugin downloads, and project trust data.

## Skills

Run every public-skill and agent-plugin install command:

```sh
./agents/install-skills.sh
```

It installs public skills for every detected agent, syncs vendored local skills
to `~/.agents/skills`, deploys Pi-only `subagent-models`, then installs Pi,
Claude Code, and Codex packages/plugins.

The Claude Herdr hook is safe when Herdr is absent: it exits unless Herdr's
runtime environment is present. Pi packages listed in `pi/settings.json` are
installed/resolved by Pi after it starts; do not copy `~/.pi/agent/npm`.

## Pi extensions and packages

`pi/extensions/linglong.ts` provides `/linglong terra|flash|toggle|status`.
It is deployed by the existing `pi` sync module. Restart Pi or run `/reload`
after applying settings.

Pi installs the packages in `pi/settings.json` at startup. To install them
explicitly:

```sh
pi install npm:pi-lens
pi install npm:pi-subagents
pi install npm:pi-background-tasks
pi install npm:@juicesharp/rpiv-ask-user-question
pi install npm:@narumitw/pi-plan-mode
pi install npm:pi-mcp-adapter
pi install npm:pi-web-access
pi install npm:pi-observational-memory
pi install https://github.com/theclaymethod/unslop
pi install npm:pi-image-paste
```
