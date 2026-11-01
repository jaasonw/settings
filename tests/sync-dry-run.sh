#!/usr/bin/env bash
set -euo pipefail

ROOT=$(cd -- "$(dirname -- "${BASH_SOURCE[0]}")/.." && pwd)
TEMP=$(mktemp -d)
trap 'rm -rf "$TEMP"' EXIT
mkdir -p "$TEMP/repo/config" "$TEMP/home/config"
cp "$ROOT/sync.sh" "$TEMP/repo/sync.sh"
printf 'test|config|config\n' >"$TEMP/repo/modules.conf"
printf 'incoming\n' >"$TEMP/repo/config/changed file"
printf 'current\n' >"$TEMP/home/config/changed file"
printf 'same\n' >"$TEMP/repo/config/same"
cp "$TEMP/repo/config/same" "$TEMP/home/config/same"
printf 'new\n' >"$TEMP/repo/config/new"
printf 'missing\n' >"$TEMP/repo/config/missing"
printf 'local only\n' >"$TEMP/home/config/local-only"
printf '\000new' >"$TEMP/repo/config/binary"
printf '\000old' >"$TEMP/home/config/binary"
ln -s new-target "$TEMP/repo/config/link"
ln -s old-target "$TEMP/home/config/link"
printf 'regular\n' >"$TEMP/repo/config/was-link"
ln -s absent "$TEMP/home/config/was-link"

HOME="$TEMP/home" bash "$TEMP/repo/sync.sh" apply --dry-run test >"$TEMP/apply"
grep -Fq 'OVERWRITE' "$TEMP/apply"
grep -Fq -- '-current' "$TEMP/apply"
grep -Fq -- '+incoming' "$TEMP/apply"
grep -Fq "CREATE $TEMP/home/config/new" "$TEMP/apply"
grep -Fq 'Binary files' "$TEMP/apply"
grep -Fq 'target: new-target' "$TEMP/apply"
grep -Fq 'replaces symlink: absent' "$TEMP/apply"
! grep -Fq '/same' "$TEMP/apply"
! grep -Fq 'local-only' "$TEMP/apply"
[[ ! -e "$TEMP/home/config/new" ]]
[[ "$(readlink "$TEMP/home/config/link")" == old-target ]]
[[ "$(readlink "$TEMP/home/config/was-link")" == absent ]]
[[ "$(<"$TEMP/home/config/changed file")" == current ]]
[[ ! -e "$TEMP/home/.local" ]]

HOME="$TEMP/home" bash "$TEMP/repo/sync.sh" import --dry-run test >"$TEMP/import"
grep -Fq -- '-incoming' "$TEMP/import"
grep -Fq -- '+current' "$TEMP/import"
grep -Fq "SKIP missing source: $TEMP/home/config/missing" "$TEMP/import"
[[ "$(<"$TEMP/repo/config/changed file")" == incoming ]]
[[ ! -e "$TEMP/repo/config/local-only" ]]

printf 'test|config|not-created\n' >"$TEMP/repo/modules.conf"
HOME="$TEMP/home" bash "$TEMP/repo/sync.sh" apply --dry-run test >"$TEMP/absent"
[[ ! -e "$TEMP/home/not-created" ]]

printf 'claude|config|.claude\n' >"$TEMP/repo/modules.conf"
HOME="$TEMP/home" bash "$TEMP/repo/sync.sh" apply --dry-run claude >"$TEMP/rules"
grep -Fq "FINAL SYMLINK $TEMP/home/.claude/CLAUDE.md -> ../.pi/agent/AGENTS.md" "$TEMP/rules"
[[ ! -e "$TEMP/home/.claude" ]]
printf 'Dry-run checks passed.\n'
