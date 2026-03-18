#!/bin/bash

# scaffold.sh — Instantly generates a Cloudflare + 1Password AI-ready monorepo
# Usage: ./scaffold.sh my-project-name

set -e  # Exit immediately on any error so failures aren't silent

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

# ── 1. Validate input ─────────────────────────────────────────────────────────

if [ -z "$1" ]; then
  echo "❌ Error: Please provide a project name."
  echo "   Usage: ./scaffold.sh my-awesome-project"
  exit 1
fi

# Validate project name (no spaces or special chars that break paths/git)
if [[ "$1" =~ [^a-zA-Z0-9_-] ]]; then
  echo "❌ Error: Project name must only contain letters, numbers, hyphens, and underscores."
  exit 1
fi

# ── 2. Preflight checks ───────────────────────────────────────────────────────

echo "🔍 Running preflight checks…"

command -v op    &>/dev/null || { echo "❌ 1Password CLI not found. Run: brew install 1password-cli"; exit 1; }
command -v node  &>/dev/null || { echo "❌ Node.js not found. Run: brew install node"; exit 1; }
command -v npm   &>/dev/null || { echo "❌ npm not found. Install Node.js: brew install node"; exit 1; }
command -v git   &>/dev/null || { echo "❌ git not found. Run: xcode-select --install"; exit 1; }

# Verify 1Password CLI authentication.
# Supports both interactive sessions (personal accounts) and service accounts.
# For personal accounts: run `op signin` once interactively, then enable
# "Integrate with 1Password CLI" in 1Password → Settings → Developer.
if ! op vault list &>/dev/null 2>&1; then
  echo "❌ 1Password CLI is not authenticated."
  echo "   Personal account: run 'op signin' and enable CLI integration in 1Password → Settings → Developer."
  echo "   Service account:  ensure OP_SERVICE_ACCOUNT_TOKEN is exported."
  exit 1
fi

echo "✅ Preflight passed."

PROJECT_NAME=$1

# ── Project type selection ────────────────────────────────────────────────────

echo ""
echo "📋 Project type:"
echo "   1) fullstack    — Pages + Worker (default)"
echo "   2) worker-only  — No frontend (cron, webhook, internal API)"
echo "   3) static-site  — No API (portfolio, landing page, content site)"
echo "   4) data-app     — Pages + Worker + D1/auth"
read -rp "   Choose [1]: " PROJECT_TYPE
PROJECT_TYPE=${PROJECT_TYPE:-1}

declare -A TEMPLATE_MAP
TEMPLATE_MAP=([1]="fullstack" [2]="worker-only" [3]="static-site" [4]="data-app")
TEMPLATE="${TEMPLATE_MAP[$PROJECT_TYPE]}"

if [ -z "$TEMPLATE" ]; then
  echo "❌ Invalid selection. Choose 1–4."
  exit 1
fi

TEMPLATE_SRC="$SCRIPT_DIR/templates/$TEMPLATE/.claude/CLAUDE.md"

if [ ! -f "$TEMPLATE_SRC" ]; then
  echo "❌ Template not found at: $TEMPLATE_SRC"
  echo "   Expected: ~/tools/templates/$TEMPLATE/.claude/CLAUDE.md"
  echo "   Run the template setup from the README to install templates."
  exit 1
fi

echo ""
read -rp "📝 One-line description of what this project does: " PROJECT_DESC
PROJECT_DESC="${PROJECT_DESC:-A new Cloudflare project.}"

echo ""
echo "🚀 Scaffolding $TEMPLATE Cloudflare monorepo: $PROJECT_NAME"
echo ""

# ── 3. Directory structure ────────────────────────────────────────────────────

mkdir -p "$PROJECT_NAME/frontend"
mkdir -p "$PROJECT_NAME/.claude"
if [ "$TEMPLATE" != "static-site" ]; then
  mkdir -p "$PROJECT_NAME/api/src"
fi
cd "$PROJECT_NAME" || exit

# ── 3.5. Node Version ─────────────────────────────────────────────────────────

echo "v20.11.1" > .nvmrc

# ── 4. .gitignore ─────────────────────────────────────────────────────────────

cat << 'HEREDOC' > .gitignore
# 🛑 CRITICAL: Never commit environment variables or secrets
.env
.env.*
!.env.tpl
.dev.vars
*.pem

# Cloudflare local development state
.wrangler/
dist/
node_modules/
.DS_Store

# Claude Code local settings (personal, machine-specific)
.claude/settings.local.json
HEREDOC

# ── 5. Generate .env.tpl ─────────────────────────────────────────────────────────

