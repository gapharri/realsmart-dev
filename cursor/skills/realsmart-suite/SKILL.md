---
name: realsmart-suite
description: >-
  RealSmart Herd suite context — Laravel apps sharing shell, Flux Pro, and
  Google login. Use when working across smartbadges, smartcops, smaps, zebidee,
  plan2do, staff-dash, smartdocs, or SOS2, or when the user mentions RealSmart
  suite switcher or icon nav.
---

# RealSmart suite

## Apps (canonical order)

| # | App | Path | `current_app` key |
|---|-----|------|-------------------|
| 1 | ZeBIDee | `~/Herd/zebidee` | `zebidee` |
| 2 | People (staff-dash) | `~/Herd/staff-dash` | `staff-dash` |
| 3 | SMAPS | `~/Herd/smaps` | `smaps` |
| 4 | SmartBadges | `~/Herd/smartbadges` | `smartbadges` |
| 5 | smartCoPs | `~/Herd/smartcops` | `smartcops` |
| 6 | SOS2 | `~/Herd/sos2` | `sos2` |
| 7 | plan2do | `~/Herd/plan2do` | `plan2do` |
| 8 | smartDocs | `~/Herd/smartdocs` | `smartdocs` |

Platform philosophy: `~/Developer/xp-trust-platform/docs/`  
Suite switcher spec: `~/Developer/xp-trust-platform/docs/suite-switcher-spec.md`  
Trust policies (Git): `~/Developer/xp-trust-docs/`

Herd URLs: `https://{app}.test`

## Stack

- Laravel 13, Livewire 4, Flux Pro, Tailwind 4
- **Local DB:** Herd Pro MySQL (`herd.yml` + `herd init` per app) — matches Laravel Cloud; see `herd-pro-mysql` skill
- **Tests:** SQLite `:memory:` via `phpunit.xml` (migrations may need MySQL/SQLite branches)
- Laravel Boost MCP in each app's `.cursor/mcp.json` (`php artisan boost:mcp`)
- RealSmart shell: `x-nav.suite-switcher`, `x-nav.rail-page-zone`, `x-nav.rail-link`, `x-nav.sidebar-link`
- Alpine store `appSwitcher` in `resources/js/shell-nav.js`
- Login: `resources/views/components/layouts/guest.blade.php` + `components/auth/login-card.blade.php`

## Suite switcher (do not copy-paste per app)

**Single source of truth:** `~/Developer/xp-trust-platform/config/suite-apps.yaml`  
**Canonical shell:** `~/Developer/realsmart-shell/`  
**Sync command:** `~/Developer/realsmart-shell/bin/sync.sh`

## Auth (per app — not shared SSO)

- Google via Socialite + Herd fwd.host redirect URIs
- Dev bypass (debug only): `GET /login/bypass?email=...` on smartbadges, smaps, plan2do, smartcops, zebidee
- Canonical docs: `smartbadges/docs/auth.md`
- Bulk OAuth sync: `~/Herd/bin/sync-google-oauth-env.sh`

## Laravel Cloud

GitHub org: `gapharri`. CLI: `composer global require laravel/cloud-cli` → `cloud auth` → per repo `cloud repo:config`.

**Flux Pro on Cloud:** `FLUX_USERNAME` + `FLUX_LICENSE_KEY` env vars; build command before `composer install`:

```bash
composer config http-basic.composer.fluxui.dev "$FLUX_USERNAME" "$FLUX_LICENSE_KEY"
```

Cursor skills: `deploying-laravel-cloud`, `herd-pro-mysql`. Team scripts: `~/Developer/realsmart-dev/`
