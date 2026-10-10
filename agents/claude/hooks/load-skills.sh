#!/usr/bin/env bash
# Plugins inject adhd/ponytail; these skills have no plugin, so inject their full text here.
for s in caveman unslop asd-ste100; do
  f="$HOME/.claude/skills/$s/SKILL.md"
  [[ -f $f ]] || continue
  echo "# ACTIVE SKILL: $s (apply every response)"
  awk 'NR==1&&/^---$/{fm=1;next} fm&&/^---$/{fm=0;next} !fm' "$f"
  echo
done
