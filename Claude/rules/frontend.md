---
paths:
  - frontend/**
---

# 🎨 Frontend Rules

## Creative Direction

- **Vibe:** Personalized, fun, concise. Never corporate, never AI-sounding.
- **Typography:** Serif (`var(--font-serif)`) for headings. Sans-serif (`var(--font-sans)`) for body.
- **Animations:** Cinematic — parallax, timeline animations, dramatic transitions.
  ALL animations must be gated inside `@media (prefers-reduced-motion: no-preference)`.
- **CSS:** Custom only. No frameworks. CSS custom properties are the design system.

*Before any creative or visual change: "Does this match the established creative direction and brand identity?"*

## ♿ Accessibility (WCAG AA — Non-Negotiable)

- **Contrast:** 4.5:1 minimum for text. 3:1 for UI components and focus indicators.
- **Focus:** `:focus-visible` styles on ALL interactive elements — never remove outlines.
- **Keyboard:** All functionality operable by keyboard alone. Tab order must be logical.
- **Semantics:** Use semantic HTML. `<button>` not `<div onclick>`.
  Use `<nav>`, `<main>`, `<header>`, `<footer>` appropriately.
- **Forms:** Every `<input>`, `<select>`, and `<textarea>` must have an associated `<label>`.
- **Motion:** All animations inside `@media (prefers-reduced-motion: no-preference)`.
  Blanket disable inside `@media (prefers-reduced-motion: reduce)`.
- **Images:** Informational `<img>` elements must have descriptive `alt`. Decorative: `alt=""`.
- **Skip link:** Every page needs a visually-hidden skip-to-content link as the first focusable element.
- **Testing:** Verify Lighthouse a11y score after any UI change. Target: 90+.

## Frontend Hard Rules

- All data fetching via `fetch('/api/...')` — never import or call backend logic directly.
- No `console.error` in frontend code — errors belong in the Worker.
- Create user-friendly fallback copy for all error states.
