# Ejemplo: reservas de pistas de pádel

Resultado real de aplicar el Harness Starter a una idea sencilla: una web para que los socios de un club reserven pistas de pádel sin WhatsApp ni hojas de cálculo.

| Archivo | De dónde sale |
|---|---|
| `CONTEXT.md`, `docs/build-brief.md`, `docs/domain-model.md`, `docs/risks-and-open-questions.md` | Documentos de discovery escritos a mano para el ejemplo. En un proyecto real los genera `build-brief` al entrevistarte. |
| `AGENTS.md`, `init.sh`, `PROGRESS.md`, `feature_list.json` | Generados por `harness-starter` con Claude Code, a partir de esos documentos. |
| `docs/specs/member-book-slot.md` | Generado por `feature-spec` para la feature "El socio reserva una franja libre". |

Fíjate en tres cosas:

- **`feature_list.json` tiene 25 features del tamaño de una sesión**, no cinco épicas. Que dos socios reserven la misma franja a la vez es una feature propia (`booking-concurrency-guard`), no un detalle que se pierda.
- **`harness-starter` señaló cuatro supuestos** que el brief no resolvía: cómo inicia sesión el gestor, qué pasa con las reservas de una pista que se bloquea, si el horario es igual todos los días y qué proveedor de email usar. Mejor verlos ahora que descubrirlos en el código.
- **La spec no se implementa todavía**: `feature-spec` avisa de que sus dependencias aún no están aceptadas. El orden importa.

No hay código de la aplicación: el ejemplo termina donde empieza la implementación.
