# ~/.zshenv -> ~/.fresh/dot-config/zsh/.zshenv
# Runs for every zsh: tabs, scripts, and "ssh host command". Keep it tiny.

# Drop duplicate entries from PATH and fpath, however many files add them.
typeset -U path PATH fpath FPATH

export EDITOR="micro"
export VISUAL="$EDITOR"

# "ssh host command" and scripts start a non-login shell, which never reads
# .zprofile. Without this line they cannot find brew, gh, op or topgrade.
# Login shells get the same paths from .zprofile, after path_helper has run.
[[ -o login ]] || path=(/opt/homebrew/bin /opt/homebrew/sbin $path)

# Rust. rustup adds this line itself when it is missing.
[[ -r "$HOME/.cargo/env" ]] && . "$HOME/.cargo/env"
