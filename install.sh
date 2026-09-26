#!/usr/bin/env bash
# Harness Starter installer.
#
#   ./install.sh <project-path>   install into one repository
#   ./install.sh --global         install for every project of the current user
#   add --force                   replace skills that already exist with the same name
#
# Skills are copied to <target>/.agents/skills (read by Codex and OpenCode) and
# linked from <target>/.claude/skills (read by Claude Code).
set -euo pipefail

SKILLS=(build-brief harness-starter feature-spec feature-validator)
SRC="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)/.agents/skills"

usage() {
  sed -n '4,6p' "$0" | sed 's/^# \{0,1\}//'
  exit 64
}

force=0
mode=""
target=""
for arg in "$@"; do
  case "$arg" in
    --force) force=1 ;;
    --global) mode="global" ;;
    -h|--help) usage ;;
    -*) echo "Unknown option: $arg" >&2; usage ;;
    *) target="$arg"; mode="${mode:-project}" ;;
  esac
done
[[ -n "$mode" ]] || usage

if [[ "$mode" == "global" ]]; then
  agents_dir="$HOME/.agents/skills"
  claude_dir="$HOME/.claude/skills"
else
  [[ -d "$target" ]] || { echo "Project directory not found: $target" >&2; exit 66; }
  target="$(cd "$target" && pwd)"
  agents_dir="$target/.agents/skills"
  claude_dir="$target/.claude/skills"
fi

mkdir -p "$agents_dir" "$claude_dir"

for skill in "${SKILLS[@]}"; do
  dest="$agents_dir/$skill"
  if [[ -e "$dest" && $force -eq 0 ]]; then
    echo "skip  $dest (already exists; use --force to replace)"
  else
    rm -rf "$dest"
    cp -R "$SRC/$skill" "$dest"
    echo "copy  $dest"
  fi

  link="$claude_dir/$skill"
  if [[ "$mode" == "global" ]]; then
    link_target="$dest"
  else
    link_target="../../.agents/skills/$skill"
  fi
  if [[ -L "$link" ]]; then
    ln -sfn "$link_target" "$link"
    echo "link  $link"
  elif [[ -e "$link" && $force -eq 0 ]]; then
    echo "skip  $link (a real folder exists; use --force to replace it with a link)"
  else
    rm -rf "$link"
    ln -s "$link_target" "$link"
    echo "link  $link"
  fi
done

cat <<'EOF'

Harness Starter installed. Open your agent in the project and start with the first skill:

  Claude Code  →  /build-brief
  Codex        →  $build-brief
  OpenCode     →  "Use the build-brief skill"

Flow: build-brief → harness-starter → feature-spec → implement → feature-validator (in a fresh session).
If the project already has a CLAUDE.md, add a line "@AGENTS.md" to it so Claude Code also reads AGENTS.md.
EOF
