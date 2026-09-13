#!/usr/bin/env bash
set -Eeuo pipefail

ROLE="${1:-proot}"
case "$ROLE" in
  proot|termux) ;;
  *) echo 'Uso: runner-preflight.sh proot|termux' >&2; exit 2 ;;
esac

REPOSITORY="${MILENA_REPOSITORY:-46Neon/Milena}"
BRANCH="${MILENA_BRANCH:-main}"

[[ "$REPOSITORY" == '46Neon/Milena' ]] || {
  echo 'ERROR: repositorio no permitido' >&2
  exit 3
}
[[ "$BRANCH" == 'main' ]] || {
  echo 'ERROR: rama no permitida' >&2
  exit 4
}

for command in bash git; do
  command -v "$command" >/dev/null 2>&1 || {
    echo "ERROR: falta $command" >&2
    exit 5
  }
done

if [[ "$ROLE" == proot ]]; then
  for command in gcc clang make; do
    command -v "$command" >/dev/null 2>&1 || {
      echo "ERROR: falta $command en Debian/proot" >&2
      exit 6
    }
  done
else
  for command in clang make dpkg; do
    command -v "$command" >/dev/null 2>&1 || {
      echo "ERROR: falta $command en Termux" >&2
      exit 7
    }
  done
fi

printf 'Preflight OK: role=%s repository=%s branch=%s arch=%s\n' \
  "$ROLE" "$REPOSITORY" "$BRANCH" "$(uname -m)"
