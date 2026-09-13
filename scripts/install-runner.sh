#!/usr/bin/env bash
set -Eeuo pipefail

ROLE="${1:-}"
case "$ROLE" in
  proot|termux) ;;
  *) echo 'Uso: install-runner.sh proot|termux' >&2; exit 2 ;;
esac

: "${RUNNER_TOKEN:?Define RUNNER_TOKEN temporalmente; nunca lo guardes en el repositorio}"
RUNNER_REPOSITORY="${RUNNER_REPOSITORY:-46Neon/Control67Tmux}"
: "${RUNNER_VERSION:?Define RUNNER_VERSION con una versión publicada de actions/runner}"
RUNNER_ROOT="${RUNNER_ROOT:-$HOME/control67-runner-$ROLE}"
RUNNER_LABELS="${RUNNER_LABELS:-self-hosted,linux,ARM64,milena-$ROLE}"
RUNNER_ARCH="${RUNNER_ARCH:-arm64}"

command -v curl >/dev/null 2>&1 || { echo 'Falta curl' >&2; exit 3; }
command -v tar >/dev/null 2>&1 || { echo 'Falta tar' >&2; exit 3; }

mkdir -p "$RUNNER_ROOT"
cd "$RUNNER_ROOT"

ARCHIVE="actions-runner-linux-${RUNNER_ARCH}-${RUNNER_VERSION}.tar.gz"
URL="https://github.com/actions/runner/releases/download/v${RUNNER_VERSION}/${ARCHIVE}"

if [[ ! -f "$ARCHIVE" ]]; then
  curl -fL --retry 3 --output "$ARCHIVE" "$URL"
fi

tar -xzf "$ARCHIVE"
chmod 700 "$RUNNER_ROOT"

./config.sh \
  --url "https://github.com/$RUNNER_REPOSITORY" \
  --token "$RUNNER_TOKEN" \
  --name "control67-${ROLE}-$(uname -n)" \
  --labels "$RUNNER_LABELS" \
  --work "_work" \
  --unattended \
  --replace

unset RUNNER_TOKEN
printf 'Runner configurado en %s. No se inicia automáticamente.\n' "$RUNNER_ROOT"
