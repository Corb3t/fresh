Run the full pre-deploy verification sequence. Do not suggest or initiate a deploy until every step passes.

1. **Working tree** — run `git status`; FAIL if there are uncommitted changes
2. **Lint** — run `npx eslint api/src/ frontend/*.js --max-warnings=0`; FAIL on any error or warning
3. **Tests** — run `npm test` if a test script exists; FAIL on any failure; WARN if no tests exist
4. **Secrets** — run `npm run secrets:list`; WARN for any secret in `.env.tpl` that is not yet bound in production
5. **Wrangler config** — confirm `wrangler.toml` `compatibility_date` is not more than 12 months old; WARN if stale
6. **Lighthouse** — if `npm run lighthouse` is available, run it; FAIL if performance < 90 or LCP > 2.5s; WARN if accessibility < 90
7. **CORS** — confirm `ALLOWED_ORIGIN` in `api/src/index.js` is set to the production Pages domain, not localhost

Print PASS / WARN / FAIL for each step with a one-line explanation.

If all steps PASS (warnings allowed): print the deploy commands and ask for explicit confirmation before running either:
- `npm run deploy:api` — deploys the Worker
- `npm run deploy:ui` — deploys the Pages frontend

Never run both deploy commands in the same step without confirming each separately.
