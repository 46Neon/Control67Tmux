#!/data/data/com.termux/files/usr/bin/bash
set -Eeuo pipefail

# Ejecutar en Termux nativo. No usar dentro de Debian/proot.
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
REPOSITORY="${MILENA_REPOSITORY:-46Neon/Milena}"
BRANCH="${MILENA_BRANCH:-main}"
WORKSPACE="${MILENA_TERMUX_WORKSPACE:-$HOME/workspace/Milena-termux}"
LOG_DIR="${CONTROL67_LOG_DIR:-$HOME/.control67/logs}"

[[ "$REPOSITORY" == '46Neon/Milena' ]] || { echo 'Repositorio no permitido' >&2; exit 2; }
[[ "$BRANCH" == 'main' ]] || { echo 'Rama no permitida' >&2; exit 2; }

for command in git clang make dpkg; do
  command -v "$command" >/dev/null 2>&1 || { echo "Falta $command" >&2; exit 3; }
done

mkdir -p "$LOG_DIR"
LOG_FILE="$LOG_DIR/milena-termux-$(date -u +%Y%m%dT%H%M%SZ).log"
exec > >(tee -a "$LOG_FILE") 2>&1

if [[ ! -d "$WORKSPACE/.git" ]]; then
  mkdir -p "$(dirname "$WORKSPACE")"
  git clone --branch "$BRANCH" --single-branch "https://github.com/$REPOSITORY.git" "$WORKSPACE"
fi

cd "$WORKSPACE"
git fetch --prune origin "$BRANCH"
git checkout --detach "origin/$BRANCH"

bash "$SCRIPT_DIR/runner-preflight.sh" termux

make clean
CC=clang make
CC=clang make test

printf 'CONTROL67_TERMUX_RESULT=PASS\nLOG_FILE=%s\n' "$LOG_FILE"
