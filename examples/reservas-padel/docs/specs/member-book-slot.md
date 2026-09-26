# Feature Implementation Spec: El socio reserva una franja libre

## Source Feature

- `id`: member-book-slot
- `area`: reservas
- `depends_on`: `member-week-availability` (y, transitivamente, `auth-consume-magic-link`, `manager-configure-schedule`, `manager-create-court`, `manager-create-member`, `bootstrap-postgres-migrations`, `bootstrap-nextjs-app`)
- `status`: `not_started` en el momento de planificar
- `source`: `feature_list.json`
- **Estado de dependencias**: BLOQUEADA. Ninguna dependencia está `accepted`; el repo está en pre-bootstrap. Esta spec se ha escrito por petición explícita y debe revisarse cuando `member-week-availability` esté aceptada (ver "Current Gaps").

## Goal

Un socio con sesión iniciada pulsa una franja libre en la vista semanal, confirma y obtiene una Reserva en estado `confirmada`. A partir de ese momento cualquier consulta de disponibilidad (de cualquier socio) muestra esa franja como ocupada.

El servidor es la autoridad: valida que la franja existe según el horario, que es futura y que no tiene ya una reserva confirmada. La base de datos garantiza con una restricción que una franja nunca tenga dos reservas confirmadas.

## Non-Goals

- Regla de cuota activa → `booking-requires-active-fee`.
- Límite de 2 reservas futuras → `booking-max-two-future`.
- Rechazo de franjas bloqueadas o de pistas cerradas → `booking-rejects-unavailable-slot`.
- Test de N intentos concurrentes → `booking-concurrency-guard` (aquí sí se crea el índice único; ver Technical Approach).
- Listado "mis reservas" y cancelación → `member-my-bookings`, `member-cancel-booking`.
- Actualización en tiempo real (websockets/polling) de otras pantallas abiertas: "ocupada para todos" significa en la siguiente carga/consulta.
- Límite de antelación máxima (p. ej. solo los próximos 7 días): no es regla del dominio; queda como pregunta abierta.
- Reservas hechas por el gestor en nombre de un socio.
- Notificaciones o emails de confirmación.

## Job Story

Cuando veo en el móvil una franja libre en la semana,
quiero reservarla con un toque y una confirmación,
para asegurarme la pista sin pasar por WhatsApp y en menos de 1 minuto.

## Users And Permissions

- Socio con sesión: puede reservar franjas libres a su nombre. El socio se toma **siempre de la sesión**, nunca del cuerpo de la petición.
- Visitante sin sesión: la acción de reservar se rechaza (`NO_AUTENTICADO`) y la UI redirige al acceso.
- Gestor: fuera de alcance; no se añade ningún flujo para él.

## Acceptance Scenarios

### Scenario 1: reserva de una franja libre

Given un socio con sesión, la Pista 1 operativa y un horario que genera la franja de mañana a las 10:30 sin reservas
When el socio pulsa esa franja, ve el resumen (Pista 1, fecha, 10:30–12:00) y confirma
Then se persiste una Reserva `confirmada` con ese socio, pista y hora de inicio, y la UI muestra la franja como reservada por él

### Scenario 2: la franja pasa a ocupada para otros socios

Given la Reserva del escenario 1
When otro socio carga la disponibilidad de la semana
Then la franja de la Pista 1 mañana a las 10:30 aparece como ocupada y no se puede pulsar para reservar

### Scenario 3: franja ya ocupada

Given una franja con una Reserva `confirmada` de otro socio
When un socio invoca la acción de reservar esa franja (p. ej. con la vista desactualizada)
Then la acción devuelve el error `FRANJA_OCUPADA`, no se crea ninguna reserva y la UI muestra "Esta franja ya no está disponible" y refresca la disponibilidad

### Scenario 4: franja inexistente o pasada

Given el horario del club
When se invoca la acción con una hora que no coincide con el inicio de una franja, con una pista inexistente o con una franja que ya ha empezado
Then la acción devuelve `FRANJA_INVALIDA` y no se crea ninguna reserva

### Scenario 5: sin sesión

Given un visitante sin sesión
When invoca la acción de reservar directamente
Then la acción devuelve `NO_AUTENTICADO` y no se crea ninguna reserva

### Scenario 6: franja con reserva cancelada

Given una franja cuya única reserva está `cancelada`
When un socio la reserva
Then se crea una nueva Reserva `confirmada` (la cancelada no bloquea la franja)

## Repository Research

### Files Inspected

- `AGENTS.md` — reglas de trabajo; reglas de negocio en servidor/BD.
- `PROGRESS.md` — estado pre-bootstrap; siguiente feature `bootstrap-nextjs-app`.
- `feature_list.json` — feature, dependencias y features adyacentes de reservas.
- `CONTEXT.md` — glosario (Franja, Reserva; nunca "turno").
- `docs/build-brief.md` — objetivos (< 1 min, cero dobles reservas), stack Next.js + PostgreSQL, uso mayoritario en móvil.
- `docs/domain-model.md` — entidad Reserva y reglas.
- `docs/risks-and-open-questions.md` — concurrencia a resolver en BD.
- `init.sh` — solo valida `feature_list.json`.

