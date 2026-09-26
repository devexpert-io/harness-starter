# Question Patterns

Ask one question at a time. Include a recommended answer when helpful. Prefer scenario questions that force concrete answers. When the environment exposes a structured user-input/multiple-choice tool, use it for bounded questions with 2-4 plausible answers; otherwise write the options in plain text.

## Product Frame

- What language should the project documents use? Always ask before generating or rewriting project documents; do not infer it from the conversation language.

- What existing workflow, tool, spreadsheet, platform, or manual process should this replace?
- What breaks if this project does not exist?
- Who experiences the pain most often?
- What would a successful proof of concept demonstrate?

## Users and Roles

- Who uses the system directly?
- Who configures or administers it?
- Who owns the data or resources?
- Can one person have multiple roles?
- Is the buyer/account owner different from the end user?

## Domain Language

- You used two similar terms. Are they synonyms or different concepts?
- What is the lifecycle of this thing from creation to archive/deletion?
- What makes an item active, valid, visible, published, completed, revoked, or expired?
- What terms should appear in code and UI because domain experts use them?

## Access and Permissions

- What can each role create, read, update, delete, publish, or revoke?
- What grants access?
- What removes access?
- Does access expire?
- What happens when access is revoked after content, submissions, certificates, or audit logs already exist?
- Can access be inherited from organization, team, purchase, enrollment, role, or invitation?
- What should happen when a user changes group/team/cohort/workspace?

## Technology Discovery

- What product surfaces are required: web, mobile, desktop, CLI, API, automation, agent, data pipeline, or another surface?
- What systems must it integrate with?
- What data must be migrated or synchronized?
- What authentication model is needed?
- What authorization complexity is expected?
- What are the hosting/deployment constraints?
- What must be observable in production?
- What must be testable end-to-end?
- Are there regulatory, privacy, security, or data residency constraints?

## Verification and Operations

- How will we know the MVP works end to end?
- What should be tested automatically before implementation is considered complete?
- What runtime events, logs, or audit records would help debug failures?
- Who operates the system on day one, and what mistakes should the system prevent?

## MVP and Slicing

- What is the smallest vertical slice that proves the core value?
- Which hard problem should the MVP include rather than postpone?
- Which tempting feature should be explicitly excluded?
- What can be fake/manual in the proof of concept without invalidating the learning?
- How will we know the MVP works?

## Product Design

- Do we have any existing design assets, brand guidelines, screenshots, Figma/Pencil files, or reference products that should shape the UI?
- Which design input is authoritative: existing product, marketing site, brand guide, generated concepts, or a new direction?
- What should the product feel like in use: calm and operational, premium/editorial, playful, technical, dense and tool-like, or another direction?
- Which screen should be visualized first because it carries the MVP value?
- Which secondary state or internal workflow needs design direction so agents do not improvise it later?
- Are generated UI concept images acceptable as inspiration before `DESIGN.md` is finalized?
- Should the first design pass prioritize desktop, mobile, or both?
- What visual details must not be invented: logo, colors, typography, product screenshots, people's identities, or official branding?
- What would make a generated design concept unacceptable?

## Decision Pressure

- Is this decision hard to reverse?
- Would a future developer ask why this was chosen?
- What alternatives are realistic?
- What is the cost of delaying this decision?
