# ------------------------------------------------------------------------------
# 1. POSIX Exports & Environment Variables
# ------------------------------------------------------------------------------
export BUN_INSTALL="$HOME/.bun"
export PATH="$BUN_INSTALL/bin:$PATH"
export EDITOR="micro"

# Cloudflare / Node (Standard NVM works perfectly here)
export NVM_DIR="$HOME/.nvm"
[ -s "/opt/homebrew/opt/nvm/nvm.sh" ] && \. "/opt/homebrew/opt/nvm/nvm.sh"

# ------------------------------------------------------------------------------
# 2. Zsh History & Behavior Settings
# ------------------------------------------------------------------------------
HISTFILE=~/.zsh_history
HISTSIZE=10000
SAVEHIST=10000
setopt append_history
setopt share_history
setopt hist_ignore_all_dups

# ------------------------------------------------------------------------------
# 3. GitHub & Docker Aliases (Replacing the Oh-My-Zsh Plugins)
# ------------------------------------------------------------------------------
alias gst="git status"
alias ga="git add"
alias gaa="git add --all"
alias gcam="git commit -a -m"
alias gcmsg="git commit -m"
alias gp="git push"
alias gl="git pull"
alias gco="git checkout"
alias dco="docker-compose"
alias lc="colorls -lA --sd"
alias nano="micro"

# ------------------------------------------------------------------------------
# 4. Plugins & Prompt Integration
# ------------------------------------------------------------------------------
# Fast directory jumping
eval "$(zoxide init zsh)"

# Homebrew-managed Zsh plugins
source $(brew --prefix)/share/zsh-autosuggestions/zsh-autosuggestions.zsh
source $(brew --prefix)/share/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh

# Initialize Starship Prompt (Must be at the bottom)
eval "$(starship init zsh)"