if [ "$TEMPLATE" != "static-site" ]; then
  echo "📄 Generating .env.tpl template..."

  cat << 'EOF' > .env.tpl
# .env.tpl
# 🔒 Injected headlessly into Wrangler/Node via 1Password CLI
# DO NOT place actual secret values in this file. Use op:// URIs.

# ☁️ Cloudflare Headless Authentication
CLOUDFLARE_API_TOKEN="op://Homelab/Cloudflare Wrangler Token/password"
CLOUDFLARE_ACCOUNT_ID="op://Homelab/Cloudflare Wrangler Token/Account ID"

# 🤖 AI API Keys (Required for claude-api as per SpecSheet)
ANTHROPIC_API_KEY="op://Homelab/Claude API/credential"

# 🗄️ Database / Data Layer (Uncomment and update when adding D1/Supabase)
# DATABASE_URL="op://Homelab/Supabase/url"
EOF
fi

# ── 6. wrangler.toml ──────────────────────────────────────────────────────────

# static-site is Pages-only — no Worker, no wrangler.toml needed.
# All other templates get a wrangler.toml with template-specific stubs.

if [ "$TEMPLATE" = "static-site" ]; then
  echo "ℹ️  Static site — skipping wrangler.toml (Pages-only project)"
else

case "$TEMPLATE" in
  worker-only)
    cat << HEREDOC > wrangler.toml
name = "$PROJECT_NAME"
main = "api/src/index.js"
compatibility_date = "$(date +%Y-%m-%d)"

[dev]
port = 8787

[vars]
# Add non-secret config vars here

# ── Cron triggers ──────────────────────────────────────────────────────────────
# Uncomment and configure if this Worker runs on a schedule.
# Document the schedule in .claude/CLAUDE.md under "Cron Schedule".
#
# [triggers]
# crons = ["0 9 * * 1"]   # Example: 9am UTC every Monday

# ── Storage bindings ───────────────────────────────────────────────────────────
# Add bindings here AND update the Active Bindings table in .claude/CLAUDE.md first.
#
# [[kv_namespaces]]
# binding = "APP_KV"
# id      = ""          # wrangler kv:namespace create APP_KV
#
# [[d1_databases]]
# binding  = "DB"
# database_name = "$PROJECT_NAME-db"
# database_id   = ""    # wrangler d1 create $PROJECT_NAME-db
HEREDOC
    ;;

  data-app)
    cat << HEREDOC > wrangler.toml
name = "$PROJECT_NAME-api"
main = "api/src/index.js"
compatibility_date = "$(date +%Y-%m-%d)"

[dev]
port = 8787

[vars]
# Production frontend URL
ALLOWED_ORIGIN = "https://$PROJECT_NAME.pages.dev"

# ── D1 Database ────────────────────────────────────────────────────────────────
# Uncomment after running: wrangler d1 create $PROJECT_NAME-db
# Document in .claude/rules/schema.md and Active Bindings table before use.
#
# [[d1_databases]]
# binding       = "DB"
# database_name = "$PROJECT_NAME-db"
# database_id   = ""    # fill in after wrangler d1 create

# ── KV Namespace ──────────────────────────────────────────────────────────────
# Uncomment after running: wrangler kv:namespace create APP_KV
# Document in Active Bindings table before use.
#
# [[kv_namespaces]]
# binding = "APP_KV"
# id      = ""          # fill in after wrangler kv:namespace create APP_KV

# ── R2 Bucket ─────────────────────────────────────────────────────────────────
# Uncomment after running: wrangler r2 bucket create $PROJECT_NAME-assets
#
# [[r2_buckets]]
# binding     = "ASSETS"
# bucket_name = "$PROJECT_NAME-assets"
HEREDOC
    ;;

  *)  # fullstack default
    cat << HEREDOC > wrangler.toml
name = "$PROJECT_NAME-api"
main = "api/src/index.js"
compatibility_date = "$(date +%Y-%m-%d)"

[dev]
port = 8787

[vars]
# Production frontend URL
ALLOWED_ORIGIN = "https://$PROJECT_NAME.pages.dev"
# Uncomment if using Cloudflare Pages preview deployments:
# PAGES_DOMAIN = "$PROJECT_NAME.pages.dev"

# ── Storage bindings ───────────────────────────────────────────────────────────
# Add bindings here AND update the Active Bindings table in .claude/CLAUDE.md first.
#
# [[kv_namespaces]]
# binding = "APP_KV"
# id      = ""          # wrangler kv:namespace create APP_KV
#
# [[d1_databases]]
# binding       = "DB"
# database_name = "$PROJECT_NAME-db"
# database_id   = ""    # wrangler d1 create $PROJECT_NAME-db
HEREDOC
    ;;
