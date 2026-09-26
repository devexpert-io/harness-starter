# Output Documents

Use these templates only when the corresponding concept has been discussed. Create documents lazily. Keep them short and deduplicated. Preserve the document language chosen by the user; ask before generating or rewriting if no language has been chosen. Prefer the compact set first; split optional documents only when they make the result clearer.


## Default Compact Set

Use this set for most projects/features unless complexity requires a split:

1. `CONTEXT.md`
2. `docs/build-brief.md`
3. `docs/domain-model.md`
4. `docs/risks-and-open-questions.md`

Only add optional files when the user, domain, or quality gate shows that one file would become too dense.

## `docs/build-brief.md`

```md
# Build Brief

## Problem

## Current Workaround / Existing System

## Target Users

## Goals

## Non-Goals

## MVP Slice

## Validation Plan

## Success Criteria

## Notes
```

## Optional Split Criteria

Split `docs/user-and-access-model.md` when permissions are a product risk.

Split `docs/technical-discovery.md` when technology, integrations, deployment, or operations shape the solution.

Split `docs/mvp-scope.md` when MVP boundaries are too large for `docs/build-brief.md`.

Create root `DESIGN.md` when the MVP or new feature has a visual interface. Ask for existing app designs first; if none exist, generate an initial design direction for agents. When the user wants image-generated concepts and the agent environment offers an image-generation tool (for example Codex's built-in `imagegen`), use it, save accepted project-bound mockups under `docs/design/concepts/`, and reference them from `DESIGN.md`.

Create ADRs only for confirmed, hard-to-reverse decisions.

## `CONTEXT.md`

Purpose: shared vocabulary for the project. No implementation details, plans, tasks, or decisions.

```md
# Context

## Glossary

### Term
Definition.

### Another Term
Definition.

## Rejected / Ambiguous Terms

### Ambiguous Term
Use `Preferred Term` instead. Reason: ...
```

## `docs/domain-model.md`

```md
# Domain Model

## Core Concepts

## Relationships

## States and Lifecycles

## Important Scenarios

## Edge Cases
```

## `docs/user-and-access-model.md`

```md
# User and Access Model

## User Types

## Roles

## Permissions

## Ownership Boundaries

## Access Rules

## Revocation / Expiry

## Edge Cases
```

## `docs/technical-discovery.md`

```md
# Technical Discovery

## Product Surface

## Candidate Stack

## Data and Storage

## Integrations

## Authentication and Authorization

## Deployment and Operations

## Testing and Verification

## Observability

## Constraints
```

## `docs/mvp-scope.md`

```md
# MVP Scope

## MVP Thesis

## Included

## Excluded

## First Vertical Slice

## Validation Plan

## Definition of Success
```

## `DESIGN.md`

Purpose: persistent visual direction for coding agents. Prefer the root filename `DESIGN.md` so agents and design tooling can discover it easily. Inspired by the DESIGN.md format: machine-readable YAML front matter for design tokens plus Markdown rationale for how to apply them.

Create this only when the project/MVP/feature has a visual interface.

If the user already has design assets, include them first and state their authority:

```md
## Existing Design Assets

- Figma/Pencil/screenshots/reference: <link/path>
- Authority: source of truth / inspiration only / outdated / partial
- Notes: <how agents should use it>
```

If generated images were used, save them in the repo and include them as directional assets:

```md
## Generated Concept Images

| Image | Role | Status |
| --- | --- | --- |
| `docs/design/concepts/learner-dashboard-v1.png` | Primary learner dashboard concept | Inspiration / accepted direction |

Prompt notes:

- `learner-dashboard-v1.png`: <short prompt summary and important constraints>

Generated images are visual direction only. `DESIGN.md` tokens, layout rules, and component guidance are authoritative when image details conflict with written guidance.
```

If there are no design assets, create an initial direction:

```md
---
name: <product or feature design name>
description: <short visual identity summary>
designAssets:
  sourceOfTruth: []
  generatedConcepts:
    - path: docs/design/concepts/<image-name>.png
      role: <why this image exists>
      status: inspiration
colors:
  primary: "#..."
  secondary: "#..."
  accent: "#..."
  background: "#..."
  surface: "#..."
  text: "#..."
typography:
  h1:
    fontFamily: <font stack>
    fontSize: <size>
    fontWeight: <weight>
  body:
    fontFamily: <font stack>
    fontSize: <size>
rounded:
  sm: <value>
  md: <value>
spacing:
  sm: <value>
  md: <value>
components:
  button-primary:
    backgroundColor: "{colors.primary}"
    textColor: "#..."
    rounded: "{radius-md}"
---

# Design Direction

## Overview

## Existing Design Assets

## Generated Concept Images

## Product Feel

## Colors

## Typography

## Layout

## Shapes

## Components

## Core Screens

## Responsive Baseline

## Accessibility Baseline

## Do's and Don'ts

## Open Design Questions
```

Keep this as product/feature direction, not a full implementation plan. Feature specs can later reference it and add feature-specific visual impact.

## Generated Design Asset Rules

Use an image-generation tool, when available, for high-level UI mockups, mood references, product illustrations, or visual concepts when a raster concept image helps agents and stakeholders align. Keep the batch small: 1-3 images is enough for most MVPs.

Do not use generated images as pixel-perfect UI specs. Generated text, exact component placement, and spacing are not authoritative unless the user explicitly accepts them. Capture durable decisions in `DESIGN.md` tokens and guidance.

Save project-bound concepts under `docs/design/concepts/` with stable, descriptive filenames. Do not leave referenced design assets only in the tool's default generated-image folder.

## `docs/risks-and-open-questions.md`

```md
# Risks and Open Questions

## Blocking Next Phase

## Implementation-Time Questions

## Later / Not MVP

## Assumptions

## Risks

## Research Tasks
```

## ADR Template

Create `docs/adr/0001-short-title.md` only for meaningful, hard-to-reverse decisions.

```md
# ADR 0001: Title

## Status
Accepted

## Context

## Decision

## Alternatives Considered

## Consequences
```
