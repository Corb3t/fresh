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

## Subagent Patterns

Static sites benefit most from subagents during **multi-page audits and parallel page generation** — the absence of a backend means there's no state to coordinate across.

**Good candidates for subagents:**
- Parallel a11y audits — one subagent per page, all independent (contrast ratios, skip links, focus styles, alt text)
- CSS token consistency check — subagent scans all stylesheets and reports any values that aren't using `var(--...)` references
- Role-targeted page stubs (e.g., `/pm`, `/ux`, `/ba`) — fan out one subagent per page when the structure is identical and only the content differs
- Third-party script inventory — subagent reads all HTML files and reports every external domain loaded (needed for CSP header generation)

**Keep on primary:** design system changes (CSS custom properties, font decisions), navigation architecture, any page that deviates from the standard structure. Creative direction requires full context.

---

## Known Quirks

*(Anything Claude should know before touching this codebase.)*
