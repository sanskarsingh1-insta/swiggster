#!/bin/bash
# swiggster — one-command installer for Claude Code (Mac/Linux)
# Usage: bash <(curl -s https://raw.githubusercontent.com/sanskarsingh1-insta/swiggster/master/install.sh)

set -e

if ! command -v node >/dev/null 2>&1; then
  echo "ERROR: 'node' is required. Install from https://nodejs.org and re-run."
  exit 1
fi

SETTINGS="$HOME/.claude/settings.json"

if [ ! -f "$SETTINGS" ]; then
  mkdir -p "$(dirname "$SETTINGS")"
  echo '{}' > "$SETTINGS"
fi

cp "$SETTINGS" "$SETTINGS.bak"

SWIGGSTER_SETTINGS="$SETTINGS" node -e "
const fs = require('fs');
const path = process.env.SWIGGSTER_SETTINGS;
const s = JSON.parse(fs.readFileSync(path, 'utf8'));

if (!s.extraKnownMarketplaces) s.extraKnownMarketplaces = {};
s.extraKnownMarketplaces.swiggster = {
  source: { source: 'github', repo: 'sanskarsingh1-insta/swiggster' }
};

if (!s.enabledPlugins) s.enabledPlugins = {};
s.enabledPlugins['swiggster@swiggster'] = true;

fs.writeFileSync(path, JSON.stringify(s, null, 2) + '\n');
console.log('swiggster registered in settings.json');
"

echo ""
echo "Done! Restart Claude Code to activate swiggster."
echo "On next session start, Claude Code will download and activate the plugin automatically."
