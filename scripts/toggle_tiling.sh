#!/usr/bin/env bash
# Toggle Bismuth tiling in KDE and record current mode.
# Writes either "tiling" or "floating" to a state file.

set -euo pipefail

STATE_DIR="${XDG_STATE_HOME:-$HOME/.local/state}"
STATE_FILE="$STATE_DIR/bismuth_mode"

mkdir -p "$STATE_DIR"

if qdbus org.kde.KWin /Scripting org.kde.KWin.Scripting.isScriptLoaded bismuth &>/dev/null; then
    qdbus org.kde.KWin /Scripting org.kde.KWin.Scripting.unloadScript bismuth >/dev/null
    MODE="floating"
else
    qdbus org.kde.KWin /Scripting org.kde.KWin.Scripting.loadScript bismuth >/dev/null
    MODE="tiling"
fi

echo "$MODE" > "$STATE_FILE"
