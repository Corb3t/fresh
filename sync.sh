#!/bin/bash
# sync.sh: keep this Mac's terminal config linked to the fresh repo.
# Changes nothing unless --apply is given. Works on macOS bash 3.2.
#
#   sync.sh check                      report link state, syntax, secrets, Brewfile drift (default)
#   sync.sh link [--apply]             create ~/.fresh and the config links. Backs up what they replace
#   sync.sh brew [--apply]             report Brewfile drift. --apply appends missing entries, never rewrites
#   sync.sh parity [host]              compare this Mac with the other one over SSH
#   sync.sh rollback <stamp> [--apply] put back a backup set made by `link --apply`
#   sync.sh hashes                     print revision and file hashes (used by parity)
#
# Exit: 0 clean, 1 drift found, 2 error.
# Peer host for parity: argument, or $FRESH_PEER, or the first line of ~/.config/fresh/peer (untracked).
set -u

REPO="$(cd "$(dirname "$0")" && pwd -P)"
LINK="$HOME/.fresh"
STATE="$HOME/.local/state/fresh"
STAMP="$(date +%Y%m%d-%H%M%S)"
BREWFILE="$REPO/Brewfile"
# Optional per-machine Brewfile for packages only this Mac should have. Not tracked here.
BREWFILE_LOCAL="$HOME/.config/fresh/Brewfile.local"
# Everything this Mac should have: the shared file, plus the local one when it exists.
brewfile_all() {
  [ -r "$BREWFILE_LOCAL" ] || { echo "$BREWFILE"; return; }
  local t="${TMPDIR:-/tmp}/fresh-brewfile-all.$$"
  { cat "$BREWFILE"; echo; cat "$BREWFILE_LOCAL"; } > "$t"; echo "$t"
}

# repo path | path under $HOME
MAP='dot-config/zsh/.zshenv|.zshenv
dot-config/zsh/.zprofile|.zprofile
dot-config/zsh/.zshrc|.zshrc
dot-config/starship.toml|.config/starship.toml
dot-config/ghostty/config|.config/ghostty/config
dot-config/topgrade.toml|.config/topgrade.toml'

LOCALS='.zshrc.local
.config/topgrade.d/local.toml
.config/ghostty/local
.config/fresh/Brewfile.local'

