---
name: ottho-design_wireframe
description: Create low-fidelity wireframes using Frame0. Use for the first phase of design work — structuring page layout and information hierarchy before visual design. Triggers on /wireframe.
---

# Wireframe Skill

## Overview

Create low-fidelity wireframes focused on **structure**, **information hierarchy**, and **user flow**. Wireframes are grayscale by design — no colors, no visual polish. The goal is to nail layout, content ordering, and interaction patterns before moving to high-fidelity mockups.

## Prerequisites

- **Frame0 MCP server** configured and running (see `mcp/frame0-config.json`)
- **Frame0 desktop app** v1.0.0-beta.17 or later installed and open

## Process

### Step 1: Gather Requirements

Ask the user **ONE question at a time** to understand the page they need. Do not overwhelm with a full questionnaire — keep it conversational.

Questions to cover (in order):

1. **Page type** — What kind of page is this? (landing page, dashboard, form, settings, profile, etc.)
2. **Key sections** — What are the main content blocks or sections needed?
3. **Primary action** — What is the single most important action a user should take on this page?
4. **Content priority** — Which content is most important? Rank the sections from highest to lowest priority.

Move to Step 2 once you have enough context to produce a meaningful wireframe.

### Step 2: Create Wireframe

Using Frame0 MCP tools, build the wireframe in the desktop app. Follow these principles:

- **Gray boxes** for content blocks — no colors, no imagery
- **Placeholder text** for headings and body copy (use realistic lengths)
- **Section ordering** reflects the content priority from Step 1
- **Content grouping** — related elements are visually grouped together
- **CTA placement** — the primary action is prominent and positioned according to the page type's conventions
- **Whitespace** — generous spacing between sections to establish visual hierarchy

### Step 3: Design Review

Invoke the **design-system** skill to critique the wireframe. The review focuses on:

- Information hierarchy — is the most important content the most prominent?
- Spacing and rhythm — are sections properly separated?
- Layout consistency — do alignment and grid usage feel intentional?
- CTA visibility — can the user immediately identify the primary action?

Address any feedback before proceeding.

### Step 4: Iterate

Present the wireframe to the user with three options:

- **Approve** — finalize the wireframe and output the section map JSON (see Output below)
- **Adjust** — make specific changes based on user feedback, then re-review
- **Restart** — discard and start over from Step 1 if the direction is wrong

## Output

When the wireframe is approved, produce a **section map JSON** summarizing the page structure:

```json
{
  "page_type": "landing",
  "sections": [
    {
      "id": "hero",
      "type": "hero",
      "priority": 1,
      "content": "Main headline, subheadline, primary CTA button",
      "layout": "centered, full-width"
    },
    {
      "id": "features",
      "type": "feature-grid",
      "priority": 2,
      "content": "3 feature cards with icon, title, description",
      "layout": "3-column grid"
    },
    {
      "id": "cta-bottom",
      "type": "cta",
      "priority": 3,
      "content": "Secondary CTA with supporting text",
      "layout": "centered, contained"
    }
  ]
}
```

This JSON serves as the contract between the wireframe phase and subsequent design/development phases.

## Standalone Usage

This skill can be used independently via `/wireframe`. No other skills are required to run the wireframe process, though the design-system skill is recommended for Step 3 review.

## MCP Tools Used

The following Frame0 MCP tools are available (all prefixed `mcp__frame0__`):

- `mcp__frame0__create_wireframe` — create a new wireframe document
- `mcp__frame0__add_element` — add an element (box, text, button, etc.) to the canvas
- `mcp__frame0__update_element` — modify properties of an existing element
- `mcp__frame0__delete_element` — remove an element from the canvas
- `mcp__frame0__get_wireframe` — retrieve the current wireframe state
- `mcp__frame0__export_wireframe` — export the wireframe as an image or JSON
- `mcp__frame0__list_templates` — list available wireframe templates
- `mcp__frame0__apply_template` — apply a template to the current wireframe
