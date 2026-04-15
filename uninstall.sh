#!/usr/bin/env bash
set -e

SKILLS_TARGET="$HOME/.claude/skills"
MCP_CONFIG="$HOME/.mcp.json"

echo ""
echo "=== Ottho Design Plugin — uninstall ==="
echo ""

# ─── 1. Remove skill symlinks ────────────────────────────────────────

echo "▸ Removing ottho-design_* symlinks from $SKILLS_TARGET ..."

found=0

# Remove new naming convention
for link in "$SKILLS_TARGET"/ottho-design_*; do
  [ -L "$link" ] || [ -e "$link" ] || continue
  rm -f "$link"
  echo "  ✅ Removed $(basename "$link")"
  found=1
done

# Also remove old naming convention (design-studio-*)
for link in "$SKILLS_TARGET"/design-studio-*; do
  [ -L "$link" ] || [ -e "$link" ] || continue
  rm -f "$link"
  echo "  ✅ Removed $(basename "$link") (legacy)"
  found=1
done

if [ "$found" -eq 0 ]; then
  echo "  ⏭  No ottho-design_* symlinks found"
fi

# ─── 2. Remove Frame0 from MCP config ────────────────────────────────

echo ""
echo "▸ Removing frame0 from $MCP_CONFIG ..."

if [ -f "$MCP_CONFIG" ]; then
  python3 -c "
import json, sys

path = '$MCP_CONFIG'
with open(path, 'r') as f:
    config = json.load(f)

if 'mcpServers' in config and 'frame0' in config['mcpServers']:
    del config['mcpServers']['frame0']
    with open(path, 'w') as f:
        json.dump(config, f, indent=2)
        f.write('\n')
    print('  ✅ frame0 removed from mcpServers')
else:
    print('  ⏭  frame0 not found in mcpServers')
"
else
  echo "  ⏭  $MCP_CONFIG not found, nothing to remove"
fi

# ─── 3. Summary ──────────────────────────────────────────────────────

echo ""
echo "=== Uninstall complete ==="
echo ""
echo "Skill symlinks and MCP config have been cleaned up."
echo "Plugin files remain at ~/.claude/plugins/design-studio/"
echo "To fully remove: rm -rf ~/.claude/plugins/design-studio/"
echo ""