CMD="${1:-check}"; [ $# -gt 0 ] && shift
APPLY=0; ARGS=""
for a in "$@"; do if [ "$a" = "--apply" ]; then APPLY=1; else ARGS="$ARGS $a"; fi; done
set -- $ARGS

DRIFT=0; ERR=0
ok()    { printf '  %-10s %s\n' "OK" "$*"; }
info()  { printf '  %-10s %s\n' "INFO" "$*"; }
drift() { printf '  %-10s %s\n' "$1" "$2"; DRIFT=1; }
fail()  { printf '  %-10s %s\n' "ERROR" "$*"; ERR=1; }
have()  { command -v "$1" >/dev/null 2>&1; }
finish() { [ $ERR = 1 ] && exit 2; [ $DRIFT = 1 ] && exit 1; exit 0; }

each_map() { # calls "$1" src dst for every MAP line
  local fn="$1" line
  while IFS= read -r line; do
    [ -n "$line" ] && "$fn" "${line%%|*}" "${line##*|}"
  done <<EOF_MAP
$MAP
EOF_MAP
}

# ── check ────────────────────────────────────────────────────────────────────
check_one() {
  local src="$1" dst="$HOME/$2" want="$LINK/$1"
  if [ ! -e "$REPO/$src" ]; then fail "$src is in the map but not in the repo"; return; fi
  if [ -L "$dst" ]; then
    if [ "$(readlink "$dst")" = "$want" ]; then
      if [ -e "$dst" ]; then ok "link  ~/$2"; else drift "BROKEN" "~/$2 -> $want"; fi
    else drift "WRONG-LINK" "~/$2 -> $(readlink "$dst")"; fi
  elif [ -e "$dst" ]; then
    if cmp -s "$dst" "$REPO/$src"; then drift "UNLINKED" "~/$2 is a regular file (same content as the repo)"
    else drift "UNLINKED" "~/$2 is a regular file and differs from the repo"; fi
  else drift "MISSING" "~/$2"; fi
}

syntax_checks() {
  local f
  if have zsh; then
    for f in .zshenv .zprofile .zshrc; do
      if zsh -n "$REPO/dot-config/zsh/$f" 2>/dev/null; then ok "zsh -n $f"; else fail "zsh syntax error in dot-config/zsh/$f"; fi
    done
  else info "zsh not found, shell syntax not checked"; fi
  local py=""
  for f in python3.13 python3.12 python3.11 python3; do
    if have "$f" && "$f" -c 'import tomllib' 2>/dev/null; then py="$f"; break; fi
  done
  if [ -n "$py" ]; then
    for f in "$REPO/dot-config/topgrade.toml" "$REPO/dot-config/starship.toml" "$HOME/.config/topgrade.d/local.toml"; do
      [ -e "$f" ] || continue
      if "$py" -c 'import tomllib,sys; tomllib.load(open(sys.argv[1],"rb"))' "$f" 2>/dev/null; then ok "toml  ${f#$HOME/}"
      else fail "invalid TOML: $f"; fi
    done
  else info "no Python with tomllib (3.11+), TOML not checked. Use: topgrade --dry-run"; fi
  local gh=""
  if have ghostty; then gh="ghostty"; elif [ -x /Applications/Ghostty.app/Contents/MacOS/ghostty ]; then gh=/Applications/Ghostty.app/Contents/MacOS/ghostty; fi
  if [ -n "$gh" ]; then
    if "$gh" +validate-config >/dev/null 2>&1; then ok "ghostty +validate-config"; else drift "INVALID" "ghostty +validate-config reports problems"; fi
  else info "Ghostty not installed here, config not validated"; fi
}

secret_scan() {
  local pat hits f files
  pat='ops_[A-Za-z0-9_-]{40,}|gh[pousr]_[A-Za-z0-9]{30,}|sk-[A-Za-z0-9_-]{24,}|BEGIN [A-Z ]*PRIVATE KEY|(TOKEN|SECRET|PASSWORD|API_KEY)[A-Z_]*=["'"'"']?[A-Za-z0-9/+_-]{20,}'
  files="$(git -C "$REPO" ls-files 2>/dev/null | sed "s|^|$REPO/|")"
  for f in "$HOME/.zshrc.local" "$HOME"/.zshrc.bak* "$HOME"/.zshrc.pre-* "$HOME"/.zprofile.bak*; do
    [ -f "$f" ] && files="$files
$f"
  done
  # File and line number only. The matched text is never printed.
  hits="$(printf '%s\n' "$files" | while IFS= read -r f; do [ -f "$f" ] && grep -nIE "$pat" "$f" 2>/dev/null | cut -d: -f1 | sed "s|^|$f:|"; done)"
  if [ -n "$hits" ]; then
    printf '%s\n' "$hits" | while IFS= read -r f; do drift "SECRET?" "${f#$HOME/}"; done; DRIFT=1
  else ok "no secret patterns in tracked files, ~/.zshrc.local or rc backups"; fi
  # Machine details must stay out of the public repo. Patterns are split so this file passes its own scan.
  pat='[.]ts[.]net|/Us''ers/|Supa''Fast'
  hits="$(git -C "$REPO" ls-files 2>/dev/null | grep -E '^(dot-config/|sync\.sh$|Brewfile$)' | while IFS= read -r f; do grep -nIE "$pat" "$REPO/$f" 2>/dev/null | cut -d: -f1 | sed "s|^|$f:|"; done)"
  if [ -n "$hits" ]; then printf '%s\n' "$hits" | while IFS= read -r f; do drift "MACHINE" "$f names a host or machine path"; done; DRIFT=1
  else ok "no host names or machine paths in tracked config"; fi
}

brew_report() {
  if ! have brew; then info "Homebrew not found, Brewfile not checked"; return; fi
  [ -f "$BREWFILE" ] || { fail "no Brewfile at $BREWFILE"; return; }
  export HOMEBREW_NO_AUTO_UPDATE=1
  local all; all="$(brewfile_all)"
  if brew bundle check --file="$all" >/dev/null 2>&1; then ok "everything in the Brewfile is installed"
  else
    brew bundle check --verbose --file="$all" 2>/dev/null | grep -E 'needs to be installed' | while IFS= read -r l; do drift "NOT-INST" "$l"; done
    DRIFT=1
  fi
  local extra; extra="$(brew_missing_entries "$all")"
  if [ -n "$extra" ]; then printf '%s\n' "$extra" | while IFS= read -r l; do drift "NOT-LISTED" "$l"; done; DRIFT=1
  else ok "everything installed on request is in the Brewfile"; fi
  [ "$all" = "$BREWFILE" ] || rm -f "$all"
}

brew_missing_entries() { # $1: Brewfile to compare with. Prints lines for things installed here and absent from it
  local n f="${1:-$BREWFILE}"
  brew leaves --installed-on-request 2>/dev/null | while IFS= read -r n; do
    grep -qE "^brew \"(.*/)?${n##*/}\"" "$f" || echo "brew \"$n\""
  done
  brew list --cask -1 2>/dev/null | while IFS= read -r n; do
    grep -qE "^cask \"(.*/)?${n##*/}\"" "$f" || echo "cask \"$n\""
  done
}

cmd_check() {
  echo "fresh: $REPO"
  if [ -L "$LINK" ] && [ "$(cd "$LINK" 2>/dev/null && pwd -P)" = "$REPO" ]; then ok "~/.fresh -> $REPO"
  else drift "NO-LINK" "~/.fresh does not point at this clone. Fix: sync.sh link --apply"; fi
  each_map check_one
  local l
  for l in $LOCALS; do
    if [ -e "$HOME/$l" ]; then ok "local ~/$l"; else info "no ~/$l (optional)"; fi
  done
  local broken; broken="$(find "$HOME/.config" "$HOME/tools" -maxdepth 2 -type l 2>/dev/null | while IFS= read -r l; do [ -e "$l" ] || echo "${l#$HOME/} -> $(readlink "$l")"; done)"
  if [ -n "$broken" ]; then printf '%s\n' "$broken" | while IFS= read -r l; do drift "BROKEN" "$l"; done; DRIFT=1; fi
  syntax_checks
  secret_scan
  brew_report
  local dirty; dirty="$(git -C "$REPO" status --porcelain 2>/dev/null | wc -l | tr -d ' ')"
  info "revision $(git -C "$REPO" rev-parse --short HEAD 2>/dev/null)"
  [ "$dirty" = "0" ] || drift "UNCOMMITTED" "$dirty file(s) changed here. The other Mac does not have them yet"
  finish
}

# ── link ─────────────────────────────────────────────────────────────────────
BK=""
backup() { # move $HOME/$1 into the backup set
  [ -n "$BK" ] || { BK="$STATE/backups/$STAMP"; mkdir -p "$BK"; }
  mkdir -p "$BK/$(dirname "$1")"
  mv "$HOME/$1" "$BK/$1" && echo "$1" >> "$BK/MANIFEST"
}

link_one() {
  local src="$1" rel="$2" dst="$HOME/$2" want="$LINK/$1"
  [ -e "$REPO/$src" ] || { fail "$src missing from the repo, skipped"; return; }
  if [ -L "$dst" ] && [ "$(readlink "$dst")" = "$want" ]; then ok "link  ~/$rel"; return; fi
  if [ $APPLY = 0 ]; then
    if [ -e "$dst" ] || [ -L "$dst" ]; then echo "  would      back up ~/$rel, then link it"; else echo "  would      link ~/$rel"; fi
    DRIFT=1; return
  fi
  if [ -e "$dst" ] || [ -L "$dst" ]; then backup "$rel" || { fail "could not back up ~/$rel"; return; }; fi
  mkdir -p "$(dirname "$dst")"
  if ln -s "$want" "$dst"; then echo "  linked     ~/$rel"; else fail "could not link ~/$rel"; fi
}

cmd_link() {
  echo "fresh: $REPO   (apply=$APPLY)"
  local f
  if have zsh; then
    for f in .zshenv .zprofile .zshrc; do
      zsh -n "$REPO/dot-config/zsh/$f" 2>/dev/null || { fail "zsh syntax error in $f. Nothing linked"; finish; }
    done
  fi
  if [ -e "$LINK" ] && [ ! -L "$LINK" ]; then fail "~/.fresh exists and is not a link. Move it first"; finish; fi
  if [ -L "$LINK" ] && [ "$(cd "$LINK" 2>/dev/null && pwd -P)" = "$REPO" ]; then ok "~/.fresh"
  elif [ $APPLY = 1 ]; then ln -sfn "$REPO" "$LINK" && echo "  linked     ~/.fresh -> $REPO"
  else echo "  would      link ~/.fresh -> $REPO"; DRIFT=1; fi
  each_map link_one
  [ -n "$BK" ] && echo "  backup set $STAMP in $STATE/backups. Undo: sync.sh rollback $STAMP --apply"
  [ $APPLY = 0 ] && [ $DRIFT = 1 ] && echo "Dry run. Re-run with --apply. Keep one terminal tab open while you test a new one."
  finish
}

# ── rollback ─────────────────────────────────────────────────────────────────
cmd_rollback() {
  local set="${1:-}" rel
  if [ -z "$set" ] || [ ! -f "$STATE/backups/$set/MANIFEST" ]; then
    echo "Backup sets:"; ls -1 "$STATE/backups" 2>/dev/null | sed 's/^/  /'; fail "name a backup set"; finish
  fi
  while IFS= read -r rel; do
    [ -n "$rel" ] || continue
    if [ $APPLY = 1 ]; then
      # mv replaces the link itself with the saved file.
      if mv -f "$STATE/backups/$set/$rel" "$HOME/$rel"; then echo "  restored   ~/$rel"; else fail "could not restore ~/$rel"; fi
    else echo "  would      restore ~/$rel"; fi
  done < "$STATE/backups/$set/MANIFEST"
  finish
}

# ── brew ─────────────────────────────────────────────────────────────────────
cmd_brew() {
  have brew || { fail "Homebrew not found"; finish; }
  export HOMEBREW_NO_AUTO_UPDATE=1
  local all; all="$(brewfile_all)"
  # New entries go to this Mac's own file when it has one, so one Mac's packages never land on the other.
  local dest="$BREWFILE" label="the Brewfile"
  [ -r "$BREWFILE_LOCAL" ] && { dest="$BREWFILE_LOCAL"; label="this Mac's Brewfile.local"; }
  local extra; extra="$(brew_missing_entries "$all")"
  if [ -z "$extra" ]; then ok "nothing to add to the Brewfile"
  elif [ $APPLY = 1 ]; then
    { printf '\n# UNSORTED: added by sync.sh on %s. Move each line to its section.\n' "$(date +%F)"; printf '%s\n' "$extra"; } >> "$dest"
    echo "  appended   $(printf '%s\n' "$extra" | wc -l | tr -d ' ') line(s) to $label. Review, then commit"
  else printf '%s\n' "$extra" | sed 's/^/  would add  /'; echo "  --apply appends these to $label"; DRIFT=1; fi
  brew bundle check --verbose --file="$all" 2>/dev/null | grep -E 'needs to be installed' | sed 's/^/  NOT-INST   /'
  [ "$all" = "$BREWFILE" ] || rm -f "$all"
  finish
}

# ── parity ───────────────────────────────────────────────────────────────────
sha() { if [ -e "$1" ]; then shasum -a 256 "$1" 2>/dev/null | cut -d' ' -f1; else echo "absent"; fi; }
hash_one() { echo "file $2 $(sha "$HOME/$2")"; }
cmd_hashes() {
  echo "rev $(git -C "$REPO" rev-parse --short HEAD 2>/dev/null)"
  echo "uncommitted $(git -C "$REPO" status --porcelain 2>/dev/null | wc -l | tr -d ' ')"
  echo "agent-config $(git -C "$HOME/.agent-config" rev-parse --short HEAD 2>/dev/null || echo absent)"
  echo "brewfile $(sha "$BREWFILE")"
  each_map hash_one
}

cmd_parity() {
  local host="${1:-${FRESH_PEER:-}}" mine theirs key a b
  [ -n "$host" ] || { [ -f "$HOME/.config/fresh/peer" ] && host="$(head -1 "$HOME/.config/fresh/peer")"; }
  [ -n "$host" ] || { fail "no peer. Give a host, set FRESH_PEER, or write it to ~/.config/fresh/peer"; finish; }
  mine="$(cmd_hashes)"
  theirs="$(ssh -o BatchMode=yes -o ConnectTimeout=5 "$host" 'bash ~/.fresh/sync.sh hashes' 2>/dev/null)"
  if [ -z "$theirs" ]; then echo "  UNREACHABLE the other Mac did not answer, or has no ~/.fresh yet"; exit 0; fi
  printf '%s\n' "$mine" | while IFS= read -r line; do
    key="${line% *}"; a="${line##* }"
    b="$(printf '%s\n' "$theirs" | grep -F "$key " | head -1)"; b="${b##* }"
    if [ "$a" = "$b" ]; then printf '  %-10s %s\n' "SAME" "$key"; else printf '  %-10s %s (here %s, there %s)\n' "DIFFERENT" "$key" "${a:0:12}" "${b:0:12}"; fi
  done
  [ "$mine" = "$theirs" ] || DRIFT=1
  finish
}

case "$CMD" in
  check)    cmd_check ;;
  link)     cmd_link ;;
  brew)     cmd_brew ;;
  parity)   cmd_parity "$@" ;;
  rollback) cmd_rollback "$@" ;;
  hashes)   cmd_hashes ;;
  *) sed -n '2,13p' "$0" | sed 's/^# \{0,1\}//'; exit 2 ;;
esac
