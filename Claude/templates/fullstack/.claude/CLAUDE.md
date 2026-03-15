# Project: {{PROJECT_NAME}}

> Extends `~/.claude/CLAUDE.md`. This file is project-specific context only — no need to repeat global rules.

## What This Is

{{One-sentence description of what this project does and who it's for.}}

**Status:** 🟡 Active development  
**Production URL:** `https://{{PROJECT_NAME}}.pages.dev`  
**Worker URL:** `https://{{PROJECT_NAME}}-api.{{ACCOUNT_SUBDOMAIN}}.workers.dev`

---

## Stack Delta

Follows the default scaffold exactly — no deviations.

- Frontend: `/frontend` → Cloudflare Pages
- API: `/api/src/index.js` → Cloudflare Worker (`{{PROJECT_NAME}}-api`)
- Node: `v20.11.1` (pinned in `.nvmrc`)

---

## Active Bindings

Document every binding here before adding it to `wrangler.toml`.

| Binding | Type | Purpose |
|---|---|---|
| *(none yet)* | — | — |

**When adding a binding:**
1. Add the `op://` reference to `.env.tpl` first
2. Update this table
3. Add the `[binding]` block to `wrangler.toml`
4. Run `wrangler secret put` for production

---

## API Routes

| Method | Path | Description |
|---|---|---|
| GET | `/api/health` | Health check |
| GET | `/api/hello` | Placeholder — replace me |

---

## Known Quirks

*(Add project-specific gotchas here as you discover them.)*
