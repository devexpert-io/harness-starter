# Minimal Harness Artifact Templates

Use these templates as starting points. Adapt content to the repository's discovery docs. Keep the generated files concise.

## `AGENTS.md`

Purpose: short landing page for agents.

```md
# Project Agent Instructions

This repository contains [one-sentence project summary].

## Read First

- `CONTEXT.md` — domain language.
- `docs/build-brief.md` — product goals and MVP.
- `docs/domain-model.md` — core entities, relationships, and states.
- `docs/risks-and-open-questions.md` — current risks and unresolved questions.

Read optional docs only when relevant:

- `docs/user-and-access-model.md` — when touching users, roles, permissions, ownership, access, or revocation.
- `docs/technical-discovery.md` — when touching stack, integrations, deployment, auth, data, or operations.
- `docs/mvp-scope.md` — when selecting or slicing MVP work.
- `docs/adr/` — when a decision might contradict existing accepted decisions.

## Startup Workflow

Before writing code:

1. Confirm the working directory with `pwd`.
2. Read `PROGRESS.md` for current verified state and next step.
3. Read `feature_list.json` and pick the first unfinished feature in list order whose `depends_on` features are all `accepted`.
4. Run `./init.sh`.
5. If baseline verification fails, fix the baseline before adding new feature work.

## Working Rules

- Work on one feature at a time.
- Do not mark a feature complete just because code was added.
- Keep changes inside the selected feature scope unless a blocker requires a narrow supporting fix.
- Do not silently change verification rules during implementation.
- Update durable repo artifacts instead of relying on chat summaries.

## Required Artifacts

- `feature_list.json`: source of truth for feature state.
- `PROGRESS.md`: current verified state and lightweight session log.
- `init.sh`: standard startup and verification path.

## Definition Of Done

A feature is done only when all are true:

- target behavior is implemented,
- required verification actually ran,
- evidence is recorded in `feature_list.json` or `PROGRESS.md`,
- repository remains restartable from the standard startup path,
- relevant docs are updated if product behavior, domain rules, API, or verification changed.

## End Of Session

Before ending a session:

1. Update `PROGRESS.md`.
2. Update `feature_list.json`.
3. Record unresolved risks or blockers.
4. Leave the repo clean enough for the next session to run `./init.sh` immediately.
```

## `init.sh`

Purpose: canonical start/verification path. Use a real script once the stack exists; use the pre-bootstrap version if it does not.

### Pre-bootstrap variant

```bash
#!/usr/bin/env bash
set -euo pipefail

echo "Repository: $(pwd)"
echo "Harness status: pre-bootstrap"
echo "Application stack is not initialized yet."
echo "Next step: choose the first feature from feature_list.json and perform technical bootstrap."
echo "Expected future commands should be recorded here after bootstrap."
```

### Bootstrapped variant

```bash
#!/usr/bin/env bash
set -euo pipefail

INSTALL_CMD="[replace]"
VERIFY_CMD="[replace]"
START_CMD="[replace]"

echo "Repository: $(pwd)"
echo "Installing dependencies..."
$INSTALL_CMD

echo "Running baseline verification..."
$VERIFY_CMD

echo "Startup command: $START_CMD"
if [ "${RUN_START_COMMAND:-0}" = "1" ]; then
  exec $START_CMD
fi
```

## `PROGRESS.md`

Purpose: current verified state first, lightweight history second.

```md
# Progress Log

## Current Verified State

- Repository root: `[absolute or relative path]`
- Standard startup path: `./init.sh`
- Standard verification path: `[command or provisional: not bootstrapped yet]`
- Current next ready feature: `[feature id]`
- Current blocker: `[none / blocker]`
- Last verified at: `[date or not yet verified]`

## Session Log

### Session 001

- Date: `[date]`
- Goal: Create the minimal startup harness.
- Completed: `AGENTS.md`, `init.sh`, `PROGRESS.md`, and `feature_list.json` created or updated.
- Verification run: `[json validation / chmod / none]`
- Evidence captured: `[what was checked]`
- Files or artifacts updated: `[list]`
- Known risk or unresolved issue: `[risk]`
- Next best step: `[next action]`
```

## `feature_list.json`

Purpose: machine-readable feature state. Generate valid JSON only.

Schema:

```json
[
  {
    "id": "short-kebab-case-id",
    "area": "product-area",
    "title": "Short feature title",
    "user_visible_behavior": "What the user or system can observe when this works.",
    "depends_on": [],
    "status": "not_started",
    "verification": [
      "Concrete verification step or command. Use provisional wording only if no app exists yet."
    ],
    "evidence": [],
    "notes": "Relevant constraints, source docs, dependencies, or known risks."
  }
]
```

Status values:

- `not_started`
- `in_progress`
- `blocked`
- `passing` — the implementer verified it and recorded evidence; ready for independent validation.
- `accepted` — an independent validator accepted it.

Rules:

- Only one feature may be `in_progress`.
- `passing` requires verification evidence.
- A feature is ready to work on when every `depends_on` feature is `accepted`, not just `passing`.
- `depends_on` is required for every feature. Use an empty array for features with no prerequisites.
- `depends_on` values must be stable feature `id` strings from the same file. Do not reference numeric positions.
- The order of the JSON array is the preferred plan order when more than one feature is ready; it is not a dependency system.
- Do not add numeric `priority` fields. Dependencies determine execution readiness, and list order breaks ties.
- Features should be vertical slices where possible, not isolated chores.
- Each feature should be plausible to complete and verify in one focused agent session.
- Split broad epics into smaller behavior slices before writing the feature list.
- Bootstrap can be a feature only when the repo has no runnable app yet; if it is broad, split it into session-sized bootstrap slices.
- A non-trivial MVP with auth, roles, data/content, workflows, and integrations should usually produce roughly 12-30 session-sized features. Fewer than 10 items is a warning sign, not a success metric.
- Split feature titles containing "and", "/", commas, or multiple domains unless the combined behavior is truly verified by one small scenario.
- Do not write milestone-style features such as "adaptive dashboard", "review flow", "content import", "auth and enrollment API", or "certificate PDF and public verification"; decompose them into concrete behaviors first.
