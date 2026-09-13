#!/usr/bin/env bash
set -Eeuo pipefail

ROOT="${1:-${MILENA_WORKSPACE:-$HOME/workspace/Milena}}"
ARTIFACT_DIR="${CONTROL67_ARTIFACT_DIR:-$HOME/.control67/artifacts}"
REPORT="$ARTIFACT_DIR/benchmark.txt"
MAX_SECONDS="${CONTROL67_MAX_SECONDS:-1800}"
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
source "$SCRIPT_DIR/resource-policy.sh"

mkdir -p "$ARTIFACT_DIR"
cd "$ROOT"

measure() {
  local label="$1"
  shift
  local start end
  start="$(date +%s)"
  run_limited "$@"
  end="$(date +%s)"
  printf '%s_elapsed_seconds=%s\n' "$label" "$((end - start))"
}

{
  echo "timestamp_utc=$(date -u +%Y-%m-%dT%H:%M:%SZ)"
  echo "architecture=$(uname -m)"
  echo "compiler_gcc=$(gcc --version 2>/dev/null | head -n 1 || true)"
  echo "compiler_clang=$(clang --version 2>/dev/null | head -n 1 || true)"
  echo
  echo '[strict_build]'
  measure strict_build make clean strict
  echo
  echo '[test_suite]'
  measure test_suite make test
  echo
  if [[ -x ./milena ]]; then
    echo '[binary]'
    stat -c 'size_bytes=%s' ./milena 2>/dev/null || wc -c ./milena
  fi
} 2>&1 | tee "$REPORT"

printf 'Benchmark base guardado en %s\n' "$REPORT"
