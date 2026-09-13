#!/usr/bin/env bash
set -Eeuo pipefail

OUTPUT_DIR="${CONTROL67_DIAGNOSTICS_DIR:-$HOME/.control67/diagnostics}"
mkdir -p "$OUTPUT_DIR"
OUTPUT="$OUTPUT_DIR/diagnostics-$(date -u +%Y%m%dT%H%M%SZ).txt"

{
  echo 'Control67Tmux diagnostics'
  echo "timestamp_utc=$(date -u +%Y-%m-%dT%H:%M:%SZ)"
  echo "user=$(id -un)"
  echo "architecture=$(uname -m)"
  echo "kernel=$(uname -sr)"
  echo "termux_prefix=${PREFIX:-unset}"
  echo "proot_prefix=${PROOT_PREFIX:-unset}"
  echo
  for command in bash git gcc clang make dpkg proot-distro; do
    if command -v "$command" >/dev/null 2>&1; then
      printf '%s=' "$command"
      "$command" --version 2>/dev/null | head -n 1 || true
    else
      echo "$command=not-found"
    fi
  done
  echo
  if command -v dpkg >/dev/null 2>&1; then
    dpkg --print-architecture || true
  fi
} > "$OUTPUT"

chmod 600 "$OUTPUT"
printf 'Diagnósticos guardados en %s\n' "$OUTPUT"
