#!/usr/bin/env bash
set -Eeuo pipefail

LOG_DIR="${1:-${CONTROL67_LOG_DIR:-$HOME/.control67/logs}}"
MAX_FILES="${CONTROL67_LOG_MAX_FILES:-20}"
MAX_BYTES="${CONTROL67_LOG_MAX_BYTES:-52428800}"

case "$MAX_FILES" in ''|*[!0-9]*) echo 'CONTROL67_LOG_MAX_FILES inválido' >&2; exit 2;; esac
case "$MAX_BYTES" in ''|*[!0-9]*) echo 'CONTROL67_LOG_MAX_BYTES inválido' >&2; exit 2;; esac

[[ -d "$LOG_DIR" ]] || exit 0

find "$LOG_DIR" -type f -size "+${MAX_BYTES}c" -print0 | while IFS= read -r -d '' file; do
  : > "$file"
done

mapfile -t files < <(find "$LOG_DIR" -maxdepth 1 -type f -printf '%T@ %p\n' | sort -nr | tail -n +$((MAX_FILES + 1)) | cut -d' ' -f2-)
for file in "${files[@]}"; do
  [[ -n "$file" ]] && rm -f -- "$file"
done
