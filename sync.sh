#!/usr/bin/env bash
set -euo pipefail

ROOT=$(cd -- "$(dirname -- "${BASH_SOURCE[0]}")" && pwd)
MODULES_FILE="$ROOT/modules.conf"
BACKUP="$HOME/.local/state/settings-backups/$(date +%Y%m%d-%H%M%S)"
MODE=
DRY_RUN=0
declare -a NAMES SOURCES TARGETS SELECTED

usage() {
  cat <<EOF
Usage: $0 [apply|import] [--dry-run] [module ...]

Run without arguments for an interactive menu.
Modules are defined in modules.conf.
EOF
  exit 2
}

load_modules() {
  while IFS='|' read -r name source target; do
    [[ -z "$name" || "$name" == \#* ]] && continue
    [[ -d "$ROOT/$source" ]] || {
      echo "Missing module source: $source" >&2
      exit 1
    }
    NAMES+=("$name")
    SOURCES+=("$source")
    TARGETS+=("$target")
  done <"$MODULES_FILE"
}

module_index() {
  local query=$1 i
  for i in "${!NAMES[@]}"; do
    [[ "$query" == "$((i + 1))" || "$query" == "${NAMES[i]}" ]] && {
      echo "$i"
      return
    }
  done
  echo "Unknown module: $query" >&2
  exit 2
}

choose_modules() {
  local choice item index
  echo "Modules:"
  echo "  all) all modules"
  for index in "${!NAMES[@]}"; do
    printf '  %d) %s\n' "$((index + 1))" "${NAMES[index]}"
  done
  read -r -p "Choose modules (all, names, or numbers): " choice
  [[ -n "$choice" ]] || choice=all
  [[ "$choice" == all ]] && {
    SELECTED=("${!NAMES[@]}")
    return
  }
  for item in $choice; do
    SELECTED+=("$(module_index "$item")")
  done
}

menu() {
  local choice
  read -r -p "Direction: [a]pply repo -> home, [i]mport home -> repo, [q]uit: " choice
  case "$choice" in
  a | apply) MODE=apply ;;
  i | import) MODE=import ;;
  q | quit) exit 0 ;;
  *) usage ;;
  esac
  choose_modules
  read -r -p "Dry run first? [Y/n] " choice
  [[ "$choice" != n && "$choice" != N ]] && DRY_RUN=1
}

parse_args() {
  (($# == 0)) && {
    menu
    return
  }
  MODE=$1
  shift
  [[ "$MODE" == apply || "$MODE" == import ]] || usage
  while (($#)); do
    case "$1" in
    --dry-run) DRY_RUN=1 ;;
    *) SELECTED+=("$(module_index "$1")") ;;
    esac
    shift
  done
  ((${#SELECTED[@]})) || SELECTED=("${!NAMES[@]}")
}

sync_module() {
  local index=$1 source="$ROOT/${SOURCES[index]}" target="$HOME/${TARGETS[index]}" list
  if [[ "$MODE" == apply ]]; then
    mkdir -p "$target"
    local args=(-a --itemize-changes --backup --backup-dir="$BACKUP")
    ((DRY_RUN)) && args+=(-n)
    rsync "${args[@]}" "$source/" "$target/"
    return
  fi

  # Import only files already represented by the repository; never sweep all of $HOME.
  list=$(mktemp)
  trap 'rm -f "$list"' RETURN
  (cd "$source" && find . -type f -printf '%P\n') >"$list"
  local args=(-a --itemize-changes --ignore-missing-args --files-from="$list")
  ((DRY_RUN)) && args+=(-n)
  rsync "${args[@]}" "$target/" "$source/"
}

load_modules
parse_args "$@"
command -v rsync >/dev/null 2>&1 || {
  echo "sync.sh requires rsync." >&2
  exit 1
}

if [[ "$MODE" == apply && $DRY_RUN -eq 0 ]]; then
  mkdir -p "$BACKUP"
fi
for index in "${SELECTED[@]}"; do
  echo "==> ${NAMES[index]}"
  sync_module "$index"
done

if [[ "$MODE" == apply && $DRY_RUN -eq 0 ]]; then
  echo "Backup: $BACKUP"
fi
