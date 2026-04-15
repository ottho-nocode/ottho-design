---
name: ottho-design_workflow
description: Orchestrate the complete design pipeline from brief to refined code. 10-step methodology — brief → inspirations → design system → wireframe (Frame0) → mockup (Pencil.dev) → code → refinement with components. Triggers on /design.
---

# Design Workflow — Full Pipeline Orchestrator

## Overview

Methodologie de design complete en 10 etapes. Chaque etape produit un livrable valide par l'utilisateur avant de passer a la suivante. L'objectif final est un code HTML/React de haute qualite, raffine avec des composants professionnels.

## Trigger

`/design`

## MANDATORY: Load Component Registry at Start

**At the beginning of the workflow, you MUST use the Read tool to load:**

1. **`/Users/thibaultmarty/.claude/plugins/design-studio/registry/registry.json`**
2. **`/Users/thibaultmarty/.claude/plugins/design-studio/registry/collections/aura/manifest.json`**

Keep the component list in memory for Step 9-10 (refinement). There are 35 pre-built components available. **Never say "no components available" — they are always there.**

---

## Pipeline

```
/design
  │
  ├─ Step 1:  BRIEF — objectif, cible, audience
  ├─ Step 2:  INSPIRATIONS — 1 a 3 sites de reference
  ├─ Step 3:  DESIGN SYSTEM — palette, typo, style a partir des inspirations
  │   → Validation utilisateur
  │
  ├─ Step 4:  WIREFRAME (Frame0) — structure basse fidelite
  │   → Validation utilisateur
  │
  ├─ Step 5:  NIVEAU DE CREATIVITE — parametre pour Pencil
  ├─ Step 6:  IMAGES — quantite et type
  ├─ Step 7:  RESSOURCES IMAGES — bibliotheques ou dossier custom
  ├─ Step 8:  MAQUETTE (Pencil.dev) — construction haute fidelite + page design system
  │   → Validation utilisateur
  │
  ├─ Step 9:  TRANSITION CODE — preview, avertissement raffinage
  ├─ Step 10: RAFFINAGE — composants du registre + modifications
  │   → Validation utilisateur
  │
  └─ DONE: fichiers finaux livres
```

---

## Step 1: Brief

Analyser le contexte du projet (fichiers existants, CLAUDE.md, etc.) puis poser ces questions **une par une** :

1. **Quel est l'objectif de cette page ?** (convertir, informer, onboarder, vendre...)
2. **Quelle est la cible / audience ?** (developpeurs, grand public, entreprise, createurs...)
3. **Y a-t-il des contraintes specifiques ?** (marque existante, delai, techno imposee...)

Stocker les reponses dans le state. Ne pas avancer sans reponses claires.

---

## Step 2: Inspirations

Demander a l'utilisateur :

> **Donne-moi 1 a 3 sites web qui t'inspirent pour ce projet.**
> (URL completes de preference — je les analyserai pour en extraire le style)

Pour chaque URL fournie :
- Utiliser le navigateur (Playwright MCP) ou WebFetch pour capturer un screenshot
- Analyser : palette de couleurs, typographie, style de layout, ambiance generale
- Noter les patterns recurrents entre les inspirations

Si l'utilisateur n'a pas d'inspiration, proposer 3 references pertinentes basees sur le brief (type de page + audience).

---

## Step 3: Design System

A partir des inspirations analysees, **proposer un design system** :

### Proposition

Presenter sous forme structuree :

```
DESIGN SYSTEM PROPOSE
━━━━━━━━━━━━━━━━━━━━━

Couleurs
  Primary:    #XXXX (inspire de [site])
  Secondary:  #XXXX
  Accent:     #XXXX
  Background: #XXXX
  Text:       #XXXX

Typographie
  Titres: [Font] (inspire de [site])
  Corps:  [Font]
  Echelle: 14 / 16 / 20 / 24 / 32 / 48

Espacement
  Base: 8px
  Echelle: 8 / 16 / 24 / 32 / 48 / 64 / 96

Style
  Border radius: Xpx
  Ombres: [description]
  Ambiance: [mot-cle, mot-cle, mot-cle]
```

Demander : **Valider / Ajuster / Recommencer**

Si ajuster : modifier les elements demandes et re-proposer.

### Generer la page Design System HTML

Une fois le design system valide, **generer un fichier HTML** pour le visualiser dans le navigateur :

