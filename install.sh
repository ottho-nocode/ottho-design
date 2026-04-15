#!/usr/bin/env bash
set -e

PLUGIN_DIR="$(cd "$(dirname "$0")" && pwd)"
SKILLS_TARGET="$HOME/.claude/skills"
MCP_CONFIG="$HOME/.mcp.json"

echo ""
echo "=== design-studio plugin — install ==="
echo ""

# ─── 1. Symlink skills ───────────────────────────────────────────────

echo "▸ Linking skills into $SKILLS_TARGET ..."
mkdir -p "$SKILLS_TARGET"

for skill_dir in "$PLUGIN_DIR"/skills/*/; do
  skill_name="$(basename "$skill_dir")"
  link_name="design-studio-${skill_name}"
  link_path="$SKILLS_TARGET/$link_name"

  if [ -L "$link_path" ] || [ -e "$link_path" ]; then
    echo "  ⏭  $link_name (already exists, skipping)"
  else
    ln -s "$skill_dir" "$link_path"
    echo "  ✅ $link_name → $skill_dir"
  fi
done

# ─── 2. Configure Frame0 MCP ─────────────────────────────────────────

echo ""
echo "▸ Configuring Frame0 MCP in $MCP_CONFIG ..."

if [ ! -f "$MCP_CONFIG" ]; then
  echo '{}' > "$MCP_CONFIG"
  echo "  ✅ Created $MCP_CONFIG"
fi

python3 -c "
import json, sys

path = '$MCP_CONFIG'
with open(path, 'r') as f:
    config = json.load(f)

if 'mcpServers' not in config:
    config['mcpServers'] = {}

if 'frame0' in config['mcpServers']:
    print('  ⏭  frame0 already configured in mcpServers')
else:
    config['mcpServers']['frame0'] = {
        'command': 'npx',
        'args': ['-y', 'frame0-mcp-server'],
        'env': {}
    }
    with open(path, 'w') as f:
        json.dump(config, f, indent=2)
        f.write('\n')
    print('  ✅ frame0 MCP server added to mcpServers')
"

# ─── 3. Pencil MCP info ──────────────────────────────────────────────

echo ""
echo "▸ Pencil MCP"
echo "  ℹ️  Pencil MCP is built into the Claude desktop app."
echo "     No configuration needed — it is available automatically"
echo "     when Claude desktop is running."

# ─── 4. Summary ──────────────────────────────────────────────────────

echo ""
echo "=== Installation complete ==="
echo ""
echo "Available slash commands:"
echo "  /design          — Full design workflow (wireframe → mockup → code)"
echo "  /wireframe       — Generate wireframes with Frame0"
echo "  /mockup          — Create high-fidelity mockups with Pencil"
echo "  /design-to-code  — Convert designs to production code"
echo "  /design-review   — Review and validate design output"
echo "  /components      — Browse and use the component registry"
echo ""
