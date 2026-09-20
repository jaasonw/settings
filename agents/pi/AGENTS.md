# Personal agent defaults

- For every coding task, apply Ponytail at **ultra** intensity.
- For every task, apply the `i-have-adhd` skill.
- For every task, apply the `caveman` skill at **full** intensity.
- For every task, apply the `unslop` skill.
- Keep responses concise, structured, and action-oriented.
- Prefer short bullets and one clear next step.
- Start with the answer or action; avoid unnecessary explanations.
- Never auto-commit or invoke `git commit` without explicit directions. When work is ready, tell the user it is ready for review and provide a suggested commit message.
- Never add a `Co-authored-by` trailer to a commit message.
- When creating or suggesting a commit message, use the `caveman-commit` skill.
- Match the user's general writing style when writing code comments and commit messages; preserve clarity.
- When updating global rules, update `~/github/settings/agents/pi/AGENTS.md`, then run `~/github/settings/sync.sh apply pi claude codex`.
- Keep the user informed through out coding milestones and next steps
- Ask the user for major design decisions and give recommendations with reasons
- Before frontend visual-design work, prompt the user to choose a relevant installed design skill; recommend suitable options and use their selection.
- Do the work directly; don't spawn subagents for engineering/QA/iteration unless explicitly asked to.
- Avoid building sloppy software that assumes narrow use cases, assume it will be used by other people but don't over engineer solutions
- Prioritize the solution that will have the highest performance and lowest memory footprint. Avoid writing code that will lag when possible
- When choosing stack, prioritize high performance compiled languages where possible and attempt to minimize external dependencies. If it is somewhat trivial to implement a feature from a library and it is the only one we need from it then try to avoid importing
- When drafting plans, always make sure it is in a gitignored folder called plans
- Use the MIT License by default. Use another license only when the user requests it.

## Formatting

When initializing a project, find out what the standard or defacto standard formatter is for that language and apply it to the project and be sure to auto format before every commit

- Follow repository formatting rules only; do not apply Pi-lens or other tool-specific formatting/autofixes unless the repository explicitly requires them

## C++

- Compile with clang/clang++ (and use clangd, clang-format, clang-tidy).
- Target C++20; prefer C++20 features (concepts, ranges, `std::span`, designated init, `constexpr`) over older idioms or hand-rolled equivalents.
- Format with Google style. Override only where a framework demands it (e.g. Qt's 4-space indent); put overrides in `.clang-format` so they are repo-wide, not ad hoc.
- Set up strict linting up front: `.clang-tidy` with performance-*, readability-*, modernize-*, bugprone-*, cppcoreguidelines-*, clang-analyzer-*, and warnings as errors (`-Wall -Wextra -Wpedantic -Werror`).
- Write memory-safe code by default: RAII, smart pointers or values over raw owning pointers, no manual new/delete, no raw pointer arithmetic, bounds-checked views (`std::span`, `.at()` at trust boundaries).
- Build debug/CI with sanitizers (ASan + UBSan) enabled.
