# Harness Starter

De una idea difusa a tu primera feature verificada con un agente de IA. Funciona con **Claude Code, Codex y OpenCode**.

[English version](README.en.md)

Los modelos cambian cada pocas semanas. Lo que hace fiable el trabajo con agentes es todo lo que los rodea: el contexto que reciben, cómo se corta el trabajo y cómo se comprueba. A eso lo llamamos harness.

Este repo es la parte de arranque del harness que uso a diario y que enseño en AI Expert: cuatro skills que llevan a tu agente de "¿qué quieres construir?" a "feature validada con evidencias", sin prompts larguísimos.

## El flujo

```
Idea ─▶ build-brief ─▶ harness-starter ─▶ feature-spec ─▶ implementación ─▶ feature-validator
        qué construir   repo listo          contrato de       con tu agente     en una sesión
                        para agentes        una feature                         nueva
```

| Skill | Qué hace | Qué deja en tu repo |
|---|---|---|
| `build-brief` | Te entrevista pregunta a pregunta hasta que el proyecto está claro. No escribe código. | `CONTEXT.md`, `docs/build-brief.md`, `docs/domain-model.md`, `docs/risks-and-open-questions.md` y opcionales si hacen falta |
| `harness-starter` | Convierte el brief en un repo preparado para agentes. | `AGENTS.md`, `init.sh`, `PROGRESS.md`, `feature_list.json` |
| `feature-spec` | Escribe el contrato de una sola feature antes de tocar código. | `docs/specs/<feature-id>.md` |
| `feature-validator` | Revisa la implementación contra la spec sin fiarse de lo que dice quien la hizo. | Veredicto `accept`, `revise` o `block`, con instrucciones concretas de arreglo |

En [`examples/reservas-padel`](examples/reservas-padel) tienes lo que generan las skills para una web de reservas de un club de pádel, por si quieres verlo antes de instalar nada.

## Instalación

Necesitas macOS o Linux y al menos uno de estos agentes: Claude Code, Codex u OpenCode.

```bash
git clone https://github.com/devexpert-io/harness-starter.git
cd harness-starter
./install.sh ../mi-proyecto   # solo en ese proyecto
./install.sh --global         # en todos tus proyectos
```

El instalador copia las skills en `.agents/skills/` (lo leen Codex y OpenCode) y crea enlaces en `.claude/skills/` (lo lee Claude Code). No sobrescribe nada que ya exista salvo que añadas `--force`.

**Instalación manual (o en Windows):** copia las carpetas de `.agents/skills/` a `.agents/skills/` de tu proyecto, y también a `.claude/skills/` si usas Claude Code.

## Cómo se usa

Cada skill se invoca así:

| Agente | Cómo |
|---|---|
| Claude Code | `/build-brief` |
| Codex | `$build-brief` |
| OpenCode | "Usa la skill build-brief" |

### 1. Aclara qué vas a construir

Lanza `build-brief` con tu idea, aunque sea vaga. Te hará una pregunta cada vez, con una respuesta recomendada cuando tenga sentido. Contesta con ejemplos concretos y no le pidas código todavía: el objetivo es que tu agente no tenga que inventarse decisiones de producto.

### 2. Prepara el repo para agentes

Lanza `harness-starter`. Revisa sobre todo `feature_list.json`: cada feature tiene que poder terminarse y verificarse en una sesión. Si ves épicas como "auth y pagos", pídele que las parta.

### 3. Especifica la siguiente feature

Lanza `feature-spec`. Sin indicar nada, elige la primera feature lista según sus dependencias. El resultado es un contrato: objetivo, fuera de alcance, escenarios de aceptación, archivos afectados, tareas y cómo se verifica.

### 4. Implementa

Pídeselo a tu agente con un prompt corto, porque el contexto ya está en el repo:

```
Implementa la feature <id> siguiendo docs/specs/<id>.md. No salgas de su alcance.
Al terminar, ejecuta ./init.sh y las verificaciones de la spec, registra la evidencia
en feature_list.json, marca la feature como passing y actualiza PROGRESS.md.
```

### 5. Valida en una sesión nueva

Abre una sesión limpia y lanza `feature-validator`. Quien valida no debe haber escrito el código.

- `accept`: confírmalo y la feature pasa a `accepted`.
- `revise`: pásale al implementador el "Implementation Repair Brief" tal cual.
- `block`: algo impide seguir; el validador te dice qué resolver antes.

Después, vuelve al paso 3 con la siguiente feature.

## Por qué funciona

- **Contexto antes que código.** `build-brief` deja por escrito las decisiones de producto para que el agente no tenga que suponerlas.
- **El contexto vive en el repo.** `AGENTS.md` y `PROGRESS.md` hacen que cada sesión sepa dónde está sin que se lo repitas.
- **Features del tamaño de una sesión.** Si una feature no se puede verificar con un escenario, está mal cortada.
- **Validación independiente.** `feature-validator` se ejecuta en una sesión que no escribió el código.
- **Evidencias antes de dar algo por hecho.** Una feature solo pasa a `accepted` con verificaciones ejecutadas y registradas.

## Qué no incluye

Este repo cubre el principio del harness: discovery, contexto y verificación. Deja fuera los hooks y subagentes con roles, los agentes en paralelo con worktrees, los evals, la IA dentro del producto y la orquestación de todo el flujo.

Eso lo montamos en directo, sobre tu propio proyecto, en [AI Expert](https://devexpert.io/cursos/expert/ai?utm_source=github&utm_medium=referral&utm_campaign=harness-starter&utm_content=readme).

## Guía paso a paso

Si quieres el recorrido comentado del ejemplo, paso a paso, y los errores más habituales, [te mando la guía en PDF por email](https://devexpert.io/harness-starter?utm_source=github&utm_medium=referral&utm_campaign=harness-starter&utm_content=readme).

## Créditos

- La regla para cortar features viene de [Learn Harness Engineering](https://github.com/walkinglabs/learn-harness-engineering).
- Las skills siguen el formato [Agent Skills](https://agentskills.io) (`SKILL.md`).

Hecho por [Antonio Leiva](https://x.com/antonioleivag) en [DevExpert](https://devexpert.io).

## Licencia

[MIT](LICENSE)
