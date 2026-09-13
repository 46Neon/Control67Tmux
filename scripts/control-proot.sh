#!/usr/bin/env bash
set -Eeuo pipefail

# Control allowlisted del contenedor Debian desde Termux.
COMMAND="${1:-status}"
DISTRO="${CONTROL67_DISTRO:-debian}"

command -v proot-distro >/dev/null 2>&1 || {
  echo 'proot-distro no está instalado.' >&2
  exit 2
}

case "$COMMAND" in
  status)
    proot-distro list
    proot-distro login "$DISTRO" -- true
    echo "proot_status=ok"
    ;;
  shell)
    exec proot-distro login "$DISTRO"
    ;;
  diagnostics)
    proot-distro login "$DISTRO" -- bash -lc 'uname -a; id; df -h; command -v gcc || true; command -v clang || true; command -v git || true'
    ;;
  *)
    echo 'Comando no permitido. Usa: status, shell o diagnostics.' >&2
    exit 3
    ;;
esac
