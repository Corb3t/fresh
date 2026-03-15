#!/bin/bash
# @raycast.schemaVersion 1
# @raycast.title New Project
# @raycast.mode fullOutput
# @raycast.argument1 { "type": "text", "placeholder": "project-name" }

bash "$HOME/tools/scaffold.sh" "$1"
open -a iTerm "$HOME/projects/$1"   # or code, cursor, etc.
