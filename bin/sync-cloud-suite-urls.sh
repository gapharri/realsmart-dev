#!/usr/bin/env bash
# Set suite cross-link *_URL env vars on all Cloud apps using live deployment URLs.
set -euo pipefail

export PATH="${HOME}/.composer/vendor/bin:${PATH}"

APPS=(zebidee staff-dash smaps smartbadges smartcops sos2 plan2do smartdocs)

json="$(cloud application:list --json -n)"

declare url_zebidee="" url_staff="" url_smaps="" url_badges="" url_cops="" url_sos2="" url_plan2do="" url_docs=""

while IFS=$'\t' read -r name url; do
    case "$name" in
        zebidee) url_zebidee="$url" ;;
        staff-dash) url_staff="$url" ;;
        smaps) url_smaps="$url" ;;
        smartbadges) url_badges="$url" ;;
        smartcops) url_cops="$url" ;;
        sos2) url_sos2="$url" ;;
        plan2do) url_plan2do="$url" ;;
        smartdocs) url_docs="$url" ;;
    esac
done < <(printf '%s' "$json" | php -r '
    $apps = json_decode(stream_get_contents(STDIN), true);
    foreach ($apps as $app) {
        $url = $app["environments"][0]["url"] ?? "";
        if ($url) {
            echo $app["name"]."\t".$url."\n";
        }
    }
')

set_urls_for_app() {
    local app="$1"
    local env_id
    env_id="$(printf '%s' "$json" | php -r '
        $apps = json_decode(stream_get_contents(STDIN), true);
        foreach ($apps as $app) {
            if ($app["name"] === $argv[1]) {
                echo $app["environments"][0]["id"] ?? "";
                exit;
            }
        }
    ' "$app")"

    [[ -n "$env_id" ]] || return 0

    cloud environment:variables "$env_id" --action=set --key=ZEBIDEE_URL --value="$url_zebidee" -n --force >/dev/null
    cloud environment:variables "$env_id" --action=set --key=STAFF_DASH_URL --value="$url_staff" -n --force >/dev/null
    cloud environment:variables "$env_id" --action=set --key=SMAPS_URL --value="$url_smaps" -n --force >/dev/null
    cloud environment:variables "$env_id" --action=set --key=SMARTBADGES_URL --value="$url_badges" -n --force >/dev/null
    cloud environment:variables "$env_id" --action=set --key=SMARTCOPS_URL --value="$url_cops" -n --force >/dev/null
    cloud environment:variables "$env_id" --action=set --key=SOS2_URL --value="$url_sos2" -n --force >/dev/null
    cloud environment:variables "$env_id" --action=set --key=PLAN2DO_URL --value="$url_plan2do" -n --force >/dev/null
    cloud environment:variables "$env_id" --action=set --key=SMARTDOCS_URL --value="$url_docs" -n --force >/dev/null

    echo "Suite URLs synced for $app"
}

for app in "${APPS[@]}"; do
    set_urls_for_app "$app"
done
