---
name: subagent-models
description: Toggle Pi builtin subagent models between DeepSeek Flash/Kimi K3 and OpenAI Codex GPT-5.6 Terra/GPT-6 Astra. Use when asked to switch, enable, disable, or show the Terra/Astra subagent profile.
license: MIT
argument-hint: "[terra|flash|toggle|status]"
---

# Subagent Models

Manage only these builtin agents:

| Agents | Flash profile | Terra profile |
| --- | --- | --- |
| `delegate`, `researcher`, `reviewer`, `scout`, `worker` | `openrouter/deepseek/deepseek-v4.1-flash` | `openai-codex/gpt-5.6-terra` |
| `oracle` | `openrouter/moonshotai/kimi-k3` | `openai-codex/gpt-6-astra` |

## Commands

- `/linglong terra`: apply Terra profile.
- `/linglong flash`: restore Flash profile.
- `/linglong toggle`: inspect, then switch to opposite complete profile. Mixed/unknown state switches to Terra.
- `/linglong status`: show current model for six agents. No changes.

`/skill:subagent-models <mode>` remains available as direct fallback.

Natural-language requests for these profiles use same behavior. If no argument, ask whether to apply `terra` or `flash`; do not guess.

## Procedure

1. Call `subagent({ action: "list", capabilities: true })`. Confirm all six builtin agents exist and target OpenAI Codex models are available/authenticated when applying Terra.
2. For `status`, report current model and stop.
3. For `toggle`, compare all six current models against both profile tables. If all equal Flash, use Terra. Otherwise use Flash only when all equal Terra; use Terra for mixed/unknown state.
4. Apply profile with one `subagent` management update per affected agent, using only `{ model: "provider/model" }`. Do not alter prompts, tools, thinking, aliases, or any other agent settings.
5. Call `subagent({ action: "list", capabilities: true })` again. Report final model for all six agents and any failed update.

Use user-scope defaults. Do not edit extension/package files directly. Do not change agents outside this table.
