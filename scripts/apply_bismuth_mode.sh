#!/usr/bin/env bash
# Apply previously saved Bismuth mode on login.
# Accepted mode values: grid or free. Defaults to free if invalid.

set -euo pipefail

STATE_DIR="${XDG_STATE_HOME:-$HOME/.local/state}"
STATE_FILE="$STATE_DIR/bismuth_mode"

if [[ -f "$STATE_FILE" ]]; then
    mode=$(<"$STATE_FILE")
    SCRIPT_DIR="$(cd -- "$(dirname -- "${BASH_SOURCE[0]}")" &>/dev/null && pwd)"
    if [[ -x "$SCRIPT_DIR/toggle_tiling.sh" ]]; then
        "$SCRIPT_DIR/toggle_tiling.sh" --"$mode"
    elif command -v toggle_tiling.sh >/dev/null 2>&1; then
        toggle_tiling.sh --"$mode"
    else
        echo "Error: toggle_tiling.sh not found" >&2
        exit 1
    fi
fi
