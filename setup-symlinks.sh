#!/usr/bin/env zsh

# Dotfiles
# What are dotfiles? See https://about.gitlab.com/blog/2020/04/17/dotfiles-document-and-automate-your-macbook-setup/
sudo -v

# ── Core CLI Tools ────────────────────────────────────────────────────────────

ln -sf ~/dot-config/.zshrc ~/.zshrc
ln -sf ~/dot-config/.gitconfig ~/.gitconfig
ln -sf ~/dot-config/.zprofile ~/.zprofile
ln -sf ~/dot-config/.gitignore_global ~/.gitignore_global

# ── Claude / Scaffold Tools ───────────────────────────────────────────────────
#
# Symlinks key files from ~/Claude/ into ~/tools/ so scaffold.sh can find
# its templates via SCRIPT_DIR resolution. ~/Claude/ is the source of truth —
# edit files there and the tools directory reflects changes immediately.
#
# Expected source layout:
#   ~/Claude/
#   ├── scaffold.sh
#   ├── CLAUDE.md
#   ├── new-project.zsh
#   ├── checklist.md
#   └── templates/
#       ├── fullstack/.claude/CLAUDE.md
#       ├── worker-only/.claude/CLAUDE.md
#       ├── static-site/.claude/CLAUDE.md
#       └── data-app/.claude/CLAUDE.md

CLAUDE_SRC="$HOME/Claude"
TOOLS_DIR="$HOME/tools"

if [ ! -d "$CLAUDE_SRC" ]; then
  echo "⚠️  ~/Claude/ not found — skipping scaffold tools setup."
  echo "   Create ~/Claude/ and add scaffold.sh, CLAUDE.md, new-project.zsh, checklist.md, and templates/ to enable."
else
  mkdir -p "$TOOLS_DIR"

  # Core scaffold files
  for file in scaffold.sh CLAUDE.md new-project.zsh checklist.md; do
    if [ -f "$CLAUDE_SRC/$file" ]; then
      ln -sf "$CLAUDE_SRC/$file" "$TOOLS_DIR/$file"
      echo "✅ Linked ~/tools/$file → ~/Claude/$file"
    else
      echo "⚠️  ~/Claude/$file not found — skipping."
    fi
  done

  # Templates directory (symlink the whole dir, not individual files)
  if [ -d "$CLAUDE_SRC/templates" ]; then
    ln -sf "$CLAUDE_SRC/templates" "$TOOLS_DIR/templates"
    echo "✅ Linked ~/tools/templates/ → ~/Claude/templates/"
  else
    echo "⚠️  ~/Claude/templates/ not found — skipping."
    echo "   scaffold.sh project-type selection won't work until templates are added."
  fi

  chmod +x "$TOOLS_DIR/scaffold.sh" 2>/dev/null || true

  # Wire new-project function into .zshrc if not already present
  if ! grep -q "new-project.zsh" ~/.zshrc 2>/dev/null; then
    echo "\n# Scaffold — new-project command" >> ~/.zshrc
    echo "source \$HOME/tools/new-project.zsh" >> ~/.zshrc
    echo "✅ Added new-project to ~/.zshrc"
  else
    echo "✅ new-project already in ~/.zshrc — skipping."
  fi

  echo ""
  echo "🛠  Scaffold tools ready. Run: new-project my-app"
fi

# ── Initialize new settings ───────────────────────────────────────────────────

source ~/.zshrc
sudo zsh -c "s --completion zsh > /usr/local/share/zsh/site-functions/_s" # Enable zquestz Autocompletion