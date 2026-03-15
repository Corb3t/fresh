# Project: {{PROJECT_NAME}}

> Extends `~/.claude/CLAUDE.md`. Project-specific context only.

## What This Is

{{One-sentence description — portfolio, landing page, docs site, etc.}}

**Status:** 🟡 Active development  
**Production URL:** `https://{{PROJECT_NAME}}.pages.dev`  
**Custom Domain:** `https://{{CUSTOM_DOMAIN}}` *(if applicable)*

---

## Stack Delta

⚠️ **Pages only — no Worker.** Ignore all `/api`, Worker, and `wrangler.toml` references from the global rules.

- Static HTML, CSS, Vanilla JS in `/frontend`
- No backend, no API calls, no secrets needed
- No `.env.tpl`, no `verify_op.sh`, no `preflight` script
- Deploy: `npx wrangler pages deploy frontend`

**If a form or dynamic feature is needed later:** add a Worker and update this file before writing any code.

---

## Brand & Design Decisions

*(Fill in as the project takes shape — these override the global creative defaults.)*

| Token | Value | Notes |
|---|---|---|
| `--color-accent` | `#{{hex}}` | Primary CTA color |
| `--font-serif` | `{{font}}` | Heading font |
| `--font-sans` | `{{font}}` | Body font |

**Breakpoints in use:** 640px · 768px · 1024px · 1280px *(global default — override here if different)*

---

## Page Structure

| File | Route | Description |
|---|---|---|
| `frontend/index.html` | `/` | Homepage |

---

## Third-Party Scripts / Embeds

*(List any analytics, fonts, or embeds loaded from external domains — needed to audit CSP headers.)*

| Service | Domain | Purpose |
|---|---|---|
| *(none)* | — | — |

---

## Known Quirks

*(Anything Claude should know before touching this codebase.)*
