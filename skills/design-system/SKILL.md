---
name: ottho-design_review
description: Critique and improve UI designs using fundamental design principles. Use when reviewing screenshots, mockups, or code for visual quality. Triggers on /design-review or when asked to improve a design.
---

# Design System — Core Design Critique Engine

Analyse any UI (screenshot, mockup, or code) against 6 fundamental design principles.
Return a structured diagnostic with actionable fixes.

---

## How to use this skill

1. The user provides a screenshot, a mockup image, a URL, or a code snippet of a UI.
2. Evaluate the UI against **all 6 principles** below.
3. Output the **diagnostic table** followed by the **top 3 priority fixes**.

---

## The 6 Design Principles

### 1. Visual Hierarchy

Every screen must have one dominant element that draws the eye first.

**Rules:**
- One dominant element per screen — the primary headline or hero visual.
- Maintain a **1.25x minimum size ratio** between consecutive heading levels (e.g. H1 40px, H2 32px, H3 24px).
- The **primary CTA** must carry the highest visual weight on the page (size, color, contrast, whitespace).
- Secondary actions must be visually subordinate — lighter weight, smaller size, ghost/outline style, or muted color.
- Decorative elements must never compete with the primary CTA or headline.

**Quick check:** Can you identify the #1 action the user should take within 2 seconds of looking at the screen? If not, hierarchy fails.

---

### 2. Spacing & Rhythm

Consistent spacing creates order and communicates relationships between elements.

**Rules:**
- Use a **4px base scale**: 4, 8, 12, 16, 24, 32, 48, 64, 96. Every spacing value must land on this scale.
- **Equal spacing** between sibling elements within the same section.
- **Law of Proximity**: related items must be closer together than unrelated items. The gap between groups must be visibly larger than the gap within a group.
- **Padding inside a container >= spacing between its children.** A card with 12px gap between children needs at least 12px internal padding (16px or more preferred).
- Section separators (if used) should be reinforced by spacing, not replace it.

**Quick check:** Cover all labels and text. Can you still see logical groupings from spacing alone? If everything looks equidistant, rhythm fails.

---

### 3. Color

Color communicates meaning, establishes brand, and drives contrast.

**Rules:**
- **Max 3 hue families** (e.g. blue primary, amber accent, red error). Neutrals (gray, white, black) do not count.
- **WCAG AA contrast ratios**: 4.5:1 for normal text (< 18px), 3:1 for large text (>= 18px bold or >= 24px regular).
- **Semantic consistency**: one color = one meaning across the entire interface. If blue means "primary action," do not also use blue for informational badges without clear differentiation.
- Use **max 2-3 neutral shades** (e.g. gray-100, gray-500, gray-900). More than 3 neutrals creates visual noise.
- Background/surface layers should use subtle shade differences (not competing saturated colors).

**Quick check:** Convert the design to grayscale. Does the visual hierarchy still hold? If elements that should stand out disappear, color usage fails.

---

### 4. Typography

Typography is the backbone of any interface. Discipline here multiplies clarity.

**Rules:**
- **Max 2 font families** — one for headings, one for body (or a single family for both).
- Use a **modular type scale**: 14, 16, 20, 24, 32, 40, 48 (px). Avoid arbitrary sizes like 15px or 22px.
- **Body text minimum 16px**, line-height **1.4 - 1.6**.
- **Heading line-height 1.1 - 1.3** (tighter than body).
- **Max 65-75 characters per line** for body text. Wider lines degrade readability.
- Font weight should reinforce hierarchy: bold (600-700) for headings, regular (400) for body, medium (500) for emphasis or labels.

**Quick check:** Squint at the page. Can you count more than 4 distinct text sizes? If yes, the type scale is too loose.

---

### 5. Layout & Alignment

Alignment is the invisible scaffolding that makes a design feel "right."

**Rules:**
- Use an **8px grid** or a **12-column grid** for page layout. All elements should snap to the grid.
- **Left-align by default** — centered text is reserved for headings, hero sections, or intentionally short blocks.
- **No orphan elements**: every item must visually belong to a group or column. Nothing should float unanchored.
- **Consistent content width**: the main content container should have a single max-width (e.g. 1200px, 1280px) used across all pages/sections.
- Margins and gutters between columns must be equal.

**Quick check:** Draw vertical lines through the design. Do element edges snap to a small number of consistent lines? If edges are scattered, alignment fails.

---

### 6. Responsive

The design must work across devices, mobile-first.

**Rules:**
- **Mobile-first baseline**: design for **375px** width first.
- **Breakpoints**: 640px (sm), 768px (md), 1024px (lg), 1280px (xl). Avoid custom breakpoints unless justified.
- Horizontal layouts must **stack vertically on mobile** (flex-col / single column).
- **Touch targets minimum 44x44px** (Apple HIG / WCAG 2.5.5). Buttons, links, and interactive elements must meet this.
- Images and media must be fluid (`max-width: 100%`) — no horizontal overflow.
- Navigation must collapse to a hamburger or bottom bar at mobile breakpoints.
- Font sizes may scale down on mobile but never below 14px for body text.

**Quick check:** Does the page work at 375px width without horizontal scroll, with all targets easily tappable? If not, responsive fails.

---

## Output Format

After evaluating the UI against all 6 principles, produce:

### Diagnostic Table

| Principle | Score | Issue | Fix |
|---|---|---|---|
| Visual Hierarchy | OK / WARN / FAIL | Description of the issue (or "None" if OK) | Concrete fix recommendation |
| Spacing & Rhythm | OK / WARN / FAIL | ... | ... |
| Color | OK / WARN / FAIL | ... | ... |
| Typography | OK / WARN / FAIL | ... | ... |
| Layout & Alignment | OK / WARN / FAIL | ... | ... |
| Responsive | OK / WARN / FAIL | ... | ... |

**Scoring:**
- **OK** — Principle is fully respected. No issues found.
- **WARN** — Minor violation that does not break usability but should be improved.
- **FAIL** — Clear violation that harms usability, accessibility, or visual coherence. Must be fixed.

### Top 3 Priority Fixes

After the table, list the **3 most impactful fixes** in priority order:

1. **[Principle name]** — What to change and why it matters most.
2. **[Principle name]** — What to change and why.
3. **[Principle name]** — What to change and why.

Priority is determined by: FAIL > WARN, accessibility impact > aesthetic impact, and fixes that cascade (improving one principle improves others).

---

## Integration

This skill is the **foundational design critique engine** used by other design-studio skills:

- **wireframe** — calls design-system to validate layout, spacing, and hierarchy before moving to high-fidelity.
- **mockup** — calls design-system to review color, typography, and visual hierarchy of the finished mockup.
- **design-to-code** — calls design-system to verify the coded implementation preserves the design intent (spacing, alignment, responsive behavior).
- **design-workflow** — orchestrates the full pipeline (wireframe -> mockup -> code) and invokes design-system as a quality gate at each stage.

When invoked by these skills, the diagnostic table and priority fixes are returned to the calling skill for decision-making (e.g. auto-fix, prompt the user, or block progression).
