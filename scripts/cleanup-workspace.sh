#!/usr/bin/env bash
set -Eeuo pipefail

WORKSPACE="${1:-${MILENA_WORKSPACE:-$HOME/workspace/Milena}}"
ARTIFACT_DIR="${CONTROL67_ARTIFACT_DIR:-$HOME/.control67/artifacts}"

case "$WORKSPACE" in
  "$HOME"/*) ;;
  *) echo 'Workspace fuera del HOME; limpieza cancelada.' >&2; exit 2 ;;
esac

if [[ -d "$WORKSPACE/.git" ]]; then
  git -C "$WORKSPACE" status --porcelain=v1 > "$ARTIFACT_DIR/workspace-status.txt" || true
fi

if [[ "${CONTROL67_CLEAN_WORKSPACE:-0}" == '1' ]]; then
  rm -rf -- "$WORKSPACE"
  echo "Workspace eliminado: $WORKSPACE"
else
  echo "Workspace conservado: $WORKSPACE"
  echo 'Para limpieza explícita: CONTROL67_CLEAN_WORKSPACE=1'
fi
