# Fresh [![Thanks](https://bit.ly/saythankss)](https://github.com/sponsors/corb3t)
Starting a fresh install of macOS and linux can be such a pain - all of your apps are gone and none of your settings are configured. Here's a collection of scripts, applications, CLI tools, extensions, config files, and dotfiles that make re-installing a breeze.

## Warning
If you are interested in setting up dotfiles, you should fork this repository, review the code, and remove and edit any things you don’t want or need. Use at your own risk!

## Start Here
Clone this repo to the hidden ~/.config directory in your home directory to restore your app's configuration files!

Run this:
```
git clone https://github.com/corb3t/fresh.git ~/.config
cd ~/.config
```

## Install Brew
[Brew](https://brew.sh/) lets macOS and Linux users install applications from the command line. This lets users easily script and automate their app installation and configuration process using my fresh repo.

Enter the following in terminal:

```
/bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
```

## Install Brew Apps
To install off your apps outlined in the Brewfile, enter the following in terminal to run a script that will download as many app as possible using homebrew.

```
brew bundle --file ~/.config/Brewfile
```

## Setup macOS Settings

```
source ~/.config/setup-macos.sh
```

## Setup symlinks

```
source ~/.config/setup-symlinks.sh
```

## Claude Tools (Scaffold)

This repo includes a project scaffolding system built around [Claude Code](https://claude.ai/code), Anthropic's AI coding agent. It generates opinionated, zero-trust Cloudflare + 1Password monorepos and pre-loads them with the right AI context so Claude Code starts every session already knowing your stack, standards, and constraints.

### How it works

Claude Code reads `CLAUDE.md` files automatically at the start of every session. This system uses three layers that stack together:

```
~/.claude/CLAUDE.md              ← Global: your identity, stack, hard rules — applies to every project
  └── .claude/CLAUDE.md          ← Project: what this specific codebase is and how it deviates
        └── .claude/CLAUDE.local.md  ← Local: your machine, ports, Tailscale config (gitignored)
```

**Global (`~/.claude/CLAUDE.md`)** — Your universal system prompt. Defines your role, workflow, architecture defaults (Cloudflare Workers + Pages, Vanilla JS, zero-dependency), secrets management rules (1Password CLI, `op://` references only), accessibility standards (WCAG AA), and hard limits (no CSS frameworks, no secrets in source, no unapproved deploys). Copied from `~/Claude/CLAUDE.md` during setup. Edit this file once and every future project inherits it.

**Project (`.claude/CLAUDE.md`)** — Generated per-project by `scaffold.sh` from a type-specific template. Records the production URL, active Cloudflare bindings, API route table, database schema, auth flow, and any quirks specific to this codebase. Lives in `.claude/` at the project root and is committed to git. Only contains what Claude cannot infer from reading the code.

**Local (`.claude/CLAUDE.local.md`)** — Optional, gitignored. Machine-specific context: Tailscale hostnames, 1Password session notes, local port conflicts, editor setup. Create this in any project where you need per-machine context that shouldn't be shared.

### Source layout

`~/Claude/` is the source of truth for all scaffold files. `setup-symlinks.sh` links them into `~/tools/` — edit in `~/Claude/`, changes reflect immediately.

```
~/Claude/
├── CLAUDE.md              # Global system prompt → copied to ~/.claude/CLAUDE.md at setup
├── scaffold.sh            # Project generator script
├── new-project.zsh        # Shell function (sourced into .zshrc)
├── checklist.md           # One-time setup checklist
└── templates/             # Project-type CLAUDE.md templates
    ├── fullstack/          # Pages + Worker (default scaffold output)
    ├── worker-only/        # No frontend — cron jobs, webhooks, internal APIs
    ├── static-site/        # No API — portfolios, landing pages, content sites
    └── data-app/           # Pages + Worker + D1/KV/auth
        └── .claude/
            └── CLAUDE.md
```

### Project types

When you run `new-project`, you choose a template that determines the project-level `CLAUDE.md` Claude Code receives:

| Type | Frontend | Worker | Database | Use when… |
|---|---|---|---|---|
| `fullstack` | ✅ Pages | ✅ Worker | — | Default — Pages + Worker, no significant data layer yet |
| `worker-only` | — | ✅ Worker | optional | Cron job, webhook receiver, internal API, background processor |
| `static-site` | ✅ Pages | — | — | Portfolio, landing page, docs site — no backend needed |
| `data-app` | ✅ Pages | ✅ Worker | ✅ D1/KV | User accounts, dashboards, anything with a schema or auth |

### Creating a new project

After running `setup-symlinks.sh`, scaffold new projects from anywhere:

```bash
new-project my-app
```

The script runs preflight checks (1Password auth, Node, git), prompts for project type, generates the full monorepo structure, copies the appropriate template into `.claude/CLAUDE.md`, initializes git, installs dependencies, wires ESLint + Husky pre-commit hooks, and optionally creates a private GitHub repo.

```
my-app/
├── frontend/              # Cloudflare Pages (HTML, CSS, Vanilla JS)
├── api/src/               # Cloudflare Worker
├── .claude/
│   └── CLAUDE.md          # Project-level prompt (type-specific template)
├── wrangler.toml          # Worker config — source of truth for all bindings
├── .env.tpl               # Secret references (op:// URIs — safe to commit)
├── .eslintrc.json
├── .husky/pre-commit
└── verify_op.sh           # 1Password preflight check
```

### After scaffolding

Three things to do immediately before your first Claude Code session:

1. **Fill in the `CLAUDE.md` placeholders** — open `.claude/CLAUDE.md` and replace `{{PROJECT_NAME}}`, `{{PRODUCTION_URL}}`, and the description with real values.
2. **Update `.env.tpl`** — replace the default `op://` references with your actual 1Password vault paths.
3. **Create `.claude/CLAUDE.local.md`** (optional) — add machine-specific notes: Tailscale hostname, local port assignments, 1Password session reminders. This file is gitignored globally and never committed.

### Maintaining templates

`~/Claude/templates/` is where you evolve the project-type templates over time. Changes apply to all future projects automatically. To update a template based on lessons from a current project:

```bash
# Copy an improved template back to the source
cp my-app/.claude/CLAUDE.md ~/Claude/templates/data-app/.claude/CLAUDE.md
```

## Install Other Apps
Download my favorite apps from the App store or independent websites:

* [Tot](https://tot.rocks/) - Tiny Quick Note-taking app
* [Meeter](https://www.trymeeter.com/) - Show upcoming meetings in your menubar and easily launch the appropriate app
* [Gestimer](http://maddin.io/gestimer/) - Easily set a reminder from your menubar
* [ColorSlurp](https://colorslurp.com/) - Color picker for macOS
* [Reeder 5](https://reederapp.com/) - RSS Reader, which uses a self-hosted instance of [FreshRSS](https://www.freshrss.org/) on my Unraid server
* [Scrobbles for Last.fm](https://apps.apple.com/us/app/scrobbles-for-last-fm/id1344679160?mt=12) - Tracks my music listening history

## Keyboard
Shortcuts: Disable Spotlight in preparation for enabling Alfred as default shortcut using cmd + space.

## Upgrading Apps
Enter the following command to update and remove any leftover brew files

```
brew update && brew upgrade && brew autoremove && brew cleanup
```

## Hire Me

Do you think I would be a valuable asset to your software development team? I am currently open to employment - e-mail me at me@corbet.dev!

## Special Thanks

[Unofficial Guide to Github Dotfile](https://dotfiles.github.io/) - Great resource.

[dotfiles](https://github.com/pawelgrzybek/dotfiles) - Original inspiration for my dotfile creation
[Backing up VS Code with dotfiles and symlinks](https://pawelgrzybek.com/sync-vscode-settings-and-snippets-via-dotfiles-on-github/) - Backup up VS Code, a great app.

[Oh My Zsh + Powerlevel 10k Terminal](https://dev.to/abdfnx/oh-my-zsh-powerlevel10k-cool-terminal-1no0) - While Terminal is great, there are many great plugins for iterm 2 that make it great

[More dotfiles templates](https://gitlab.com/dnsmichi/dotfiles) - More dotfile inspos

[Another amazing dotfile guide](https://github.com/holman/dotfiles) - Helped me simplify this process.