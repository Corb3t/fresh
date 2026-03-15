# CLI Reference

A practical reference for day-to-day terminal work across the homelab stack: Node, Cloudflare Workers, Git, 1Password, and Tailscale.

---

## ⭐ VIP — Commands You'll Use Every Day

```bash
# Start local dev (Worker + Pages)
npm run dev

# The full git commit flow
git add . && git commit -m "type: message" && git push

# Check what changed before committing
git status

# Stream live Worker logs in production
npx wrangler tail

# Undo last commit but keep your changes
git reset --soft HEAD~1

# Shelve dirty work, do something else, restore it
git stash
git stash pop

# Kill whatever is hanging
Ctrl+C

# Unblock a port after a bad exit
lsof -i :8787
kill 12345

# Confirm 1Password is authenticated before a session
op whoami

# Check your Tailscale devices and connectivity
tailscale status
```

---

## Navigation & Files

```bash
pwd                   # Where am I?
ls -la                # All files including hidden, with permissions
cd -                  # Jump back to previous directory
open .                # Open current folder in Finder
```

---

## Processes & Ports

```bash
ps aux | grep node    # Find running node processes
lsof -i :8787         # What's using this port?
top                   # Live process monitor (q to quit)
htop                  # Prettier version (brew install htop)
```

---

## Escape Hatches

When a process hangs or npm errors out:

```bash
Ctrl+C        # Kill the current process — try this first
Ctrl+D        # Send EOF, exits the current shell or session
Ctrl+Z        # Suspend to background, then run kill %1 to clean up
q             # Exit pagers like less if you're stuck in one
:q            # Exit vim if you accidentally end up there
```

If npm left orphaned processes holding a port:

```bash
lsof -i :8787         # Find what's holding your Worker port
lsof -i :8788         # Find what's holding your Pages port
kill 12345            # Kill by PID
kill -9 12345         # Force kill if it won't respond
```

---

## Git

### Everyday flow

```bash
git status                  # See what changed
git diff                    # See unstaged changes before adding
git add .                   # Stage everything
git add -p                  # Stage changes interactively, chunk by chunk
git commit -m "type: msg"   # Commit with a conventional message
git push                    # Push to remote
```

### Useful recovery commands

```bash
git stash                   # Shelve dirty changes temporarily
git stash pop               # Restore shelved changes
git diff HEAD               # See all changes since last commit
git reset --soft HEAD~1     # Undo last commit, keep changes staged
git log --oneline -10       # Last 10 commits at a glance
git push origin main        # Explicit push if default upstream isn't set
```

---

## npm & Node

```bash
npm list --depth=0          # Installed packages in current project
npm outdated                # Which packages have updates available
node -e "console.log(process.version)"  # Quick Node version check
```

---

## Cloudflare & Wrangler

```bash
npx wrangler whoami          # Confirm Cloudflare auth is working
npx wrangler secret list     # See what secrets are bound to a Worker
npx wrangler tail            # Stream live Worker logs — essential for debugging
npx wrangler pages list      # List your Pages projects
```

> `wrangler tail` is the most useful debugging tool for production Worker errors. Run it in a second terminal tab while you reproduce the issue.

---

## 1Password CLI

```bash
op whoami                                         # Confirm authenticated
op vault list                                     # List all vaults
op item list --vault Homelab                      # List items in a vault
op item get "Unraid API Key" --vault Homelab      # Inspect a specific item
```

---

## Tailscale

```bash
tailscale status             # See all devices on your tailnet
tailscale ping alexandria    # Test connectivity to your Unraid box
tailscale funnel status      # See what ports are currently funneled
```

---

## Network & curl

```bash
curl -I https://yoursite.com                      # Check response headers
curl -s https://yoursite.com/api/health | jq      # Pretty-print a JSON response
ping 100.94.146.116                               # Test Tailscale IP reachability
```

---

## System (macOS)

```bash
df -h                        # Disk usage
du -sh *                     # Size of everything in current directory
history | grep npm           # Search command history
!!                           # Re-run the last command
!git                         # Re-run the last git command
```

---

## Conventional Commit Types

Used in `git commit -m "type: message"` — your Husky pre-commit hook enforces this pattern.

| Type       | When to use                                      |
|------------|--------------------------------------------------|
| `feat`     | New feature or capability                        |
| `fix`      | Bug fix                                          |
| `chore`    | Tooling, deps, config — no production code change|
| `refactor` | Code restructure with no behavior change         |
| `docs`     | Documentation only                               |
| `style`    | Formatting, whitespace — no logic change         |
| `perf`     | Performance improvement                          |