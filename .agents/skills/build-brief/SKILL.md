---
name: build-brief
description: Guided briefing for new software projects, significant features, or product changes before implementation. Use when the user has a product/app/tool/platform idea, a vague feature direction, a replacement for an existing system, or a proof-of-concept to define; the skill interviews the user one question at a time, discovers domain language, users, workflows, technology constraints, access rules, MVP scope, risks, and only then prepares controlled project documents. Do not use for implementation, coding, or creating harness artifacts before the project is understood.
---

# Build Brief

Use this skill to turn an unclear project, significant feature, or product change into a small set of durable, teachable brief documents. The goal is clarity before coding: shared language, user types, workflows, constraints, technology options, MVP boundaries, and unresolved questions.

All paths in this skill are relative to the repository root.

## Hard Rules

- Do not implement code.
- Do not create `AGENTS.md`, `feature_list.json`, `PROGRESS.md`, issue backlogs, task plans, or implementation plans until the user explicitly asks after discovery is complete.
- Ask one question at a time. Include a recommended answer when useful.
- Prefer structured question tools when available: if the current agent environment exposes a multiple-choice/user-input tool, use it for bounded discovery questions; otherwise present the question and options as plain text.
- If a repository or existing docs exist, inspect them before asking questions that the files can answer.
- Create or update only the controlled discovery documents listed below.
- Keep documents concise and maintainable. Avoid context rot, duplicated statements, and stale open questions.
- Before creating or updating discovery documents, always ask which language to use for project documents. Do not assume from the conversation language.
- For products/features with a visual interface, discover existing design assets and create or update `DESIGN.md` after the MVP or new-feature direction is clear.
- If the user asks to create design direction and no source-of-truth design exists, and the agent environment offers an image-generation tool or skill (for example Codex's built-in `imagegen`), use it for a small number of UI concept images, then save the accepted project-bound images under `docs/design/concepts/` and reference them from `DESIGN.md`. If no image tool is available, describe the visual direction in text inside `DESIGN.md`.
- Explain why each artifact exists when introducing it: every document must answer a concrete ambiguity or risk, not add ceremony.

## Controlled Outputs

Do not create every possible file by default. Start with the smallest useful document set and split only when complexity justifies it.

Default compact set:

- `CONTEXT.md` — glossary and domain language only.
- `docs/build-brief.md` — problem, users, goals, non-goals, MVP slice, validation, and success criteria.
- `docs/domain-model.md` — domain entities, relationships, states, lifecycle rules.
- `docs/risks-and-open-questions.md` — unresolved decisions, assumptions, risks, research tasks.

Optional split-out documents, only when they would reduce confusion rather than add ceremony:

- `docs/user-and-access-model.md` — use when roles, permissions, ownership, revocation, or access rules are central to the project.
- `docs/technical-discovery.md` — use when stack, integrations, data, deployment, or operational constraints require focused treatment.
- `docs/mvp-scope.md` — use when the MVP boundaries are large enough that they would make `docs/build-brief.md` hard to read.
- `DESIGN.md` — use when the MVP or feature has a visual interface. If the user already has app designs, screenshots, Figma/Pencil files, brand guidelines, or references, capture how they should be used. If not, create an initial design direction with tokens and rationale.
- `docs/design/concepts/*.png` — optional generated UI concept images when the user explicitly wants image-generated design direction and no authoritative design assets exist. These are visual references, not implementation artifacts.
- `docs/adr/*.md` — use only for hard-to-reverse decisions with real trade-offs.

Read `references/output-documents.md` before writing or updating these files.

## Interaction Style

Use the richest interaction mode available in the current agent environment:

1. If a structured user-input or multiple-choice tool is available, use it for bounded questions where 2-4 likely answers exist.
2. Put the recommended option first and label it as recommended when the tool supports labels.
3. Always allow an escape hatch such as free-form "other" when the tool or interface supports it.
4. Use plain text questions when the answer is open-ended, sensitive, exploratory, or when no structured question tool is available.
5. Do not force every discovery question into multiple choice; use structured options to reduce ambiguity, not to constrain thinking prematurely.

Example plain-text fallback:

```txt
Which surface should the MVP target first?

Recommended: Web app, because admins and end users can both use it immediately.
Other plausible options: mobile app, CLI/internal tool, API-first backend.
```

## Workflow

### 1. Establish the Discovery Frame

First ask which language to use for generated project documents. Then clarify what is being discovered:

- What is the product/system/tool?
- What existing workflow or system does it replace or improve?
- Who needs it and why now?
- What would make the proof of concept successful?

If the user only has a vague idea, start with the problem and current workaround. Do not jump to architecture.

### 2. Build Shared Language

Use domain-modeling discipline:

- Detect vague or overloaded terms.
- Propose precise canonical terms.
- Ask for confirmation.
- Add resolved terms to `CONTEXT.md` only after they are stable.

`CONTEXT.md` is a glossary, not a PRD, scratchpad, or decision log.

### 3. Discover Users and Access

Identify user types, roles, ownership boundaries, permissions, and access edge cases. Prefer concrete scenarios over abstract permission matrices.

Examples:

- "Can a user belong to more than one organization/team/cohort/workspace?"
- "Who can see a private resource, and what revokes that access?"
- "Is the buyer always the end user?"

### 4. Discover Workflows and Domain State

Map the important workflows as lifecycle stories:

- creation,
- activation/publication,
- use,
- modification,
- completion/archive/deletion,
- failure or exception states.

Prefer state transitions over vague nouns. If a concept has statuses, define what causes each transition.

### 5. Discover Technology and Constraints

Do not assume the project is web. Ask about the required surface and constraints:

- web, mobile, desktop, CLI, API, automation, data pipeline, internal tool, embedded system, AI agent workflow, or hybrid,
- target users and devices,
- data storage and migration,
- integrations,
- authentication and authorization,
- deployment and hosting,
- privacy/security/compliance,
- testability and observability,
- budget/time/operational constraints.

Read `references/question-patterns.md` for phase-specific questions.

### 6. Define MVP Scope

Narrow the project to a vertical slice that proves the riskiest useful behavior. A good MVP:

- has real users or realistic actors,
- exercises core domain rules,
- includes one end-to-end workflow,
- avoids optional platform breadth,
- can be verified without hand-waving.

Capture explicit non-goals. Non-goals are part of the product definition.

### 7. Discover Product Design Direction

Run this step after the MVP or new-feature direction is clear, and only when the product/feature has a visual interface.

First discover whether the user already has design inputs:

- Figma, Pencil, Sketch, screenshots, wireframes, design docs, or brand guidelines,
- screenshots of the existing product being replaced,
- reference products or visual inspiration,
- logo, colors, typography, component library, or marketing site constraints.

If design assets exist, record where they are and whether they are source of truth, inspiration, outdated, or partial.

If design assets do not exist, decide whether the user wants generated visual concepts before locking `DESIGN.md`. If yes and an image-generation tool or skill is available (for example Codex's built-in `imagegen`), use it for 1-3 concept mockups that show the product feel across the most important surfaces. If no image tool is available, skip the images and capture the direction in text. Good defaults are:

- one primary user-facing screen for the MVP's first workflow,
- one secondary operational or edge-state screen when the MVP has internal users,
- one compact mobile or responsive variant when mobile behavior is materially important.

Treat generated UI images as direction-setting references. Do not assume generated text, exact spacing, or component details are authoritative. Save only accepted or useful project-bound concepts under `docs/design/concepts/`, record the prompt and role in `DESIGN.md`, and mark each concept as source of truth, inspiration, rejected, or needs iteration.

Create a first `DESIGN.md` for agents. Use it to give future coding agents persistent visual direction: design tokens plus human-readable rationale. Do not over-design every screen; define enough visual identity, layout principles, core screens, components, and accessibility expectations to prevent agents from improvising inconsistent UI.

`DESIGN.md` should be useful for an MVP or a significant new feature. For a non-visual project, explicitly mark visual design as not applicable in the relevant brief and do not create `DESIGN.md`.

### 8. Record Decisions Sparingly

Create an ADR only when all are true:

1. The decision is hard to reverse.
2. A future maintainer would wonder why it was chosen.
3. There were real alternatives with trade-offs.

Before creating an ADR, show a short decision preview and ask for confirmation unless the user has already clearly accepted the choice. Otherwise keep the point in the relevant discovery document or open questions.

### 9. Run a Discovery Quality Gate

Run this step when discovery is about to close, or when the user explicitly asks to apply the quality gate to existing discovery docs without re-running the interview. Before editing, ask which language to preserve/use for project documents if it is not already documented. Review the generated documents and fix structure without adding new product assumptions:

- Remove duplicated goals, assumptions, and repeated notes.
- Move resolved questions out of open questions.
- Mark remaining questions as `Blocking next phase`, `Implementation-time`, or `Later`.
- Do not leave critical sections as only `Not yet defined`; write a minimal initial position or explain why it is safely deferred.
- Check that access revocation/expiry, verification/testing, observability, operational ownership, and MVP validation have at least a minimal stance.
- For visual products/features, check that design assets were either referenced or `DESIGN.md` was created with enough direction for future UI implementation. If generated images were used, verify that project-bound concept images are saved under `docs/design/concepts/`, referenced from `DESIGN.md`, and clearly marked as directional rather than exact UI source.
- Keep each document concise enough to be reread by an agent; if a document grows large, summarize decisions and move details to later planning docs only when the user asks.

### 10. Stop Condition

Stop discovery when there is enough information to answer:

- What are we building?
- Who is it for?
- What are the core domain concepts?
- What access rules matter?
- What technology constraints shape the project?
- What is the MVP vertical slice?
- If visual UI exists: what visual direction or design source should agents follow?
- If generated design concepts exist: which images are accepted as inspiration, and what prompt or constraint produced them?
- What is explicitly out of scope?
- What remains unknown?

Then ask the user whether to proceed to the next phase, usually the `harness-starter` skill to derive `AGENTS.md`, `init.sh`, `PROGRESS.md`, and `feature_list.json`. Do not proceed automatically.
