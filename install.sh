#!/bin/bash
# swiggster installer
# Usage: bash <(curl -s https://raw.githubusercontent.com/sanskarsingh1-insta/swiggster/master/install.sh)

REPO="sanskarsingh1-insta/swiggster"
BRANCH="master"
BASE="https://raw.githubusercontent.com/$REPO/$BRANCH"
CLAUDE="$HOME/.claude"
HASH="a1b2c3d4e5f6"

FILES=(
  ".claude-plugin/plugin.json"
  "skills/swiggster/SKILL.md"
  "hooks/swiggster-activate.js"
  "references/cross-domain-signals.md"
)

DIRS=(
  "$CLAUDE/plugins/marketplaces/swiggster"
  "$CLAUDE/plugins/cache/swiggster/swiggster/$HASH"
)

# 1. Download plugin files into both dirs
for DIR in "${DIRS[@]}"; do
  for FILE in "${FILES[@]}"; do
    DEST="$DIR/$FILE"
    mkdir -p "$(dirname "$DEST")"
    curl -fsSL "$BASE/$FILE" -o "$DEST" 2>/dev/null || echo "Warning: could not download $FILE"
  done
done
echo "Plugin files installed."

# 2. Wire into ~/.claude/settings.json
SETTINGS="$CLAUDE/settings.json"
mkdir -p "$CLAUDE"
[ -f "$SETTINGS" ] || echo '{}' > "$SETTINGS"

python3 - "$SETTINGS" "$REPO" <<'EOF'
import json, sys
path, repo = sys.argv[1], sys.argv[2]
with open(path) as f:
    s = json.load(f)
s.setdefault("extraKnownMarketplaces", {})["swiggster"] = {
    "source": {"source": "github", "repo": repo}
}
s.setdefault("enabledPlugins", {})["swiggster@swiggster"] = True
with open(path, "w") as f:
    json.dump(s, f, indent=2)
print("settings.json updated.")
EOF

echo ""
echo "Done. Restart Claude Code to activate swiggster."
