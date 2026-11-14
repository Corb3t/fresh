#!/usr/bin/env bash
# Superseded by sync.sh. Kept so old instructions still work.
exec bash "$(cd "$(dirname "$0")" && pwd)/sync.sh" link "$@"