1. Lire le template : **`/Users/thibaultmarty/.claude/plugins/design-studio/templates/design-system.html`**
2. Remplacer les placeholders `{{...}}` par les valeurs du design system valide :
   - `{{PROJECT_NAME}}` — nom du projet (depuis le brief)
   - `{{PRIMARY}}`, `{{SECONDARY}}`, `{{ACCENT}}`, `{{BACKGROUND}}`, `{{TEXT}}`, `{{TEXT_SECONDARY}}` — couleurs
   - `{{HEADING_FONT}}`, `{{BODY_FONT}}` — noms des fontes
   - `{{HEADING_FONT_URL}}`, `{{BODY_FONT_URL}}` — noms des fontes encodes pour Google Fonts URL (espaces remplacees par +)
   - `{{BORDER_RADIUS}}` — ex: "12px"
   - `{{SPACING_BASE}}` — ex: "8"
   - `{{MOOD_TAGS}}` — generer des `<span class="mood-tag">mot-cle</span>` pour chaque mot d'ambiance
   - `{{DATE}}` — date du jour
3. Sauvegarder le fichier dans le projet : `./design-system.html`
4. Proposer a l'utilisateur d'ouvrir le fichier : `open ./design-system.html`

Cette page HTML sert de reference visuelle tout au long du projet.

Stocker le design system valide dans le state.

---

## Step 4: Wireframe (Frame0)

Invoquer le skill **wireframe** avec le brief + design system comme contexte.

- Proposer la structure de la page en sections
- Construire le wireframe basse fidelite dans Frame0
- Invoquer **design-system** pour valider la hierarchie d'information

Demander : **Valider / Ajuster / Recommencer**

Stocker la section map validee dans le state.

---

## Step 5: Niveau de Creativite

Avant de passer a Pencil, demander :

> **Quel niveau de creativite pour la maquette ?**
>
> - **0 — Strict** : Respecte exactement la structure du wireframe Frame0. Aucune modification de layout.
> - **1 — Ameliorations par section** : Permet des ameliorations visuelles section par section, mais sans changer l'organisation globale de la page.
> - **2 — Libre** : Permet des ameliorations de structure. Les sections peuvent etre reorganisees, fusionnees ou enrichies pour un meilleur resultat.

Stocker le choix dans le state : `mockup.creativity_level` (0, 1, ou 2).

---

## Step 6: Images

Demander :

> **Combien d'images dans la maquette ?**
>
> - **0 — Aucune** : Pas d'image, placeholders ou icones uniquement
> - **1 — Peu** : 1 a 3 images maximum (hero, une illustration)
> - **2 — Moyenne** : Jusqu'a 5 images (hero + sections cles)
> - **3 — Haute** : Images a presque toutes les sections

Stocker dans le state : `mockup.image_density` (0, 1, 2, ou 3).

Si la reponse est **0**, passer directement au Step 8.
Si la reponse est **1, 2, ou 3**, continuer au Step 7.

---

## Step 7: Ressources Images

Demander :

> **Quel type d'images ?**
>
> - **Realiste** (photos)
> - **Illustration** (dessins, graphismes)

### Si Illustration :

Proposer 3 bibliotheques libres de droits :

1. **unDraw** (undraw.co) — Illustrations SVG flat design, personnalisables en couleur
2. **Humaaans** (humaaans.com) — Personnages modulaires, style moderne
3. **Storyset** (storyset.com) — Illustrations animees, plusieurs styles

> Tu peux aussi ajouter tes propres illustrations dans un dossier `./illustrations/` du projet. Je les integrerai dans la maquette.

### Si Realiste :

Proposer 3 bibliotheques libres de droits :

1. **Unsplash** (unsplash.com) — Photos haute qualite, usage libre
2. **Pexels** (pexels.com) — Photos et videos libres de droits
3. **Pixabay** (pixabay.com) — Images, vecteurs et illustrations

> Tu peux aussi ajouter tes propres photos dans un dossier `./images/` du projet. Je les integrerai dans la maquette.

Stocker les choix dans le state : `mockup.image_type` et `mockup.image_source`.

---

## Step 8: Maquette (Pencil.dev)

Invoquer le skill **mockup** avec tous les parametres accumules :

### Parametres de construction

- **Design system** (Step 3) : couleurs, typo, espacement
- **Section map** (Step 4) : structure du wireframe
- **Creativite** (Step 5) : niveau 0, 1, ou 2
- **Images** (Step 6-7) : densite, type, source

### Construction

1. **Creer une page "Design System"** dans Pencil.dev :
   - Palette de couleurs avec swatches
   - Echantillons typographiques (titres, corps, liens)
   - Composants de base (boutons, cartes, inputs)
   - Echelle d'espacement visuelle

