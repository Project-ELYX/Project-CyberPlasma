#!/usr/bin/env bash
# Output current Bismuth mode, defaults to 'free' if state file missing.
STATE_DIR="${XDG_STATE_HOME:-$HOME/.local/state}"
STATE_FILE="$STATE_DIR/bismuth_mode"
if [[ -f "$STATE_FILE" ]]; then
  cat "$STATE_FILE"
else
  echo free
fi