No existen: código de aplicación, `package.json`, migraciones, tests, `DESIGN.md`, `ARCHITECTURE.md`, `CONSTRAINTS.md`, `docs/user-and-access-model.md`, `docs/technical-discovery.md`, `docs/mvp-scope.md`, `docs/adr/`, ni specs previas en `docs/specs/`. El repo no tiene commits.

### Existing Patterns To Follow

- Ninguno en código todavía. Al implementar, seguir los patrones que establezcan `bootstrap-*`, `auth-consume-magic-link` (lectura de sesión), `manager-configure-schedule` (generación de franjas y zona horaria) y `member-week-availability` (consulta y vista semanal).
- Vocabulario de dominio en español en nombres de estado (`confirmada`, `cancelada`, `no_presentada`).

### Current Gaps

- Todo el stack está por construir; las rutas de archivo de esta spec son **provisionales**.
- La función de generación de franjas (de `manager-configure-schedule`) debe exponerse para validar en servidor que una hora de inicio es una franja real. Si no está expuesta así, hacerlo con un cambio mínimo.
- La consulta de disponibilidad (de `member-week-availability`) debe derivar "ocupada" de las reservas `confirmada`. Si esa feature se implementó antes de existir la tabla de reservas, habrá que conectar la consulta aquí (cambio mínimo imprescindible).
- Sin `DESIGN.md`: el estilo visual no está definido.
- Sin harness E2E conocido todavía.

## Technical Approach

1. **Modelo de datos** (migración nueva): tabla `reservas` con `id`, `socio_id` (FK socios), `pista_id` (FK pistas), `inicio` (`timestamptz`, inicio de la franja), `estado` (enum/check `confirmada | cancelada | no_presentada`, por defecto `confirmada`), `creada_en`. La Franja no se persiste: se identifica por `(pista_id, inicio)`; la duración de 90 min es constante del dominio.
2. **Garantía en BD**: índice único parcial `UNIQUE (pista_id, inicio) WHERE estado = 'confirmada'`. Se crea aquí porque es la forma correcta de cumplir "una franja tiene como máximo una reserva confirmada"; `booking-concurrency-guard` aporta el test concurrente y cualquier endurecimiento adicional.
3. **Servicio de dominio** `reservarFranja({ socioId, pistaId, inicio, ahora })`:
   - valida que la pista existe y que `inicio` coincide con una franja generada por el horario para ese día (zona `Europe/Madrid`), y que `inicio > ahora` → si no, `FRANJA_INVALIDA`;
   - inserta la reserva `confirmada`; si la inserción viola el índice único → `FRANJA_OCUPADA` (no hacer "SELECT y luego INSERT" como única protección);
   - devuelve un resultado tipado `{ ok: true, reserva } | { ok: false, error }`. El tipo de error debe poder ampliarse con las reglas de las features siguientes (`CUOTA_INACTIVA`, `LIMITE_RESERVAS`, `FRANJA_NO_DISPONIBLE`).
   - `ahora` inyectable para tests con reloj controlado.
4. **Frontera de servidor**: server action (o route handler, según el patrón que exista) `reservarFranjaAction({ pistaId, inicio })` que obtiene el socio de la sesión (`NO_AUTENTICADO` si no hay), llama al servicio y revalida la ruta de disponibilidad. Entrada validada con esquema (tipos y formato ISO de `inicio`).
5. **UI** en la vista semanal: al pulsar una franja libre se abre una confirmación (hoja inferior en móvil) con pista, fecha y rango horario, botones "Confirmar reserva" y "Cancelar". Estados: enviando (botón deshabilitado, evita doble envío), éxito (franja marcada como "Tu reserva"), error (mensaje según código y refresco de disponibilidad). Franjas ocupadas no son pulsables.

## Expected File Changes

Rutas provisionales (ajustar a la estructura real tras el bootstrap):

- `db/migrations/<timestamp>_crear_reservas.sql` (o equivalente de la herramienta elegida) — create; tabla `reservas` e índice único parcial.
- `src/server/reservas/reservar-franja.ts` — create; servicio de dominio.
- `src/server/reservas/reservar-franja.test.ts` — create; tests de integración contra PostgreSQL de test.
- `src/app/(socio)/disponibilidad/actions.ts` — create/modify; server action.
- `src/app/(socio)/disponibilidad/...` componente de vista semanal — modify; franja pulsable + confirmación.
- `src/components/reservas/ConfirmarReserva.tsx` — create; hoja de confirmación.
- `src/server/disponibilidad/...` — modify solo si la consulta aún no considera reservas `confirmada`.
- `e2e/reservar-franja.spec.ts` — create si existe harness E2E.
- `feature_list.json`, `PROGRESS.md` — modify; estado y evidencia.

## Visual Design Impact

