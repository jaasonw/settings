# Agent settings

`agent-skills`, `pi`, `claude`, `codex`, and `opencode` are optional sync modules:

```sh
./sync.sh apply agent-skills pi claude codex opencode
```

`agents/pi/AGENTS.md` is canonical. Claude Code, Codex, and OpenCode receive symlinks to the deployed Pi file.

They contain only portable preferences, prompts, and hook configuration.
Authenticate separately on every machine.

Excluded on purpose: OAuth/API credentials, model catalogs with provider keys,
sessions, history, caches, task state, plugin downloads, and project trust data.

## OpenCode

Preview or apply OpenCode v2 preferences:

```sh
./sync.sh apply --dry-run opencode
./sync.sh apply opencode
```

The module manages `opencode.jsonc` and `cli.json`. It shares Pi rules and
skill directories, and stores matching model profiles. Model profiles are a
snapshot, not an automatic conversion of Pi settings. Deploy `pi` and
`agent-skills` too when setting up a new machine.

OpenCode loads `opencode.jsonc` after `opencode.json`. Keep machine-specific
MCP servers and provider settings in the unmanaged `opencode.json`.
Applying this module preserves that file, service passwords, credentials,
and chat history. Import only brings back the two managed preference files.
Do not add credentials or local MCP paths to them. Pi extensions do not run
in OpenCode. Restart OpenCode after applying settings.

## Skills

Run every public-skill and agent-plugin install command:

```sh
./agents/install-skills.sh
```

It installs public skills for every detected agent, syncs vendored local skills
to `~/.agents/skills`, deploys Pi-only `subagent-models`, then installs Pi,
Claude Code, and Codex packages/plugins. It also registers REA for these three
agents and installs REA's matching `reverse-engineer-anything` skill.

The installer includes `asd-ste100`, which the global agent rules require for
every prompt. To install this skill separately:

```sh
npx --yes skills add danyuchn/asd-ste100-skill -g -a '*' -y -s asd-ste100
```

The Claude Herdr hook is safe when Herdr is absent: it exits unless Herdr's
runtime environment is present. Pi packages listed in `pi/settings.json` are
installed/resolved by Pi after it starts; do not copy `~/.pi/agent/npm`.

## REA

The installer uses `rea-agents@6.4.0`, matching the installed MCP registrations.
To preview or apply REA setup separately:

```sh
npx --yes rea-agents@6.4.0 setup --client pi --client claude_code --client codex --dry-run
npx --yes rea-agents@6.4.0 setup --client pi --client claude_code --client codex
```

Setup preserves unrelated agent settings, backs up changed files, and installs
the matching workflow instructions. Restart the affected agents after setup.
Keep the version here and in `install-skills.sh` aligned when updating REA.

REA registrations stay outside the sync modules because they share files with
other MCP servers, credentials, or machine-specific settings. Configure native
analysis engines separately on each machine. Do not copy local Java or Ghidra
paths into this repository. See [REA setup](https://github.com/morluto/rea/blob/main/docs/installation.md).

## Pi extensions and packages

`pi/extensions/linglong.ts` provides `/linglong china|openai|toggle|status`.
Commands change the six subagent model overrides directly in user settings;
they do not call a model or consume tokens. Thinking levels and the main chat
model stay unchanged. `status` shows effective user/project model overrides;
conflicting project model overrides block switches. Model availability and
configured credentials are checked locally, not by making provider requests.
The OpenAI profile requires `openai/gpt-6-astra` for the oracle; if that
model is unavailable, the switch fails without changing settings.

It is deployed by the existing `pi` sync module. Restart Pi or run `/reload`
after applying settings. Run `node --test tests/linglong.test.mjs` to test the
command without calling providers or changing live settings.

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
pi install npm:@andre-barbosa/pi-codex-usage@0.1.2
```
