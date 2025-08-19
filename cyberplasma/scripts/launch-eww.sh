#!/usr/bin/env bash
# Launch Eww widgets for each connected monitor using --screen.
# Determines monitor geometry via xrandr.
set -euo pipefail

# Start the daemon if not already running
if ! eww ping >/dev/null 2>&1; then
  eww daemon
  # Give the daemon a moment to initialise
  sleep 0.2
fi

# Parse connected monitors and their geometry
xrandr --query | awk '/ connected/{print $1, $3}' | while read -r name geometry; do
  # Extract width, height and offsets from the geometry string: 1920x1080+0+0
  width=${geometry%%x*}
  rest=${geometry#*x}
  height=${rest%%+*}
  offset_x=${rest#*+}
  offset_y=${offset_x#*+}
  offset_x=${offset_x%%+*}

  # Open widgets on the given monitor. Geometry inside config.yuck
  # is relative to the screen, so the coordinates computed above are
  # primarily informational and available for potential future use.
  eww open top_bar --screen "$name"
  eww open left_column --screen "$name"
done

# Optionally open standalone mpris controls on the primary monitor
# only if desired by users of this script. Commented out by default.
# eww open mpris_controls --screen "$(xrandr --query | awk '/ primary/{print $1}')"

