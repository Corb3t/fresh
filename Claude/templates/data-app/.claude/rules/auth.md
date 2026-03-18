---
paths:
  - api/src/**
---

# 🔐 Auth Rules

> Document the auth flow once here — Claude will thread it through every new endpoint
> without being told. Update this file before writing any protected route.

## Auth Strategy

{{Describe auth strategy — Cloudflare Access, JWT, session cookie, magic link, etc.}}

## Request Lifecycle

1. {{Step 1 — e.g. User hits POST /api/auth/login with email + password}}
2. {{Step 2 — e.g. Worker validates against D1, issues a signed JWT stored in APP_KV}}
3. {{Step 3 — e.g. All protected routes check Authorization: Bearer <token> header}}
4. Token TTL: {{24h}} — refresh via {{POST /api/auth/refresh}}

## Protected Route Pattern

All `/api/{{protected-prefix}}/*` routes require a valid token.
Invalid/expired token → 401 (frontend handles redirect to /login — Worker never redirects).

## Auth Hard Rules

- Never return different error messages for "wrong password" vs "user not found" — timing/enumeration attacks.
- JWT signing key lives in `APP_KV` or as a bound Worker secret — never hardcoded.
- Never log tokens, session IDs, or any credential fragment.
