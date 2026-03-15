A reference guide for applying the four project templates in your `scaffold.sh` + Claude Code workflow.

---

## How This System Works

Your setup has three layers of Claude context that stack on every session:

```
~/.claude/CLAUDE.md           ← Global: your identity, stack defaults, hard rules (never edit per-project)
  └── .claude/CLAUDE.md       ← Project: what this specific codebase is and how it deviates
        └── .claude/CLAUDE.local.md  ← Local: your machine, ports, Tailscale, personal notes (gitignored)
```

**The global file does the heavy lifting.** Project files should be lean — only what Claude cannot infer from reading the code. If you're writing something in a project file that would be true of every project, it belongs in the global file instead.

A well-filled project `CLAUDE.md` means Claude starts every session already knowing the production URL, every active binding, the auth strategy, and any quirks — without you typing a single orientation message.

---

## Template Decision Tree

```
new-project my-app
│
├── Has a frontend AND an API?
│   ├── Mostly display/content, minimal data?  →  fullstack
│   └── Auth, database, user accounts, dashboards?  →  data-app
│
├── No frontend at all?  →  worker-only
│
└── No API at all?  →  static-site
```

---

## Template 1 — `fullstack`

**File:** `fullstack/.claude/CLAUDE.md`

### What it's for

The default output of `scaffold.sh`. Use this whenever a project has both a Cloudflare Pages frontend and a Worker API but doesn't yet have meaningful database bindings or an auth layer. It's intentionally thin — its job is to record the production URLs and document bindings as you add them, not to describe architecture Claude already knows from the global file.

### When to use it

- A new project right out of `scaffold.sh` before any real features are built
- A tool or utility with a simple UI (a form that calls an API, a dashboard that reads from a single KV namespace)
- Any project where the scaffold defaults haven't been significantly deviated from

### When to switch to a different template

Promote to `data-app` once you add D1, implement auth, or the API route table grows beyond ~5 routes. The line is roughly: if Claude needs to understand data relationships or access control to write correct code, you've outgrown `fullstack`.

### Use-case examples

| Project | Notes |
|---|---|
| `link-shortener` | POST to Worker stores a slug in KV, Pages serves a redirect page |
| `uptime-dashboard` | Worker polls your Unraid containers, Pages renders status cards |
| `webhook-forwarder` | Worker receives a POST, fan-outs to Discord + email |
| `portfolio-contact-form` | Static Pages site with a single Worker endpoint for form submissions |

### Filling it in

The two most important fields to complete immediately after scaffolding:

```markdown
## What This Is
A link shortener for internal team use. Slugs stored in KV, analytics in D1.

## Active Bindings
| Binding    | Type | Purpose            |
|------------|------|--------------------|
| LINKS_KV   | KV   | slug → URL mapping |
```

Everything else can fill in as the project grows.

---

## Template 2 — `worker-only`

**File:** `worker-only/.claude/CLAUDE.md`

### What it's for

Any Worker that has no associated frontend. These are headless jobs — they receive an event (HTTP request, cron trigger, Queue message) and do something: write to a database, call an external API, send a notification, transform data. The template explicitly suppresses all the frontend sections from the global rules so Claude doesn't waste tokens reasoning about things that don't apply.

### When to use it

- Scheduled jobs (cron triggers)
- Webhook receivers (GitHub, Stripe, Cloudflare notifications)
- Internal APIs consumed by other services, not by a browser
- Data pipelines and ETL workers
- Background processors (Queue consumers)

### Use-case examples

| Project | Trigger | What it does |
|---|---|---|
| `alexandria-health-check` | Cron — every 5 min | Pings Unraid containers, writes status to D1, pings Uptime Kuma |
| `github-webhook-relay` | HTTP POST | Receives GitHub push events, posts a formatted message to Discord |
| `plex-notify` | HTTP POST from Tautulli | Fires a push notification when a new episode is added to Plex |
| `dns-audit` | Cron — weekly | Reads all Cloudflare DNS records via API, diffs against a D1 snapshot, emails a report |
| `stripe-webhook` | HTTP POST | Validates Stripe signatures, writes transaction records to D1 |

### Key sections to fill in immediately

The **Cron Schedule** and **Output / Side Effects** sections are the most valuable for this template — they answer "when does this run and what does it actually change?"

```markdown
## Cron Schedule
[triggers]
crons = ["*/5 * * * *"]  # Every 5 minutes

## Output / Side Effects
- Writes a row to D1 `container_status` table on every run
- Sends a POST to Uptime Kuma push URL if any container is down
- Logs nothing to stdout in production (Cloudflare captures Worker logs separately)
```

---

## Template 3 — `static-site`

**File:** `static-site/.claude/CLAUDE.md`

### What it's for

Pure Cloudflare Pages deployments with no Worker. The template actively suppresses all API, Worker, secrets, and `wrangler.toml` sections from the global rules — Claude shouldn't be thinking about CORS or `op://` references when the entire project is HTML, CSS, and Vanilla JS. It adds a brand/design table and a third-party script inventory that the other templates don't need.

### When to use it

- Marketing or landing pages
- Portfolio sites (including `corbet.app`)
- Documentation sites
- Event pages, microsites, anything that doesn't need server-side logic
- Any project where "add a contact form" would be the first reason to introduce a Worker

### Use-case examples

| Project | Notes |
|---|---|
| `corbet.app` | Portfolio — static Pages with role-targeted sub-pages (`/pm`, `/ux`) |
| `tiki-history-zine` | Long-form editorial content site, heavy parallax and timeline animations |
| `homebrewing-guide` | Recipe and process reference, client-side search via Pagefind |
| `event-landing-2025` | Single-page event site, countdown timer, no backend needed |
| `rum-reference` | Categorized reference guide with client-side filtering |