2. **Creer la page principale** selon les parametres :
   - **Creativite 0** : reproduire le wireframe pixel-perfect avec les couleurs/typo du design system
   - **Creativite 1** : respecter l'organisation, mais ameliorer chaque section individuellement (meilleur espacement, elements decoratifs, micro-interactions suggerees)
   - **Creativite 2** : proposer des ameliorations structurelles (fusion de sections, nouveaux elements, layout alternatifs) tout en respectant le brief

3. **Integrer les images** selon la densite choisie, en utilisant la source selectionnee

4. Invoquer **design-system** pour valider les 6 principes

Demander : **Valider / Ajuster / Recommencer**

---

## Step 9: Transition vers le Code

Une fois la maquette Pencil validee :

1. **Generer le code HTML/React** a partir de la maquette
   - Demander le format : HTML seul / React seul / Les deux
   - Assembler les sections en page complete

2. **Afficher un avertissement clair** :

> **Note importante :** Le raffinage avec les composants du registre (Aura, etc.) se fera uniquement sur la version codee, pas dans Pencil. La maquette Pencil reste votre reference visuelle.

3. Invoquer **design-system** pour une review du code genere

Demander : **Valider / Passer au raffinage**

---

## Step 10: Raffinage avec Composants

C'est ici que le registre de composants entre en jeu.

### Process

1. **Charger le registre** (deja fait au demarrage — 35 composants Aura disponibles)

2. **Pour chaque section du code**, chercher des composants matchants :
   - Afficher un comparatif : section actuelle (code) vs composant du registre
   - Inclure un score de correspondance et les differences cles

3. **Choix par section** :
   - **Utiliser le composant** — remplacer la section par le composant adapte (couleurs, contenu, typo du design system)
   - **Garder mon code** — conserver le code genere depuis la maquette
   - **Modifier manuellement** — l'utilisateur donne des instructions specifiques de modification

4. **Appliquer les modifications** et re-generer le code

5. **Review finale** avec design-system (6 principes)

6. **Proposer** :
   - **Terminer** — sauvegarder les fichiers finaux
   - **Continuer a raffiner** — faire un autre tour de modifications
   - **Modifier une section specifique** — cibler une section a ameliorer

---

## MCP Availability

Verifier la disponibilite des MCP au demarrage :

| Scenario | Comportement |
|---|---|
| Frame0 + Pencil disponibles | Pipeline complet |
| Frame0 absent | Passer Step 4 : decrire la structure textuellement, passer a Pencil |
| Pencil absent | Passer Steps 5-8 : aller directement de la structure au code |
| Aucun | Steps 1-3 (brief + inspirations + design system) puis directement Step 9-10 (code + raffinage) |

Ne jamais bloquer. Toujours proposer une alternative.

---

## State Management

```json
{
  "brief": {
    "objective": "...",
    "audience": "...",
    "constraints": "..."
  },
  "inspirations": {
    "urls": ["...", "..."],
    "analysis": { "colors": [], "fonts": [], "patterns": [] }
  },
  "design_system": {
    "colors": { "primary": "#...", "secondary": "#...", "accent": "#...", "background": "#...", "text": "#..." },
    "typography": { "heading": "...", "body": "...", "scale": [14, 16, 20, 24, 32, 48] },
    "spacing_base": 8,
    "border_radius": "...",
    "mood": ["...", "..."],
    "approved": false
  },
  "wireframe": {
    "section_map": {},
    "approved": false
  },
  "mockup": {
    "creativity_level": 1,
    "image_density": 2,
    "image_type": "illustration",
    "image_source": "undraw",
    "pen_file": "...",
    "approved": false
  },
  "code": {
    "format": "both",
    "output_dir": "./output",
    "approved": false
  },
  "refinement": {
    "component_map": {},
    "iterations": 0,
    "completed": false
  },
  "meta": {
    "current_step": 1,
    "mcp_available": { "frame0": true, "pencil": true },
    "started_at": "...",
    "updated_at": "..."
  }
}
```

Sauvegarder dans `.design-studio-state.json` apres chaque step. Sur `/design`, si un state existe, proposer **Reprendre** ou **Recommencer**.

---

## Skip Phases

- `/design --skip-wireframe` — sauter Step 4
- `/design --skip-mockup` — sauter Steps 5-8, aller au code
- `/design --quick` — Steps 1-3 puis directement 9-10 (pas de wireframe ni mockup)

Entree directe par skill individuel :
- `/design-studio-wireframe` — Step 4 seul
- `/design-studio-mockup` — Step 8 seul
- `/design-studio-design-to-code` — Steps 9-10
- `/design-studio-design-system` — Review design seule
- `/design-studio-component-registry` — Recherche composants seule
