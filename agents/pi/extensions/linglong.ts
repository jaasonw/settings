import {
  existsSync,
  mkdirSync,
  readFileSync,
  realpathSync,
  renameSync,
  rmSync,
  statSync,
  writeFileSync,
} from "node:fs";
import { randomUUID } from "node:crypto";
import { dirname, join } from "node:path";
import {
  CONFIG_DIR_NAME,
  getAgentDir,
  type ExtensionAPI,
} from "@earendil-works/pi-coding-agent";

const PROFILES = {
  china: {
    scout: "openrouter/~deepseek/deepseek-flash-latest",
    worker: "openrouter/~deepseek/deepseek-flash-latest",
    reviewer: "openrouter/z-ai/glm-5.3",
    oracle: "openrouter/moonshotai/kimi-k3.1-pro",
    researcher: "openrouter/~deepseek/deepseek-flash-latest",
    delegate: "openrouter/~deepseek/deepseek-flash-latest",
  },
  openai: {
    scout: "openai/gpt-6.1-terra",
    worker: "openai/gpt-6.1-terra",
    reviewer: "openai/gpt-6.1-sol",
    oracle: "openai/gpt-6-astra",
    researcher: "openai/gpt-6.1-terra",
    delegate: "openai/gpt-6.1-terra",
  },
} as const;

type Profile = keyof typeof PROFILES;
type Agent = keyof (typeof PROFILES)[Profile];
const AGENTS = Object.keys(PROFILES.china) as Agent[];

function object(value: unknown, label: string): Record<string, unknown> {
  if (value === undefined) return {};
  if (value === null || typeof value !== "object" || Array.isArray(value)) {
    throw new Error(`${label} must be a JSON object.`);
  }
  return value as Record<string, unknown>;
}

function readSettings(path: string): Record<string, unknown> {
  if (!existsSync(path)) return {};
  try {
    return object(JSON.parse(readFileSync(path, "utf8")), path);
  } catch (error) {
    throw new Error(`Cannot read settings at ${path}.`, { cause: error });
  }
}

function overrides(settings: Record<string, unknown>): Record<string, unknown> {
  return object(object(settings["subagents"], "subagents")["agentOverrides"], "agentOverrides");
}

type ModelSetting = string | false | undefined;

function model(overrides: Record<string, unknown>, agent: Agent): ModelSetting {
  const value = object(overrides[agent], agent)["model"];
  if (value === undefined || value === false || typeof value === "string") return value;
  throw new Error(`Invalid model setting for ${agent}.`);
}

function saveSettings(path: string, settings: Record<string, unknown>) {
  // Preserve settings-file symlinks and replace the complete JSON atomically.
  if (existsSync(path)) path = realpathSync(path);
  mkdirSync(dirname(path), { recursive: true });
  const temporary = `${path}.${randomUUID()}.tmp`;
  const mode = existsSync(path) ? statSync(path).mode & 0o777 : 0o600;
  try {
    writeFileSync(temporary, `${JSON.stringify(settings, null, 2)}\n`, { flag: "wx", mode });
    renameSync(temporary, path);
  } finally {
    rmSync(temporary, { force: true });
  }
}

export default function (pi: ExtensionAPI) {
  pi.registerCommand("linglong", {
    description: "Switch subagent models locally: china, openai, toggle, or status",
    handler: async (args, ctx) => {
      const mode = args.trim().toLowerCase();
      if (!["china", "openai", "toggle", "status"].includes(mode)) {
        ctx.ui.notify("Use /linglong china, openai, toggle, or status.", "error");
        return;
      }

      try {
        const path = join(getAgentDir(), "settings.json");
        const settings = readSettings(path);
        const user = overrides(settings);
        const project = overrides(readSettings(join(ctx.cwd, CONFIG_DIR_NAME, "settings.json")));
        const current = new Map(AGENTS.map((agent) => [agent, model(project, agent) ?? model(user, agent)]));
        const matches = (profile: Profile) =>
          AGENTS.every((agent) => current.get(agent) === PROFILES[profile][agent]);
        let active: Profile | "mixed" = "mixed";
        if (matches("china")) active = "china";
        else if (matches("openai")) active = "openai";

        if (mode === "status") {
          ctx.ui.notify(
            [`Subagent profile: ${active}`, ...AGENTS.map((agent) => `${agent}: ${current.get(agent) ?? "inherited"}`)].join("\n"),
            "info",
          );
          return;
        }

        let target: Profile;
        if (mode === "china" || mode === "openai") target = mode;
        else target = active === "openai" ? "china" : "openai";
        const profile = PROFILES[target];
        const available = new Set(ctx.modelRegistry.getAvailable().map((entry) => `${entry.provider}/${entry.id}`));
        for (const agent of AGENTS) {
          if (!available.has(profile[agent])) {
            throw new Error(`Model unavailable or credentials missing: ${profile[agent]}. No settings changed.`);
          }
          const projectModel = model(project, agent);
          if (projectModel !== undefined && projectModel !== profile[agent]) {
            throw new Error(`Project model override blocks switching ${agent}. No settings changed.`);
          }
        }

        const updated = { ...user };
        for (const agent of AGENTS) {
          updated[agent] = { ...object(user[agent], agent), model: profile[agent] };
        }
        settings["subagents"] = {
          ...object(settings["subagents"], "subagents"),
          agentOverrides: updated,
        };
        saveSettings(path, settings);
        ctx.ui.notify(`Subagent profile: ${target}. Thinking levels and main chat model unchanged.`, "info");
      } catch (error) {
        ctx.ui.notify(`Cannot switch subagent profile: ${error instanceof Error ? error.message : String(error)}`, "error");
      }
    },
  });
}