esac

fi

# ── 7. verify_op.sh ───────────────────────────────────────────────────────────

cat << 'HEREDOC' > verify_op.sh
#!/bin/bash

# verify_op.sh — Pre-flight check for 1Password CLI authentication
# Supports both personal interactive sessions and service accounts.

echo "🔒 Verifying 1Password CLI authentication…"

if ! command -v op &>/dev/null; then
  echo "❌ ERROR: 1Password CLI not installed. Run: brew install 1password-cli"
  exit 1
fi

if ! command -v node &>/dev/null; then
  echo "❌ ERROR: Node.js not found. Run: brew install node"
  exit 1
fi

# Check Node meets the minimum major version defined in .nvmrc
if [ -f ".nvmrc" ]; then
  MIN_NODE=$(cat .nvmrc | tr -d '\nv')       # e.g. 20.11.1
  MIN_MAJOR=$(echo "$MIN_NODE" | cut -d. -f1)
  CURRENT_NODE=$(node -v | tr -d 'v')        # e.g. 22.14.0
  CURRENT_MAJOR=$(echo "$CURRENT_NODE" | cut -d. -f1)
  if [ "$CURRENT_MAJOR" -lt "$MIN_MAJOR" ]; then
    echo "⚠️  WARNING: Node version too old."
    echo "   Required: v${MIN_NODE}+ — Found: v${CURRENT_NODE}"
    echo "   Run 'nvm install ${MIN_MAJOR}' or update Node to proceed safely."
    echo ""
  fi
fi

# Test authentication — works for both interactive sessions and service accounts
if op vault list &>/dev/null 2>&1; then
  echo "✅ 1Password authenticated. Vault access confirmed."
else
  echo "❌ ERROR: 1Password CLI authentication failed."
  echo ""
  if [ -n "$OP_SERVICE_ACCOUNT_TOKEN" ]; then
    echo "   Service account token is set but vault access failed — check token permissions."
  else
    echo "   Personal account: run 'op signin' to start a session."
    echo "   Tip: Enable 'Integrate with 1Password CLI' in 1Password → Settings → Developer"
    echo "        to tie authentication to your macOS login — no session expiry."
  fi
  exit 1
fi
HEREDOC
chmod +x verify_op.sh

# ── 8. package.json ───────────────────────────────────────────────────────────

cat << HEREDOC > package.json
{
  "name": "$PROJECT_NAME",
  "private": true,
  "scripts": {
    "preflight": "./verify_op.sh",
    "dev:api": "op run --env-file=.env.tpl -- npx wrangler dev --port 8787 --var ALLOWED_ORIGIN:http://localhost:8788",
    "dev:ui": "npx wait-on http://localhost:8787/api/health && npx wrangler pages dev frontend --proxy 8787",
    "dev": "npm run preflight && concurrently \"npm run dev:api\" \"npm run dev:ui\"",
    "deploy:api": "echo '⚠️  Confirm deploy to production? (ctrl+c to cancel)' && read && npx wrangler deploy",
    "deploy:ui": "echo '⚠️  Confirm deploy to production? (ctrl+c to cancel)' && read && npx wrangler pages deploy frontend",
    "secrets:list": "npx wrangler secret list"
  },
  "devDependencies": {
    "wrangler": "^3.0.0",
    "concurrently": "^8.0.0",
    "wait-on": "^7.0.0",
    "eslint": "^8.0.0",
    "husky": "^9.0.0"
  }
}
HEREDOC

# ── 9. Cloudflare Worker backend (api/src/index.js) ───────────────────────────

if [ "$TEMPLATE" = "static-site" ]; then
  echo "ℹ️  Static site — skipping Worker generation"
else

cat << 'HEREDOC' > api/src/index.js
/**
 * Cloudflare Worker — API backend
 */

function getCorsOrigin(origin, env) {
  const primaryOrigin = env.ALLOWED_ORIGIN || 'http://localhost:8788';

  // 1. Strict exact match
  if (origin === primaryOrigin) return origin;

  // 2. Dynamic match for Pages preview deployments (if configured)
  if (origin && env.PAGES_DOMAIN && origin.endsWith(`.${env.PAGES_DOMAIN}`)) {
    return origin;
  }

  // Fallback blocks unauthorized cross-origin requests
  return primaryOrigin;
}

function corsHeaders(origin, env) {
  return {
    'Access-Control-Allow-Origin': getCorsOrigin(origin, env),
    'Access-Control-Allow-Methods': 'GET, POST, OPTIONS',
    'Access-Control-Allow-Headers': 'Content-Type',
  };
}

