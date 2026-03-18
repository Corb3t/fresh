# Scaffold Setup Checklist

One-time setup to get `new-project` working end-to-end on your Mac mini.

# 1. Put your tools in place
mkdir -p ~/tools/rules ~/tools/settings ~/tools/commands
mv scaffold.sh CLAUDE.md ~/tools/
mv rules/secrets.md rules/frontend.md rules/api.md rules/design-system.md rules/performance.md ~/tools/rules/
mv settings/settings.json ~/tools/settings/
mv commands/*.md ~/tools/commands/
chmod +x ~/tools/scaffold.sh

# 2. Shell function
echo "source ~/tools/new-project.zsh" >> ~/.zshrc && source ~/.zshrc

# 3. GitHub CLI (if not already)
brew install gh && gh auth login

# 4. Raycast script — point Raycast at your scripts folder, drop the file in

-----

## 1 · Tools Directory

- [ ] Create the tools subdirectories

  ```bash
  mkdir -p ~/tools/rules ~/tools/settings ~/tools/commands
  ```
- [ ] Move `scaffold.sh` and `CLAUDE.md` into `~/tools/`

  ```bash
  mv ~/Downloads/scaffold.sh ~/tools/scaffold.sh
  mv ~/Downloads/CLAUDE.md ~/tools/CLAUDE.md
  ```
- [ ] Move the five shared rules files into `~/tools/rules/`

  ```bash
  mv ~/Downloads/rules/secrets.md       ~/tools/rules/secrets.md
  mv ~/Downloads/rules/frontend.md      ~/tools/rules/frontend.md
  mv ~/Downloads/rules/api.md           ~/tools/rules/api.md
  mv ~/Downloads/rules/design-system.md ~/tools/rules/design-system.md
  mv ~/Downloads/rules/performance.md   ~/tools/rules/performance.md
  ```
- [ ] Move the settings template into `~/tools/settings/`

  ```bash
  mv ~/Downloads/settings/settings.json ~/tools/settings/settings.json
  ```
- [ ] Move the slash command stubs into `~/tools/commands/`

  ```bash
  mv ~/Downloads/commands/preflight.md     ~/tools/commands/preflight.md
  mv ~/Downloads/commands/binding-audit.md ~/tools/commands/binding-audit.md
  mv ~/Downloads/commands/deploy-check.md  ~/tools/commands/deploy-check.md
  ```
- [ ] Make the script executable

  ```bash
  chmod +x ~/tools/scaffold.sh
  ```
- [ ] Verify the tools directory

  ```bash
  ls ~/tools/           # scaffold.sh  CLAUDE.md  rules/  settings/  commands/
  ls ~/tools/rules/     # secrets.md  frontend.md  api.md  design-system.md  performance.md
  ls ~/tools/settings/  # settings.json
  ls ~/tools/commands/  # preflight.md  binding-audit.md  deploy-check.md
  ```

-----

## 2 · Projects Directory

- [ ] Create a canonical home for all your projects
  
  ```bash
  mkdir -p ~/projects
  ```
- [ ] Open `new-project.zsh` and decide whether you want all projects to always land under `~/projects/` regardless of your current terminal directory. If yes, uncomment this line before the `bash` call:
  
  ```bash
  # cd "$HOME/projects" || return 1
  ```
  
  If you leave it commented, the project folder is created wherever your terminal is when you run the command.

-----

## 3 · Shell Function

- [ ] Open `~/.zshrc` in your editor and paste the full contents of `new-project.zsh` at the bottom
- [ ] Reload your shell
  
  ```bash
  source ~/.zshrc
  ```
- [ ] Confirm the function registered
  
  ```bash
  which new-project
  # new-project: shell function
  ```
- [ ] Confirm it finds `scaffold.sh` (it will fail fast at preflight — that’s expected)
  
  ```bash
  new-project test-123
  # Should reach preflight checks, not "command not found"
  ```

-----

## 4 · GitHub CLI

- [ ] Check if `gh` is already installed
  
  ```bash
  gh --version
  ```
- [ ] If not installed, install it
  
  ```bash
  brew install gh
  ```
- [ ] Authenticate — opens a browser flow and stores credentials in your macOS keychain
  
  ```bash
  gh auth login
  # Choose: GitHub.com → HTTPS → Yes (authenticate Git with GitHub credentials) → Login with a web browser
  ```
- [ ] Verify authentication succeeded
  
  ```bash
  gh auth status
  # ✓ Logged in to github.com as yourname
  ```

> `gh` is optional — the scaffold silently skips the GitHub prompt if it isn’t found.

-----

## 5 · Raycast Script Command

- [ ] Create a Raycast scripts directory if you don’t have one
  
  ```bash
  mkdir -p ~/raycast-scripts
  ```
- [ ] In Raycast → Preferences → Extensions → Script Commands, click **Add Directories** and point it at `~/raycast-scripts/`
- [ ] Copy the script in and make it executable (Raycast requires this)
  
  ```bash
  cp ~/Downloads/new-project.raycast.sh ~/raycast-scripts/new-project.sh
  chmod +x ~/raycast-scripts/new-project.sh
  ```
- [ ] Open the file and uncomment whichever editor line you use
  
  ```bash
  # Pick one — uncomment it:
  open -a "Cursor" "$HOME/projects/$PROJECT_NAME"
  # code "$HOME/projects/$PROJECT_NAME"
  # cd "$HOME/projects/$PROJECT_NAME" && claude
  ```
- [ ] Back in Raycast, hit the refresh button in Script Commands (`⌘R`) to pick up the new file
- [ ] Test it: open Raycast → type **New Project** → enter a project name → confirm it runs

-----

## 6 · End-to-End Verification

Run a real scaffold and confirm each piece worked:

```bash
new-project hello-world
```

Expected output sequence:

- [ ] ✅ Preflight passed (1Password auth, node, npm, git, CLAUDE.md found)
- [ ] Project folder created
- [ ] Prompt asking about GitHub repo creation appears
- [ ] Summary printed with correct paths

Spot-check the output:

- [ ] All expected files are present
  
  ```bash
  ls hello-world/
  # frontend/  api/  wrangler.toml  .env.tpl  .eslintrc.json  .husky/  verify_op.sh  CLAUDE.md  package.json
  ```
- [ ] `CLAUDE.md` contains your system prompt
  
  ```bash
  head -5 hello-world/CLAUDE.md
  ```
- [ ] Initial git commit was made
  
  ```bash
  cd hello-world && git log --oneline
  # chore: initial scaffold — zero-trust Cloudflare + 1Password monorepo
  ```
- [ ] Pre-commit hook is in place and executable
  
  ```bash
  cat .husky/pre-commit
  # npx eslint api/src/ frontend/*.js --max-warnings=0
  ```
- [ ] Clean up the test project when done
  
  ```bash
  cd ~ && rm -rf hello-world
  ```

-----

## Quick Reference — Final File Locations

|File                         |Location                            |
|-----------------------------|------------------------------------|
|`scaffold.sh`                |`~/tools/scaffold.sh`               |
|`CLAUDE.md`                  |`~/tools/CLAUDE.md`                 |
|`rules/secrets.md`           |`~/tools/rules/secrets.md`          |
|`rules/frontend.md`          |`~/tools/rules/frontend.md`         |
|`rules/api.md`               |`~/tools/rules/api.md`              |
|`rules/design-system.md`     |`~/tools/rules/design-system.md`    |
|`rules/performance.md`       |`~/tools/rules/performance.md`      |
|`settings/settings.json`     |`~/tools/settings/settings.json`    |
|`commands/preflight.md`      |`~/tools/commands/preflight.md`     |
|`commands/binding-audit.md`  |`~/tools/commands/binding-audit.md` |
|`commands/deploy-check.md`   |`~/tools/commands/deploy-check.md`  |
|`new-project.zsh`            |Pasted into `~/.zshrc`              |
|`new-project.raycast.sh`     |`~/raycast-scripts/new-project.sh`  |
|New projects                 |`~/projects/<n>/`                   |