#!/usr/bin/env bash
set -euo pipefail

REPO_ROOT="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
HERMES_SKILLS_DIR="${HOME}/.hermes/skills/custom"
SURF_BIN_DIR="${HOME}/.local/bin"
SURF_BIN="${SURF_BIN_DIR}/surf"

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

  local src_real dst_real
  src_real="$(readlink -f "$src")"
  dst_real="$(readlink -f "$dst" 2>/dev/null || true)"

  if [ -n "$dst_real" ] && [ "$src_real" = "$dst_real" ]; then
    echo "Already linked/installed ${name} -> ${dst}"
    return 0
  fi

  cp "$src" "$dst"
  echo "Installed ${name} -> ${dst}"
}

detect_surf_artifact() {
  local os arch
  os="$(uname -s)"
  arch="$(uname -m)"

  case "$os" in
    Linux) os='linux' ;;
    Darwin) os='darwin' ;;
    *) echo "Unsupported OS: $os" >&2; exit 1 ;;
  esac

  case "$arch" in
    x86_64|amd64) arch='amd64' ;;
    arm64|aarch64) arch='arm64' ;;
    *) echo "Unsupported architecture: $arch" >&2; exit 1 ;;
  esac

  printf 'surf_%s_%s' "$os" "$arch"
}

install_surf_cli() {
  local version artifact url checksum_url tmpdir checksum expected actual
  version="$(curl -fsSL https://downloads.asksurf.ai/cli/releases/latest)"
  artifact="$(detect_surf_artifact)"
  url="https://downloads.asksurf.ai/cli/releases/${version}/${artifact}"
  checksum_url="https://downloads.asksurf.ai/cli/releases/${version}/checksums.txt"
  tmpdir="$(mktemp -d)"
  trap 'rm -rf "$tmpdir"' RETURN

  mkdir -p "$SURF_BIN_DIR"

  echo "Downloading Surf CLI ${version} (${artifact})"
  curl -fsSLo "$tmpdir/surf" "$url"
  checksum="$(curl -fsSL "$checksum_url")"
  expected="$(printf '%s\n' "$checksum" | awk -v a="$artifact" '$2==a{print $1}')"

  if [ -z "$expected" ]; then
    echo "Could not find checksum for ${artifact}" >&2
    exit 1
  fi

  actual="$(sha256sum "$tmpdir/surf" | awk '{print $1}')"
  if [ "$expected" != "$actual" ]; then
    echo "Checksum mismatch for Surf CLI" >&2
    echo "expected=$expected" >&2
    echo "actual=$actual" >&2
    exit 1
  fi

  chmod +x "$tmpdir/surf"
  "$tmpdir/surf" install --local

  if [ ! -x "$SURF_BIN" ]; then
    echo "Expected Surf binary at $SURF_BIN after install" >&2
    exit 1
  fi

  echo "Installed Surf CLI -> $SURF_BIN"
}

verify_surf_ready() {
  local surf_cmd
  if [ -x "$SURF_BIN" ]; then
    surf_cmd="$SURF_BIN"
  elif command -v surf >/dev/null 2>&1; then
    surf_cmd="$(command -v surf)"
  else
    echo "Surf CLI not found after installation" >&2
    exit 1
  fi

  echo "Syncing Surf API spec cache"
  "$surf_cmd" sync >/dev/null

  echo "Verifying Surf CLI"
  "$surf_cmd" --help >/dev/null
  "$surf_cmd" list-operations >/dev/null
  "$surf_cmd" market-price --symbol BTC --json >/dev/null

  echo "Surf is ready to use via: $surf_cmd"

  case ":$PATH:" in
    *":${SURF_BIN_DIR}:"*) ;;
    *)
      echo
      echo "Note: ${SURF_BIN_DIR} is not currently in PATH."
      echo "You can still run: ${surf_cmd}"
      echo "To use plain 'surf', add this to your shell profile:"
      echo "  export PATH=\"${SURF_BIN_DIR}:\$PATH\""
      ;;
  esac
}

usage() {
  cat <<'EOF'
Usage:
  ./install.sh install-surf-for-hermes
  ./install.sh surf
  ./install.sh cli
  ./install.sh all

Commands:
  install-surf-for-hermes  Install the install helper skill only
  surf                     Install the surf skill and Surf CLI
  cli                      Install / update only the Surf CLI
  all                      Install both skills plus the Surf CLI (recommended)
EOF
}

case "${1:-all}" in
  install-surf-for-hermes)
    install_skill install-surf-for-hermes
    ;;
  surf)
    install_skill surf
    install_surf_cli
    verify_surf_ready
    ;;
  cli)
    install_surf_cli
    verify_surf_ready
    ;;
  all)
    install_skill install-surf-for-hermes
    install_skill surf
    install_surf_cli
    verify_surf_ready
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
