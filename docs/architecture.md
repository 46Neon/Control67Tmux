# Arquitectura de Control67Tmux

## Principios

1. El anfitrión es Termux.
2. La ejecución de Milena ocurre dentro de Debian mediante `proot-distro`.
3. Solo se permite el repositorio `46Neon/Milena`.
4. Solo se permite la rama `main`.
5. No se acepta una terminal pública ni comandos arbitrarios.
6. Los secretos se mantienen fuera del repositorio.

## Componentes previstos

```text
Termux
└── Debian/proot-distro
    ├── runner autenticado
    ├── allowlist de tareas
    ├── límites de tiempo y recursos
    ├── compilación y pruebas de Milena
    └── logs y artefactos
```

## Evolución prevista

- `preflight`: verifica arquitectura, herramientas y entorno.
- `ci-milena-proot.sh`: ejecuta la validación completa.
- `collect-diagnostics.sh`: recopila versiones, flags y resultados.
- `termux-native.sh`: valida únicamente el entorno nativo de Termux.
- `runner-policy`: restringe repositorio, rama, comandos y rutas.
- `artifacts`: almacena logs y reportes sin secretos.
