#!/usr/bin/env bash
# One-shot install for all RealSmart Herd apps: Flux auth, composer, npm, MySQL, migrate:fresh --seed.
#
# Prerequisites:
#   - Herd Pro with MySQL available (herd services:list -n)
#   - FLUX_USERNAME and FLUX_LICENSE_KEY in environment (or pass via team 1Password)
#   - App repos cloned under ~/Herd
#
set -euo pipefail

HERD="${HERD_ROOT:-$HOME/Herd}"
APPS=(zebidee staff-dash smaps smartbadges smartcops sos2 plan2do smartdocs sars)
DBS=(zebidee staff_dash smaps smartbadges smartcops sos2 plan2do smartdocs sars)

if [[ -z "${FLUX_USERNAME:-}" || -z "${FLUX_LICENSE_KEY:-}" ]]; then
    echo "Set FLUX_USERNAME and FLUX_LICENSE_KEY before running (team 1Password)." >&2
    exit 1
fi

echo "==> Flux Pro composer auth"
composer config --global http-basic.composer.fluxui.dev "${FLUX_USERNAME}" "${FLUX_LICENSE_KEY}"

echo "==> Ensuring Herd MySQL is available"
if ! mysql -u root -h 127.0.0.1 -P 3306 -e "SELECT 1" &>/dev/null; then
    echo "MySQL not reachable on 127.0.0.1:3306. Enable Herd Pro MySQL first." >&2
    exit 1
fi

for app in "${APPS[@]}"; do
    dir="$HERD/$app"
    if [[ ! -d "$dir" ]]; then
        echo "Skip $app (missing $dir)" >&2
        continue
    fi

    echo "==> $app: dependencies"
    cd "$dir"

    [[ -f .env ]] || cp .env.example .env
    grep -q '^APP_KEY=base64:' .env 2>/dev/null || php artisan key:generate --no-interaction

    composer install --no-interaction
    npm install
    npm run build

    echo "==> $app: herd init"
    herd init -n
done

echo "==> Creating MySQL databases"
{
    for db in "${DBS[@]}"; do
        echo "CREATE DATABASE IF NOT EXISTS \`${db}\` CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci;"
    done
} | mysql -u root -h 127.0.0.1 -P 3306

for app in "${APPS[@]}"; do
    dir="$HERD/$app"
    [[ -d "$dir" ]] || continue

    echo "==> $app: migrate:fresh --seed"
    cd "$dir"
    php artisan migrate:fresh --seed --no-interaction
done

echo ""
echo "Done. Optional next steps:"
echo "  ~/Herd/bin/sync-google-oauth-env.sh"
echo "  Set GEMINI_API_KEY in zebidee and smartcops .env"
echo "  ~/Developer/realsmart-shell/bin/sync.sh"
echo "  herd-dev   # start Vite watchers"
