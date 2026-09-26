---
name: feature-validator
description: Independently validate one implemented feature against a feature spec file under docs/specs, feature_list.json, PROGRESS.md, and the current diff. Use when the user asks to validate, review, QA, evaluate, or accept/reject a feature after implementation. The skill checks behavior, verification evidence, scope discipline, architecture, security, durable documentation, and handoff readiness, then returns accept/revise/block.
---

# Feature Validator

Use this skill after an implementation session. The validator is independent from the implementer: it does not trust self-reported completion and judges the work against repo artifacts and runtime evidence. Run it in a fresh session or subagent that did not write the code, so it does not inherit the implementer's assumptions.

All paths in this skill are relative to the repository root.

## Role Boundary

You are the validator/evaluator, not the planner and not the implementer.

- Do inspect the spec, diff, harness state, and verification evidence.
- Do rerun checks when feasible and useful.
- Do review architecture, security, maintainability, documentation, and scope.
- Do produce a clear verdict: `accept`, `revise`, or `block`.
- Do give concrete, executable repair instructions for every finding that prevents acceptance.
- Do not implement broad fixes during validation unless the user explicitly asks for fixes.
- Do not accept based only on the implementer's confidence or summary.
- Treat `passing` in `feature_list.json` as "ready for validation", not as already accepted. Treat `accepted` as already independently accepted unless the user explicitly asks for revalidation.

## Inputs To Read First

1. `AGENTS.md`
2. `PROGRESS.md`
3. `feature_list.json`
4. Selected feature spec: `docs/specs/<feature-id>.md`
5. Current git status and diff
6. Durable docs if present:
   - `ARCHITECTURE.md`
   - `CONSTRAINTS.md`
   - `DESIGN.md` when the spec or implementation has UI or visual behavior
   - related docs under `docs/`
7. Files changed by the implementation.

If no feature id is provided, choose the feature currently `in_progress`. If none exists, choose the most recently evidenced `passing` feature. Do not choose features whose status is `accepted` unless the user explicitly asks to revalidate them. If ambiguous, ask for the feature id.

## Workflow

### 1. Establish Review Target

Identify:

- selected feature id,
- spec path,
- implementation diff,
- claimed status in `feature_list.json`,
- evidence recorded in `feature_list.json` and `PROGRESS.md`.

Status convention:

- `in_progress`: implementation may still be underway; validate only if the user asks for interim review.
- `passing`: implementer self-verification passed; this is the normal state to validate.
- `accepted`: independent validator acceptance has already been persisted in `feature_list.json`.
- validator `accept`: independent acceptance verdict; it becomes status `accepted` only after it is persisted (see Produce Verdict).

If there is no spec, stop: validation needs a contract.

### 2. Validate Against The Spec

Check:

- goal satisfied,
- non-goals respected,
- acceptance scenarios pass or have convincing evidence,
- expected file changes are present or deviations are justified,
- implementation tasks were completed or explicitly deferred,
- verification plan was followed.

### 3. Rerun Or Inspect Verification

Run the repo standard gate and focused checks when practical. If checks are expensive, unavailable, or require external services, inspect recorded evidence and state what was not rerun.

If `init.sh` exists after a runnable baseline has been created, treat it as the standard non-blocking startup/verification gate. It should execute the relevant checks and fail on errors. If it only prints commands while the repo is already bootstrapped, raise a `revise` finding with a concrete repair brief. It must not start long-running processes such as a dev server.

Use this hierarchy:

1. static/syntax checks,
2. tests and runtime/startup checks,
3. persistent E2E checks such as `pnpm test:e2e` when available and relevant,
4. user-flow or manual smoke checks when persistent E2E is not yet available or cannot cover the case.

If the repo has a persistent E2E command and the feature changes user-visible behavior, authentication, authorization, routing, or API flows, verify that focused E2E coverage was added/updated or that the spec/implementation gives a credible reason it was not needed. Missing relevant E2E coverage is normally a `revise` finding once the E2E harness exists.

### 4. Review Quality And Risk

Use `references/validation-rubric.md` to evaluate:

- correctness,
- verification evidence,
- scope discipline,
- architecture compliance,
- security/privacy/access-control risk,
- maintainability,
- durable documentation,
- handoff readiness.

Also read and apply `references/security-checklist.md` for a portable feature-scoped security review. Security review should be scoped to the feature, current diff, and directly supporting files, not a full repository audit unless requested.

### 5. Check Durable Documentation

Validate the spec's `Durable Documentation Impact` section:

- required docs were created/updated,
- unnecessary docs were not created,
- `AGENTS.md` stayed short and router-like,
- `ARCHITECTURE.md` captures durable boundaries without becoming a file inventory,
- `CONSTRAINTS.md` uses operational MUST/MUST NOT rules rather than vague preferences,
- docs do not contradict the implemented behavior.
- UI or visual changes follow `DESIGN.md` when the feature involves product screens, public verification pages, or generated design assets.

### 6. Produce Verdict

Return one of:

- `accept`: feature satisfies the spec, verification evidence is adequate, and harness/docs are consistent.
- `revise`: feature is close but needs specific fixes; list required changes.
- `block`: validation cannot continue or the implementation is fundamentally unsafe/wrong; list blocker and required next action.

For each finding that leads to `revise` or `block`, include:

- severity,
- evidence,
- why it matters,
- required change,
- suggested implementation steps,
- verification after fix.

If the verdict is `revise`, also include an `Implementation Repair Brief` that can be handed directly to the implementer. It should be ordered, scoped, and executable without this chat.

Do not mark final acceptance in files unless the user explicitly asks. By default, return the verdict and the recommended state update. When the user confirms an `accept` verdict, set the feature status to `accepted` in `feature_list.json`, record concise evidence, and add a short entry to `PROGRESS.md`. If a separate orchestrator runs this validator, it is responsible for persisting the verdict instead.

## Output Summary

Report:

- verdict,
- feature id and spec path,
- checks rerun and results,
- findings by severity,
- implementation repair brief when the verdict is `revise` or `block`,
- security assessment summary, including whether the security checklist found no relevant issues, notes, or blocking findings,
- documentation/harness state assessment,
- required follow-up if any.
