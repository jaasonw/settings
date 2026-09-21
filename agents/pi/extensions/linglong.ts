import type { ExtensionAPI } from "@earendil-works/pi-coding-agent";

const MODES = new Set(["terra", "flash", "toggle", "status"]);

export default function (pi: ExtensionAPI) {
  pi.registerCommand("linglong", {
    description: "Toggle between Chinese or OpenAI models",
    handler: async (args, ctx) => {
      const mode = args.trim().toLowerCase();
      if (!MODES.has(mode)) {
        ctx.ui.notify(
          "Use /linglong terra, flash, toggle, or status.",
          "error",
        );
        return;
      }

      pi.sendUserMessage(`/skill:subagent-models ${mode}`, {
        expandPromptTemplates: true,
      });
    },
  });
}
