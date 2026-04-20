# Ottho Design

**Complete design workflow for Claude Code.**

Ottho Design is an open-source Claude Code plugin that orchestrates a full design-to-code pipeline in 10 steps: brief → inspirations → design system → wireframe (Frame0) → mockup (Pencil.dev) → code → refinement with a reusable component registry. A design critique based on 6 principles is applied at every stage.

---

## Workflow (10 steps)

```
  1. BRIEF            Gather context (audience, goal, brand, type)
  2. INSPIRATIONS     Collect visual references
  3. DESIGN SYSTEM    Define colors, typography, spacing tokens
  4. WIREFRAME        Low-fi layout with Frame0 MCP
  5. MOCKUP           High-fidelity design with Pencil.dev MCP
  6. CODE             Production HTML/React + TailwindCSS
  7. REFINEMENT       Match & adapt components from the registry

  [design critique after each visual phase — 6 principles check,
   user approval required before advancing]
```

Each phase is validated against 6 design principles (visual hierarchy, spacing, color, typography, layout, responsive) before advancing. The user approves every transition.

---

## Installation

```bash
git clone https://github.com/ottho-nocode/ottho-design.git ~/.claude/plugins/design-studio
~/.claude/plugins/design-studio/install.sh
```

The install script:
- Symlinks all skills into `~/.claude/skills/`
- Configures Frame0 MCP server in `~/.mcp.json`
- Pencil MCP is built into Claude desktop (no configuration needed)

---

## Quick Start

```
/ottho-design_workflow
```

The orchestrator will walk you through the 10-step pipeline from brief to refined code. Each visual phase includes a design critique and requires your approval before advancing.

---

## Available Commands

| Command | Description |
|---|---|
| `/ottho-design_workflow` | Full 10-step pipeline: brief → inspirations → design system → wireframe → mockup → code → refinement |
| `/ottho-design_wireframe` | Wireframe phase only (Frame0 MCP) |
| `/ottho-design_mockup` | High-fidelity mockup phase only (Pencil.dev MCP) |
| `/ottho-design_code` | Code generation from an existing design or wireframe |
| `/ottho-design_review` | Standalone design critique against 6 principles |
| `/ottho-design_components` | Browse, search, and manage the component registry |

Each skill can run standalone or as part of the full `/ottho-design_workflow` pipeline.

---

## Component Registry

The registry stores reusable UI components organized into collections. During code generation, the pipeline searches the registry for components that match the design spec, so you get production-tested code instead of generating everything from zero.

### Built-in collection

- **aura** -- 35 components from [aura.build](https://aura.build) (heroes, pricing tables, feature sections, dashboards, CTAs). Available in HTML and React formats.

### Adding a collection

1. Create a directory under `registry/collections/<your-collection>/`
2. Add a `manifest.json` describing your components (see `registry/collections/aura/manifest.json` for the format)
3. Place component files in subdirectories (e.g., `components/<name>/html/` and `components/<name>/react/`)
4. Register the collection in `registry/registry.json`

See [CONTRIBUTING.md](CONTRIBUTING.md) for the full manifest.json schema and step-by-step guide.

---

## Requirements

| Requirement | Required? | Notes |
|---|---|---|
| [Claude Code](https://claude.ai/code) | Yes | The plugin runs inside Claude Code |
| [Frame0](https://frame0.app) MCP server | Optional | Enables the wireframe phase. Installed automatically by `install.sh` |
| [Pencil.dev](https://pencil.dev) MCP server | Optional | Enables the mockup phase. Built into Claude desktop app |

The plugin degrades gracefully when MCP servers are unavailable -- it skips the corresponding phase and continues the pipeline.

---

## Uninstall

```bash
~/.claude/plugins/design-studio/uninstall.sh
```

This removes skill symlinks and the Frame0 MCP entry from `~/.mcp.json`. Plugin files remain on disk. To fully remove:

```bash
rm -rf ~/.claude/plugins/design-studio
```

---

## Contributing

See [CONTRIBUTING.md](CONTRIBUTING.md) for guidelines on adding component collections, improving design principles, and submitting new skills.

---

## License

[MIT](LICENSE)
