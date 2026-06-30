#!/usr/bin/env bash
set -euo pipefail

ROOT="$(cd "$(dirname "$0")/.." && pwd)"
DEST="$HOME/.cursor/skills"

mkdir -p "$DEST"

for skill in realsmart-suite herd-pro-mysql xp-trust-platform; do
    mkdir -p "$DEST/$skill"
    cp "$ROOT/cursor/skills/$skill/SKILL.md" "$DEST/$skill/SKILL.md"
    echo "Installed $DEST/$skill/SKILL.md"
done

echo ""
echo "Also run (after composer global cloud-cli): cloud skills:install --agent=cursor"