// Content-Security-Policy — tighten before production deploy.
// Update script-src and connect-src to match your actual domains.
// Reference: https://developer.mozilla.org/en-US/docs/Web/HTTP/CSP
function cspHeader(env) {
  const apiOrigin = env.ALLOWED_ORIGIN || 'http://localhost:8788';
  return [
    "default-src 'none'",
    "script-src 'self'",
    "style-src 'self'",
    "font-src 'self'",
    "img-src 'self' data:",
    `connect-src 'self' ${apiOrigin}`,
    "frame-ancestors 'none'",
    "base-uri 'self'",
    "form-action 'self'",
  ].join('; ');
}

export default {
  async fetch(request, env, ctx) {
    const url = new URL(request.url);
    const origin = request.headers.get('Origin');

    if (request.method === 'OPTIONS') {
      return new Response(null, { status: 204, headers: corsHeaders(origin, env) });
    }

    if (url.pathname === '/api/health') {
      return new Response(JSON.stringify({ status: 'ok' }), {
        headers: {
          'Content-Type': 'application/json',
          'Content-Security-Policy': cspHeader(env),
          ...corsHeaders(origin, env),
        },
      });
    }

    if (url.pathname === '/api/hello') {
      return new Response(JSON.stringify({
        message: 'Hello from the secure data layer!',
        dbStatus: env.DATABASE_URL ? 'connected' : 'missing',
      }), {
        headers: {
          'Content-Type': 'application/json',
          'Content-Security-Policy': cspHeader(env),
          ...corsHeaders(origin, env),
        },
      });
    }

    return new Response(JSON.stringify({ error: 'Not found' }), {
      status: 404,
      headers: { 'Content-Type': 'application/json', ...corsHeaders(origin, env) },
    });
  },
};
HEREDOC

fi

# ── 10. Frontend (frontend/index.html) ────────────────────────────────────────

cat << HEREDOC > frontend/index.html
<!DOCTYPE html>
<html lang="en">
<head>
  <meta charset="UTF-8">
  <meta name="viewport" content="width=device-width, initial-scale=1.0">
  <meta name="description" content="$PROJECT_DESC">

  <!-- Open Graph / Social sharing -->
  <meta property="og:type"        content="website">
  <meta property="og:title"       content="$PROJECT_NAME">
  <meta property="og:description" content="$PROJECT_DESC">
  <meta property="og:url"         content="https://$PROJECT_NAME.pages.dev">
  <meta property="og:image"       content="https://$PROJECT_NAME.pages.dev/og.png">

  <!-- Twitter / X card -->
  <meta name="twitter:card"        content="summary_large_image">
  <meta name="twitter:title"       content="$PROJECT_NAME">
  <meta name="twitter:description" content="$PROJECT_DESC">
  <meta name="twitter:image"       content="https://$PROJECT_NAME.pages.dev/og.png">

  <title>$PROJECT_NAME</title>

  <!-- Preconnect to API Worker (reduces TTFB on first fetch) -->
  <!-- Update this domain after first deploy -->
  <link rel="preconnect" href="https://$PROJECT_NAME-api.workers.dev">
  <link rel="dns-prefetch" href="https://$PROJECT_NAME-api.workers.dev">

  <link rel="stylesheet" href="/style.css">
</head>
<body>
  <a href="#main-content" class="skip-link">Skip to main content</a>

  <main id="main-content">
    <h1>$PROJECT_NAME</h1>
    <p id="api-status" aria-live="polite">Loading...</p>
  </main>

  <script type="module" src="/app.js"></script>
</body>
</html>
HEREDOC

# ── 11. Frontend (frontend/style.css) ─────────────────────────────────────────

cat << 'HEREDOC' > frontend/style.css
/* Base — intentionally minimal, extend per project */
*, *::before, *::after { box-sizing: border-box; margin: 0; padding: 0; }

:root {
  --color-bg:      #0f0f0f;
  --color-surface: #1a1a1a;
  --color-text:    #ededed;
  --color-muted:   #999;
  --color-accent:  #e8632a;
  --font-serif:    'Georgia', 'Times New Roman', serif;
  --font-sans:     system-ui, -apple-system, sans-serif;
}

body {
  background: var(--color-bg);
  color: var(--color-text);
  font-family: var(--font-sans);
  line-height: 1.6;
  min-height: 100svh;
}

h1, h2, h3 { font-family: var(--font-serif); line-height: 1.15; }

/* Skip link — visually hidden until focused (WCAG 2.4.1) */
.skip-link {
  position: absolute;
  top: -999px;
  left: 0;
  padding: 0.5rem 1rem;
  background: var(--color-accent);
  color: #fff;
  z-index: 9999;
  text-decoration: none;
}
.skip-link:focus-visible { top: 0; }

