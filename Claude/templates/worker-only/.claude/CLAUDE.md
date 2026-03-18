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

## Subagent Patterns

Worker-only projects are usually **single-agent territory** — the code surface is small and highly sequential. Subagents only pay off here when the scope expands.

**Good candidates for subagents:**
- Reading and summarizing external API docs or webhook payload schemas before writing handler code
- Parallel generation of multiple route handlers when they provably share no state
- Read-only audit: validating that all bindings in the code match the active binding table in this file

**Keep on primary:** cron trigger logic, error handling paths, any D1 query that touches multiple tables, anything that determines whether a side effect fires. These jobs often have no retry — a mistake is a missed webhook or a duplicate write.

---

## Known Quirks

*(Timeouts, CPU limits, quirky external APIs, etc.)*
