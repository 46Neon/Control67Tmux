# Arquitectura de Control67Tmux

## Principios

1. El anfitrión es Termux.
2. Debian se ejecuta mediante `proot-distro`.
3. El control del dispositivo está separado de los perfiles de trabajo.
4. Milena es un perfil opcional, no el objetivo central.
5. No se acepta una terminal pública ni comandos arbitrarios.
6. Los secretos se mantienen fuera del repositorio.
7. Las tareas remotas deben corresponder a una allowlist versionada.

## Componentes previstos

```text
Termux
├── plano de control
│   ├── estado
│   ├── salud
│   ├── runners
│   ├── logs
│   └── allowlist
└── Debian/proot-distro
    ├── límites de tiempo y recursos
    ├── runner aislado
    └── perfiles de trabajo
        └── CI de Milena (opcional)
```

## Evolución prevista

- `preflight`: verifica arquitectura, herramientas y entorno.
- `ci-milena-proot.sh`: ejecuta la validación completa.
- `collect-diagnostics.sh`: recopila versiones, flags y resultados.
- `termux-native.sh`: valida únicamente el entorno nativo de Termux.
- `runner-policy`: restringe repositorio, rama, comandos y rutas.
- `artifacts`: almacena logs y reportes sin secretos.