/* Focus visible — all interactive elements (WCAG 2.4.7) */
:focus-visible {
  outline: 2px solid var(--color-accent);
  outline-offset: 3px;
}

/* Disable cinematic animations for users who prefer reduced motion (WCAG 2.3.3) */
@media (prefers-reduced-motion: reduce) {
  *, *::before, *::after {
    animation-duration: 0.01ms !important;
    transition-duration: 0.01ms !important;
    scroll-behavior: auto !important;
  }
}

main {
  max-width: 960px;
  margin: 0 auto;
  padding: 2rem 1.5rem;
}

/* Error State UI */
.error-message {
  color: #ff5555;
  background: rgba(255, 85, 85, 0.1);
  padding: 1rem;
  border-left: 4px solid #ff5555;
  border-radius: 4px;
  font-weight: 500;
  margin-top: 1rem;
}
HEREDOC

# ── 12. Frontend (frontend/app.js) ────────────────────────────────────────────

cat << 'HEREDOC' > frontend/app.js
// app.js — Vanilla JS entry point
// All API calls go to /api/… — never talk to 1Password or expose credentials

const statusEl = document.getElementById('api-status');

async function init() {
  try {
    const response = await fetch('/api/hello');
    if (!response.ok) throw new Error(`HTTP ${response.status}`);
    const data = await response.json();
    statusEl.textContent = `${data.message} — DB: ${data.dbStatus}`;
    statusEl.classList.remove('error-message');
  } catch (err) {
    statusEl.textContent = 'Unable to connect to the API. Please try again.';
    statusEl.classList.add('error-message');
    console.error('API error:', err);
  }
}

init();
HEREDOC

# ── 13. .claude/ context — project CLAUDE.md + rules symlinks ────────────────

# The global ~/.claude/CLAUDE.md is auto-loaded by Claude Code.
# Project-level CLAUDE.md provides project-specific context only.
# Rules in .claude/rules/ load automatically:
#   - Unconditional rules: every session
#   - Path-scoped rules: only when Claude touches matching files

cp "$TEMPLATE_SRC" .claude/CLAUDE.md

echo "🔗 Wiring .claude/rules/ symlinks…"
mkdir -p .claude/rules

RULES_SRC="$SCRIPT_DIR/rules"

# Verify shared rules exist before symlinking
for rule in secrets.md frontend.md api.md; do
  if [ ! -f "$RULES_SRC/$rule" ]; then
    echo "⚠️  Warning: $RULES_SRC/$rule not found — skipping symlink."
    echo "   Run the setup checklist to install shared rules into ~/tools/rules/"
  fi
done

# Symlink matrix — keyed to project type
case "$TEMPLATE" in
  fullstack)
    [ -f "$RULES_SRC/secrets.md"       ] && ln -sf "$RULES_SRC/secrets.md"        .claude/rules/secrets.md
    [ -f "$RULES_SRC/frontend.md"      ] && ln -sf "$RULES_SRC/frontend.md"       .claude/rules/frontend.md
    [ -f "$RULES_SRC/api.md"           ] && ln -sf "$RULES_SRC/api.md"            .claude/rules/api.md
    [ -f "$RULES_SRC/design-system.md" ] && ln -sf "$RULES_SRC/design-system.md"  .claude/rules/design-system.md
    [ -f "$RULES_SRC/performance.md"   ] && ln -sf "$RULES_SRC/performance.md"    .claude/rules/performance.md
    ;;
  worker-only)
    [ -f "$RULES_SRC/secrets.md"  ] && ln -sf "$RULES_SRC/secrets.md"  .claude/rules/secrets.md
    [ -f "$RULES_SRC/api.md"      ] && ln -sf "$RULES_SRC/api.md"      .claude/rules/api.md
    ;;
  static-site)
    [ -f "$RULES_SRC/frontend.md"      ] && ln -sf "$RULES_SRC/frontend.md"       .claude/rules/frontend.md
    [ -f "$RULES_SRC/design-system.md" ] && ln -sf "$RULES_SRC/design-system.md"  .claude/rules/design-system.md
    [ -f "$RULES_SRC/performance.md"   ] && ln -sf "$RULES_SRC/performance.md"    .claude/rules/performance.md
    ;;
  data-app)
    [ -f "$RULES_SRC/secrets.md"       ] && ln -sf "$RULES_SRC/secrets.md"        .claude/rules/secrets.md
    [ -f "$RULES_SRC/frontend.md"      ] && ln -sf "$RULES_SRC/frontend.md"       .claude/rules/frontend.md
    [ -f "$RULES_SRC/api.md"           ] && ln -sf "$RULES_SRC/api.md"            .claude/rules/api.md
    [ -f "$RULES_SRC/design-system.md" ] && ln -sf "$RULES_SRC/design-system.md"  .claude/rules/design-system.md
    [ -f "$RULES_SRC/performance.md"   ] && ln -sf "$RULES_SRC/performance.md"    .claude/rules/performance.md
    # data-app gets project-local stubs — these are committed, not symlinked
    DATA_APP_RULES="$SCRIPT_DIR/templates/data-app/.claude/rules"
    cp "$DATA_APP_RULES/schema.md" .claude/rules/schema.md
    cp "$DATA_APP_RULES/auth.md"   .claude/rules/auth.md
    ;;
