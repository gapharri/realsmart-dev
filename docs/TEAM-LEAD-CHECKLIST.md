# Team lead checklist

Use this when onboarding a new developer to RealSmart.

## GitHub (`gapharri`)

- [ ] Invite colleague to GitHub org
- [ ] Grant access to app repos: `zebidee`, `staff-dash`, `smaps`, `smartbadges`, `smartcops`, `sos2`, `plan2do`, `smartdocs`, `sars`
- [ ] Grant access to: `realsmart-dev`, `xp-trust-platform`, `realsmart-shell`, `xp-trust-docs` (as appropriate)

## Google Cloud Console

- [ ] Add colleague's Google account as **OAuth consent screen test user** (if app is in Testing mode)
- [ ] Confirm fwd.host redirect URIs are registered (output of `sync-google-oauth-env.sh`)

## 1Password / secure share

Create or update a vault item **RealSmart Local Dev** with:

| Secret | Used for |
|--------|----------|
| `FLUX_USERNAME` | Composer Flux Pro auth (local + Laravel Cloud build) |
| `FLUX_LICENSE_KEY` | Composer Flux Pro auth |
| `GOOGLE_CLIENT_ID` | Socialite login (all suite apps) |
| `GOOGLE_CLIENT_SECRET` | Socialite login |
| `GEMINI_API_KEY` | ZeBIDee + smartCoPs AI features (Google AI Studio, not OAuth) |
| Laravel Cloud org invite | Production deploys (`cloud auth`) |

**Do not** commit these to git.

## Laravel Cloud

- [ ] Invite colleague to Laravel Cloud organization
- [ ] Confirm they can run `cloud auth` successfully

## Point colleague to

1. [docs/MANUAL-CHECKLIST.md](MANUAL-CHECKLIST.md)
2. [docs/CURSOR-AGENT-PROMPT.md](CURSOR-AGENT-PROMPT.md)

## Optional Cursor user rule

Suggest they add a personal rule:

> When working on RealSmart Herd apps, read the `realsmart-suite` and `herd-pro-mysql` skills first.
