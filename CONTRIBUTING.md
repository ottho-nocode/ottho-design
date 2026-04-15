# Contributing to Design Studio

Thanks for your interest in contributing. This guide covers the main ways to extend and improve the plugin.

---

## Adding a Component Collection

Component collections live in `registry/collections/`. Each collection has its own directory with a manifest and component files.

### Step-by-step

1. **Create the collection directory:**

   ```bash
   mkdir -p registry/collections/<your-collection>/components
   ```

2. **Create `manifest.json`** at the root of your collection directory:

   ```json
   {
     "name": "your-collection",
     "version": "1.0.0",
     "source": "https://example.com",
     "components": [
       {
         "id": "01-component-name",
         "name": "Component Name",
         "category": "hero",
         "description": "Short description of the component",
         "tags": ["tailwind", "animated", "gsap"],
         "formats": {
           "html": "html/index.html",
           "react": "react/component-name.tsx"
         }
       }
     ]
   }
   ```

   **Field reference:**

   | Field | Required | Description |
   |---|---|---|
   | `id` | Yes | Unique identifier, kebab-case. Prefix with a number for ordering (e.g., `01-hero-section`) |
   | `name` | Yes | Human-readable name |
   | `category` | Yes | One of: `hero`, `pricing`, `features`, `dashboard`, `cta`, `section`, `background`, `navigation`, `footer`, or a new category |
   | `description` | Yes | Short description used for search matching |
   | `tags` | Yes | Array of technology/style tags (e.g., `tailwind`, `gsap`, `webgl`, `animated`) |
   | `formats` | Yes | Object mapping format names to file paths relative to the component directory |

3. **Add component files.** Each component gets its own subdirectory:

   ```
   registry/collections/your-collection/
     manifest.json
     components/
       01-component-name/
         html/
           index.html
         react/
           component-name.tsx
   ```

   You can support one or both formats. Format paths in `manifest.json` are relative to the component subdirectory.

4. **Register the collection** in `registry/registry.json`:

   ```json
   {
     "version": "1.0.0",
     "collections": [
       {
         "name": "your-collection",
         "description": "Brief description of the collection",
         "path": "./collections/your-collection",
         "source": "https://example.com",
         "categories": ["hero", "pricing", "features"]
       }
     ]
   }
   ```

5. **Test** that your components are discoverable:

   ```
   /components list your-collection
   /components search hero
   /components info your-collection:01-component-name
   ```

---

## Improving Design Principles

The design critique engine lives in `skills/design-system/SKILL.md`. It evaluates UI output against 6 principles: Visual Hierarchy, Spacing & Rhythm, Color, Typography, Layout & Alignment, and Responsive.

### Adding or updating a rule

1. Open `skills/design-system/SKILL.md`.
2. Find the principle section you want to improve.
3. Add your rule under the **Rules** list. Each rule should be:
   - Concrete and verifiable (not vague guidelines)
   - Expressed as a constraint with a measurable threshold when possible
4. Include a **before/after example** to make the rule unambiguous:

   ```markdown
   **Rule:** Card padding must be at least equal to the gap between card children.

   Before (FAIL):
   - Card has 8px padding, 16px gap between children
   - Content feels cramped against card edges

   After (OK):
   - Card has 16px padding, 16px gap between children
   - Balanced whitespace inside and between elements
   ```

5. Update the **Quick check** if your rule changes what reviewers should look for at a glance.

---

## Submitting a New Skill

Skills are self-contained SKILL.md files that Claude Code loads as behavioral instructions.

### Structure

```
skills/
  your-skill/
    SKILL.md
```

### SKILL.md format

```markdown
---
name: your-skill
description: One sentence explaining what it does and when it triggers.
---

# Skill Title

## Overview
What the skill does and why it exists.

## Trigger
The slash command(s) that invoke this skill.

## Instructions
Step-by-step behavior Claude should follow.

## Integration
How this skill connects to other design-studio skills (if applicable).
```

### Checklist for new skills

- [ ] The skill has a clear, single responsibility
- [ ] The trigger command does not conflict with existing commands
- [ ] The SKILL.md frontmatter includes `name` and `description`
- [ ] The skill documents its standalone usage (in case it is invoked outside the pipeline)
- [ ] If the skill depends on an MCP server, it handles the "server unavailable" case gracefully
- [ ] The skill is registered in `plugin.json` under the `skills` array

---

## Pull Request Guidelines

1. **One concern per PR.** A new collection, a design principle update, or a new skill -- not all three at once.
2. **Describe the change.** Explain what you changed and why. For design principle changes, include the before/after example in the PR description.
3. **Test your changes.** Run the relevant slash commands and confirm they work as expected. Include a brief summary of what you tested.
4. **Keep files small.** Component HTML/React files should be self-contained. Avoid adding build steps or external dependencies that require installation.
5. **Follow existing patterns.** Look at the aura collection and existing skills for naming conventions, directory structure, and manifest format.
