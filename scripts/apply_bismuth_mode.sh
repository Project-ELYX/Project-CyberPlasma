#!/usr/bin/env bash
# Apply previously saved Bismuth mode on login.
# Accepted mode values: grid or free. Defaults to free if invalid.

set -euo pipefail

STATE_DIR="${XDG_STATE_HOME:-$HOME/.local/state}"
STATE_FILE="$STATE_DIR/bismuth_mode"

if [[ -f "$STATE_FILE" ]]; then
    mode=$(<"$STATE_FILE")
    if [[ "$mode" != "grid" && "$mode" != "free" ]]; then
        mode="free"
    fi
    "$HOME"/scripts/toggle_tiling.sh --"$mode"
fi
