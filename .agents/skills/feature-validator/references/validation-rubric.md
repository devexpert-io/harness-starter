# Feature Validation Rubric

Use this rubric after implementation and before final acceptance.

Status convention:

- `passing` in `feature_list.json` means the implementer self-verified the feature and recorded evidence.
- `passing` does not mean independent acceptance.
- `accept`, `revise`, and `block` are validator verdicts.
- Unless the project explicitly extends the feature state machine, record validator acceptance in `PROGRESS.md` or a validation artifact rather than adding a new feature status.

| Category | Question | Pass Signal | Fail Signal |
| --- | --- | --- | --- |
| Correctness | Does the implementation match the feature spec? | Acceptance scenarios pass or have strong evidence. | Behavior missing, fake, or materially different from the spec. |
| Verification | Did required checks actually run with evidence? | Exact commands/results are recorded and rerunnable where possible. | No evidence, failed checks hidden, or only verbal confidence. |
| E2E coverage | For observable user/API flows, did persistent E2E coverage exist and get updated when available? | `pnpm test:e2e` or repo-equivalent coverage exercises the changed flow, or the spec justifies why it is not needed. | Only manual smoke evidence remains after an E2E harness exists and the changed flow is E2E-testable. |
| Scope discipline | Did implementation stay inside the selected feature? | No unrelated feature work or broad refactors. | Adjacent features implemented opportunistically. |
| Architecture | Does code respect documented boundaries and patterns? | Dependencies and layers match `ARCHITECTURE.md`/repo patterns. | New ad hoc architecture, boundary violations, tangled coupling. |
| Security/access | Does the diff avoid obvious security/privacy regressions? | Auth, secrets, input, data exposure, and external calls are handled appropriately for this slice. | Secrets committed, unsafe auth bypass, unchecked input, private data exposure. |
| Maintainability | Can a fresh agent understand and extend this? | Clear structure, small files, tests/docs where useful. | Obscure logic, oversized files, duplicated rules, unclear ownership. |
| Durable docs | Did durable knowledge land in the right artifact? | `AGENTS.md`, `ARCHITECTURE.md`, `CONSTRAINTS.md`, specs, progress are updated only when warranted. | Important rules remain only in chat/code, or docs are stale/duplicative. |
| Handoff readiness | Can the next session continue safely? | `PROGRESS.md` and `feature_list.json` reflect actual state and next step. | State files lie, omit blockers, or require oral context. |

## `init.sh` Validation Rule

After the repo has a runnable baseline, `init.sh` is expected to execute the non-blocking standard gate. It should not merely print the commands.

Acceptable:

- runs lint/typecheck/tests/build or the repo-equivalent non-blocking checks,
- exits non-zero when those checks fail,
- prints manual commands such as `pnpm dev` only after checks pass.

Not acceptable after bootstrap:

- only echoes "run pnpm lint && pnpm test",
- starts a long-running dev server by default,
- reports success without executing any check.

If this rule is violated, use verdict `revise` unless the repository is still explicitly pre-bootstrap.

## Severity Guidance

- Critical: unsafe, data-loss, security, build cannot run, or feature is fundamentally wrong.
- High: acceptance scenario fails, required verification missing, or major architecture violation.
- Medium: maintainability/doc gap likely to hurt future sessions.
- Low: polish, naming, small clarity issue.

## Verdict Guidance

- `accept`: no critical/high findings; evidence is adequate.
- `revise`: fixable critical/high/medium findings with clear next actions.
- `block`: cannot validate, wrong feature, missing spec, unsafe state, or implementation must be rethought.

## Required Finding Format

Every finding that prevents acceptance must be actionable enough for an implementer to execute.

```md
### Finding: <short title>

- Severity: Critical/High/Medium/Low
- Evidence: <file path, command output, diff detail, or spec section>
- Why it matters: <impact on correctness, harness reliability, security, architecture, or handoff>
- Required change: <concrete outcome required>
- Suggested implementation:
  1. <specific step>
  2. <specific step>
  3. <specific step>
- Verification after fix:
  - <command or scenario>
  - <expected result>
```

## Implementation Repair Brief

When the verdict is `revise`, include a compact section that can be pasted into the implementer's next session:

```md
## Implementation Repair Brief

Goal: <what must be corrected>

Do:
1. <ordered implementation step>
2. <ordered implementation step>
3. <ordered implementation step>

Do not:
- <scope boundary>
- <scope boundary>

Run:
- <verification command>
- <verification command>

Update:
- <state/doc artifact>
- <state/doc artifact>
```

The repair brief should not be vague. Prefer "change `init.sh` so it executes `pnpm lint`, `pnpm typecheck`, `pnpm test`, and `pnpm build`, but does not start `pnpm dev`" over "improve init.sh".
