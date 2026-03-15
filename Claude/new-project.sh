new-project() {
  local tools_dir="$HOME/tools"   # wherever scaffold.sh + CLAUDE.md live
  if [ -z "$1" ]; then
    echo "Usage: new-project my-project-name"
    return 1
  fi
  bash "$tools_dir/scaffold.sh" "$1"
}