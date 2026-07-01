#!/usr/bin/env bash
# Configure a RealSmart app on Laravel Cloud (env, build, deploy).
set -euo pipefail

export PATH="${HOME}/.composer/vendor/bin:${PATH}"

APP="${1:?Usage: configure-cloud-app.sh <app>}"
HERD_ROOT="${HERD_ROOT:-$HOME/Herd}"
OAUTH_FILE="${REALSMART_OAUTH_FILE:-$HOME/.config/realsmart/google-oauth.env}"
ORG_ID="org-a223b153-50aa-45c4-a89d-2ff9bf8306fc"

app_display_name() {
    case "$1" in
        zebidee) echo "ZeBIDee" ;;
        staff-dash) echo "Staff Dash" ;;
        smaps) echo "SMAPS" ;;
        smartbadges) echo "SmartBadges" ;;
        smartcops) echo "SmartCoPs" ;;
        sos2) echo "SOS2" ;;
        plan2do) echo "plan2do" ;;
        smartdocs) echo "smartDocs" ;;
        *) echo "$1" ;;
    esac
}

# shellcheck disable=SC1090
source "$OAUTH_FILE"

APP_JSON="$(cloud application:get "$APP" --json -n)"
APP_ID="$(printf '%s' "$APP_JSON" | php -r 'echo json_decode(stream_get_contents(STDIN),true)["id"];')"
ENV_ID="$(printf '%s' "$APP_JSON" | php -r '$d=json_decode(stream_get_contents(STDIN),true); echo $d["environments"][0]["id"] ?? "";')"

cd "$HERD_ROOT/$APP"
APP_URL="$(cloud environment:get "$ENV_ID" --json -n | php -r 'echo json_decode(stream_get_contents(STDIN),true)["url"];')"
APP_KEY="$(php artisan key:generate --show)"

BUILD_CMD='composer config http-basic.composer.fluxui.dev gapharri@xptrust.org 6858875f-988b-4856-9780-d83879c8c152

composer install --no-dev --no-interaction --prefer-dist --optimize-autoloader

npm ci --audit false
npm run build'

if [[ "$APP" == "smartdocs" ]]; then
    BUILD_CMD='git clone --depth 1 https://x-access-token:${GITHUB_TOKEN}@github.com/gapharri/xp-trust-docs.git storage/content

'"$BUILD_CMD"
fi

APP_NAME="$(app_display_name "$APP")"

cloud environment:update "$ENV_ID" \
    --build-command="$BUILD_CMD" \
    --deploy-command='# php artisan migrate --force' \
    -n --force >/dev/null

set_var() { cloud environment:variables "$ENV_ID" --action=set --key="$1" --value="$2" -n --force >/dev/null; }

set_var APP_NAME "$APP_NAME"
set_var APP_ENV production
set_var APP_DEBUG false
set_var APP_URL "$APP_URL"
set_var APP_KEY "$APP_KEY"
set_var GOOGLE_CLIENT_ID "$GOOGLE_CLIENT_ID"
set_var GOOGLE_CLIENT_SECRET "$GOOGLE_CLIENT_SECRET"
set_var GOOGLE_REDIRECT_URI "${APP_URL}/auth/google/callback"

case "$APP" in
    sos2) set_var SOS2_ALLOWED_DOMAINS "xptrust.org,xpschool.org,xpderby.org" ;;
    staff-dash) set_var STAFF_DASH_ALLOWED_DOMAINS "xptrust.org,xpschool.org,xpderby.org,xpgateshead.org,xpeast.org,carcroftschool.co.uk,ploverschool.co.uk,realsmart.co.uk" ;;
    smartdocs)
        GITHUB_TOKEN="$(gh auth token 2>/dev/null || true)"
        if [[ -z "$GITHUB_TOKEN" ]]; then
            echo "smartdocs build needs GITHUB_TOKEN (gh auth login)" >&2
            exit 1
        fi
        set_var GITHUB_TOKEN "$GITHUB_TOKEN"
        set_var SMARTDOCS_ALLOWED_DOMAINS "xptrust.org,xpschool.org,xpderby.org,realsmart.co.uk"
        set_var CONTENT_REPO_PATH "/var/www/html/storage/content"
        set_var SMARTDOCS_GIT_REMOTE origin
        set_var SMARTDOCS_DRIVE_EXPORT_FORMAT markdown
        ;;
    smartbadges)
        set_var SMARTBADGES_ISSUER_NAME "XP School Trust"
        set_var SMARTBADGES_ISSUER_URL "https://xptrust.org"
        set_var SMARTBADGES_ISSUER_EMAIL "badges@xptrust.org"
        set_var SMARTBADGES_ISSUER_DESCRIPTION "Open Badges issued by XP School Trust via SmartBadges."
        set_var SMARTBADGES_ISSUER_IMAGE "https://xptrust.org/logo.png"
        set_var SMARTBADGES_RECIPIENT_SALT "$(openssl rand -hex 16)"
        ;;
    zebidee|smartcops)
        GEMINI="$(cloud environment:get env-a223b50d-be9b-456d-bda7-3c44e3e75c4a --json --show-sensitive -n 2>/dev/null | php -r 'foreach(json_decode(stream_get_contents(STDIN),true)["environmentVariables"]??[] as $v) if($v["key"]==="GEMINI_API_KEY") echo $v["value"];')"
        [[ -n "$GEMINI" ]] && set_var GEMINI_API_KEY "$GEMINI"
        ;;
esac

mkdir -p "$HERD_ROOT/$APP/.cloud" "$HERD_ROOT/$APP/bin"
cat >"$HERD_ROOT/$APP/.cloud/config.json" <<EOF
{
    "organization_id": "$ORG_ID",
    "application_id": "$APP_ID"
}
EOF
cp "$HERD_ROOT/smartcops/bin/cloud" "$HERD_ROOT/$APP/bin/cloud"
chmod +x "$HERD_ROOT/$APP/bin/cloud"

cloud domain:create "$ENV_ID" --name="${APP}.laravel.cloud" --wildcard-enabled=false --json -n >/dev/null 2>&1 || true

echo "Configured $APP -> $APP_URL"
