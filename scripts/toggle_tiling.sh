#!/usr/bin/env bash
# Toggle Bismuth tiling in KDE and record current mode.
# Writes either "grid" or "free" to a state file.
# Accepts `--grid` or `--free` to force a mode without toggling.

set -euo pipefail

STATE_DIR="${XDG_STATE_HOME:-$HOME/.local/state}"
STATE_FILE="$STATE_DIR/bismuth_mode"

mkdir -p "$STATE_DIR"

force="${1:-}"

if [[ "$force" == "--grid" ]]; then
    qdbus org.kde.KWin /Scripting org.kde.KWin.Scripting.loadScript bismuth >/dev/null
    MODE="grid"
elif [[ "$force" == "--free" ]]; then
    qdbus org.kde.KWin /Scripting org.kde.KWin.Scripting.unloadScript bismuth >/dev/null
    MODE="free"
else
    if qdbus org.kde.KWin /Scripting org.kde.KWin.Scripting.isScriptLoaded bismuth &>/dev/null; then
        qdbus org.kde.KWin /Scripting org.kde.KWin.Scripting.unloadScript bismuth >/dev/null
        MODE="free"
    else
        qdbus org.kde.KWin /Scripting org.kde.KWin.Scripting.loadScript bismuth >/dev/null
        MODE="grid"
    fi
fi

echo "$MODE" > "$STATE_FILE"

# Optionally toggle a Plasma panel on a specific screen.  The
# CYBERPLASMA_PANEL_SCREEN_ID environment variable selects which
# screen's panel should respond when modes change.  When switching to
# Command Mode ("grid") the panel is hidden; returning to Control Mode
# ("free") shows it again.
panel_screen="${CYBERPLASMA_PANEL_SCREEN_ID:-}"
if [[ -n "$panel_screen" ]]; then
    if [[ "$MODE" == "grid" ]]; then
        "$HOME"/scripts/panel_visibility.sh hide "$panel_screen"
    else
        "$HOME"/scripts/panel_visibility.sh show "$panel_screen"
    fi
fi
