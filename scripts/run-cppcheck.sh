#!/usr/bin/env bash
set -Eeuo pipefail

ROOT="${1:-${MILENA_WORKSPACE:-$HOME/workspace/Milena}}"
ARTIFACT_DIR="${CONTROL67_ARTIFACT_DIR:-$HOME/.control67/artifacts}"
REPORT="$ARTIFACT_DIR/cppcheck.xml"

command -v cppcheck >/dev/null 2>&1 || {
  echo 'cppcheck no está instalado.' >&2
  exit 2
}
[[ -d "$ROOT/src" && -d "$ROOT/include" ]] || {
  echo "No se encontraron src/include en $ROOT" >&2
  exit 3
}

mkdir -p "$ARTIFACT_DIR"
cppcheck \
  --enable=warning,performance,portability \
  --std=c17 \
  --language=c \
  --inline-suppr \
  --suppress=missingIncludeSystem \
  --xml \
  --xml-version=2 \
  "$ROOT/src" "$ROOT/include" \
  2> "$REPORT"

printf 'cppcheck OK: %s\n' "$REPORT"
