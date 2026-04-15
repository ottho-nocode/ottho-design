---
name: design-workflow
description: Orchestrate the complete design pipeline from wireframe to code. Chains wireframe (Frame0) → mockup (Pencil.dev) → component matching → code generation with design critique at every stage. Triggers on /design.
---

# Design Workflow — Full Pipeline Orchestrator

## Overview

Run the complete design-to-code pipeline step by step. Each phase produces output that feeds the next. The user validates at every transition, ensuring no phase advances without explicit approval.

## Trigger

`/design`

## Pipeline

```
/design
  ├─ Phase 0: BRIEF — gather context
  ├─ Phase 1: WIREFRAME → invoke wireframe skill
  │   → design-system reviews → user validates → section map
  ├─ Phase 2: MOCKUP → invoke mockup skill
  │   → design-system reviews → user validates → design spec
  ├─ Phase 3: COMPONENT MATCHING → query component-registry per section
  │   → side-by-side comparison → user chooses per section → component map
  ├─ Phase 4: CODE → invoke design-to-code skill
  │   → uses component map → design-system reviews → user validates
  └─ DONE: files saved
```

---

## Phase 0: Brief

Before any design work begins, gather the project context. Ask the user **one question at a time** — do not present a form or checklist.

Questions to cover:

1. **What are you building?** — Page type, feature, or component (e.g., "SaaS landing page," "pricing dashboard," "onboarding wizard")
2. **Who is the audience?** — Target users, their technical level, expectations
3. **Existing brand or style?** — Colors, fonts, mood references, existing design system, or "start from scratch"
4. **Primary goal** — The single most important outcome for this page (e.g., "get signups," "explain pricing," "reduce support tickets")

Store the answers in the pipeline state (see State Management below) and reference them throughout all subsequent phases. The brief is the source of truth for every design decision.

---

## Phase 3: Component Matching

After the mockup is validated, match each mockup section against the component registry before generating code.

### Process

1. **Extract sections** — Parse the mockup's section list (from `mockup.design_spec.sections` or the wireframe `section_map`).
2. **Query registry** — For each section, run `/components search <section-type>` to find candidate Aura components. Retrieve the top 3 matches per section.
3. **Side-by-side comparison** — Present the user with a comparison for each section:
   - Left: the user's mockup section (screenshot or design spec excerpt)
   - Right: the proposed Aura component (screenshot, code preview, or live preview link)
   - Include fit assessment (excellent / partial / low) and key differences.

4. **User decision per section** — For each section, offer exactly three choices:
   - **Use Aura component** — The registry component will be adapted to the design spec in Phase 4.
   - **Keep my design** — The section will be generated from scratch in Phase 4, following the mockup exactly.
   - **Skip** — The section is excluded from the final output entirely.

5. **Build the component map** — Assemble a mapping that records each section's decision:

```json
{
  "hero": { "decision": "use_registry", "component": "aura/hero-gradient", "collection": "aura", "component_id": "hero-gradient" },
  "features": { "decision": "keep_custom" },
  "pricing": { "decision": "use_registry", "component": "aura/pricing-table", "collection": "aura", "component_id": "pricing-table" },
  "cta": { "decision": "skip" },
  "footer": { "decision": "keep_custom" }
}
```

6. **Save to state** — Write the component map to `component_matching.component_map` and set `component_matching.approved = true` after the user confirms the full map. This component map feeds directly into Phase 4 (Code Generation).

---

## Phase Transitions

At the boundary between every phase, execute this sequence:

1. **Design-system critique** — Invoke the **design-system** skill to audit the current phase's output against all 6 design principles. Collect the diagnostic table and top 3 priority fixes. (For Phase 3 — Component Matching — the design-system critique is not applicable; the user validates the component map directly.)
2. **Present results** — Show the user the phase output (section map, screenshot, component map, or code) alongside the design-system critique.
3. **Ask for decision** — Offer exactly three options:
   - **Approve** — Accept the output and advance to the next phase. Pass the output as input to the next skill.
   - **Adjust** — Apply specific changes based on user feedback, then re-run the design-system critique and present again.
   - **Restart phase** — Discard the current phase output and start it over from the beginning.

Do not auto-advance. The user must explicitly approve before moving on.

