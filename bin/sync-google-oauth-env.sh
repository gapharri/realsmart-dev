#!/usr/bin/env bash
# Sync Google OAuth credentials from one file into all RealSmart Herd app .env files.
#
# Setup:
#   1. Register fwd.host redirect URIs in Google Cloud Console (see smartbadges/docs/auth.md)
#   2. cp config/google-oauth.env.example ~/.config/realsmart/google-oauth.env
#   3. Fill in GOOGLE_CLIENT_ID and GOOGLE_CLIENT_SECRET (from team 1Password)
#   4. ~/Herd/bin/sync-google-oauth-env.sh
#
set -euo pipefail

SOURCE="${1:-$HOME/.config/realsmart/google-oauth.env}"
HERD_ROOT="${HERD_ROOT:-$HOME/Herd}"

if [[ ! -f "$SOURCE" ]]; then
    echo "Missing $SOURCE" >&2
    echo "Copy config/google-oauth.env.example from realsmart-dev to ~/.config/realsmart/google-oauth.env" >&2
    exit 1
fi

# shellcheck disable=SC1090
source "$SOURCE"

if [[ -z "${GOOGLE_CLIENT_ID:-}" || -z "${GOOGLE_CLIENT_SECRET:-}" ]]; then
    echo "GOOGLE_CLIENT_ID and GOOGLE_CLIENT_SECRET must be set in $SOURCE" >&2
    exit 1
fi

APPS=(smartbadges smartcops smaps zebidee plan2do staff-dash smartdocs sos2)

upsert_env() {
    local file="$1"
    local key="$2"
    local value="$3"

    if grep -q "^${key}=" "$file" 2>/dev/null; then
        perl -i -pe "s|^\\Q${key}=\\E.*|${key}=${value}|" "$file"
    else
        printf '\n%s=%s\n' "$key" "$value" >>"$file"
    fi
}

herd_host_from_env() {
    local env_file="$1"
    grep -E '^APP_URL=' "$env_file" 2>/dev/null | cut -d= -f2- | tr -d '"' | sed -E 's#^https?://##' | sed 's#/$##'
}

fwd_redirect_uri() {
    local host="$1"
    echo "https://fwd.host/https://${host}/auth/google/callback"
}

for app in "${APPS[@]}"; do
    env_file="$HERD_ROOT/$app/.env"

    if [[ ! -f "$env_file" ]]; then
        echo "Skip $app (no .env)" >&2
        continue
    fi

    host="$(herd_host_from_env "$env_file")"
    redirect="$(fwd_redirect_uri "$host")"

    upsert_env "$env_file" "GOOGLE_CLIENT_ID" "$GOOGLE_CLIENT_ID"
    upsert_env "$env_file" "GOOGLE_CLIENT_SECRET" "$GOOGLE_CLIENT_SECRET"
    upsert_env "$env_file" "GOOGLE_REDIRECT_URI" "$redirect"

    echo "Updated $app/.env"
done

echo ""
echo "Register these Authorized redirect URIs in Google Cloud Console:"
for app in "${APPS[@]}"; do
    env_file="$HERD_ROOT/$app/.env"
    if [[ -f "$env_file" ]]; then
        host="$(herd_host_from_env "$env_file")"
        echo "  $(fwd_redirect_uri "$host")"
    fi
done

echo ""
echo "Run in each app: php artisan config:clear"
