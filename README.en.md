# Harness Starter

From a fuzzy idea to your first verified feature with an AI coding agent. Works with **Claude Code, Codex, and OpenCode**.

[Versión en español](README.md)

Models change every few weeks. What makes agent work reliable is everything around them: the context they get, how work is sliced, and how it gets verified. That is the harness.

This repo is the starting part of the harness I use every day and teach in AI Expert: four skills that take your agent from "what do you want to build?" to "feature validated with evidence", without giant prompts.

## The flow

```
Idea ─▶ build-brief ─▶ harness-starter ─▶ feature-spec ─▶ implementation ─▶ feature-validator
        what to build   agent-ready repo    one-feature       with your agent   in a fresh
                                            contract                            session
```

| Skill | What it does | What it leaves in your repo |
|---|---|---|
| `build-brief` | Interviews you one question at a time until the project is clear. Writes no code. | `CONTEXT.md`, `docs/build-brief.md`, `docs/domain-model.md`, `docs/risks-and-open-questions.md`, plus optional docs when needed |
| `harness-starter` | Turns the brief into an agent-ready repository. | `AGENTS.md`, `init.sh`, `PROGRESS.md`, `feature_list.json` |
| `feature-spec` | Writes the contract for a single feature before any code is touched. | `docs/specs/<feature-id>.md` |
| `feature-validator` | Reviews the implementation against the spec without trusting the implementer's summary. | An `accept`, `revise`, or `block` verdict with concrete repair steps |

Want to see the output first? [`examples/reservas-padel`](examples/reservas-padel) shows what the skills generate for a padel club booking app (in Spanish).

## Install

You need macOS or Linux and at least one of: Claude Code, Codex, or OpenCode.

```bash
git clone https://github.com/devexpert-io/harness-starter.git
cd harness-starter
./install.sh ../my-project   # one project
./install.sh --global        # all your projects
```

The installer copies the skills to `.agents/skills/` (read by Codex and OpenCode) and links them from `.claude/skills/` (read by Claude Code). It never overwrites existing files unless you pass `--force`.

**Manual install (or Windows):** copy the folders in `.agents/skills/` to your project's `.agents/skills/`, and also to `.claude/skills/` if you use Claude Code.

## Usage

| Agent | How to invoke a skill |
|---|---|
| Claude Code | `/build-brief` |
| Codex | `$build-brief` |
| OpenCode | "Use the build-brief skill" |

1. **Clarify what you are building** with `build-brief`. Answer with concrete examples and do not ask for code yet.
2. **Prepare the repo** with `harness-starter`. Check `feature_list.json`: every feature must be finishable and verifiable in one session.
3. **Specify the next feature** with `feature-spec`. Without arguments it picks the first dependency-ready feature.
4. **Implement** with a short prompt, because the context already lives in the repo:

   ```
   Implement feature <id> following docs/specs/<id>.md. Stay inside its scope.
   When done, run ./init.sh and the spec's checks, record the evidence in
   feature_list.json, mark the feature as passing, and update PROGRESS.md.
   ```

5. **Validate in a fresh session** with `feature-validator`. Whoever validates must not have written the code. On `revise`, hand the "Implementation Repair Brief" to the implementer as is.

Then go back to step 3 with the next feature.

## Why it works

- **Context before code.** The agent works from your decisions, not its guesses.
- **Everything important lives in the repo, not in the chat.** Every session starts knowing where it is.
- **Session-sized features.** If one scenario cannot verify it, it is sliced wrong.
- **The validator is not the implementer.**
- **Work closes with evidence, not promises.**

## What is not included

This repo covers the beginning of the harness: discovery, context, and verification. It leaves out hooks and role-based subagents, parallel agents with worktrees, evals, AI inside the product, and orchestrating the whole flow. We build those live, on your own project, in [AI Expert](https://devexpert.io/cursos/expert/ai?utm_source=github&utm_medium=referral&utm_campaign=harness-starter&utm_content=readme-en) (taught in Spanish).

## Credits

- The feature-slicing rule comes from [Learn Harness Engineering](https://github.com/walkinglabs/learn-harness-engineering).
- The skills follow the [Agent Skills](https://agentskills.io) format (`SKILL.md`).

Made by [Antonio Leiva](https://x.com/antonioleivag) at [DevExpert](https://devexpert.io).

## License

[MIT](LICENSE)