---

## Skip Phases

The pipeline supports selective phase skipping:

### Flags

- `--skip-wireframe` — Skip Phase 1 entirely. Phase 2 (mockup) starts from the brief alone (standalone mode).
- `--skip-mockup` — Skip Phase 2 entirely. Phase 3 (component matching) receives the wireframe section map directly, without a high-fidelity mockup.
- `--skip-matching` — Skip Phase 3 (component matching) entirely. Phase 4 (code) proceeds without a pre-built component map — the design-to-code skill will search the registry itself during code generation.

Flags can be combined: `/design --skip-wireframe --skip-mockup` goes directly from brief to component matching then code. `/design --skip-wireframe --skip-mockup --skip-matching` goes directly from brief to code generation.

### Direct entry via individual skills

Each skill can be invoked independently, bypassing the orchestrator:

- `/wireframe` — Run only the wireframe phase (standalone mode)
- `/mockup` — Run only the mockup phase (standalone mode)
- `/design-to-code` — Run only the code generation phase

When invoked standalone, skills handle their own input gathering (see each skill's "Standalone Usage" section).

---

## MCP Availability

Check MCP server availability **at the start** of the pipeline, before Phase 0 completes. Adapt the pipeline gracefully — never block the user.

| Scenario | Behavior |
|---|---|
| Frame0 available, Pencil available | Full pipeline: wireframe → mockup → code |
| Frame0 **not** available, Pencil available | Skip wireframe automatically. Inform user, proceed to mockup (standalone mode) → code |
| Frame0 available, Pencil **not** available | Wireframe → skip mockup automatically. Pass section map directly to code generation |
| Neither available | Skip wireframe and mockup. Proceed directly to component-based code generation using design-system guidance and component-registry for reuse. Inform the user that the design phase is manual/conceptual only |

When a server is unavailable, print a clear message:

> **Frame0 non disponible** — la phase wireframe sera ignoree. Le design commencera par le mockup haute-fidelite.

or

> **Pencil non disponible** — la phase mockup sera ignoree. Le code sera genere directement depuis la structure wireframe.

Never error out. Never ask the user to fix MCP configuration mid-pipeline (they can restart later if needed).

---

## State Management

Maintain a JSON state object that persists between phases. This enables resume capability if the session is interrupted.

### State Structure

```json
{
  "brief": {
    "type": "SaaS landing page",
    "audience": "Startup founders, non-technical",
    "style": "Minimal, modern, dark mode",
    "goal": "Drive free trial signups"
  },
  "wireframe": {
    "section_map": {
      "page_type": "landing",
      "sections": [
        { "id": "hero", "type": "hero", "priority": 1, "content": "...", "layout": "..." }
      ]
    },
    "approved": true
  },
  "mockup": {
    "design_spec": {
      "colors": { "primary": "#2563EB", "secondary": "#1E293B" },
      "typography": { "heading": "Inter", "body": "Inter" },
      "spacing_base": "8px"
    },
    "pen_file": "./output/landing-page.pen",
    "approved": true
  },
  "component_matching": {
    "component_map": {
      "hero": { "decision": "use_registry", "component": "aura/hero-gradient", "collection": "aura", "component_id": "hero-gradient" },
      "features": { "decision": "keep_custom" },
      "pricing": { "decision": "use_registry", "component": "aura/pricing-table", "collection": "aura", "component_id": "pricing-table" },
      "cta": { "decision": "keep_custom" },
      "footer": { "decision": "keep_custom" }
    },
    "approved": true
  },
  "code": {
    "format": "both",
    "output_dir": "./output"
  },
  "meta": {
    "current_phase": "component_matching",
    "mcp_available": { "frame0": true, "pencil": true },
    "started_at": "2026-04-15T10:00:00Z",
    "updated_at": "2026-04-15T10:35:00Z"
  }
}
```

### Persistence

- Save to `.design-studio-state.json` in the project directory after every phase transition and every approval.
- On `/design` invocation, check for an existing state file. If found, ask the user:
  - **Resume** — Continue from the last completed phase
  - **Start fresh** — Discard the state and begin from Phase 0

### Phase data flow

Each phase reads from the previous phase's state and writes its own output:

- **Phase 1** reads `brief` → writes `wireframe.section_map`
- **Phase 2** reads `brief` + `wireframe.section_map` → writes `mockup.design_spec` + `mockup.pen_file`
- **Phase 3** reads `brief` + `wireframe.section_map` + `mockup.design_spec` → writes `component_matching.component_map`
- **Phase 4** reads `brief` + `wireframe.section_map` + `mockup.design_spec` + `component_matching.component_map` → writes `code.output_dir` with generated files

---

## Skill Invocation Reference

| Phase | Skill invoked | Input from state | Output to state |
|---|---|---|---|
| 0 | (none — direct conversation) | — | `brief` |
| 1 | **wireframe** | `brief` | `wireframe.section_map` |
| review | **design-system** | wireframe output | diagnostic + fixes |
| 2 | **mockup** | `brief` + `wireframe.section_map` | `mockup.design_spec`, `mockup.pen_file` |
| review | **design-system** | mockup output | diagnostic + fixes |
| 3 | **component-registry** | `mockup.design_spec` sections | `component_matching.component_map` |
| 4 | **design-to-code** | `brief` + `wireframe` + `mockup` + `component_matching.component_map` | generated files in `code.output_dir` |
| review | **design-system** | generated code | diagnostic + fixes |

---

## Example Session

```
User: /design

  [Phase 0 — Brief]
  Agent: What are you building?
  User: A landing page for a SaaS product
  Agent: Who is the target audience?
  User: Startup founders, non-technical
  Agent: Do you have existing brand guidelines or should we start from scratch?
  User: Start from scratch, modern and minimal
  Agent: What is the primary goal of this page?
  User: Drive free trial signups
  → State saved: brief complete

  [Phase 1 — Wireframe]
  Agent: Invoking wireframe skill with brief context...
  → Frame0 generates wireframe
  → design-system reviews: OK / OK / n/a / OK / OK / n/a
  Agent: Here is the wireframe and design review. Approve / Adjust / Restart?
  User: Approve
  → State saved: wireframe.approved = true

  [Phase 2 — Mockup]
  Agent: Invoking mockup skill with section map...
  → Pencil generates high-fidelity mockup
  → design-system reviews: OK / WARN / OK / OK / OK / OK
  Agent: Spacing rhythm has a minor issue — fixing automatically.
  Agent: Here is the mockup and design review. Approve / Adjust / Restart?
  User: Approve
  → State saved: mockup.approved = true

  [Phase 3 — Component Matching]
  Agent: Searching component-registry for each mockup section...
  → hero: found hero-gradient (92% match), hero-split (70%), hero-minimal (55%)
  → features: found feature-grid (80%), feature-cards (65%)
  → pricing: found pricing-table (85%), pricing-toggle (60%)
  → cta: no strong match found
  → footer: found footer-minimal (50%)
  Agent: Side-by-side comparison for each section:
    hero — Your mockup vs hero-gradient (aura): excellent fit. Use Aura / Keep my design / Skip?
  User: Use Aura component
    features — Your mockup vs feature-grid (aura): partial fit. Use Aura / Keep my design / Skip?
  User: Keep my design
    pricing — Your mockup vs pricing-table (aura): excellent fit. Use Aura / Keep my design / Skip?
  User: Use Aura component
    cta — No registry match. Keep my design / Skip?
  User: Keep my design
    footer — Your mockup vs footer-minimal (aura): low fit. Use Aura / Keep my design / Skip?
  User: Keep my design
  → Component map built: hero=registry, features=custom, pricing=registry, cta=custom, footer=custom
  Agent: Here is the component map. Approve / Adjust / Restart?
  User: Approve
  → State saved: component_matching.approved = true

  [Phase 4 — Code]
  Agent: Invoking design-to-code with design spec + component map...
  → hero: adapting aura/hero-gradient to design spec
  → features: generating from scratch per mockup
  → pricing: adapting aura/pricing-table to design spec
  → cta: generating from scratch per mockup
  → footer: generating from scratch per mockup
  → Code generated in ./output/
  → design-system reviews final code: OK across all 6 principles
  Agent: Here is the generated code and final review. Approve / Adjust / Restart?
  User: Approve
  → Files saved to ./output/
  → State saved: pipeline complete

  DONE
```