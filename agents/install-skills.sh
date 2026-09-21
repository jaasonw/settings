#!/usr/bin/env bash
set -euo pipefail

ROOT=$(cd -- "$(dirname -- "${BASH_SOURCE[0]}")/.." && pwd)

# Public skills, installed for every detected agent.
npx --yes skills add JuliusBrussee/caveman -g -a '*' -y -s \
  cavecrew caveman caveman-commit caveman-compress caveman-discover \
  caveman-evidence-review caveman-explore caveman-help caveman-learn \
  caveman-manage caveman-optimize caveman-review caveman-setup caveman-stats
npx --yes skills add Leonxlnx/taste-skill -g -a '*' -y -s \
  brandkit design-taste-frontend design-taste-frontend-v1 \
  full-output-enforcement gpt-taste high-end-visual-design image-to-code \
  imagegen-frontend-mobile imagegen-frontend-web industrial-brutalist-ui \
  minimalist-ui redesign-existing-projects stitch-design-taste
npx --yes skills add ayghri/i-have-adhd -g -a '*' -y
npx --yes skills add dietrichgebert/ponytail -g -a '*' -y -s \
  ponytail ponytail-audit ponytail-debt ponytail-gain ponytail-help ponytail-review
npx --yes skills add theclaymethod/unslop -g -a '*' -y
npx --yes skills add vercel-labs/skills -g -a '*' -y -s find-skills

# Locally maintained skills plus Pi-only subagent-models.
"$ROOT/sync.sh" apply agent-skills pi

# Pi packages.
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

# Claude Code plugin skills.
claude plugin marketplace add anthropics/claude-plugins-official
claude plugin marketplace add ayghri/i-have-adhd
claude plugin marketplace add DietrichGebert/ponytail
claude plugin install i-have-adhd@i-have-adhd -y
claude plugin install frontend-design@claude-plugins-official -y
claude plugin install rust-analyzer-lsp@claude-plugins-official -y
claude plugin install ponytail@ponytail -y

# Codex plugin skill.
codex plugin marketplace add ayghri/i-have-adhd
codex plugin add i-have-adhd@i-have-adhd
