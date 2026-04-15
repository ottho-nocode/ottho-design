---
name: component-registry
description: Search, browse, and manage collections of UI components (HTML/React). Use when looking for pre-built components to integrate into a design. Triggers on /components.
---

# Component Registry

Manage an extensible registry of UI component collections. The registry indexes pre-built HTML and React components organized into collections, each with its own manifest. Use this skill to search, browse, add, and remove components or entire collections.

## Commands

### /components search `<query>`
Search across all registered collections for components matching a query. The query can be a category name, tag, or keyword.

### /components list [collection]
List all registered collections, or list all components within a specific collection.

### /components add `<path>`
Register a new collection by providing the path to its directory. The directory must contain a valid `manifest.json`. The collection is added to `registry.json` automatically.

### /components remove `<collection-name>`
Remove a collection from the registry. This updates `registry.json` but does not delete the collection files from disk.

### /components info `<collection>/<component-id>`
Show detailed information about a specific component, including its description, tags, available formats, and file paths.

## Registry Structure

The registry follows a three-level hierarchy:

```
registry/
  registry.json              # Top-level index of all collections
  collections/
    aura/                    # One directory per collection
      manifest.json          # Collection manifest with component list
      components/            # Component files (HTML, React, etc.)
        hero-gradient.html
        hero-gradient.tsx
        pricing-table.html
        ...
```

### registry.json

The top-level index file at `registry/registry.json`. It lists every registered collection with its metadata:

```json
{
  "version": "1.0.0",
  "collections": [
    {
      "name": "aura",
      "description": "UI components from aura.build — heroes, pricing, features, dashboards",
      "path": "./collections/aura",
      "source": "https://aura.build/components",
      "categories": ["hero", "pricing", "features", "dashboard", "cta", "section", "background"]
    }
  ]
}
```

### manifest.json Format

Each collection directory must contain a `manifest.json` describing its components:

```json
{
  "name": "aura",
  "version": "1.0.0",
  "source": "https://aura.build/components",
  "components": [
    {
      "id": "hero-gradient",
      "name": "Hero Gradient",
      "category": "hero",
      "tags": ["gradient", "landing", "dark", "animated"],
      "formats": {
        "html": "components/hero-gradient.html",
        "react": "components/hero-gradient.tsx"
      },
      "description": "Full-width hero section with animated gradient background and centered CTA"
    }
  ]
}
```

**Required fields per component:**
- `id` — unique identifier within the collection (kebab-case)
- `name` — human-readable display name
- `category` — primary category (must match one of the collection's categories)
- `tags` — array of searchable tags
- `formats` — object mapping format names (`html`, `react`) to relative file paths
- `description` — short description of the component

## Search Algorithm

When executing `/components search <query>`, results are ranked by relevance using a tiered matching strategy:

1. **Category exact match** (highest priority) — the query matches a component's `category` field exactly
2. **Tag match** — the query matches one or more entries in the component's `tags` array
3. **Name + description keyword match** (lowest priority) — the query appears as a substring in the component's `name` or `description`

Results are sorted by tier first (category > tag > keyword), then alphabetically within each tier. Components appearing in multiple tiers are deduplicated and placed at their highest-ranking tier.

## Adding a Collection

To add a new collection manually:

1. Create a directory under `registry/collections/<collection-name>/`
2. Write a valid `manifest.json` in that directory following the format spec above
3. Place component files in a `components/` subdirectory (or wherever the manifest paths point)
4. Add the collection entry to `registry/registry.json`

Or use `/components add <path>` which automates step 4 by reading the manifest and updating the registry.

## Integration

This skill is called by other design-studio skills:

- **design-to-code** — searches the registry to find existing components that match a design before generating new code
- **design-workflow** — uses the registry to suggest component reuse opportunities during multi-step design workflows

## Reading Component Code

To read a component's source code:

1. Use `/components info <collection>/<component-id>` to get the file paths for each format
2. The paths in the manifest are relative to the collection directory. Resolve the full path as: `registry/collections/<collection-name>/<format-path>`
3. Read the file at that resolved path to get the component source code (HTML, React, etc.)

For example, if the manifest lists `"html": "components/hero-gradient.html"` in the `aura` collection, the full path is `registry/collections/aura/components/hero-gradient.html`.
