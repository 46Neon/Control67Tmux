#!/usr/bin/env bash
set -Eeuo pipefail

# Ejecutar dentro de Debian instalado por proot-distro.
if [[ "$(uname -o 2>/dev/null || true)" != 'GNU/Linux' ]]; then
  echo 'Este script debe ejecutarse dentro de Debian/proot.' >&2
  exit 2
fi

export DEBIAN_FRONTEND=noninteractive
apt-get update
apt-get install -y --no-install-recommends \
  bash ca-certificates clang cppcheck curl git make gcc g++ \
  libc6-dev dpkg-dev pkg-config tar xz-utils

mkdir -p "$HOME/.control67/logs" "$HOME/workspace"
printf 'Debian/proot preparado para compilar Milena.\n'
printf 'Siguiente paso: configurar el runner con un token temporal.\n'
