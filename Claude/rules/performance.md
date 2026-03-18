---
paths:
  - frontend/**
---

# ⚡ Frontend Performance Rules

> Target: Lighthouse 90+ · LCP < 2.5s · CLS < 0.1 · INP < 200ms
> These are behavioral rules to apply while writing code, not just metrics to measure after.

## Images

- All `<img>` below the fold: `loading="lazy"` — no exceptions.
- Hero/LCP `<img>`: `fetchpriority="high" loading="eager"` — explicit, not left to the browser.
- Every `<img>` must have explicit `width` and `height` attributes — prevents layout shift (CLS).
- Use `srcset` + `sizes` for any image displayed at variable widths.
- Prefer `<picture>` with `webp` source + fallback for non-animated images.
- Never use a `<div>` background-image for content images — only for purely decorative backgrounds.

## Fonts

- All `@font-face` declarations must include `font-display: swap`.
- Preload the primary heading font: `<link rel="preload" as="font" type="font/woff2" crossorigin>`.
- Never load more than 2 custom font families. Each family: max 2 weights (regular + bold).
- Self-host fonts in `/frontend/fonts/` — never load from Google Fonts or external CDNs in production.
  (External font CDN = extra DNS lookup + potential render block + privacy implications.)
- Subset fonts to the character sets actually used when possible.

## CSS

- Keep total stylesheet size under 50KB uncompressed. Split only if the project genuinely warrants it.
- No `@import` inside CSS files — use `<link>` in HTML instead (imports are render-blocking).
- `content-visibility: auto` on any section that is off-screen at page load and has significant DOM.
- `contain: layout style` on repeated card/list components — limits browser recalc scope.
- Avoid `will-change` except where measured to help; it consumes compositor memory.
- Never animate `width`, `height`, `top`, `left`, `margin`, or `padding` — these trigger layout.
  Animate `transform` and `opacity` only — they stay on the compositor thread.

## JavaScript

- `<script type="module">` gets `defer` behavior automatically — no need to add `defer`.
- Never block the main thread with synchronous operations in the load path.
- Debounce scroll and resize handlers — 100ms debounce minimum.
- `IntersectionObserver` for all scroll-triggered behavior — never `scroll` event listeners.
- No third-party scripts in `<head>` — load analytics and non-critical scripts with `defer` or `async`.

## Resource Hints

Include these in `<head>` for every project:

```html
<!-- DNS prefetch for any third-party domain the page calls -->
<link rel="dns-prefetch" href="https://{{api-worker-domain}}">

<!-- Preconnect to the API worker (reduces TTFB on first fetch) -->
<link rel="preconnect" href="https://{{api-worker-domain}}">
```

## Core Web Vitals Checklist (Before Any Deploy)

- [ ] **LCP element identified** — is it an `<img>` with `fetchpriority="high"`? Or `<h1>` with font preloaded?
- [ ] **No layout shift sources** — all images have `width`/`height`; no FOUT from fonts; no dynamically injected content above the fold
- [ ] **INP clean** — no long tasks on interaction handlers; event listeners are passive where possible
- [ ] **Lighthouse run completed** — `npm run lighthouse` or DevTools; screenshot the scores before deploy

## What Not to Do

- Never add a spinner/loader for content that could be skeleton-screened instead.
- Never use `setTimeout` to defer content reveal — it creates CLS and is not a real performance optimization.
- Never `console.log` in production frontend code — it holds references and can leak data.
- Do not lazy-load above-the-fold content — it delays LCP.
