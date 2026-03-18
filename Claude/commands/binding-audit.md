Read `wrangler.toml` and `.claude/CLAUDE.md` (or `.claude/rules/schema.md` if it exists).

Cross-reference every binding declared in `wrangler.toml` against the Active Bindings table in the project CLAUDE.md. Then scan `api/src/` for any KV, D1, R2, or env references in code that are not declared in `wrangler.toml`.

Report three lists:
1. **Declared in wrangler.toml but missing from CLAUDE.md binding table** — these need to be documented
2. **In CLAUDE.md binding table but missing from wrangler.toml** — these are phantom bindings (docs ahead of reality)
3. **Referenced in code but not declared anywhere** — these will fail silently in production

For each item, show the exact binding name, where it appears, and what action is needed.
End with a summary line: either "All bindings are in sync" or the count of issues found.
