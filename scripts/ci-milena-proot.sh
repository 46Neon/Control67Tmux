#!/usr/bin/env bash
set -Eeuo pipefail

# Ejecutar dentro de Debian/proot-distro, no en Termux nativo.
# El script se limita a main y a tareas CI predefinidas.

REPOSITORY="${MILENA_REPOSITORY:-46Neon/Milena}"
BRANCH="${MILENA_BRANCH:-main}"
WORKSPACE="${MILENA_WORKSPACE:-$HOME/workspace/Milena}"
JOBS="${CONTROL67_JOBS:-2}"
LOG_DIR="${CONTROL67_LOG_DIR:-$HOME/.control67/logs}"

if [[ "$BRANCH" != "main" ]]; then
    echo "ERROR: Control67Tmux solo permite la rama main" >&2
    exit 2
fi

for command in git gcc clang make; do
    command -v "$command" >/dev/null 2>&1 || {
        echo "ERROR: falta el comando requerido: $command" >&2
        exit 3
    }
done

mkdir -p "$LOG_DIR"
LOG_FILE="$LOG_DIR/milena-$(date -u +%Y%m%dT%H%M%SZ).log"
exec > >(tee -a "$LOG_FILE") 2>&1

printf 'Control67Tmux CI\nRepositorio: %s\nRama: %s\nArquitectura: %s\n' \
    "$REPOSITORY" "$BRANCH" "$(uname -m)"

if [[ ! -d "$WORKSPACE/.git" ]]; then
    mkdir -p "$(dirname "$WORKSPACE")"
    git clone --branch "$BRANCH" --single-branch "https://github.com/$REPOSITORY.git" "$WORKSPACE"
fi

cd "$WORKSPACE"
git fetch --prune origin "$BRANCH"
git checkout --detach "origin/$BRANCH"

make clean
make CC=gcc \
    CFLAGS='-std=c17 -Wall -Wextra -Wpedantic -Wshadow -Wconversion -Werror -O2 -Iinclude' \
    LDFLAGS='-lm' strict

make clean
make CC=clang \
    CFLAGS='-std=c17 -Wall -Wextra -Wpedantic -Wshadow -Wconversion -Werror -O2 -Iinclude' \
    LDFLAGS='-lm' test

ASAN_OPTIONS='detect_leaks=1:halt_on_error=1' \
UBSAN_OPTIONS='print_stacktrace=1:halt_on_error=1' \
make clean

ASAN_OPTIONS='detect_leaks=1:halt_on_error=1' \
UBSAN_OPTIONS='print_stacktrace=1:halt_on_error=1' \
make CC=clang \
    CFLAGS='-std=c17 -Wall -Wextra -Wpedantic -g3 -O1 -fsanitize=address,undefined -Iinclude' \
    LDFLAGS='-fsanitize=address,undefined -lm' test

printf 'CONTROL67_RESULT=PASS\nLOG_FILE=%s\n' "$LOG_FILE"
