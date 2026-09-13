#!/usr/bin/env bash
set -Eeuo pipefail

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
ARTIFACT_DIR="${CONTROL67_ARTIFACT_DIR:-$HOME/.control67/artifacts}"
MAX_SECONDS="${CONTROL67_MAX_SECONDS:-1800}"
mkdir -p "$ARTIFACT_DIR"

export CONTROL67_ARTIFACT_DIR="$ARTIFACT_DIR"
export CONTROL67_DIAGNOSTICS_DIR="$ARTIFACT_DIR"
export CONTROL67_MAX_SECONDS="$MAX_SECONDS"
trap 'bash "$SCRIPT_DIR/rotate-logs.sh" || true' EXIT

bash "$SCRIPT_DIR/runner-preflight.sh" proot
bash "$SCRIPT_DIR/collect-diagnostics.sh"
bash "$SCRIPT_DIR/ci-milena-proot.sh"
bash "$SCRIPT_DIR/run-cppcheck.sh"

if [[ "${CONTROL67_RUN_BENCHMARKS:-0}" == '1' ]]; then
  bash "$SCRIPT_DIR/run-benchmarks.sh"
fi

bash "$SCRIPT_DIR/cleanup-workspace.sh"
printf 'CONTROL67_VALIDATION=PASS\nARTIFACT_DIR=%s\n' "$ARTIFACT_DIR"
