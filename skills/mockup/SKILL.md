---
name: ottho-design_mockup
description: Create high-fidelity mockups using Pencil.dev. Use for the second phase of design — applying visual styling (colors, typography, spacing) to a wireframe structure. Triggers on /mockup.
---

# Mockup Skill

## Overview

Transform a wireframe into a polished high-fidelity mockup. This skill takes a structural layout (from the wireframe skill or a standalone description) and applies visual styling — colors, typography, spacing, imagery — to produce a production-ready design in Pencil.dev.

## Prerequisites

- **Pencil desktop app** running with MCP enabled (built-in server, no separate install required)
- If coming from the wireframe skill, have the section map and `.pen` file ready

## Process

### Step 1 — Determine Input

**Option A: From wireframe section map**
Use the section map produced by the wireframe skill as the structural foundation. Open the existing `.pen` file containing the wireframe layout.

**Option B: Standalone**
If no wireframe exists, start fresh:
- Ask the user to describe the page or provide an existing `.pen` file path
- Use `mcp__pencil__get_editor_state` to inspect the current editor context
- Use `mcp__pencil__open_document` to open the file or create a new one

### Step 2 — Gather Visual Direction

Ask the user ONE question at a time to establish the visual language:

1. **Brand mood** — What feeling should the design convey? (e.g., minimal & clean, bold & energetic, warm & organic, corporate & trustworthy)
2. **Color palette** — Does the user have brand colors? If not, propose a palette based on the mood. Confirm primary, secondary, accent, and neutral colors.
3. **Typography preference** — Serif, sans-serif, or mixed? Any specific font families? Confirm heading and body type choices.

Do not ask all three at once. Wait for each answer before proceeding to the next question.

### Step 3 — Build Mockup

Apply the visual direction to the wireframe structure using Pencil MCP tools:

1. **Open the document** — `mcp__pencil__open_document` to load the `.pen` file
2. **Load design guidelines** — `mcp__pencil__get_guidelines` to retrieve Pencil's built-in style guides and constraints
3. **Design section by section** — Use `mcp__pencil__batch_design` to apply styles to each section incrementally (colors, typography, spacing, border radius, imagery). Aim for 25 operations max per batch call.
4. **Capture progress** — Use `mcp__pencil__get_screenshot` after each major section to share visual progress with the user

Work top-to-bottom through the page sections. For each section:
- Apply background colors and container styles
- Set typography (font family, size, weight, line height, color)
- Add spacing (padding, margins, gaps)
- Insert imagery or placeholder images where needed
- Apply border radius and shadow treatments

### Step 4 — Design Review

Invoke the **design-system** skill to audit the mockup against all 6 design principles. Pay particular attention to:

- **WCAG contrast ratios** — Ensure all text/background combinations meet AA (4.5:1 for body, 3:1 for large text)
- **Type scale consistency** — Verify heading hierarchy follows a consistent modular scale
- **Spacing rhythm** — Confirm spacing values use a consistent base unit
- **Color usage** — Check that the palette is applied consistently across sections

Document any violations and fix them before presenting the final mockup.

### Step 5 — Iterate

Present the mockup screenshot to the user and ask for feedback:

- **Approve** — Finalize the design and generate outputs
- **Adjust** — Apply targeted changes via `mcp__pencil__batch_design` on specific sections
- **Restart visual direction** — If the overall direction is off, return to Step 2 and re-establish mood, colors, and typography

Repeat until the user approves.

## Output

Once approved, produce:

1. **`.pen` file** — The finalized Pencil design file
2. **Screenshot** — Full-page PNG capture via `mcp__pencil__get_screenshot`
3. **Design spec JSON** — Structured specification including:
   - `colors` — Primary, secondary, accent, neutral, background, text values
   - `typography` — Font families, sizes, weights, and line heights for each heading level and body text
   - `spacing_base` — Base spacing unit (e.g., 8px) and scale
   - `border_radius` — Border radius values used
   - `sections` — Per-section summary of styles applied

## Standalone Usage

This skill can be invoked independently with `/mockup` — no prior wireframe is required. In standalone mode, Step 1 Option B applies: describe the page you want to design or provide an existing `.pen` file, and the skill handles the rest.

## MCP Tools Used

| Tool | Purpose |
|---|---|
| `mcp__pencil__get_editor_state` | Check current editor context and active file |
| `mcp__pencil__open_document` | Open an existing `.pen` file or create a new one |
| `mcp__pencil__get_guidelines` | Load Pencil's built-in design guides and style constraints |
| `mcp__pencil__batch_design` | Apply insert/update/replace/delete/image operations in batches |
| `mcp__pencil__batch_get` | Retrieve nodes by pattern or ID for inspection |
| `mcp__pencil__get_screenshot` | Capture a screenshot of the current design state |
| `mcp__pencil__get_variables` | Read design variables (tokens) from the file |
| `mcp__pencil__set_variables` | Set or update design variables (tokens) in the file |
