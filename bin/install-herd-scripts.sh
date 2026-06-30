#!/usr/bin/env bash
set -euo pipefail

ROOT="$(cd "$(dirname "$0")/.." && pwd)"
HERD="${HERD_ROOT:-$HOME/Herd}"

mkdir -p "$HERD/bin"

link_script() {
    local name="$1"
    ln -sf "$ROOT/bin/$name" "$HERD/bin/$name"
    chmod +x "$ROOT/bin/$name"
    echo "Linked $HERD/bin/$name"
}

link_script setup-suite.sh
link_script sync-google-oauth-env.sh

ln -sf "$ROOT/bin/start-dev.sh" "$HERD/start-dev.sh"
chmod +x "$ROOT/bin/start-dev.sh"
echo "Linked $HERD/start-dev.sh"

mkdir -p "$HOME/.config/realsmart"
if [[ ! -f "$HOME/.config/realsmart/google-oauth.env.example" ]]; then
    cp "$ROOT/config/google-oauth.env.example" "$HOME/.config/realsmart/google-oauth.env.example"
fi

ZSHRC="$HOME/.zshrc"
if ! grep -q "alias herd-dev=" "$ZSHRC" 2>/dev/null; then
    printf '\n# RealSmart suite Vite watchers\nalias herd-dev="%s/start-dev.sh"\n' "$HERD" >>"$ZSHRC"
    echo "Added herd-dev alias to $ZSHRC"
else
    echo "herd-dev alias already in $ZSHRC"
fi

echo ""
echo "Done. Restart your shell or run: source $ZSHRC"
