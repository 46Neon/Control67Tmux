#!/data/data/com.termux/files/usr/bin/bash
set -Eeuo pipefail

# Preparar Termux como anfitrión. No registra runners ni solicita secretos.
command -v pkg >/dev/null 2>&1 || {
  echo 'Este script debe ejecutarse en Termux nativo.' >&2
  exit 2
}

pkg update -y
pkg upgrade -y
pkg install -y bash curl ca-certificates git openssh tar proot-distro coreutils

if ! proot-distro list 2>/dev/null | grep -Eq '^debian( |$)'; then
  echo 'La versión instalada de proot-distro no muestra Debian.' >&2
  exit 3
fi

if ! proot-distro login debian -- true >/dev/null 2>&1; then
  echo 'Debian no está instalado. Ejecuta: proot-distro install debian' >&2
  exit 4
fi

printf 'Termux preparado. Debian está disponible para la configuración del runner.\n'
printf 'Siguiente paso: proot-distro login debian\n'
