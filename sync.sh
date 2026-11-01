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

link_rules() {
  case "${NAMES[$1]}" in
    claude) ln -sfn ../.pi/agent/AGENTS.md "$2/CLAUDE.md" ;;
    codex) ln -sfn ../.pi/agent/AGENTS.md "$2/AGENTS.md" ;;
    opencode) ln -sfn ../../.pi/agent/AGENTS.md "$2/AGENTS.md" ;;
  esac
}

preview_file() {
  local from=$1 to=$2 before=$2 status
  if [[ -L "$from" ]]; then
    if [[ -L "$to" && "$(readlink "$from")" == "$(readlink "$to")" ]]; then
      return
    fi
    printf '\nSYMLINK %s\n  from: %s\n  target: %s\n' "$to" "$from" "$(readlink "$from")"
    if [[ -e "$to" || -L "$to" ]]; then
      printf '  replaces existing destination\n'
    fi
    return
  fi
  if [[ -f "$to" && ! -L "$to" ]] && cmp -s "$from" "$to"; then
    return
  fi
  if [[ -e "$to" || -L "$to" ]]; then
    printf '\nOVERWRITE %s\n  from: %s\n' "$to" "$from"
    if [[ -L "$to" ]]; then
      printf '  replaces symlink: %s\n' "$(readlink "$to")"
    elif [[ ! -f "$to" ]]; then
      printf '  conflict: destination is not a regular file\n'
      return
    fi
  else
    printf '\nCREATE %s\n  from: %s\n' "$to" "$from"
  fi
  [[ -f "$to" ]] || before=/dev/null
  if diff -u --label "$to (current)" --label "$to (incoming)" "$before" "$from"; then
    :
  else
    status=$?
    [[ "$status" == 1 ]] || return "$status"
  fi
}

preview_module() {
  local index=$1 repo=$2 home=$3 rel from to rule='' link=''
  while IFS= read -r -d '' rel; do
    rel=${rel#./}
    if [[ "$MODE" == apply ]]; then
      from=$repo/$rel to=$home/$rel
    else
      from=$home/$rel to=$repo/$rel
    fi
    if [[ ! -e "$from" && ! -L "$from" ]]; then
      printf '\nSKIP missing source: %s\n' "$from"
      continue
    fi
    preview_file "$from" "$to"
  done < <(cd "$repo" && find . \( -type f -o -type l \) -print0)
  if [[ "$MODE" == apply ]]; then
    case "${NAMES[index]}" in
      claude) rule=CLAUDE.md link=../.pi/agent/AGENTS.md ;;
      codex) rule=AGENTS.md link=../.pi/agent/AGENTS.md ;;
      opencode) rule=AGENTS.md link=../../.pi/agent/AGENTS.md ;;
    esac
    if [[ -n "$rule" ]]; then
      printf '\nFINAL SYMLINK %s/%s -> %s\n' "$home" "$rule" "$link"
    fi
  fi
  printf '\nPreview only. Destination-only files are preserved.\n'
}

# Fallback for hosts without rsync (stock Git Bash on Windows). Walks repo files only.
copy_files() {
  local repo=$1 home=$2 rel from to
  while IFS= read -r -d '' rel; do
    if [[ "$MODE" == apply ]]; then
      from=$repo/$rel to=$home/$rel
    else
      from=$home/$rel to=$repo/$rel
    fi
    [[ -e "$from" ]] || continue
    if [[ -e "$to" ]]; then
      cmp -s "$from" "$to" && continue
      echo "changed $rel"
    else
      echo "new $rel"
    fi
    ((DRY_RUN)) && continue
    if [[ "$MODE" == apply && -e "$to" ]]; then
      mkdir -p "$(dirname "$BACKUP/$rel")"
      cp -p "$to" "$BACKUP/$rel"
    fi
    mkdir -p "$(dirname "$to")"
    rm -f "$to"
    cp -p "$from" "$to"
  done < <(cd "$repo" && find . ! -type d -printf '%P\0')
}

sync_module() {
  local index=$1 source="$ROOT/${SOURCES[index]}" target="$HOME/${TARGETS[index]}" list
  if ((DRY_RUN)); then
    preview_module "$index" "$source" "$target"
    return
  fi
  ((HAVE_RSYNC)) || {
    copy_files "$source" "$target"
    [[ "$MODE" == apply ]] && ((!DRY_RUN)) && link_rules "$index" "$target"
    return 0
  }
  if [[ "$MODE" == apply ]]; then
    mkdir -p "$target"
    local args=(-a --itemize-changes --backup --backup-dir="$BACKUP")
    ((DRY_RUN)) && args+=(-n)
    rsync "${args[@]}" "$source/" "$target/"
    ((DRY_RUN)) && return
    link_rules "$index" "$target"
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
HAVE_RSYNC=1
command -v rsync >/dev/null 2>&1 || {
  HAVE_RSYNC=0
  echo "rsync not found; using cp fallback." >&2
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
