---
paths:
  - api/src/**
---

# 🌐 API / Worker Rules

## Logging Policy

- **Log:** request metadata, errors
- **Never log:** user data, secrets, full request bodies
- `console.error` in Workers only — never in frontend code.
- Return structured error responses and user-friendly fallback copy to clients.
  Never return raw error messages, stack traces, or internal details.

## CORS

- `ALLOWED_ORIGIN` in `api/src/index.js` controls permitted origins.
- Local dev: `http://localhost:8788` — Production: Cloudflare Pages domain.
- Always handle `OPTIONS` preflight requests — return `204` with correct headers.
- Never use `Access-Control-Allow-Origin: *` in production.

## Rate Limiting

- All public endpoints must implement rate limiting via Cloudflare WAF or Worker logic.
- MCP tool endpoints (if present) are public API surface — rate limiting is non-negotiable.

## Worker Hard Rules

- All database connections, business logic, and external/AI API calls live in the Worker.
- Never expose AI API keys, database credentials, or secrets in HTTP responses.
- Write tests for all critical business logic and core backend routes.
