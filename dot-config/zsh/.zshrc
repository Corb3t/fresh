# ~/.zshrc -> ~/.fresh/dot-config/zsh/.zshrc
# Interactive shells only. This file is public. No secrets, no host names,
# no machine paths. Machine-specific lines go in ~/.zshrc.local (untracked).
# PATH is set in ~/.zprofile. Duplicates are dropped by ~/.zshenv.

# ── 1. History and options ───────────────────────────────────────────────────
HISTFILE=~/.zsh_history
HISTSIZE=50000
SAVEHIST=50000
setopt append_history share_history hist_ignore_all_dups
setopt hist_ignore_space      # a command typed with a leading space is not saved
setopt interactive_comments

# ── 2. Completions ───────────────────────────────────────────────────────────
# Completion files are found through fpath and loaded on first use.
# The full compinit scan runs at most once a day. Other starts reuse the dump.
() {
  local dir="$HOME/.cache/zsh"
  [[ -d $dir ]] || mkdir -p "$dir"
  fpath=("${HOMEBREW_PREFIX:-/opt/homebrew}/share/zsh/site-functions" "$HOME/.bun" $fpath)
  autoload -Uz compinit
  local -a recent=( $dir/zcompdump(N.mh-24) )
  if (( $#recent )); then compinit -C -d "$dir/zcompdump"; else compinit -d "$dir/zcompdump"; fi
}

# ── 3. Aliases ───────────────────────────────────────────────────────────────
alias gst="git status"
alias ga="git add"
alias gaa="git add --all"
alias gcam="git commit -a -m"
alias gcmsg="git commit -m"
alias gp="git push"
alias gl="git pull"
alias gco="git checkout"
alias dco="docker-compose"
alias nano="micro"
alias wrangler="nocorrect wrangler"
alias python="python3"
alias pip="uv pip"
alias pipx="uv tool"
if (( $+commands[eza] )); then alias lc="eza -la --group-directories-first"
else alias lc="ls -lAG"; fi

# ── 4. Node ──────────────────────────────────────────────────────────────────
# Node comes from Homebrew today. fnm is installed and unused. Turning it on
# changes which node runs, so it stays off until you choose a default version:
#   fnm install --lts && fnm default lts-latest
# (( $+commands[fnm] )) && eval "$(fnm env --use-on-cd --shell zsh)"

# ── 5. zoxide and Starship ───────────────────────────────────────────────────
(( $+commands[zoxide] )) && eval "$(zoxide init zsh)"
(( $+commands[starship] )) && eval "$(starship init zsh)"

# ── 6. Installer-managed blocks ──────────────────────────────────────────────
# oMLX looks for these two marker comments and re-adds the block if they are gone.
# oMLX: CLI shim path begin
case ":$PATH:" in
  *":$HOME/.omlx/bin:"*) ;;
  *) export PATH="$HOME/.omlx/bin:$PATH" ;;
esac
# oMLX: CLI shim path end

# ── 7. agent-config ──────────────────────────────────────────────────────────
# agent-config/install.sh looks for these three source lines and appends any
# that are missing. They live here so it never writes to this tracked file.
[[ -r ~/.agent-config/templates/scaffold/new-project.sh ]] && source ~/.agent-config/templates/scaffold/new-project.sh
[[ -r ~/.agent-config/ops/shell/dev-guard.zsh ]] && source ~/.agent-config/ops/shell/dev-guard.zsh
[[ -r ~/.agent-config/ops/shell/lighthouse.zsh ]] && source ~/.agent-config/ops/shell/lighthouse.zsh

# ── 8. This machine only ─────────────────────────────────────────────────────
[[ -r ~/.zshrc.local ]] && source ~/.zshrc.local

# ── 9. Plugins, last ─────────────────────────────────────────────────────────
# zsh-syntax-highlighting must come after everything that defines widgets.
() {
  local f
  for f in zsh-autosuggestions/zsh-autosuggestions.zsh zsh-syntax-highlighting/zsh-syntax-highlighting.zsh; do
    [[ -r "${HOMEBREW_PREFIX:-/opt/homebrew}/share/$f" ]] && source "${HOMEBREW_PREFIX:-/opt/homebrew}/share/$f"
  done
}
