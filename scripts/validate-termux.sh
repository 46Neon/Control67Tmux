#!/usr/bin/env bash
set -Eeuo pipefail

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
ARTIFACT_DIR="${CONTROL67_ARTIFACT_DIR:-$HOME/.control67/artifacts-termux}"
mkdir -p "$ARTIFACT_DIR"

export CONTROL67_ARTIFACT_DIR="$ARTIFACT_DIR"
export CONTROL67_DIAGNOSTICS_DIR="$ARTIFACT_DIR"
trap 'bash "$SCRIPT_DIR/rotate-logs.sh" || true' EXIT

bash "$SCRIPT_DIR/runner-preflight.sh" termux
bash "$SCRIPT_DIR/collect-diagnostics.sh"
bash "$SCRIPT_DIR/termux-native.sh"
bash "$SCRIPT_DIR/cleanup-workspace.sh" "${MILENA_TERMUX_WORKSPACE:-$HOME/workspace/Milena-termux}"

printf 'CONTROL67_TERMUX_VALIDATION=PASS\nARTIFACT_DIR=%s\n' "$ARTIFACT_DIR"
