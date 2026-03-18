# 🤖 MCP Project Overrides

> Extends `~/.claude/CLAUDE.md`. MCP-specific context only — global rules, subagent strategy,
> hard boundaries, and secrets handling all apply unchanged.

-----

## 🎨 MCP-Specific Rules

- MCP server lives in `/api` alongside the Worker — same secrets management, same `wrangler.toml` as source of truth.
- Auth on MCP endpoints is non-negotiable — Cloudflare's `agents` SDK supports OAuth, use it.
- MCP tools are public API surface — same rate limiting requirement as REST endpoints.
- Document every exposed tool with its purpose, inputs, and what data it can access.

-----

## 🤖 Subagent Strategy (MCP Additions)

MCP tool calls map cleanly onto the subagent delegation model — treat each call type as a routing signal.

### ✅ Delegate to subagents:

- **Read-only MCP calls** — fetching records, listing resources, reading tool schemas, validating connectivity
- **Parallel tool discovery** — when multiple MCP tools need inventorying before planning, fan out one subagent per tool category
- **Stub generation** — multiple MCP tool handler skeletons when they share no auth or state logic

### 🛑 Keep on primary (never delegate):

- Any MCP call that **mutates state** — creating records, sending notifications, modifying configs, firing webhooks
- Auth token handling and OAuth flows — the `agents` SDK auth wiring requires full project context
- Tool documentation — purpose, inputs, and data access scope must be written with full project context
- Rate limiting logic — MCP endpoints are public API surface

-----

## 🏗️ Architecture Delta

- **Language:** Vanilla JavaScript. TypeScript only with justification and explicit approval.
- **Frontend (`/frontend`):** Cloudflare Pages. Static HTML, CSS, Vanilla JS. Zero build step.
- **Backend (`/api`):** Cloudflare Workers + MCP server. `wrangler.toml` is source of truth.
  Storage: D1 (relational), KV (edge config), R2 (assets).
- **No CSS frameworks** — custom CSS is intentional and non-negotiable.

-----

## 🔒 Secrets Management

> Full secrets rules in `~/.claude/rules/secrets.md` — load automatically, apply unchanged.
> One MCP-specific addition: never expose MCP tool credentials or OAuth tokens in tool response payloads.

-----

## 🌐 CORS

> Full CORS rules in `~/.claude/rules/api.md` — load automatically when editing `api/src/**`.