esac

# ── Slash commands ────────────────────────────────────────────────────────────
COMMANDS_SRC="$SCRIPT_DIR/commands"
if [ -d "$COMMANDS_SRC" ]; then
  mkdir -p .claude/commands
  for cmd in "$COMMANDS_SRC"/*.md; do
    [ -f "$cmd" ] && cp "$cmd" ".claude/commands/$(basename "$cmd")"
  done
  echo "⚡ Slash commands installed (.claude/commands/)"
else
  echo "⚠️  commands/ not found at $COMMANDS_SRC — skipping slash commands."
fi

# ── settings.local.json stub (gitignored — personal overrides) ────────────────
cat << 'LOCALEOF' > .claude/settings.local.json
{}
LOCALEOF
echo "🔧 settings.local.json stub created (gitignored — add personal overrides here)"

# ── 13b. .claude/settings.json — permissions + PostToolUse hooks ─────────────

SETTINGS_SRC="$SCRIPT_DIR/settings/settings.json"

if [ -f "$SETTINGS_SRC" ]; then
  cp "$SETTINGS_SRC" .claude/settings.json
  echo "⚙️  Claude Code permissions and hooks wired (.claude/settings.json)"
else
  echo "⚠️  settings/settings.json not found at $SETTINGS_SRC — skipping."
  echo "   Run the setup checklist to install settings into ~/tools/settings/"
fi

# Substitute known values into the project CLAUDE.md.
# Uses python3 to safely handle special characters in user-provided input
# (sed chokes on slashes and ampersands in project descriptions).
python3 - "$PROJECT_NAME" "$PROJECT_DESC" << 'PYEOF'
import sys, re
name, desc = sys.argv[1], sys.argv[2]
with open('.claude/CLAUDE.md', 'r') as f:
    content = f.read()
content = content.replace('{{PROJECT_NAME}}', name)
content = re.sub(r'\{\{One-sentence description[^}]*\}\}', desc, content)
with open('.claude/CLAUDE.md', 'w') as f:
    f.write(content)
PYEOF

# ── 14. Git initialization & "Update Instead" configuration ───────────────
echo "📦 Initializing Git and applying Tailscale safety rules..."
git init
git config receive.denyCurrentBranch updateInstead

# 🔒 1Password Headless SSH Signing Fix
# If the 1Password Mac app is installed, force Git to use its custom signing
# binary. This prevents the "Couldn't find key in agent" error during headless remote sessions.
if [ -f "/Applications/1Password.app/Contents/MacOS/op-ssh-sign" ]; then
    echo "   Applying 1Password headless SSH signing bypass..."
    git config --global gpg.ssh.program "/Applications/1Password.app/Contents/MacOS/op-ssh-sign"
fi

git add .
git commit -m "chore: initial scaffold with zero-trust architecture"

# ── 15. Install dependencies ──────────────────────────────────────────────────

echo "⚡ Installing dependencies…"
npm install

# ── 16. ESLint + Husky pre-commit hooks ───────────────────────────────────────

echo "🪝 Setting up pre-commit hooks…"

cat << 'HEREDOC' > .eslintrc.json
{
  "env": { "browser": true, "es2022": true, "worker": true },
  "parserOptions": { "ecmaVersion": 2022, "sourceType": "module" },
  "rules": {
    "no-unused-vars": "warn",
    "no-console": "off",
    "no-undef": "error"
  }
}
HEREDOC

# Initialize Husky and write the pre-commit hook
npx husky init
cat << 'HEREDOC' > .husky/pre-commit
#!/bin/sh
npx eslint api/src/ frontend/*.js --max-warnings=0
HEREDOC
chmod +x .husky/pre-commit

# Stage the new files so the initial commit includes them
git add .eslintrc.json .husky/

# ── 17. GitHub remote (optional) ─────────────────────────────────────────────

if command -v gh &>/dev/null; then
  echo ""
  read -rp "🐙 Create private GitHub repo and push? (y/N): " CREATE_REMOTE
  if [[ "$CREATE_REMOTE" =~ ^[Yy]$ ]]; then
    gh repo create "$PROJECT_NAME" --private --source=. --remote=origin --push
    GITHUB_URL=$(gh repo view "$PROJECT_NAME" --json url -q .url 2>/dev/null || echo "")
    echo "✅ GitHub repo created and pushed."
  fi
fi

# ── 18. Summary ───────────────────────────────────────────────────────────────

REPO_PATH=$(pwd)
MAC_HOSTNAME=$(scutil --get LocalHostName 2>/dev/null || hostname -s)

echo ""
echo "✅ $PROJECT_NAME is ready. ($TEMPLATE)"
echo ""
echo "📁 Structure:"
echo "   $PROJECT_NAME/"
echo "   ├── frontend/           Cloudflare Pages (HTML, CSS, JS)"
if [ "$TEMPLATE" != "static-site" ]; then
  echo "   ├── api/src/            Cloudflare Worker"
fi
echo "   ├── .claude/"
echo "   │   ├── CLAUDE.md           Project context ($TEMPLATE template)"
echo "   │   ├── settings.json       Permissions + PostToolUse hooks"
echo "   │   ├── settings.local.json Personal overrides (gitignored)"
echo "   │   ├── commands/"
echo "   │   │   ├── preflight.md"
echo "   │   │   ├── binding-audit.md"
echo "   │   │   └── deploy-check.md"
echo "   │   └── rules/"

case "$TEMPLATE" in
  fullstack|data-app)
    echo "   │       ├── secrets.md       → ~/tools/rules/ (symlink)"
    echo "   │       ├── frontend.md      → ~/tools/rules/ (symlink)"
    echo "   │       ├── api.md           → ~/tools/rules/ (symlink)"
    echo "   │       ├── design-system.md → ~/tools/rules/ (symlink)"
    echo "   │       └── performance.md   → ~/tools/rules/ (symlink)"
    if [ "$TEMPLATE" = "data-app" ]; then
      echo "   │       ├── auth.md          (project-local stub)"
      echo "   │       └── schema.md        (project-local stub)"
    fi
    ;;
  worker-only)
    echo "   │       ├── secrets.md → ~/tools/rules/ (symlink)"
    echo "   │       └── api.md     → ~/tools/rules/ (symlink)"
    ;;
  static-site)
    echo "   │       ├── frontend.md      → ~/tools/rules/ (symlink)"
    echo "   │       ├── design-system.md → ~/tools/rules/ (symlink)"
    echo "   │       └── performance.md   → ~/tools/rules/ (symlink)"
    ;;
esac

if [ "$TEMPLATE" != "static-site" ]; then
  echo "   ├── wrangler.toml       Worker config"
  echo "   ├── .env.tpl            Secret references (op:// — safe to commit)"
fi
echo "   ├── .eslintrc.json      ESLint config"
echo "   ├── .husky/             Pre-commit hooks"
echo "   └── verify_op.sh        1Password preflight check"
echo ""
echo "➡️  Next steps:"
echo ""
echo "   1. Update op:// references in .env.tpl to match your 1Password vault items."
echo "      Run: op item get 'Claude API' --format json | jq '.fields[] | {label, reference}'"
echo ""
echo "   2. Start local dev:"
echo "      cd $REPO_PATH && npm run dev"
echo ""
if [ -n "${GITHUB_URL:-}" ]; then
  echo "   3. GitHub repo: $GITHUB_URL"
  echo "      Clone: gh repo clone $PROJECT_NAME"
  echo ""
else
  echo "   3. Clone from your laptop (requires Tailscale):"
  echo "      git clone ssh://$(whoami)@$MAC_HOSTNAME.local:$REPO_PATH"
  echo "      (Replace .local with your Tailscale MagicDNS hostname if needed)"
  echo "      (Or run: gh repo create $PROJECT_NAME --private --source=. --remote=origin --push)"
  echo ""
fi
echo "   4. After first production deploy, update ALLOWED_ORIGIN in api/src/index.js"
echo "      to your Cloudflare Pages domain and bind production secrets:"
echo "      npx wrangler secret put AI_API_KEY"
echo "      npx wrangler secret put DATABASE_URL"
echo ""
echo "──────────────────────────────────────────────────────────────────────────────"
echo "📋 Complete .claude/CLAUDE.md before your first Claude Code session:"
echo ""
echo "   Already populated:"
echo "   ✅  Project name"
if [[ "$PROJECT_DESCRIPTION" != "{{TODO"* ]]; then
  echo "   ✅  Description"
else
  echo "   ⚠️  Description         — fill this in first, Claude reads it every session"
fi
case "$TEMPLATE" in
  fullstack)
    echo "   ✅  Pages URL          — $PAGES_URL"
    echo ""
    echo "   Complete manually:"
    echo "   ✏️   Worker URL subdomain — replace <your-subdomain> in Worker URL"
    echo "   ✏️   Active Bindings     — update the table before adding any wrangler.toml binding"
    echo "   ✏️   Known Quirks        — add as you discover them"
    ;;
  worker-only)
    echo "   ✅  Worker URL (partial) — replace <your-subdomain> once known"
    echo ""
    echo "   Complete manually:"
    echo "   ✏️   Trigger type         — Cron / HTTP / Queue"
    echo "   ✏️   Cron schedule        — if applicable, add to wrangler.toml and document here"
    echo "   ✏️   Output / Side Effects — what does it actually write, call, or send?"
    echo "   ✏️   Active Bindings      — update before adding any wrangler.toml binding"
    echo "   ✏️   Known Quirks         — add as you discover them"
    ;;
  static-site)
    echo "   ✅  Pages URL          — $PAGES_URL"
    echo ""
    echo "   Complete manually:"
    echo "   ✏️   Custom domain        — if applicable"
    echo "   ✏️   Brand & Design table — fill in before writing any CSS (overrides global defaults)"
    echo "   ✏️   Third-Party Scripts  — list every external domain loaded (needed for CSP headers)"
    echo "   ✏️   Known Quirks         — add as you discover them"
    ;;
  data-app)
    echo "   ✅  Pages URL          — $PAGES_URL"
    echo "   ✅  Worker name        — ${PROJECT_NAME}-api"
    echo ""
    echo "   Complete manually (highest priority — Claude makes wrong assumptions without these):"
    echo "   ✏️   Auth strategy        — Cloudflare Access / JWT / magic link / etc."
    echo "   ✏️   Database Schema      — keep current; Claude reads this instead of migration files"
    echo "   ✏️   Auth Flow            — document the request lifecycle once; Claude threads it everywhere"
    echo "   ✏️   Active Bindings      — update before touching wrangler.toml"
    echo "   ✏️   API Routes table     — add as you build"
    echo "   ✏️   Known Quirks         — D1 gotchas, KV consistency, auth edge cases"
    ;;
esac
echo ""
echo "   Open now:  open .claude/CLAUDE.md"
echo "──────────────────────────────────────────────────────────────────────────────"
echo ""
echo "📋 Before your first Claude Code session, complete .claude/CLAUDE.md:"
echo ""

case "$TEMPLATE" in
  fullstack)
    echo "   Required now:"
    echo "   • Worker URL account subdomain  ({{ACCOUNT_SUBDOMAIN}})"
    echo ""
    echo "   Fill in as the project grows:"
    echo "   • Active Bindings table — update before adding any KV/D1/R2 binding"
    echo "   • Known Quirks — add as you discover them"
    ;;
  worker-only)
    echo "   Required now:"
    echo "   • Trigger type  (Cron / HTTP / Queue)"
    echo "   • Worker URL account subdomain  ({{ACCOUNT_SUBDOMAIN}})"
    echo ""
    echo "   Fill in before first deploy:"
    echo "   • Cron Schedule — add the wrangler.toml trigger block"
    echo "   • Output / Side Effects — what does this Worker actually change?"
    echo ""
    echo "   Fill in as the project grows:"
    echo "   • Active Bindings table"
    echo "   • Known Quirks"
    ;;
  static-site)
    echo "   Required now (before writing any CSS):"
    echo "   • Brand & Design Decisions — token overrides from your global defaults"
    echo ""
    echo "   Fill in before first deploy:"
    echo "   • Custom Domain  (if applicable)"
    echo "   • Third-Party Scripts / Embeds — needed for CSP headers"
    echo ""
    echo "   Fill in as the project grows:"
    echo "   • Page Structure table"
    echo "   • Known Quirks"
    ;;
  data-app)
    echo "   Required now:"
    echo "   • Worker URL account subdomain  ({{ACCOUNT_SUBDOMAIN}})"
    echo "   • Auth strategy  ({{Describe auth strategy...}})"
    echo ""
    echo "   Fill in before writing any routes:"
    echo "   • Database Schema — keep current; Claude reads this instead of migration files"
    echo "   • Auth Flow — document the full request lifecycle once"
    echo ""
    echo "   Fill in as the project grows:"
    echo "   • Active Bindings table — update before adding any binding"
    echo "   • API Routes table"
    echo "   • Known Quirks"
    ;;
esac
echo ""