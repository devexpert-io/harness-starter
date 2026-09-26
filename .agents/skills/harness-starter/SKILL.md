---
name: harness-starter
description: Create or update the minimal startup harness for a software repository after product discovery and before implementation. Use when the user says to use harness-starter, prepare the initial repo harness, create AGENTS/init/progress/feature list, or move from discovery docs to a coding-agent-ready repository. The skill reads existing discovery docs, derives only AGENTS.md, init.sh, PROGRESS.md, and feature_list.json, and must not reopen discovery, implement product code, initialize frameworks, install dependencies, or create extra harness documents.
---

# Harness Starter

Use this skill to create the smallest useful repo harness after discovery is complete. The output should let an agent answer: what is this project, how do I start it, what is the next feature, and how do I verify work.

All paths in this skill are relative to the repository root.

## Hard Rules

- Do not implement product code.
- Do not initialize frameworks, install dependencies, or modify application source.
- Do not reopen product discovery unless the discovery docs are missing or contradictory enough to block the harness.
- Create or update only the minimal startup harness:
  - `AGENTS.md`
  - `init.sh`
  - `PROGRESS.md`
  - `feature_list.json`
- Do not create `ARCHITECTURE.md`, clean-state checklists, evaluator rubrics, quality documents, implementation plans, issue backlogs, or extra docs unless the user explicitly asks after this skill finishes.
- Keep `AGENTS.md` short and routing-oriented. It is a landing page, not an encyclopedia.
- Preserve the repository's document language and style. If unclear, infer from existing discovery docs; ask only if there is no evidence.
- If any target file already exists, read it first and update conservatively. Do not overwrite useful human-authored content.

## Inputs To Read First

Read available discovery docs before generating artifacts:

1. `CONTEXT.md`
2. `docs/build-brief.md` or `docs/product-brief.md`
3. `docs/domain-model.md`
4. `docs/risks-and-open-questions.md`
5. Optional if present:
   - `docs/user-and-access-model.md`
   - `docs/technical-discovery.md`
   - `docs/mvp-scope.md`
   - `docs/adr/*.md`

If none of these exist, stop and tell the user to run the `build-brief` skill first.

## Workflow

### 1. Inspect Current State

Check whether each target file already exists. For existing files, preserve intent and only fix gaps needed for this minimal harness.

### 2. Derive The Minimal Harness

Create/update the four target files using `references/artifact-templates.md`:

- `AGENTS.md`: project landing page and operating rules.
- `init.sh`: standard startup/verification path, even if initially provisional.
- `PROGRESS.md`: current verified state and lightweight session log.
- `feature_list.json`: machine-readable feature state with verification and evidence fields.

### 3. Keep Scope Tight

The feature list should contain session-sized feature slices, not epics and not low-level chores. Each feature must represent user-visible or system-verifiable behavior that is plausibly completable and verifiable in one focused agent session.

Granularity rule from [Learn Harness Engineering](https://github.com/walkinglabs/learn-harness-engineering): too broad will not finish; too narrow creates management overhead. Prefer slices like `Learner can request a magic-link sign-in email` over epics like `Magic-link auth and enrollment API`.

Use this operational slicing test before writing `feature_list.json`:

- If a feature title contains multiple domains joined by "and" / "/" / commas, split it.
- If a feature would require multiple independent screens, endpoints, jobs, or integrations to verify, split it.
- If a feature cannot be verified with one small scenario plus the standard repo gate, split it.
- If a non-trivial MVP produces fewer than 10 features, treat that as a smell: perform another slicing pass or explicitly explain why the project is genuinely that small.
- For a product MVP with authentication, roles, content/data, user workflows, and integrations, expect roughly 12-30 session-sized features, not 5-8 broad milestones.

At most one feature may be `in_progress`. Prefer all features `not_started` unless the repo already has active work.

Use `depends_on` to express execution prerequisites. The order of items in `feature_list.json` is only the preferred plan order when multiple features are otherwise ready. Do not add numeric priority fields: stable feature identity comes from `id`, and dependency references use those ids.

### 4. Handle Missing Technical Commands

If the app is not bootstrapped yet, `init.sh` should be honest and provisional:

- confirm the directory,
- report that product bootstrap is pending,
- list expected future commands when known,
- exit successfully only if this is intentional for the pre-bootstrap phase.

Do not invent working commands that do not exist.

### 5. Quality Check

Before finishing, verify:

- `AGENTS.md` answers: what is the project, how to start, how to verify.
- `feature_list.json` is valid JSON.
- Every feature has `id`, `area`, `title`, `user_visible_behavior`, `depends_on`, `status`, `verification`, `evidence`, and `notes`.
- Every `depends_on` entry references an existing feature `id`, does not reference itself, and does not create a dependency cycle.
- No feature is an epic/milestone such as "auth and enrollment API", "adaptive dashboard", "review flow", "content import", or "certificate generation and public verification" unless it has first been split into smaller verifiable slices.
- For non-trivial MVPs, the feature count is not suspiciously low. If there are fewer than 10 features, run a second slicing pass before finishing.
- `PROGRESS.md` names the standard startup and verification paths, even if provisional.
- `init.sh` is executable or tell the user to run `chmod +x init.sh` if tooling prevented changing mode.
- No extra files were created.

## Explaining The Result

When reporting back, emphasize the progression:

`Build Brief -> minimal repo harness -> technical bootstrap -> feature spec -> implementation -> independent validation`

Suggest the next step explicitly: run the `feature-spec` skill for the first dependency-ready feature. The user should not need a long prompt; the value of the skill is that it already knows this phase's rules.
