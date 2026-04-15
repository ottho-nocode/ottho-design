---
name: design-to-code
description: Generate production code from mockups by matching and adapting components from the registry. Use for the final phase of design — turning a validated mockup into HTML/React code. Triggers on /design-to-code.
---

# Design to Code — Component-Based Code Generation

Take a validated mockup and generate production code by matching sections to registry components, adapting them to the design spec, and assembling the final page.

---

## Prerequisites

- **Component registry** with at least one registered collection (see `/components list` to verify).
- **Design spec** from the mockup phase (design spec JSON with palette, typography, spacing, sections) **or** a screenshot/description of the target design.

---

## Process

### Step 1: Identify Sections

Extract the list of page sections from the design source:

- **If a design spec JSON is available** (from the mockup skill): parse the `sections` array directly. Each entry has a type, content summary, and layout notes.
- **If no spec is available**: ask the user to describe the page or provide a screenshot, then identify section types manually.

Recognized section types: `hero`, `features`, `pricing`, `cta`, `footer`, `header`, `testimonials`, `faq`, `stats`, `process`, `team`, `gallery`, `contact`, `dashboard`, `background`.

Output a numbered section list for the user to confirm before proceeding:

```
Sections identified:
1. hero — Full-width hero with headline, subtitle, and CTA
2. features — Three-column feature grid with icons
3. pricing — Two-tier pricing table
4. cta — Final call-to-action banner
5. footer — Minimal footer with links and copyright
```

---

### Step 2: Match Components

For each section identified in Step 1, query the component registry:

1. Run `/components search <section-type>` to find candidates.
2. Present the **top 3 matches** to the user for each section:

```
Section 1 — hero:
  A) hero-gradient (aura) — Full-width hero with animated gradient background and centered CTA. Fit: excellent — matches dark theme + centered layout.
  B) hero-split (aura) — Hero with left text / right image split. Fit: partial — layout differs but typography matches.
  C) hero-minimal (aura) — Clean hero with large headline, no background. Fit: low — too minimal for the spec.
  → Choose A, B, C, or S to skip (generate from scratch):
```

3. The user picks a component for each section or skips (S) to have the code generated from scratch.

---

### Step 3: Adapt Components

For each chosen component, read the source code and adapt it to the design spec:

1. **Read the component code** — resolve the file path via the manifest (`/components info <collection>/<component-id>`) and read the HTML or React source.
2. **Replace colors** — swap the component's existing color values with the design palette (primary, secondary, accent, neutrals). Preserve opacity and gradient structures.
3. **Update typography** — match font families, sizes, weights, and line-heights to the design spec's type scale.
4. **Modify content** — replace placeholder text, images, and icons with the actual content from the design spec or user input.
5. **Adjust spacing** — update padding, margins, and gaps to match the design spec's spacing scale (4px base: 4, 8, 12, 16, 24, 32, 48, 64, 96).
6. **Keep animations intact** — preserve any existing CSS animations, transitions, JS-based effects (Vanta.js, WebGL, GSAP), or Tailwind animation classes. Only modify animation parameters if the design spec explicitly requires changes.

For skipped sections (user chose S), generate the code from scratch following the design spec and the design-system principles.

---

### Step 4: Assemble

Combine all adapted sections into a complete page:

**HTML output:**
```html
<!DOCTYPE html>
<html lang="fr">
<head>
  <meta charset="UTF-8">
  <meta name="viewport" content="width=device-width, initial-scale=1.0">
  <title>Page Title</title>
  <!-- Tailwind CDN or inline styles -->
  <!-- Google Fonts if specified in design spec -->
</head>
<body>
  <!-- Section 1: Hero -->
  ...
  <!-- Section 2: Features -->
  ...
  <!-- Section N: Footer -->
  ...
</body>
</html>
```

**React output:**
```tsx
// page.tsx — Page component importing section components
import { Hero } from "./sections/Hero";
import { Features } from "./sections/Features";
import { Pricing } from "./sections/Pricing";
import { Cta } from "./sections/Cta";
import { Footer } from "./sections/Footer";

export default function Page() {
  return (
    <>
      <Hero />
      <Features />
      <Pricing />
      <Cta />
      <Footer />
    </>
  );
}
```

Each section is saved as a separate component file under a `sections/` directory. The page component imports and composes them.

---

### Step 5: Design Review

Before finalizing, invoke the **design-system** skill to run a full design critique on the assembled output:

1. Evaluate all **6 principles**: Visual Hierarchy, Spacing & Rhythm, Color, Typography, Layout & Alignment, Responsive.
2. Produce the diagnostic table and top 3 priority fixes.
3. **Verify design intent**: compare the coded output against the original mockup/spec to ensure the implementation faithfully reproduces the design — check that colors, spacing, typography, and layout match.
4. If any principle scores **FAIL**, apply the recommended fix and re-review until all principles pass or reach WARN.
5. Present the final diagnostic to the user with any remaining WARN items noted.

---

### Step 6: Output

Save the generated code to the project directory:

1. Ask the user for the target output directory (default: current working directory).
2. Write the files:
   - **HTML**: single `index.html` file (or `<page-name>.html`).
   - **React**: `page.tsx` + `sections/<SectionName>.tsx` for each section.
   - **Both**: create both outputs in separate subdirectories (`html/` and `react/`).
3. Report the list of files created with their paths.

---

## Output Format Choice

Before starting Step 3, ask the user which output format they want:

- **HTML only** — single self-contained HTML file with embedded styles
- **React only** — page component + individual section components (TSX)
- **Both** — generate both HTML and React versions

This choice determines which component format to read from the registry (HTML or React) and how the final assembly is structured.

---

## Standalone Usage

This skill can be invoked independently via `/design-to-code` without going through the full design-workflow pipeline. When used standalone:

- If no design spec is available, the skill will ask the user to describe the page or provide a screenshot.
- If the component registry is empty, the skill will generate all sections from scratch (Step 2 is skipped, Step 3 generates all code manually).
- The design-system review (Step 5) is always performed regardless of how the skill was invoked.

---

## Integration

This skill is part of the **design-studio** plugin pipeline:

- **component-registry** — queried in Step 2 to find matching components for each section.
- **design-system** — invoked in Step 5 to validate the final output against the 6 design principles.
- **mockup** — provides the design spec JSON that feeds into Step 1 (section identification).
- **design-workflow** — orchestrates the full pipeline and calls design-to-code as the final code generation phase.
