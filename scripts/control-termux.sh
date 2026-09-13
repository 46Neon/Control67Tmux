#!/usr/bin/env bash
set -Eeuo pipefail

# Punto de control local y allowlisted para Termux.
# No ejecuta comandos recibidos desde internet.

COMMAND="${1:-status}"
PROJECT_DIR="${CONTROL67_PROJECT_DIR:-$HOME/Control67Tmux}"
RUNNER_ROOT="${CONTROL67_RUNNER_ROOT:-$HOME/control67-runner-termux}"
LOG_DIR="${CONTROL67_LOG_DIR:-$HOME/.control67/logs}"

require_termux() {
  command -v pkg >/dev/null 2>&1 || {
    echo 'Este controlador debe ejecutarse en Termux nativo.' >&2
    exit 2
  }
}

status() {
  printf 'control67_status=ok\n'
  printf 'architecture=%s\n' "$(uname -m)"
  printf 'kernel=%s\n' "$(uname -sr)"
  printf 'termux_prefix=%s\n' "${PREFIX:-unset}"
  printf 'project_dir=%s\n' "$PROJECT_DIR"
  printf 'runner_root=%s\n' "$RUNNER_ROOT"
  printf 'runner_configured=%s\n' "$([[ -f "$RUNNER_ROOT/.runner" ]] && echo yes || echo no)"
  printf 'runner_running=%s\n' "$(pgrep -f "$RUNNER_ROOT/bin/Runner.Listener" >/dev/null 2>&1 && echo yes || echo no)"
  printf 'proot_distro=%s\n' "$(command -v proot-distro >/dev/null 2>&1 && echo available || echo missing)"
  printf 'storage_home=\n'
  df -h "$HOME" || true
}

diagnostics() {
  mkdir -p "$LOG_DIR"
  local output="$LOG_DIR/termux-health-$(date -u +%Y%m%dT%H%M%SZ).txt"
  {
    status
    echo
    echo '[packages]'
    pkg list-installed 2>/dev/null | head -n 80 || true
    echo
    echo '[processes]'
    ps -ef 2>/dev/null | grep -E 'Runner|proot|sshd' | grep -v grep || true
  } > "$output"
  chmod 600 "$output"
  echo "$output"
}

runner_start() {
  [[ -x "$PROJECT_DIR/scripts/start-runner.sh" ]] || { echo 'Falta start-runner.sh' >&2; exit 3; }
  RUNNER_ROOT="$RUNNER_ROOT" bash "$PROJECT_DIR/scripts/start-runner.sh" termux
}

runner_stop() {
  if [[ -f "$RUNNER_ROOT/.runner" ]]; then
    pkill -f "$RUNNER_ROOT/bin/Runner.Listener" || true
    echo 'Runner detenido.'
  else
    echo 'Runner no configurado.'
  fi
}

require_termux
case "$COMMAND" in
  status) status ;;
  diagnostics) diagnostics ;;
  runner-start) runner_start ;;
  runner-stop) runner_stop ;;
  logs) find "$LOG_DIR" -maxdepth 1 -type f -printf '%TY-%Tm-%Td %TH:%TM %p\n' 2>/dev/null | sort -r ;;
  *) echo 'Comando no permitido. Usa: status, diagnostics, runner-start, runner-stop o logs.' >&2; exit 4 ;;
esac
