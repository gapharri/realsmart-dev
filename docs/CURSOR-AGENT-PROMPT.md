# Cursor Agent prompt (copy everything below the line)

Paste into **Cursor Agent mode** after completing [MANUAL-CHECKLIST.md](MANUAL-CHECKLIST.md).

---

```
Set up my MacBook for RealSmart suite development to match our team standard.

Clone team tooling first:
  git clone https://github.com/gapharri/realsmart-dev.git ~/Developer/realsmart-dev

## Context
- Apps live in ~/Herd (Laravel Herd Pro, PHP 8.4, HTTPS *.test)
- Stack: Laravel 13, Livewire 4, Flux Pro, Tailwind 4, Herd Pro MySQL, Laravel Boost MCP
- GitHub org: gapharri. Production: Laravel Cloud (MySQL)
- Supporting repos: ~/Developer/xp-trust-platform, ~/Developer/realsmart-shell, ~/Developer/xp-trust-docs
- Team scripts: ~/Developer/realsmart-dev/bin/
- Tests use SQLite in-memory (phpunit.xml); local dev uses MySQL

## Manual steps I already completed
- [x] Herd Pro installed and licensed
- [x] Cursor installed
- [x] GitHub gapharri access
- [x] FLUX_USERNAME and FLUX_LICENSE_KEY exported in my shell
- [x] Team shared GOOGLE_CLIENT_ID/SECRET (for google-oauth.env)
- [x] GEMINI_API_KEY from team lead
- [x] cloud auth completed in my terminal

## Your job (automate everything below)

### 1. Directory layout
mkdir -p ~/Herd ~/Developer ~/.config/realsmart
herd park ~/Herd

### 2. Install Herd + Cursor tooling
~/Developer/realsmart-dev/bin/install-herd-scripts.sh
~/Developer/realsmart-dev/bin/install-cursor-skills.sh

### 3. Clone app repos (if missing)
Into ~/Herd from gapharri: zebidee, staff-dash, smaps, smartbadges, smartcops, sos2, plan2do, smartdocs, sars
Into ~/Developer: xp-trust-platform, realsmart-shell, xp-trust-docs (if I have access)

### 4. Google OAuth
cp ~/Developer/realsmart-dev/config/google-oauth.env.example ~/.config/realsmart/google-oauth.env
Ask me to paste GOOGLE_CLIENT_ID and GOOGLE_CLIENT_SECRET if the file is still empty, then:
~/Herd/bin/sync-google-oauth-env.sh

### 5. Gemini AI
Set GEMINI_API_KEY in ~/Herd/zebidee/.env and ~/Herd/smartcops/.env (ask me if not in environment)

### 6. smartdocs
Set CONTENT_REPO_PATH=~/Developer/xp-trust-docs in smartdocs .env

### 7. Full suite setup
Ensure FLUX_USERNAME and FLUX_LICENSE_KEY are set, then:
~/Herd/bin/setup-suite.sh

### 8. Cursor per-app rules
~/Developer/realsmart-dev/bin/install-cursor-rules.sh

### 9. Shell sync
~/Developer/realsmart-shell/bin/sync.sh

### 10. Cloud Cursor skill
composer global require laravel/cloud-cli
cloud skills:install --agent=cursor

### 11. Verify
- php artisan migrate:status in smartcops, staff-dash, sos2
- php artisan test in smartcops (spot check)
- curl -k -o /dev/null -w '%{http_code}' https://smartcops.test/login (expect 200)

### 12. Report
Summarize what succeeded, any failures, and fwd.host redirect URIs I must confirm in Google Cloud Console.

## Rules
- Never commit .env, auth.json, or secrets
- Never install Homebrew MySQL on port 3306
- Follow realsmart-suite and herd-pro-mysql skills
- Minimal scope; match existing conventions
```
