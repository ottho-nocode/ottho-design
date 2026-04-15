# Charte Graphique — {{PROJECT_NAME}}

> Document genere par Ottho Design Studio. Reference visuelle pour tous les developpeurs et outils travaillant sur ce projet.

---

## Objectif du projet

{{OBJECTIVE}}

## Cible / Audience

{{AUDIENCE}}

## Contraintes

{{CONSTRAINTS}}

---

## Inspirations

{{INSPIRATIONS}}

---

## Palette de couleurs

| Role | Couleur | Hex | Usage |
|------|---------|-----|-------|
| Primary | {{PRIMARY_SWATCH}} | `{{PRIMARY}}` | CTA, liens, elements interactifs |
| Secondary | {{SECONDARY_SWATCH}} | `{{SECONDARY}}` | Backgrounds secondaires, accents subtils |
| Accent | {{ACCENT_SWATCH}} | `{{ACCENT}}` | Highlights, badges, elements d'attention |
| Background | {{BACKGROUND_SWATCH}} | `{{BACKGROUND}}` | Fond principal de la page |
| Text | {{TEXT_SWATCH}} | `{{TEXT}}` | Texte principal |
| Text Secondary | {{TEXT_SECONDARY_SWATCH}} | `{{TEXT_SECONDARY}}` | Texte secondaire, labels, placeholders |

### CSS Variables

```css
:root {
  --color-primary: {{PRIMARY}};
  --color-secondary: {{SECONDARY}};
  --color-accent: {{ACCENT}};
  --color-background: {{BACKGROUND}};
  --color-text: {{TEXT}};
  --color-text-secondary: {{TEXT_SECONDARY}};
}
```

---

## Typographie

| Element | Font | Taille | Poids | Line-height |
|---------|------|--------|-------|-------------|
| H1 | {{HEADING_FONT}} | 48px | 700 | 1.1 |
| H2 | {{HEADING_FONT}} | 32px | 600 | 1.2 |
| H3 | {{HEADING_FONT}} | 24px | 600 | 1.3 |
| H4 | {{HEADING_FONT}} | 20px | 500 | 1.3 |
| Body | {{BODY_FONT}} | 16px | 400 | 1.6 |
| Small | {{BODY_FONT}} | 14px | 400 | 1.5 |
| Caption | {{BODY_FONT}} | 12px | 400 | 1.4 |

### Echelle typographique

`12 / 14 / 16 / 20 / 24 / 32 / 48`

### Import

```html
<link href="https://fonts.googleapis.com/css2?family={{HEADING_FONT_URL}}:wght@400;500;600;700&family={{BODY_FONT_URL}}:wght@300;400;500;600&display=swap" rel="stylesheet">
```

---

## Espacement

**Base :** {{SPACING_BASE}}px

| Token | Valeur | Usage |
|-------|--------|-------|
| xs | 4px | Espacement entre icone et label |
| sm | 8px | Espacement intra-composant |
| md | 16px | Padding interne des cartes |
| lg | 24px | Espacement entre elements de section |
| xl | 32px | Espacement entre groupes |
| 2xl | 48px | Padding de section |
| 3xl | 64px | Espacement entre sections |
| 4xl | 96px | Grandes separations visuelles |

---

## Composants de base

### Boutons

| Variante | Background | Texte | Border | Usage |
|----------|-----------|-------|--------|-------|
| Primary | `{{PRIMARY}}` | `#fff` | aucun | Action principale (CTA) |
| Secondary | `{{SECONDARY}}` | `#fff` | aucun | Action secondaire |
| Accent | `{{ACCENT}}` | `#000` | aucun | Highlight, promotion |
| Outline | transparent | `{{TEXT}}` | `1px solid #444` | Action tertiaire |
| Ghost | transparent | `{{TEXT_SECONDARY}}` | aucun | Navigation, actions mineures |

```css
.btn {
  padding: 12px 24px;
  border-radius: {{BORDER_RADIUS}};
  font-family: var(--font-body);
  font-size: 14px;
  font-weight: 500;
  transition: all 0.2s;
}
```

### Cartes

```css
.card {
  background: {{CARD_BACKGROUND}};
  border: 1px solid {{CARD_BORDER}};
  border-radius: {{BORDER_RADIUS}};
  padding: 24px;
}
```

### Inputs

```css
.input {
  background: {{INPUT_BACKGROUND}};
  border: 1px solid {{INPUT_BORDER}};
  border-radius: {{BORDER_RADIUS}};
  padding: 10px 14px;
  color: {{TEXT}};
  font-size: 14px;
}
.input:focus {
  border-color: {{PRIMARY}};
}
```

---

## Layout

- **Mode :** {{LAYOUT_MODE}}
- **Border radius :** {{BORDER_RADIUS}}
- **Ombres :** {{SHADOWS}}

{{LAYOUT_CSS}}

---

## Images

- **Densite :** {{IMAGE_DENSITY}}
- **Type :** {{IMAGE_TYPE}}
- **Source :** {{IMAGE_SOURCE}}

{{IMAGE_GUIDELINES}}

---

## Ambiance

{{MOOD_DESCRIPTION}}

Mots-cles : {{MOOD_KEYWORDS}}

---

## Structure de la page

{{SECTIONS_LIST}}

---

## Regles design-system

Les 6 principes appliques automatiquement :

1. **Hierarchie visuelle** — Un element dominant par ecran, ratio 1.25x entre niveaux de titres
2. **Espacement** — Echelle 4px, rythme vertical coherent, loi de proximite
3. **Couleur** — Max 3 familles de teintes, contraste WCAG AA (4.5:1 texte, 3:1 grands textes)
4. **Typographie** — Max 2 familles, echelle modulaire, corps 16px min, max 65-75 caracteres/ligne
5. **Layout** — Grille 8px ou 12 colonnes, alignement gauche par defaut
6. **Responsive** — Mobile-first 375px, breakpoints 640/768/1024/1280, touch targets 44x44px

---

*Genere le {{DATE}} par [Ottho Design Studio](https://github.com/ottho-nocode/ottho-design)*
