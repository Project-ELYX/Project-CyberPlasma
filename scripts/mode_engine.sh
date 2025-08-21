#!/usr/bin/env bash
# Manage per-screen xrandr modes with persistent state.
# When run without arguments, restore saved modes for all screens.
# Options:
#   --screen NAME --mode MODE   Set and save MODE for screen NAME
#   --screen NAME --toggle      Toggle screen NAME on/off using saved MODE
#   --toggle-all                Toggle all screens using saved modes

set -euo pipefail

# Ensure required commands are available
for cmd in jq xrandr; do
    if ! command -v "$cmd" >/dev/null 2>&1; then
        echo "Error: $cmd is required but not installed" >&2
        exit 1
    fi
done

STATE_DIR="${XDG_STATE_HOME:-$HOME/.local/state}"
STATE_FILE="$STATE_DIR/cyberplasma_modes.json"

mkdir -p "$STATE_DIR"
touch "$STATE_FILE"
exec 9<>"$STATE_FILE"
flock 9
[[ -s "$STATE_FILE" ]] || echo '{}' > "$STATE_FILE"
flock -u 9

save_mode() {
    local screen="$1" mode="$2"
    flock 9
    jq --arg s "$screen" --arg m "$mode" '.[$s]=$m' "$STATE_FILE" \
        >"$STATE_FILE.tmp" && mv "$STATE_FILE.tmp" "$STATE_FILE"
    flock -u 9
}

apply_mode() {
    local screen="$1" mode="$2"
    xrandr --output "$screen" --mode "$mode"
}

restore_all() {
    jq -r 'to_entries[] | "\(.key) \(.value)"' "$STATE_FILE" | \
    while read -r s m; do
        xrandr --output "$s" --mode "$m" || true
    done
}

toggle_screen() {
    local screen="$1"
    if xrandr --query | grep "^$screen connected" | grep -q '+'; then
        xrandr --output "$screen" --off
    else
        local mode
        mode=$(jq -r --arg s "$screen" '.[$s] // empty' "$STATE_FILE")
        [[ -n "$mode" ]] && xrandr --output "$screen" --mode "$mode"
    fi
}

toggle_all() {
    jq -r 'keys[]' "$STATE_FILE" | while read -r s; do
        toggle_screen "$s"
    done
}

screen=""
mode=""
do_toggle=false
do_toggle_all=false

while [[ $# -gt 0 ]]; do
    case "$1" in
        --screen)
            screen="$2"; shift 2;;
        --mode)
            mode="$2"; shift 2;;
        --toggle)
            do_toggle=true; shift;;
        --toggle-all)
            do_toggle_all=true; shift;;
        *)
            echo "Usage: $0 [--screen NAME [--mode MODE|--toggle]] [--toggle-all]" >&2
            exit 1;;
    esac
done

if [[ -n "$screen" ]] && [[ ! "$screen" =~ ^[A-Za-z0-9_-]+$ ]]; then
    echo "Error: invalid screen '$screen'; must match [A-Za-z0-9_-]+" >&2
    exit 1
fi

if [[ -n "$mode" ]] && [[ ! "$mode" =~ ^[A-Za-z0-9_-]+$ ]]; then
    echo "Error: invalid mode '$mode'; must match [A-Za-z0-9_-]+" >&2
    exit 1
fi

if [[ "$do_toggle_all" == true ]]; then
    toggle_all
elif [[ -n "$screen" ]]; then
    if [[ -n "$mode" ]]; then
        save_mode "$screen" "$mode"
        apply_mode "$screen" "$mode"
    elif [[ "$do_toggle" == true ]]; then
        toggle_screen "$screen"
    else
        mode=$(jq -r --arg s "$screen" '.[$s] // empty' "$STATE_FILE")
        [[ -n "$mode" ]] && apply_mode "$screen" "$mode"
    fi
else
    restore_all
fi