### Key sections to fill in immediately

The **Brand & Design Decisions** table is uniquely valuable here because this template is where you're most likely to deviate from your global CSS defaults. Document the token overrides before you write a single line of CSS:

```markdown
## Brand & Design Decisions
| Token            | Value      | Notes                          |
|------------------|------------|--------------------------------|
| `--color-accent` | `#c8a96e`  | Warm gold — editorial/vintage  |
| `--color-bg`     | `#f5f0e8`  | Cream paper — light mode only  |
| `--font-serif`   | `Playfair Display` | Self-hosted via `/fonts/` |
```

Also fill in **Third-Party Scripts / Embeds** immediately if you're loading anything from an external domain — Claude needs this to write correct CSP headers.

---

## Template 4 — `data-app`

**File:** `data-app/.claude/CLAUDE.md`

### What it's for

Any project where Claude needs to understand data relationships, binding configuration, or access control to write correct code. This template is the most detailed by design — it includes a live database schema section, an auth flow walkthrough, and a route table with auth requirements. Without this context, Claude will make reasonable-but-wrong assumptions about your data model on every session.

### When to use it

- User-facing apps with accounts (login, registration, sessions)
- Internal dashboards that read from D1 or an external database
- Any project with more than one D1 table or KV namespace
- Multi-tenant apps or anything with permission tiers
- Anything where "which user owns this record?" is a question the code has to answer

### Use-case examples

| Project | Auth | Data Layer |
|---|---|---|
| `alexandria-dashboard` | Cloudflare Access (internal only) | D1 — container status, uptime history |
| `homelab-bookmarks` | Single-user JWT | D1 — bookmarks, tags; KV — tag index |
| `brew-log` | Single-user JWT | D1 — batches, measurements, notes |
| `tiki-recipe-vault` | Cloudflare Access | D1 — recipes, ingredients, spirits |
| `client-portal` | Email magic link | D1 — clients, projects, deliverables |

### Key sections to fill in immediately

**Database Schema** is the highest-value field in this template. Keep it current — Claude reads this instead of scanning migration files, which means an accurate schema here directly improves every SQL query it writes:

```markdown
## Database Schema

-- bookmarks
CREATE TABLE bookmarks (
  id         TEXT PRIMARY KEY,
  url        TEXT NOT NULL,
  title      TEXT,
  tag_ids    TEXT,           -- JSON array of tag IDs
  created_at INTEGER NOT NULL
);

-- tags
CREATE TABLE tags (
  id    TEXT PRIMARY KEY,
  label TEXT UNIQUE NOT NULL
);
```

**Auth Flow** is the second priority — document it once, and Claude will correctly thread auth through every new endpoint without being told:

```markdown
## Auth Flow
1. POST /api/auth/login → validates credentials → issues JWT → stored in APP_KV with 24h TTL
2. All /api/user/* routes: Worker reads Authorization header, validates JWT signature against KV
3. Invalid/expired token → 401, no redirect (frontend handles redirect to /login)
```

---

## Workflow Integration

### Adding a template to `scaffold.sh`

Rather than always copying the same `fullstack` template, you can prompt for project type at scaffold time:

```bash
echo ""
echo "📋 Project type:"
echo "   1) fullstack    (Pages + Worker — default)"
echo "   2) worker-only  (no frontend)"
echo "   3) static-site  (no API)"
echo "   4) data-app     (Pages + Worker + D1/auth)"
read -rp "   Choose [1]: " PROJECT_TYPE
PROJECT_TYPE=${PROJECT_TYPE:-1}

TEMPLATE_MAP=([1]="fullstack" [2]="worker-only" [3]="static-site" [4]="data-app")
TEMPLATE="${TEMPLATE_MAP[$PROJECT_TYPE]}"
TEMPLATE_SRC="$SCRIPT_DIR/templates/$TEMPLATE/.claude/CLAUDE.md"

mkdir -p "$PROJECT_NAME/.claude"
cp "$TEMPLATE_SRC" "$PROJECT_NAME/.claude/CLAUDE.md"
```

### Keeping templates updated

Templates drift from reality fast if you don't maintain them. Three rules that help:

1. **Update the schema section immediately when you add a migration** — don't wait until the next Claude session.
2. **Add a binding to the table before adding it to `wrangler.toml`** — the template table is your pre-flight check.
3. **Move a line to the global `CLAUDE.md` if you've written it in three different project files** — it belongs globally.

### The `CLAUDE.local.md` alongside every project

Every project should also get a `CLAUDE.local.md` (gitignored globally) for your machine-specific context. At minimum:

```markdown
# Local — corbet on mac-mini

## Active ports
Worker: 8787 / Pages: 8788

## Known local issues
- Port 8787 sometimes held after a crash: lsof -ti:8787 | xargs kill -9
```

This separates "what the project is" from "how my machine runs it" — a distinction that matters when you're developing from two different machines over Tailscale.

---

## Quick Reference

| Template | Frontend | Worker | Database | Auth | Start here when... |
|---|---|---|---|---|---|
| `fullstack` | ✅ Pages | ✅ Worker | ❌ | ❌ | Running `new-project` for the first time |
| `worker-only` | ❌ | ✅ Worker | optional | ❌ | Building a cron job, webhook, or internal API |
| `static-site` | ✅ Pages | ❌ | ❌ | ❌ | Building a portfolio, landing page, or content site |
| `data-app` | ✅ Pages | ✅ Worker | ✅ D1/KV | ✅ | Adding user accounts, a schema, or multiple bindings |
