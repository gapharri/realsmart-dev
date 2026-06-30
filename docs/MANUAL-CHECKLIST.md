# Manual checklist (colleague — do before Cursor Agent)

Complete these steps yourself. Cursor cannot do them for you.

- [ ] Install [Laravel Herd](https://herd.laravel.com) and purchase **Herd Pro**
- [ ] Install [Cursor](https://cursor.com) (desktop; optional mobile app for monitoring agents)
- [ ] Accept GitHub org invite to **`gapharri`**
- [ ] Receive team secrets from your lead (1Password): `FLUX_USERNAME`, `FLUX_LICENSE_KEY`, `GOOGLE_CLIENT_ID`, `GOOGLE_CLIENT_SECRET`, `GEMINI_API_KEY`
- [ ] Ask team lead to add you as a **Google Cloud OAuth test user** (if consent screen is in Testing mode)
- [ ] Run in your terminal: `composer global require laravel/cloud-cli` then `cloud auth` (opens browser)
- [ ] Export Flux creds for setup script:
  ```bash
  export FLUX_USERNAME='your-flux-email'
  export FLUX_LICENSE_KEY='your-flux-license'
  ```

When done, open **Cursor Agent mode** and paste [CURSOR-AGENT-PROMPT.md](CURSOR-AGENT-PROMPT.md).

## npm note

Herd manages PHP (and can isolate Node), but **`npm install` always runs in Terminal** — there is no Herd GUI button for it. The Agent runs it during setup.

## Daily dev (after setup)

| Command | When |
|---------|------|
| `herd-dev` | Start all Vite dev servers (keep terminal open) |
| `setup-suite.sh` | After fresh clone or when dependencies/migrations need reset |

`herd-dev` is **not** an install command — it only runs `npm run dev` watchers.
