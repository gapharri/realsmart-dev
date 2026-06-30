---
name: herd-pro-mysql
description: >-
  Herd Pro local MySQL for RealSmart Laravel apps. Use when setting up local
  databases, herd.yml, migrating from SQLite, provisioning per-app MySQL databases,
  or matching Laravel Cloud MySQL locally.
---

# Herd Pro MySQL (RealSmart suite)

## Principles

- **Local dev:** Herd Pro MySQL on `127.0.0.1:3306` (matches Laravel Cloud engine).
- **Tests:** Keep `phpunit.xml` on SQLite `:memory:` unless the user asks otherwise.
- **Do not** install or start Homebrew MySQL on port 3306 — it conflicts with Herd.

## Suite database names

| App | Path | MySQL database |
|-----|------|----------------|
| zebidee | `~/Herd/zebidee` | `zebidee` |
| staff-dash | `~/Herd/staff-dash` | `staff_dash` |
| smaps | `~/Herd/smaps` | `smaps` |
| smartbadges | `~/Herd/smartbadges` | `smartbadges` |
| smartcops | `~/Herd/smartcops` | `smartcops` |
| sos2 | `~/Herd/sos2` | `sos2` |
| plan2do | `~/Herd/plan2do` | `plan2do` |
| smartdocs | `~/Herd/smartdocs` | `smartdocs` |
| sars | `~/Herd/sars` | `sars` |

## One-shot setup

```sh
export FLUX_USERNAME=...
export FLUX_LICENSE_KEY=...
~/Herd/bin/setup-suite.sh
```

## MySQL migration pitfalls

- Index names max **64 chars** — pass explicit short names to `->unique([...], 'short_name')`.
- Dropping unique indexes used by FKs: drop FKs first, drop index, re-add FKs (MySQL only).
- Avoid SQLite-only `PRAGMA` in seeders — use `Schema::disableForeignKeyConstraints()`.
