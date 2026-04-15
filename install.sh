#!/usr/bin/env bash
set -e

PLUGIN_DIR="$(cd "$(dirname "$0")" && pwd)"
SKILLS_TARGET="$HOME/.claude/skills"
MCP_CONFIG="$HOME/.mcp.json"

echo ""
echo "=== Ottho Design Plugin — install ==="
echo ""

# ─── 1. Symlink skills ───────────────────────────────────────────────

echo "▸ Linking skills into $SKILLS_TARGET ..."
mkdir -p "$SKILLS_TARGET"

link_skill() {
  local skill_dir="$1"
  local link_name="$2"
  local link_path="$SKILLS_TARGET/$link_name"

  if [ -L "$link_path" ] || [ -e "$link_path" ]; then
    echo "  ⏭  $link_name (already exists, skipping)"
  else
    ln -s "$skill_dir" "$link_path"
    echo "  ✅ $link_name"
  fi
}

link_skill "$PLUGIN_DIR/skills/design-workflow"    "ottho-design_workflow"
link_skill "$PLUGIN_DIR/skills/design-system"      "ottho-design_review"
link_skill "$PLUGIN_DIR/skills/wireframe"          "ottho-design_wireframe"
link_skill "$PLUGIN_DIR/skills/mockup"             "ottho-design_mockup"
link_skill "$PLUGIN_DIR/skills/design-to-code"     "ottho-design_code"
link_skill "$PLUGIN_DIR/skills/component-registry" "ottho-design_components"

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
echo "  /ottho-design_workflow    — Full 10-step design workflow"
echo "  /ottho-design_wireframe   — Wireframe with Frame0"
echo "  /ottho-design_mockup      — High-fidelity mockup with Pencil"
echo "  /ottho-design_code        — Convert designs to production code"
echo "  /ottho-design_review      — Design critique (6 principles)"
echo "  /ottho-design_components  — Component registry (search, list, add)"
echo ""
