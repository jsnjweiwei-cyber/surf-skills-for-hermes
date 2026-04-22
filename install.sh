#!/usr/bin/env bash
set -euo pipefail

REPO_ROOT="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
HERMES_SKILLS_DIR="${HOME}/.hermes/skills/custom"

install_skill() {
  local name="$1"
  local src="${REPO_ROOT}/skills/${name}/SKILL.md"
  local dst_dir="${HERMES_SKILLS_DIR}/${name}"
  local dst="${dst_dir}/SKILL.md"

  if [ ! -f "$src" ]; then
    echo "Missing skill file: $src" >&2
    exit 1
  fi

  mkdir -p "$dst_dir"
  cp "$src" "$dst"
  echo "Installed ${name} -> ${dst}"
}

usage() {
  cat <<'EOF'
Usage:
  ./install.sh install-surf-for-hermes
  ./install.sh surf
  ./install.sh all

Installs selected skills into ~/.hermes/skills/custom/
EOF
}

case "${1:-all}" in
  install-surf-for-hermes)
    install_skill install-surf-for-hermes
    ;;
  surf)
    install_skill surf
    ;;
  all)
    install_skill install-surf-for-hermes
    install_skill surf
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
  echo "Installed skills now visible via: hermes skills list | grep -E 'surf|install-surf'"
fi
