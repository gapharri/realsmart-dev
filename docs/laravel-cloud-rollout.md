# Laravel Cloud rollout (RealSmart suite)

## Prerequisites

- `composer global require laravel/cloud-cli` and `cloud auth`
- `~/.config/realsmart/google-oauth.env` with Google OAuth creds
- Optional: `~/.config/realsmart/cloud-shared.env` (Flux + Gemini) — auto-bootstrapped from smartcops

## Database (MySQL only)

All suite apps share one Laravel MySQL cluster:

| Setting | Value |
|---------|-------|
| Cluster | `xp-trust-db` |
| Engine | `laravel_mysql_84` |
| Region | `eu-west-2` |

Do **not** provision Serverless Postgres or per-app database clusters. `sync-cloud-env.sh` creates/attaches the correct schema on `xp-trust-db`.

If you inherit orphan Postgres clusters from a bad deploy, delete them after reattaching apps to MySQL (they are usually empty when never linked to an environment).

## Scripts

| Script | Purpose |
|--------|---------|
| `bin/sync-cloud-env.sh <app>` | Push shared + per-app env vars to Cloud |
| `bin/sync-cloud-env.sh --all` | Sync all 8 suite apps |
| `bin/sync-cloud-env.sh --suite-urls` | Update cross-link `*_URL` vars only |
| `bin/sync-cloud-env.sh --bootstrap` | Seed `cloud-shared.env` from live smartcops |
| `bin/sync-cloud-env.sh --ship <app>` | Full first-time ship + env + deploy |
| `bin/sync-cloud-env.sh --ship-all` | Ship all apps except smartcops |

## Google OAuth (production)

Add these redirect URIs in Google Cloud Console (one-time). Use each app's **live** URL:

```
https://smartcops.laravel.cloud/auth/google/callback
https://plan2do-production-zgh9ir.laravel.cloud/auth/google/callback
https://staff-dash-production-itqqef.laravel.cloud/auth/google/callback
https://sos2-production-4to0ju.laravel.cloud/auth/google/callback
https://smaps-production-dfcz3t.laravel.cloud/auth/google/callback
https://zebidee-production-ruhnmq.laravel.cloud/auth/google/callback
https://smartbadges-production-szjjoi.laravel.cloud/auth/google/callback
https://smartdocs-production-xbpnr9.laravel.cloud/auth/google/callback
```

Vanity domains (`{app}.laravel.cloud`) are requested for each app; until they verify, use the production URLs above.

## Scripts (suite URLs)

| `bin/sync-cloud-suite-urls.sh` | Push live `*_URL` cross-links to every app |

## Per-repo artifacts

After `cloud repo:config`, commit:

- `.cloud/config.json`
- `bin/cloud` (optional wrapper)

Push-to-deploy on `main` matches smartcops.

## smartdocs content

Build command clones `gapharri/xp-trust-docs` into `storage/content`. `CONTENT_REPO_PATH=/var/www/html/storage/content`.
