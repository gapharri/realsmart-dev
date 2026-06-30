#!/usr/bin/env bash
# Copy shared Cursor rules into each Herd app (.cursor is gitignored in most repos).
set -euo pipefail

ROOT="$(cd "$(dirname "$0")/.." && pwd)"
HERD="${HERD_ROOT:-$HOME/Herd}"
APPS=(zebidee staff-dash smaps smartbadges smartcops sos2 plan2do smartdocs sars)

for app in "${APPS[@]}"; do
    dir="$HERD/$app"
    [[ -d "$dir" ]] || continue

    mkdir -p "$dir/.cursor/rules"
    for rule in herd-laravel-stack.mdc flux-pro-ui.mdc realsmart-shell.mdc realsmart-suite.mdc laravel-cloud.mdc herd-pro-mysql.mdc; do
        cp "$ROOT/cursor/rules/$rule" "$dir/.cursor/rules/$rule"
    done

    if [[ ! -f "$dir/.cursor/mcp.json" ]]; then
        mkdir -p "$dir/.cursor"
        cp "$ROOT/cursor/mcp.json" "$dir/.cursor/mcp.json"
    fi

    echo "Installed .cursor rules → $app"
done
