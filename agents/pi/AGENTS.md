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
- When a faster native CLI tool is installed, prefer it over the classic one: `rg` over grep, `fd` over find, `sd` over sed, `jaq` over jq, `fzf` for fuzzy selection. Fall back to the classic tool when it is missing.
- When drafting plans, always make sure it is in a gitignored folder called plans
- Use the MIT License by default. Use another license only when the user requests it.

## Formatting

When initializing a project, find out what the standard or defacto standard formatter is for that language and apply it to the project and be sure to auto format before every commit

- Follow repository formatting rules only; do not apply Pi-lens or other tool-specific formatting/autofixes unless the repository explicitly requires them
- JS/TS: unless otherwise stated, lint with `@antfu/eslint-config` and set `stylistic: false`; format with Prettier instead of its stylistic rules
- C++: format with clang-format using Google style. Override only where a framework demands it (e.g. Qt's 4-space indent); put overrides in `.clang-format` so they are repo-wide, not ad hoc.

## JavaScript / TypeScript

Apply these defaults when creating a new project. In existing repos, follow their current setup; do not migrate toward these unless asked.

### Tooling

- pnpm, pinned via the `packageManager` field. ESM only: `"type": "module"`, no CommonJS.
- Lock down pnpm: `--frozen-lockfile` in CI, install scripts only via `onlyBuiltDependencies`, and set `minimumReleaseAge` so fresh releases are not installed immediately.
- Vite to build, Vitest to test, sharing one config. `tsc --noEmit` only typechecks; the bundler transpiles.
- Enable type-aware lint rules: pass `typescript: { tsconfigPath: './tsconfig.json' }` to `@antfu/eslint-config` (`no-floating-promises`, `no-misused-promises`, `switch-exhaustiveness-check`, `no-unnecessary-condition`).
- One gate script, run before every commit: `tsc --noEmit && eslint . && prettier --check . && knip && vitest run`. knip catches unused files, exports, and dependencies.
- Framework: ask when not stated. Recommend Svelte 5 or SolidJS for performance (compiled, no virtual DOM).

### TypeScript

- `strict`, `noUncheckedIndexedAccess`, `exactOptionalPropertyTypes`, `verbatimModuleSyntax`, `erasableSyntaxOnly` (no enums or namespaces, so code runs under Node type stripping).
- Also `noImplicitOverride`, `noImplicitReturns`, `noFallthroughCasesInSwitch`, `noPropertyAccessFromIndexSignature`, `allowUnreachableCode: false`, `allowUnusedLabels: false`. Write the flags out; do not add `@tsconfig/strictest`.
- Prefer `satisfies` over `as`. No `any` at boundaries; take `unknown` and validate.
- Validate environment variables with Valibot at startup so missing config fails at boot.

### Bundle size and performance

- No barrel files (re-export-only `index.ts`); import from the defining module.
- Build target `baseline-widely-available`, no legacy plugin or polyfills.
- Split routes with dynamic `import()`.
- When bundle size matters, add a size budget to the gate script. For libraries, set `"sideEffects": false`.

### Styling

- Prefer Tailwind wherever possible. Tailwind v4 with CSS-first config: `@import "tailwindcss"` plus `@theme` tokens, no `tailwind.config.js`.
- Sort classes with `prettier-plugin-tailwindcss`.
- Utilities in markup. Use `@apply` or custom CSS only for what Tailwind cannot express.
- Add `tailwind-merge` only when components accept overriding classes. Use template strings for conditional classes, not `clsx`.

### Dependencies

- Platform APIs first: `fetch`, `URL`, `structuredClone`, `Intl`, `crypto.randomUUID`, `AbortController` over axios, lodash, moment, uuid.
- Valibot over Zod for validation at trust boundaries (tree-shakes to a smaller bundle).

## Python

Apply these defaults when creating a new project. In existing repos, follow their current setup; do not migrate toward these unless asked.

### Tooling

- uv for Python versions, environments, dependencies, and the lockfile. Commit `uv.lock`; use `uv sync --locked` in CI.
- `pyproject.toml` only, no `setup.py` or `requirements.txt`. Use the `src/` layout.
- Latest stable CPython, pinned in `.python-version` and `requires-python`.
- Ruff for lint and format. `select = ["ALL"]`; ignore `COM812` and `ISC001` (formatter conflicts) and `D` unless docstrings are wanted. Disable any other rule only with the reason written next to it.
- basedpyright in strict mode for type checking.
- pytest with `filterwarnings = ["error"]`, `--strict-markers`, and `xfail_strict = true`.
- One gate script, run before every commit: `ruff format --check && ruff check && basedpyright && pytest`.

### Typing

- Annotate everything. No `Any`; take `object` and narrow.
- `@dataclass(slots=True, frozen=True)` for internal data, `TypedDict` for JSON shapes, `StrEnum` for fixed value sets.
- `match` with `assert_never` so missing cases fail typechecking.
- `pathlib` over `os.path`, timezone-aware `datetime`, `logging` over `print`.

### Dependencies and performance

- Stdlib first: `tomllib`, `json`, `sqlite3`, `argparse`, `concurrent.futures`. Add typer, click, or requests only when stdlib falls short.
- msgspec over Pydantic for validation and serialization at trust boundaries. Use Pydantic only when a framework requires it.
- httpx when a real HTTP client is needed.
- Async only for I/O-bound concurrency. Use generators for large data.
- Profile before optimizing. Move a hot path that is still too slow to Rust with PyO3 + maturin rather than hand-tuning Python.

### One-off scripts

The project rules above do not apply to throwaway scripts written to complete a task.

- Skip the script when a shell one-liner or a built-in tool does the job.
- Pipe it through a heredoc (`python - <<'EOF'`) instead of writing a file. If a file is needed, put it in the scratchpad, never the repo.
- Stdlib only. If a dependency is unavoidable, declare it with PEP 723 inline metadata and run it with `uv run`.
- Print only the answer: counts, summaries, the first N matches. Cap long output (`[:50]` plus a remaining count). Never dump whole files or raw JSON; print compact JSON with `separators=(",", ":")`.
- No `argparse`, `main()` guard, type hints, docstrings, logging, or error-swallowing `try`/`except`. Hardcode inputs and let it crash.
- Stream files line by line and use generators. Filter early with `os.scandir` or a `Path.rglob` pattern.
- Avoid pandas, numpy, and requests for small jobs; use `csv`, `json`, `urllib`, `sqlite3`.
- If the same script is needed twice, save it under `scripts/`; the project rules then apply.

## C++

Clang is mandated. clang/clang++ for builds, clangd for the editor,
clang-format and clang-tidy for the gate — so the analyzer and the compiler
agree on what the code means.

### Language and style

- Target C++20; prefer C++20 features (concepts, ranges, `std::span`, designated init, `constexpr`) over older idioms or hand-rolled equivalents.
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
