#!/usr/bin/env bash
# Launch Eww widgets for each connected monitor using --screen.
# Determines monitor geometry via xrandr.
set -euo pipefail
MODE=${CYBERPLASMA_MODE:-command}

# Load theme variables so Eww can resolve color references
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
set -a
source "${SCRIPT_DIR}/../theme.env"
set +a

# Start the daemon if not already running
if ! eww ping >/dev/null 2>&1; then
  eww daemon
  # Give the daemon a moment to initialise
  sleep 0.2
fi

# Parse connected monitors and their geometry
xrandr --query | awk '/ connected/{for(i=1;i<=NF;i++) if ($i ~ /[0-9]+x[0-9]+\+/){print $1, $i}}' | while read -r name geometry; do
  # Ensure geometry token matches WIDTHxHEIGHT+X+Y
  if [[ $geometry =~ ^([0-9]+)x([0-9]+)\+([0-9]+)\+([0-9]+)$ ]]; then
    width=${BASH_REMATCH[1]}
    height=${BASH_REMATCH[2]}
    offset_x=${BASH_REMATCH[3]}
    offset_y=${BASH_REMATCH[4]}
  else
    continue
  fi

  # Open widgets on the given monitor. Geometry inside config.yuck
  # is relative to the screen, so the coordinates computed above are
  # primarily informational and available for potential future use.
  if [[ "$MODE" == "control" ]]; then
    eww open control_strip --screen "$name" --arg monitor_width="$width"
  else
    eww open top_bar --screen "$name" --arg monitor_width="$width"
  fi
  eww open left_column --screen "$name"
done

# Optionally open standalone mpris controls on the primary monitor
# only if desired by users of this script. Commented out by default.
# eww open mpris_controls --screen "$(xrandr --query | awk '/ primary/{print $1}')"
