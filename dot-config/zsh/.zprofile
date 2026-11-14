# ~/.zprofile -> ~/.fresh/dot-config/zsh/.zprofile
# Login shells only. Ghostty opens a login shell for every tab.
# Every PATH addition lives here. /etc/zprofile has already run path_helper.

# Homebrew, written out. These are the lines `brew shellenv` prints on Apple silicon.
export HOMEBREW_PREFIX="/opt/homebrew"
export HOMEBREW_CELLAR="/opt/homebrew/Cellar"
export HOMEBREW_REPOSITORY="/opt/homebrew"
path=("$HOMEBREW_PREFIX/bin" "$HOMEBREW_PREFIX/sbin" $path)
[[ -n "${MANPATH-}" ]] && export MANPATH=":${MANPATH#:}"
export INFOPATH="$HOMEBREW_PREFIX/share/info:${INFOPATH:-}"

# User tools. Missing folders are harmless.
export BUN_INSTALL="$HOME/.bun"
path=("$HOME/.local/bin" "$BUN_INSTALL/bin" $path "$HOME/.lmstudio/bin")

# OrbStack adds this line itself when it is missing.
source ~/.orbstack/shell/init.zsh 2>/dev/null || :
