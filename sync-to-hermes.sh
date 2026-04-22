#!/usr/bin/env bash
set -euo pipefail

REPO_ROOT="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

link_skill() {
  local src="$1"
  local dst="$2"

  if [ ! -f "$src/SKILL.md" ]; then
    echo "Missing source skill: $src/SKILL.md" >&2
    exit 1
  fi

  mkdir -p "$(dirname "$dst")"

  if [ -L "$dst" ]; then
    rm "$dst"
  elif [ -e "$dst" ]; then
    local backup="${dst}.backup.$(date +%Y%m%d-%H%M%S)"
    mv "$dst" "$backup"
    echo "Backed up existing path: $backup"
  fi

  ln -s "$src" "$dst"
  echo "Linked $dst -> $(readlink -f "$dst")"
}

show_status() {
  local path="$1"
  if [ -L "$path" ]; then
    echo "$path -> $(readlink -f "$path")"
  elif [ -e "$path" ]; then
    echo "$path (exists, not symlink)"
  else
    echo "$path (missing)"
  fi
}

usage() {
  cat <<'EOF'
Usage:
  ./sync-to-hermes.sh
  ./sync-to-hermes.sh status
  ./sync-to-hermes.sh relink

Commands:
  status   Show current link state only
  relink   Recreate links from repo to Hermes skill paths
  (none)   Same as relink
EOF
}

INSTALL_SURF_SRC="${REPO_ROOT}/skills/install-surf-for-hermes"
SURF_SRC="${REPO_ROOT}/skills/surf"
INSTALL_SURF_DST="${HOME}/.hermes/skills/autonomous-ai-agents/install-surf-for-hermes"
SURF_DST="${HOME}/.hermes/skills/custom/surf"

case "${1:-relink}" in
  status)
    show_status "$INSTALL_SURF_DST"
    show_status "$SURF_DST"
    ;;
  relink)
    link_skill "$INSTALL_SURF_SRC" "$INSTALL_SURF_DST"
    link_skill "$SURF_SRC" "$SURF_DST"
    ;;
  -h|--help|help)
    usage
    ;;
  *)
    usage >&2
    exit 1
    ;;
esac

if command -v hermes >/dev/null 2>&1; then
  echo
  echo "Visible skills:"
  hermes skills list | grep -E '^│ (install-surf-for-hermes|surf)\b' || true
fi
