#!/usr/bin/env bash
set -Eeuo pipefail

# Este archivo se obtiene desde scripts de CI, nunca desde código de un PR.
# Limita los procesos de validación del runner.

CONTROL67_MAX_SECONDS="${CONTROL67_MAX_SECONDS:-1800}"
CONTROL67_MAX_MEMORY_KB="${CONTROL67_MAX_MEMORY_KB:-0}"
CONTROL67_MAX_OPEN_FILES="${CONTROL67_MAX_OPEN_FILES:-4096}"

case "$CONTROL67_MAX_SECONDS" in ''|*[!0-9]*) echo 'CONTROL67_MAX_SECONDS inválido' >&2; exit 2;; esac
case "$CONTROL67_MAX_MEMORY_KB" in ''|*[!0-9]*) echo 'CONTROL67_MAX_MEMORY_KB inválido' >&2; exit 2;; esac
case "$CONTROL67_MAX_OPEN_FILES" in ''|*[!0-9]*) echo 'CONTROL67_MAX_OPEN_FILES inválido' >&2; exit 2;; esac

run_limited() {
  if [[ "$#" -eq 0 ]]; then
    echo 'run_limited requiere un comando' >&2
    return 2
  fi

  (
    ulimit -n "$CONTROL67_MAX_OPEN_FILES" 2>/dev/null || true
    if [[ "$CONTROL67_MAX_MEMORY_KB" != '0' ]]; then
      ulimit -v "$CONTROL67_MAX_MEMORY_KB" 2>/dev/null || true
    fi
    timeout --signal=TERM --kill-after=30s "$CONTROL67_MAX_SECONDS" "$@"
  )
}
