# Project: {{PROJECT_NAME}}

> Extends `~/.claude/CLAUDE.md`. Project-specific context only.

## What This Is

{{One-sentence description — cron job, webhook receiver, internal API, etc.}}

**Status:** 🟡 Active development  
**Worker URL:** `https://{{PROJECT_NAME}}.{{ACCOUNT_SUBDOMAIN}}.workers.dev`  
**Trigger:** {{Cron / HTTP / Queue — pick one}}

---

## Stack Delta

⚠️ **No frontend.** Worker-only project — delete or ignore all `/frontend` references from the global rules.

- Entry point: `api/src/index.js`
- No Pages deployment, no `dev:ui` script
- No CORS configuration needed unless this Worker is called cross-origin

---

## Active Bindings

| Binding | Type | Purpose |
|---|---|---|
| *(none yet)* | — | — |

---

## Cron Schedule

*(If this Worker uses a cron trigger, document the schedule here.)*

```toml
# wrangler.toml
[triggers]
crons = ["0 9 * * 1"]  # Example: 9am UTC every Monday
```

---

## API Routes / Handlers

| Method | Path / Event | Description |
|---|---|---|
| GET | `/health` | Health check |

---

## Output / Side Effects

*(What does this Worker actually do when it runs? Write to D1? Call an external API? Send a notification? Document it here so Claude doesn't have to guess.)*

---

## Known Quirks

*(Timeouts, CPU limits, quirky external APIs, etc.)*
