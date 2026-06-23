# Design System — Apollo Content

## Overview

The Apollo Design System (ADS) is the single source of truth for all visual and interactive elements across Apollo's digital products. It exists to enforce consistency, accelerate design-to-dev handoff, and eliminate bikeshedding over spacing and colour choices.

## Component Library

All components live in a shared Figma library (`Apollo — Design System v1`) and are mirrored in a React component library (`@apollo/ads-ui`). Every component must exist in both before it can be used in production.

### Core Component Categories

**Atoms** — Irreducible building blocks:
- Button (primary, secondary, ghost, destructive)
- Input (text, textarea, select, checkbox, radio, toggle)
- Label, Badge, Tag, Avatar, Icon (Phosphor Icons, weight: regular)
- Link (inline, standalone, with/without underline)

**Molecules** — Simple compositions:
- Form group (label + input + helper text + error state)
- Card (with variants: default, elevated, interactive)
- Modal (header, body, footer, overlay, escape-to-close)
- Toast notification (success, error, warning, info)
- Search bar (input + icon + clear button + dropdown results)

**Organisms** — Complex, self-contained sections:
- Navbar (desktop and mobile variants)
- Footer (four-column with newsletter signup)
- Hero section (text-left, text-centre, image-right variants)
- Pricing table (three-column, feature comparison rows)
- Testimonial carousel

**Templates** — Page-level layouts:
- Blog post template
- Landing page template
- Documentation page template
- Case study template

## Spacing Scale

ADS uses a **4px base unit**. Every spacing value is a multiple of 4.

| Token | Value | Usage |
|---|---|---|
| `space-0` | 0 | Flush edges |
| `space-1` | 4px | Tight inline spacing, icon-text gaps |
| `space-2` | 8px | Related items, button padding-y |
| `space-3` | 12px | Card padding (compact) |
| `space-4` | 16px | Default padding, section gutters (mobile) |
| `space-5` | 24px | Section padding, card gaps |
| `space-6` | 32px | Section gutters (desktop) |
| `space-7` | 48px | Hero spacing, major section breaks |
| `space-8` | 64px | Page-level separators |
| `space-9` | 96px | Hero vertical padding |
| `space-10` | 128px | Maximum whitespace |

**Rule:** Never use a raw pixel value in CSS or Figma that isn't on this scale. If what you need is between `space-5` and `space-6`, use `space-5`. Consistency beats perfection.

## Responsive Breakpoints

| Name | Min Width | Max Width | Design Column Count |
|---|---|---|---|
| `mobile` | 320px | 767px | 4 |
| `tablet` | 768px | 1023px | 8 |
| `desktop` | 1024px | 1439px | 12 |
| `wide` | 1440px | — | 12 (centred, max 1200px content) |

**Mobile-first development:** All base styles target `mobile`. Breakpoints add complexity only when needed.

```css
/* Example breakpoint usage — mobile-first */
.container { padding: var(--space-4); }          /* mobile */
@media (min-width: 768px) { .container { padding: var(--space-6); } } /* tablet+ */
@media (min-width: 1024px) { .container { max-width: 1200px; margin: 0 auto; } }
```

## Accessibility Requirements

Every component must meet **WCAG 2.1 Level AA** before release:

- **Colour contrast:** 4.5:1 minimum for normal text, 3:1 for large text (≥18px bold or ≥24px)
- **Focus states:** Visible focus ring (3px, Apollo Navy with 2px offset) on all interactive elements. Never `outline: none` without a replacement.
- **Keyboard navigation:** Tab order must match visual order. Modals trap focus. Dropdowns support arrow keys.
- **Screen reader:** All images have meaningful `alt` text (or `alt=""` if decorative). Form inputs have associated `<label>` elements. Icons have `aria-label` or are hidden with `aria-hidden="true"`.
- **Reduced motion:** Respect `prefers-reduced-motion`. Disable autoplaying animations, transitions, and carousels when the user requests it.
- **Touch targets:** Minimum 44x44px for all interactive elements on mobile.

**Pre-launch checklist:**
1. Run axe DevTools on every page/view
2. Tab through the entire page — no traps, no invisible elements receiving focus
3. Test with VoiceOver (macOS) or NVDA (Windows) for at least one critical user flow
4. Verify all text resizes correctly at 200% browser zoom without horizontal scrolling

## Figma Handoff

### Designer Responsibilities

1. **Name all layers.** No "Rectangle 47." Use semantic names: `btn-primary/hover`, `card-pricing/default`.
2. **Use auto-layout** for all components. Absolute positioning is forbidden in handoff files.
3. **Mark components as ready for dev** using the Figma "Ready for development" status.
4. **Include all states** per component: default, hover, focus, active, disabled, loading, error, empty.
5. **Export assets** as SVG (icons, logos) or WebP (photos). Never hand off PNG for production assets.
6. **Annotate interactions** with brief notes in the Figma file: "On click → navigates to /pricing," "On hover → tooltip with definition."

### Developer Responsibilities

1. **Inspect, don't assume.** Use Figma's code panel (set to CSS) for exact values. Never eyeball spacing.
2. **Match the design at all three breakpoints** before marking a component as done.
3. **Flag discrepancies** in the #design-system Slack channel within one sprint. Don't silently "fix" design decisions in code.
4. **Keep the component library in sync.** If you add a prop or variant in code, open a Figma ticket to add it there too.

### Handoff Sign-Off

Both a designer and a developer must approve a component before it graduates from `draft` to `production` in the Figma library. Use the component's Figma comment thread as the approval record.

## Revision History
- 2026-06-10 — Initial publication
