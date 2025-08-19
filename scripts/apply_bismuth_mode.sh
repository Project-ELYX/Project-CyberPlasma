#!/usr/bin/env bash
# Apply previously saved Bismuth mode on login.

set -euo pipefail

STATE_DIR="${XDG_STATE_HOME:-$HOME/.local/state}"
STATE_FILE="$STATE_DIR/bismuth_mode"

if [[ -f "$STATE_FILE" ]]; then
    mode=$(<"$STATE_FILE")
    "$HOME"/scripts/toggle_tiling.sh --"$mode"
fi
