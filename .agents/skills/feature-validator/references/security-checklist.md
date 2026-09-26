# Feature Security Checklist

Use this checklist during feature validation. It is intentionally portable: do not assume Codex Security or any specific plugin is available.

This is not a full repository security audit. It is a feature-scoped security review anchored to:

- the selected feature spec,
- the implementation diff,
- files changed by the implementation,
- directly supporting files needed to understand the changed security behavior.

## Security Review Principles

- Stay diff-focused: review changed behavior and directly supporting code, not the whole repo.
- Think in source -> control -> sink paths: where input/data comes from, what checks transform or restrict it, and where it is used.
- Preserve evidence: cite file paths, relevant code behavior, commands, or missing controls.
- Prefer concrete findings over generic advice.
- If a risk is theoretical but not exploitable in this feature slice, record it as a note, not a blocking finding.
- If a security issue blocks acceptance, produce a repair brief that an implementer can execute.

## Core Checks

### 1. Secrets And Configuration

Check for:

- committed API keys, tokens, private URLs, passwords, cookies, service credentials, or `.env` contents,
- secrets embedded in tests, fixtures, screenshots, logs, or docs,
- unsafe default credentials,
- config values that should be environment variables.

Pass signal:

- no secrets in the diff,
- `.env*` files are ignored or represented by safe examples,
- docs use placeholders for sensitive values.

### 2. Authentication And Authorization

When the feature touches identity, sessions, roles, API keys, enrollment, certificates, admin, or teacher flows, check:

- unauthenticated access is intentionally public,
- authenticated-only routes enforce auth server-side,
- role checks are server-side and cannot be bypassed by UI changes,
- service/API keys are checked before side effects,
- revoked or expired access is respected,
- public certificate verification does not expose private learner data.

Pass signal:

- access checks are explicit at the correct boundary,
- negative cases are tested or manually verified.

### 3. Input Validation And Injection

When the feature handles user/API input, search, transcript text, file names, URLs, SQL, templates, or external payloads, check:

- input is parsed/validated at the boundary,
- SQL uses parameterized queries or ORM-safe APIs,
- search queries cannot break query syntax or access unintended records,
- HTML/Markdown/template rendering avoids XSS,
- URLs are validated before redirects or fetches,
- file paths cannot traverse outside allowed directories.

Pass signal:

- boundary validation is visible,
- dangerous sinks have nearby controls,
- tests cover at least one invalid or malicious input where practical.

### 4. Data Exposure And Privacy

When the feature returns or renders learner, cohort, transcript, progress, certificate, or attendance data, check:

- responses include only required fields,
- private data does not appear in public pages, logs, screenshots, or error messages,
- one learner cannot access another learner's private state,
- public verification pages expose only intentionally public certificate fields.

Pass signal:

- data selection is explicit,
- public/private boundaries are clear,
- logs avoid sensitive payloads.

### 5. External Services And SSRF-Like Risks

When the feature calls Mux, Zoom, SendGrid, n8n, webhooks, user-provided URLs, or other external services, check:

- outbound URLs are allowlisted or constructed from trusted config,
- webhooks verify signatures or secrets,
- retries/timeouts are bounded,
- failures do not leak secrets,
- service clients isolate credentials from UI/client code.

Pass signal:

- external calls go through server-side adapters/providers,
- credentials stay server-side,
- failure modes are handled deliberately.

### 6. Dependency And Tooling Risk

When dependencies or tooling change, check:

- new packages are necessary for the feature,
- packages are current and plausibly maintained,
- install/build scripts do not introduce suspicious behavior,
- lockfile changes match package changes,
- generated build artifacts are ignored unless intentionally tracked.

Pass signal:

- dependency additions are justified,
- no obvious abandoned or unrelated package is introduced,
- generated artifacts such as `.next/`, coverage, and tsbuild info are ignored.

### 7. Server/Client Boundary

For web apps, especially Next.js/React, check:

- secrets and server-only logic are not imported into client components,
- server actions/routes validate input server-side,
- client UI checks are not treated as authorization,
- public environment variables contain only public values,
- sensitive code uses server-only modules or boundaries where applicable.

Pass signal:

- client/server split is obvious,
- sensitive operations happen server-side.

### 8. File Uploads And Media

When the feature touches uploads, recordings, transcripts, generated PDFs, or local files, check:

- file type and size limits exist,
- paths and names are sanitized,
- untrusted files are not executed or served with unsafe content types,
- generated files do not include private data unintentionally.

Pass signal:

- upload/media constraints are explicit,
- storage and serving paths are controlled.

### 9. Auditability And Abuse Controls

When the feature changes enrollment, access, certificate, admin, teacher review, or service APIs, check:

- important state changes are auditable,
- destructive/revocation actions are explicit,
- rate limits or abuse controls are considered for public endpoints,
- errors are actionable without leaking internals.

Pass signal:

- audit fields/logging hooks are planned or implemented at the appropriate maturity level,
- public endpoints have basic abuse considerations.

## Finding Format

Use the validator's required finding format. Security findings should add:

- Attack path: how an attacker or unauthorized actor reaches the issue.
- Affected asset: learner data, certificate validity, service credential, admin capability, etc.
- Closest missing or weak control: auth check, validation, allowlist, server/client boundary, escaping, parameterization, etc.

Example:

```md
### Finding: Enrollment API accepts unauthenticated writes

- Severity: High
- Evidence: `src/app/api/enroll/route.ts` creates enrollments without checking the service API key described in the spec.
- Attack path: Anyone who can reach the route can create learner enrollments.
- Affected asset: Academy access and learner records.
- Closest missing control: Server-side service API key verification before side effects.
- Why it matters: Unauthorized enrollments grant private course access.
- Required change: Reject requests without the configured service API key before parsing or writing enrollment data.
- Suggested implementation:
  1. Add a server-side service API key guard for this route.
  2. Return 401/403 before any database write when the key is absent or invalid.
  3. Add tests for missing, invalid, and valid keys.
- Verification after fix:
  - `pnpm test`
  - API call without key returns 401/403 and creates no enrollment.
  - API call with valid key succeeds.
```

## Acceptance Guidance

- Critical/High exploitable security findings should produce `revise` or `block`.
- Missing security tests for a security-sensitive feature usually produces `revise`.
- Purely future-facing risks outside the feature scope can be recorded as notes, not blockers.
- If a full security audit is needed, recommend a dedicated security scan rather than overloading feature validation.
