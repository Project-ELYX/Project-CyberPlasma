#!/usr/bin/env bash
# Apply previously saved screen modes on login.
set -euo pipefail
IFS=$'\n\t'

SCRIPT_DIR="$(cd -- "$(dirname -- "${BASH_SOURCE[0]}")" &>/dev/null && pwd)"
if [[ -x "$SCRIPT_DIR/mode_engine.sh" ]]; then
    "$SCRIPT_DIR/mode_engine.sh"
elif command -v mode_engine.sh >/dev/null 2>&1; then
    mode_engine.sh
else
    echo "Error: mode_engine.sh not found" >&2
    exit 1
fi
