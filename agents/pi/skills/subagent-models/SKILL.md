---
name: subagent-models
description: Explain the local /linglong command and its China and OpenAI subagent profiles. Use when asked to switch, enable, disable, or show either profile.
license: MIT
argument-hint: "[china|openai|toggle|status]"
---

# Subagent Models

The `/linglong` command runs directly in `extensions/linglong.ts`. It does not send a prompt, call a model, or consume tokens. Use it even when the current provider has no quota.

## Commands

- `/linglong china`: apply the China profile through OpenRouter.
- `/linglong openai`: apply the OpenAI profile.
- `/linglong toggle`: switch complete profiles. Mixed or unknown state switches to OpenAI.
- `/linglong status`: show the six effective model overrides without changing settings.

| Agents | China profile | OpenAI profile |
| --- | --- | --- |
| `delegate`, `researcher`, `scout`, `worker` | `openrouter/~deepseek/deepseek-flash-latest` | `openai-codex/gpt-6.1-terra` |
| `reviewer` | `openrouter/z-ai/glm-5.3` | `openai-codex/gpt-6.1-sol` |
| `oracle` | `openrouter/moonshotai/kimi-k3.1-pro` | `openai-codex/gpt-6-astra` |

The DeepSeek model ID includes a leading `~` in the installed Pi catalog.

## Behavior

- Change only model fields for these six agents in user settings.
- Preserve thinking levels, prompts, tools, other agents, and the main chat model.
- Check local model availability and configured credentials before writing. Do not make a provider request to test quota.
- Refuse changes when a conflicting project model override would prevent the selected profile from taking effect.
- Write the settings atomically. Do not edit extension or package files to switch profiles.

For natural-language requests, direct the user to the corresponding `/linglong` command. If no profile is specified, ask whether to use `china` or `openai`. Do not use model-driven management calls as a substitute for this command. `/skill:subagent-models` explains the command; it does not execute a switch.

Run `/reload` after installing or updating the extension.
