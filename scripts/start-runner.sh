#!/usr/bin/env bash
set -Eeuo pipefail

ROLE="${1:-}"
case "$ROLE" in
  proot|termux) ;;
  *) echo 'Uso: start-runner.sh proot|termux' >&2; exit 2 ;;
esac

RUNNER_ROOT="${RUNNER_ROOT:-$HOME/control67-runner-$ROLE}"
[[ -x "$RUNNER_ROOT/run.sh" ]] || {
  echo "Runner no configurado en $RUNNER_ROOT" >&2
  exit 3
}

cd "$RUNNER_ROOT"
umask 077
exec ./run.sh
