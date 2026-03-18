Run the full session preflight sequence and report status for each step:

1. Run `./verify_op.sh` — confirm 1Password CLI is authenticated and vault is accessible
2. Run `git status` — report working tree state; flag any uncommitted changes that could block a Tailscale push
3. Run `npm run secrets:list` — list currently bound Worker secrets; flag any that are in `.env.tpl` but not yet bound in production
4. Check that `.nvmrc` Node version matches `node -v` — warn if they diverge by major version
5. Confirm `wrangler.toml` exists and `name` field is set (not the scaffold placeholder)

Print a clear PASS / WARN / FAIL for each step.
If any step FAILs, stop and explain what needs to be resolved before proceeding with dev work.
If all steps PASS, confirm the session is ready with a single summary line.
