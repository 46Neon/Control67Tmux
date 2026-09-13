# Instalación de runners

Control67Tmux usa dos runners separados:

| Runner | Entorno | Etiquetas |
|---|---|---|
| proot | Debian dentro de `proot-distro` | `self-hosted`, `linux`, `ARM64`, `milena-proot` |
| termux | Termux nativo | `self-hosted`, `linux`, `ARM64`, `milena-termux` |

Termux es el anfitrión. Las pruebas Linux compatibles deben ejecutarse en Debian/proot; el runner nativo solo valida el entorno Termux.

## Requisitos

- dispositivo ARM64;
- Termux actualizado;
- Debian instalado con `proot-distro`;
- `git`, `curl`, `tar` y herramientas de compilación;
- permisos de administrador del repositorio;
- una versión concreta de `actions/runner` compatible con ARM64.

## Obtener el token

El token de registro de GitHub es temporal. Debe obtenerse desde la configuración del repositorio y pasarse únicamente mediante una variable de entorno. Nunca debe escribirse en un archivo, commit, log o mensaje.

## Runner Debian/proot

Dentro de Debian:

```bash
export RUNNER_TOKEN='TOKEN_TEMPORAL'
export RUNNER_VERSION='VERSION_PUBLICADA'
bash /ruta/a/Control67Tmux/scripts/install-runner.sh proot
unset RUNNER_TOKEN
```

Después, iniciar el runner según el mecanismo local elegido. No exponer su puerto ni crear un webhook que ejecute comandos.

## Runner Termux nativo

Dentro de Termux, fuera de Debian:

```bash
export RUNNER_TOKEN='TOKEN_TEMPORAL'
export RUNNER_VERSION='VERSION_PUBLICADA'
bash /ruta/a/Control67Tmux/scripts/install-runner.sh termux
unset RUNNER_TOKEN
```

## Política de seguridad

- no habilitar workflows de `pull_request` sobre estos runners;
- aceptar únicamente trabajos definidos en `main` o disparados manualmente;
- usar runners separados para `proot` y Termux;
- no almacenar secretos del proyecto en el runner;
- aplicar bloqueo de pantalla y almacenamiento cifrado en el dispositivo;
- detener el runner si el dispositivo se pierde;
- revisar periódicamente los logs y la versión del runner.
