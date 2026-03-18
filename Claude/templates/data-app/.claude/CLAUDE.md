# Project: {{PROJECT_NAME}}

> Extends `~/.claude/CLAUDE.md`. Project-specific context only.

## What This Is

{{One-sentence description — dashboard, internal tool, user-facing app, etc.}}

**Status:** 🟡 Active development  
**Production URL:** `https://{{PROJECT_NAME}}.pages.dev`  
**Worker:** `{{PROJECT_NAME}}-api`

---

## Stack Delta

Follows default scaffold with the following additions:

- **Auth:** {{Describe auth strategy — Cloudflare Access, JWT, session cookie, etc.}}
- **Database:** D1 (SQLite at the edge) — binding: `DB`
- **KV:** Used for {{session tokens / feature flags / edge config}} — binding: `APP_KV`
- **R2:** Used for {{asset storage / uploads}} — binding: `ASSETS` *(if applicable)*

---

## Active Bindings

| Binding | Type | `wrangler.toml` key | Purpose |
|---|---|---|---|
| `DB` | D1 | `[[d1_databases]]` | Primary relational store |
| `APP_KV` | KV | `[[kv_namespaces]]` | {{Purpose}} |

**Never** add a binding without updating this table and `.env.tpl` first.

---

## Database Schema

*(Keep this current — Claude reads this instead of scanning migration files.)*

```sql
-- users
CREATE TABLE users (
  id        TEXT PRIMARY KEY,   -- nanoid
  email     TEXT UNIQUE NOT NULL,
  created_at INTEGER NOT NULL    -- Unix timestamp
);

-- {{next_table}}
```

**Migrations:** `/api/src/migrations/`  
**Convention:** `001_create_users.sql`, `002_add_sessions.sql` — sequential, never edit existing files.

---

## Auth Flow

*(Describe the request lifecycle so Claude doesn't reinvent it.)*

1. User hits `POST /api/auth/login` with email + password
2. Worker validates against D1, issues a signed JWT stored in `APP_KV`
3. All protected routes check `Authorization: Bearer <token>` header
4. Token TTL: 24h — refresh via `POST /api/auth/refresh`

**Protected route pattern:** all `/api/user/*` and `/api/admin/*` routes require a valid token.

---

## API Routes

| Method | Path | Auth | Description |
|---|---|---|---|
| GET | `/api/health` | ❌ | Health check |
| POST | `/api/auth/login` | ❌ | Authenticate |
| GET | `/api/user/me` | ✅ | Current user |

---

## Subagent Patterns

`data-app` projects have the most to gain from subagent parallelization — and the most to lose from subagent mistakes. The database schema is load-bearing; delegate reads freely, delegate writes carefully.

**Good candidates for subagents:**
- **Schema reconnaissance** — one subagent reads migration history, another reads the current route table; primary synthesizes before planning any schema change
- **Parallel route stub generation** — when adding multiple independent API endpoints that share only auth middleware, fan out
- **Read-only schema audit** — subagent validates that every D1 query in the codebase references columns that exist in the schema defined above
- **Fixture/seed data generation** — parallelizable boilerplate with no side effects

**Keep on primary:** schema migrations (sequential, irreversible), auth flow changes, any query joining multiple tables, JWT signing/validation logic, and anything that determines what data a user is allowed to see. Data access control bugs are silent in tests and catastrophic in production.

---

## Known Quirks

*(D1 gotchas, KV consistency notes, auth edge cases — document them here.)*
