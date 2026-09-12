# Control67Tmux

Puente seguro para coordinar pruebas CI/CD de Milena desde Debian ejecutado dentro de Termux.

## Objetivo

Control67Tmux no expone una terminal pública ni acepta comandos arbitrarios. Su propósito es ejecutar un conjunto limitado de tareas verificables:

- actualizar únicamente `main`;
- compilar Milena con GCC y Clang;
- ejecutar la suite de pruebas;
- ejecutar sanitizadores;
- ejecutar análisis estático;
- guardar logs y códigos de salida.

## Diseño

```text
GitHub Actions / coordinador
          |
          v
Runner autenticado en Debian/proot-distro
          |
          v
scripts/ci-milena-proot.sh
          |
          v
Milena: compilación, pruebas y sanitizadores
```

Termux inicia Debian y mantiene el proceso; las pruebas se ejecutan dentro de Debian, no en el entorno nativo de Android.

## Estado

Proyecto inicial de arquitectura. No contiene tokens, credenciales ni endpoints privados.

## Seguridad

- permitir solo el repositorio configurado;
- permitir solo la rama `main`;
- no ejecutar comandos recibidos desde internet;
- usar una allowlist de tareas;
- aplicar timeout y límites de recursos;
- no guardar secretos en el repositorio;
- conservar logs sin credenciales.
