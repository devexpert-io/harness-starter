# Instrucciones para agentes

Este repositorio contiene una web responsive de reservas de pistas de pádel para un club: los socios reservan y cancelan franjas de 90 minutos, y el gestor administra socios, pistas, horario y bloqueos.

## Leer primero

- `CONTEXT.md` — glosario del dominio (usar `Franja`, nunca "turno").
- `docs/build-brief.md` — problema, objetivos y MVP.
- `docs/domain-model.md` — entidades, reglas de reserva y ciclo de vida.
- `docs/risks-and-open-questions.md` — riesgos y preguntas abiertas.

Si se añaden más adelante, leer solo cuando aplique:

- `docs/adr/` — cuando una decisión pueda contradecir otra ya aceptada.

## Flujo de arranque

Antes de escribir código:

1. Confirmar el directorio con `pwd`.
2. Leer `PROGRESS.md` (estado verificado actual y siguiente paso).
3. Leer `feature_list.json` y elegir la primera feature no terminada, en orden de la lista, cuyas dependencias estén todas en `accepted`.
4. Ejecutar `./init.sh`.
5. Si la verificación base falla, arreglar la base antes de añadir trabajo nuevo.

## Reglas de trabajo

- Una feature cada vez.
- No marcar una feature como terminada solo porque haya código.
- Mantener los cambios dentro del alcance de la feature salvo un arreglo mínimo imprescindible.
- No cambiar en silencio las reglas de verificación durante la implementación.
- Las reglas de negocio de `docs/domain-model.md` (una reserva confirmada por franja, cuota activa, máximo 2 reservas futuras, cancelación ≥24 h) se hacen cumplir en servidor/base de datos, no solo en la interfaz.
- Actualizar los artefactos del repo en lugar de depender de resúmenes del chat.

## Calidad de código

Toda feature debe pasar estas comprobaciones, que ejecuta `./init.sh`. Hasta que se complete `bootstrap-nextjs-app` son comandos previstos, no instalados.

- Lint: previsto `pnpm lint`
- Formato: previsto `pnpm format:check`
- Tipado: previsto `pnpm typecheck`
- Tests: previsto `pnpm test`

## Artefactos obligatorios

- `feature_list.json`: fuente de verdad del estado de las features.
- `PROGRESS.md`: estado verificado actual y registro ligero de sesiones.
- `init.sh`: ruta estándar de arranque y verificación.

## Definición de terminado

Una feature está terminada solo si:

- el comportamiento objetivo está implementado,
- la verificación requerida se ha ejecutado de verdad,
- la evidencia está registrada en `feature_list.json` o `PROGRESS.md`,
- el repo sigue arrancando con la ruta estándar (`./init.sh`),
- la documentación relevante está actualizada si cambian comportamiento, reglas de dominio, API o verificación.

## Fin de sesión

1. Actualizar `PROGRESS.md`.
2. Actualizar `feature_list.json`.
3. Anotar riesgos o bloqueos pendientes.
4. Dejar el repo listo para que la siguiente sesión ejecute `./init.sh` directamente.
