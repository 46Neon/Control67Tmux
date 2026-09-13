# Control67Tmux

Plano de control seguro para administrar Termux y Debian ejecutado mediante `proot-distro`.

Milena es solamente un perfil opcional de trabajo. El objetivo principal de Control67Tmux es controlar el entorno Termux, sus runners, sus diagnósticos y sus límites de ejecución.

## Capacidades principales

- comprobar la salud de Termux;
- comprobar el estado de Debian/proot-distro;
- iniciar y detener el runner local;
- recopilar diagnósticos;
- rotar logs;
- aplicar límites de recursos;
- ejecutar perfiles autorizados;
- conservar artefactos sin secretos;
- evitar comandos arbitrarios y terminales públicas.

## Componentes

```text
Termux
├── control-termux.sh
├── control-proot.sh
├── runner local
└── logs/diagnósticos
    └── Debian mediante proot-distro
        └── perfiles de trabajo autorizados
```

## Perfiles

### Control del dispositivo

```text
scripts/control-termux.sh
scripts/control-proot.sh
```

Comandos permitidos:

```text
status
diagnostics
runner-start
runner-stop
logs
```

### Perfil CI de Milena

```text
scripts/ci-milena-proot.sh
scripts/termux-native.sh
scripts/validate-proot.sh
scripts/validate-termux.sh
```

Este perfil solo ejecuta compilaciones y pruebas autorizadas. No modifica automáticamente el código de Milena.

## Seguridad

- solo se permite el repositorio configurado;
- solo se permite la rama `main`;
- no se ejecutan comandos recibidos desde internet;
- las tareas están en una allowlist;
- los runners no se exponen mediante puertos entrantes;
- se aplican timeouts y límites de recursos;
- no se guardan tokens en el repositorio;
- los workflows de runners no ejecutan pull requests externos.

## Workflows

```text
control-termux.yml       Estado del entorno Termux
milena-proot.yml         Perfil opcional Debian/proot
milena-termux.yml        Perfil opcional Termux nativo
milena-benchmarks.yml    Benchmarks manuales
validate.yml             Validación del repositorio
```
