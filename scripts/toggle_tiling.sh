#!/usr/bin/env bash
# Toggle Bismuth tiling in KDE and record current mode.
# Writes either "grid" or "free" to a state file.
# Accepts `--grid` or `--free` to force a mode without toggling.

set -euo pipefail

SCRIPT_DIR="$(cd -- "$(dirname -- "${BASH_SOURCE[0]}")" &>/dev/null && pwd)"
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
    if [[ "$panel_screen" =~ ^[0-9]+$ ]]; then
        helper="$SCRIPT_DIR/panel_visibility.sh"
        if [[ -x "$helper" ]]; then
            panel_cmd="$helper"
        elif command -v panel_visibility.sh >/dev/null 2>&1; then
            panel_cmd="panel_visibility.sh"
        else
            panel_cmd=""
        fi
        if [[ -n "$panel_cmd" ]]; then
            if [[ "$MODE" == "grid" ]]; then
                "$panel_cmd" hide "$panel_screen"
            else
                "$panel_cmd" show "$panel_screen"
            fi
        else
            echo "Warning: panel_visibility.sh not found; skipping panel toggling" >&2
        fi
    else
        echo "Warning: invalid CYBERPLASMA_PANEL_SCREEN_ID '$panel_screen'; skipping panel toggling" >&2
    fi
fi