- UI involved: sí.
- Design source: `DESIGN.md` no existe → **gap de planificación**. Reutilizar los estilos que haya fijado `member-week-availability`; no inventar un sistema visual nuevo.
- Screens or states affected: vista semanal (franja libre pulsable, ocupada, "Tu reserva"); hoja de confirmación (reposo, enviando, error).
- New design artifact required: no para esta feature; recomendable crear `DESIGN.md` antes o durante `member-week-availability`.
- Requisitos: ancho 375 px sin scroll horizontal; objetivos táctiles ≥ 44 px; el flujo completo cabe en 2 toques (franja → confirmar).

## Durable Documentation Impact

- `ARCHITECTURE.md`: update si existe (crear si no) — introduce el módulo `reservas` y el patrón servicio de dominio + resultado tipado + action.
- `CONSTRAINTS.md`: create/update — MUST: la unicidad de reserva confirmada por franja se garantiza con índice único parcial en BD; MUST: el socio de una reserva sale de la sesión, nunca de la entrada del cliente.
- `AGENTS.md`: not needed — no cambia el flujo de trabajo.
- `docs/domain-model.md`: not needed — salvo que se decida limitar la antelación máxima.
- `docs/risks-and-open-questions.md`: update — añadir la pregunta abierta sobre antelación máxima de reserva.

## Implementation Plan

1. Confirmar que `member-week-availability` está `accepted` y revisar sus rutas y patrones reales; ajustar las rutas provisionales.
2. Crear la migración de `reservas` con el índice único parcial; aplicarla desde cero con `./init.sh`.
3. Implementar `reservarFranja` con tests de integración primero (escenarios 1, 3, 4, 6).
4. Implementar la action con autenticación y validación de entrada (escenario 5).
5. Conectar la consulta de disponibilidad a reservas `confirmada` si hace falta (escenario 2).
6. Implementar la UI de confirmación y estados.
7. Verificar, actualizar documentación durable y registrar evidencia.

## Implementation Tasks

- [ ] Migración `reservas` + índice único parcial `(pista_id, inicio) WHERE estado='confirmada'`.
- [ ] Servicio `reservarFranja` con validación de franja (horario, pista, futura) y mapeo de violación única → `FRANJA_OCUPADA`.
- [ ] Tests de integración: libre → confirmada; ocupada → error sin duplicar; hora desalineada / pista inexistente / pasada → `FRANJA_INVALIDA`; cancelada no bloquea.
- [ ] Action con socio desde sesión, validación de esquema y revalidación de disponibilidad; test sin sesión.
- [ ] Disponibilidad muestra ocupada la franja reservada (test de consulta).
- [ ] UI: franja pulsable, hoja de confirmación, estados enviando/éxito/error, franjas ocupadas no pulsables.
- [ ] E2E del flujo feliz y de franja ocupada, si hay harness E2E.
- [ ] `CONSTRAINTS.md` / `ARCHITECTURE.md` / riesgos actualizados.
- [ ] `feature_list.json` y `PROGRESS.md` con evidencia.

## Verification Plan

- `./init.sh` termina con código 0 (instalación, migraciones desde cero, lint, typecheck, tests). No debe arrancar el servidor de desarrollo.
- Tests de integración del servicio contra PostgreSQL de test cubren los escenarios 1, 3, 4 y 6, incluidos los dos tests exigidos en `feature_list.json`.
- Test de la action: sin sesión → `NO_AUTENTICADO`; el `socioId` enviado por el cliente (si se intenta) se ignora.
- Test de la consulta de disponibilidad tras reservar → franja ocupada (escenario 2).
- Test directo de BD: insertar dos reservas `confirmada` para la misma `(pista_id, inicio)` falla por el índice.
- E2E: si el bootstrap añadió un comando persistente (p. ej. `pnpm test:e2e`), añadir un test a 375 px: iniciar sesión, reservar una franja libre, ver "Tu reserva"; segundo socio ve la franja ocupada. Si no existe harness E2E, justificarlo en `PROGRESS.md` y hacer comprobación manual con `RUN_START_COMMAND=1 ./init.sh` a 375 px.

## Evidence To Capture

- Salida resumida de `./init.sh` (código 0) y recuento de tests.
- Nombres de los tests que cubren cada escenario.
- Salida del E2E o nota de la comprobación manual a 375 px (con captura si es posible).
- Nombre de la migración y definición del índice único.

## Validator Checklist

- [ ] Implementación dentro del alcance: sin reglas de cuota, límite de 2, bloqueos/pistas cerradas ni cancelación.
- [ ] Escenarios 1–6 pasan.
- [ ] La unicidad se garantiza con índice único parcial en BD y la violación se traduce a `FRANJA_OCUPADA`.
- [ ] El socio sale de la sesión; la action rechaza peticiones sin sesión.
- [ ] El servidor valida que la franja existe en el horario y es futura, usando `Europe/Madrid` de forma consistente.
- [ ] La UI evita doble envío y funciona a 375 px sin scroll horizontal.
- [ ] Se usa "Franja", nunca "turno", en código, UI y docs.
- [ ] E2E añadido si existe harness, o justificación registrada.
- [ ] Evidencia en `feature_list.json` / `PROGRESS.md`; `./init.sh` sigue pasando.
- [ ] `CONSTRAINTS.md` / `ARCHITECTURE.md` / riesgos actualizados según lo indicado.
