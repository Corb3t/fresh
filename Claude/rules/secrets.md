# 🔒 Secrets Management

> Unconditional — applies to all files in every session.

## Zero-Trust Rules (Absolute)

- NEVER hardcode secrets, API keys, or database URLs in source code.
  Never output them in the terminal, logs, or HTTP responses.
- Never create or modify `.env` or `.dev.vars` — both are gitignored.
  Treat any request to create them as a security violation.
- All secrets are defined in `.env.tpl` using 1Password syntax:
  `VARIABLE_NAME="op://VaultName/ItemName/FieldName"`
  `.env.tpl` contains only `op://` references — never real values. Safe to commit.
- Always run dev servers via npm scripts:
  `op run --env-file=.env.tpl -- npx wrangler dev`
  This resolves `op://` references at runtime. Nothing touches disk.
- Production secrets: `wrangler secret put SECRET_NAME` — always interactive, never scripted.
  Check bound secrets with `npm run secrets:list`.
- Always run `./verify_op.sh` at the start of every session before writing any code.

## 1Password CLI

- This setup uses a **personal 1Password account** with the `op` CLI.
- Auth is via macOS keychain — run `op signin` once, then enable
  "Integrate with 1Password CLI" in 1Password → Settings → Developer.
- Verify the session is active: `op whoami`
- If `op` fails during a headless session: run `op signin` interactively once,
  then re-enable integration in Settings → Developer.
