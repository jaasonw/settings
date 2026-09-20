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

Clang is mandated. clang/clang++ for builds, clangd for the editor,
clang-format and clang-tidy for the gate — so the analyzer and the compiler
agree on what the code means.

### Language and style

- Target C++20; prefer C++20 features (concepts, ranges, `std::span`, designated init, `constexpr`) over older idioms or hand-rolled equivalents.
- Format with Google style. Override only where a framework demands it (e.g. Qt's 4-space indent); put overrides in `.clang-format` so they are repo-wide, not ad hoc.
- Build debug and CI with ASan + UBSan. Add TSan on Linux/macOS when the project has threads. Skip MSan unless every dependency is already instrumented.

### Warnings and lint

- `-Wall -Wextra -Wpedantic -Werror` as the floor.
- Dangling-reference warnings as errors: `-Wdangling -Wdangling-gsl -Wreturn-stack-address`.
- `-Wthread-safety -Wthread-safety-negative` when the project has shared mutable state.
- `-Wconversion -Wsign-conversion` so narrowing is never silent.
- `.clang-tidy` enabling performance-*, readability-*, modernize-*, bugprone-*, cppcoreguidelines-*, clang-analyzer-*, with `WarningsAsErrors: '*'`. Disable a check only with the reason written next to it.

### Memory safety

Rust-level guarantees are not on offer; these close the classes Rust
eliminates, in descending order of safety per unit of effort.

1. Harden the standard library so bounds are checked in release builds: `-D_LIBCPP_HARDENING_MODE=_LIBCPP_HARDENING_MODE_FAST` under libc++, `-D_GLIBCXX_ASSERTIONS` under libstdc++. Pick it per build tree, never per target.
2. RAII everywhere. Values or `unique_ptr` over raw owning pointers, no manual new/delete, no raw pointer arithmetic, `std::span` and `.at()` at trust boundaries. Confine `reinterpret_cast` and C arrays to a named FFI boundary.
3. Annotate lifetimes and locks: `[[clang::lifetimebound]]` on accessors returning views or references, `GUARDED_BY`/`REQUIRES` on shared state. Both behind `__has_attribute` macros so they compile away elsewhere.
4. `-ftrivial-auto-var-init=pattern` so nothing is read uninitialized.
5. Make ignored errors a compile error: `[[nodiscard]]` on anything returning a status, plus `modernize-use-nodiscard` and `bugprone-unused-return-value`. Prefer a sum type over bool-plus-out-param; `std::expected` once the project is on C++23.

### Portability

Express these as intent plus a per-toolchain flag mapping in CMake, not
hardcoded flags. Stdlib is the real variable, not the OS: the hardening
macro differs between libc++ and libstdc++, and MSVC's `_ITERATOR_DEBUG_LEVEL`
changes ABI, so it must match across every linked library. `_FORTIFY_SOURCE`
is glibc-only. Fewer checks on a weaker toolchain is fine; a broken build is
not.
