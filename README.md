# realsmart-dev

Team tooling for RealSmart Herd suite development on macOS.

## Quick start (new colleague)

1. Complete the [manual checklist](docs/MANUAL-CHECKLIST.md) (~15 min).
2. Paste the [Cursor Agent prompt](docs/CURSOR-AGENT-PROMPT.md) into Cursor Agent mode.
3. Or run scripts manually after cloning app repos — see below.

## Install scripts onto your Mac

```bash
git clone https://github.com/gapharri/realsmart-dev.git ~/Developer/realsmart-dev
~/Developer/realsmart-dev/bin/install-herd-scripts.sh
~/Developer/realsmart-dev/bin/install-cursor-skills.sh
```

This links:

- `~/Herd/bin/setup-suite.sh` — one-shot composer/npm/MySQL/migrate for all apps
- `~/Herd/bin/sync-google-oauth-env.sh` — Google OAuth into every app `.env`
- `~/Herd/start-dev.sh` — all Vite dev servers (`herd-dev` alias)

## Daily commands

| Command | Purpose |
|---------|---------|
| `setup-suite.sh` | After fresh clone or major pull (install + migrate:fresh --seed) |
| `herd-dev` | Start 8 Vite watchers (run in a dedicated terminal tab) |
| `sync-google-oauth-env.sh` | Push shared Google creds to all app `.env` files |

## Secrets (team lead shares via 1Password)

See [docs/TEAM-LEAD-CHECKLIST.md](docs/TEAM-LEAD-CHECKLIST.md).

## Cursor

- Skills: `bin/install-cursor-skills.sh` → `~/.cursor/skills/`
- Per-app rules template: `cursor/rules/` + `bin/install-cursor-rules.sh`
- MCP: each Laravel app uses `.cursor/mcp.json` (Laravel Boost) after `composer install`
