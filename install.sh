#!/bin/bash
# swiggster installer — no dependencies required
# Usage: bash <(curl -s https://raw.githubusercontent.com/sanskarsingh1-insta/swiggster/master/install.sh)

SETTINGS="$HOME/.claude/settings.json"
mkdir -p "$HOME/.claude"
[ -f "$SETTINGS" ] || echo '{}' > "$SETTINGS"

python3 - "$SETTINGS" <<'EOF'
import json, sys
path = sys.argv[1]
with open(path) as f:
    s = json.load(f)

s.setdefault("extraKnownMarketplaces", {})["swiggster"] = {
    "source": {"source": "github", "repo": "sanskarsingh1-insta/swiggster"}
}
s.setdefault("enabledPlugins", {})["swiggster@swiggster"] = True

with open(path, "w") as f:
    json.dump(s, f, indent=2)
print("Done. Restart Claude Code to activate swiggster.")
EOF
