# Design Studio

**Complete design workflow for Claude Code.**

Design Studio is an open-source Claude Code plugin that orchestrates a full design-to-code pipeline: wireframe (Frame0) to mockup (Pencil.dev) to production code, with built-in design critique at every stage. It ships with an extensible component registry so you can reuse high-quality UI components instead of generating everything from scratch.

---

## Workflow

```
  BRIEF                 WIREFRAME               MOCKUP                  CODE
  ------                ---------               ------                  ----
  Gather context   -->  Generate layout    -->  High-fidelity      -->  Production
  (audience, goal,      with Frame0 MCP         design with             HTML/React
   brand, type)                                 Pencil.dev MCP          + TailwindCSS

                   [design critique]       [design critique]       [design critique]
                   6 principles check      6 principles check      6 principles check
                   User approves           User approves           User approves
```

Each phase is validated against 6 design principles (visual hierarchy, spacing, color, typography, layout, responsive) before advancing. The user approves every transition.

---

## Installation

```bash
git clone https://github.com/thibaultmarty/design-studio.git ~/.claude/plugins/design-studio
~/.claude/plugins/design-studio/install.sh
```

The install script:
- Symlinks all skills into `~/.claude/skills/`
- Configures Frame0 MCP server in `~/.mcp.json`
- Pencil MCP is built into Claude desktop (no configuration needed)

---

## Quick Start

```
/design
```

The orchestrator will walk you through the full pipeline:

1. **Brief** -- Answer 4 questions about what you are building
2. **Wireframe** -- Frame0 generates the layout structure
3. **Mockup** -- Pencil.dev creates a high-fidelity design
4. **Code** -- Production HTML and React components are generated

Each phase includes a design critique and requires your approval before advancing.

---

## Available Commands

| Command | Description |
|---|---|
| `/design` | Full pipeline: brief, wireframe, mockup, code with design critique at every stage |
| `/wireframe` | Wireframe phase only (Frame0 MCP) |
| `/mockup` | Mockup phase only (Pencil.dev MCP) |
| `/design-to-code` | Code generation from an existing design or wireframe |
| `/design-review` | Standalone design critique against 6 principles |
| `/components search\|list\|add\|info` | Browse, search, and manage the component registry |

Each skill can run standalone or as part of the full `/design` pipeline.

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
