#!/usr/bin/env bash
set -euo pipefail

HERD="${HERD_ROOT:-$HOME/Herd}"
CONCURRENTLY="$HERD/smaps/node_modules/.bin/concurrently"

if [[ ! -x "$CONCURRENTLY" ]]; then
    echo "concurrently not found. Run setup-suite.sh or: cd $HERD/smaps && npm install" >&2
    exit 1
fi

cd "$HERD"

# Vite ports (see each app's vite.config.js):
#   plan2do     5176
#   smaps       5173
#   smartbadges 5175
#   smartcops   5174
#   smartdocs   5179
#   sos2        5178
#   staff-dash  5180
#   zebidee     5177

exec "$CONCURRENTLY" \
    -n plan2do,smaps,smartbadges,smartcops,smartdocs,sos2,staff-dash,zebidee \
    -c yellow,blue,green,magenta,cyan,red,white,gray \
    "cd plan2do && npm run dev" \
    "cd smaps && npm run dev" \
    "cd smartbadges && npm run dev" \
    "cd smartcops && npm run dev" \
    "cd smartdocs && npm run dev" \
    "cd sos2 && npm run dev" \
    "cd staff-dash && npm run dev" \
    "cd zebidee && npm run dev"
