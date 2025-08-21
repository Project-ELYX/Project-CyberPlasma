#!/usr/bin/env bash
# Toggle GLava and CAVA visualizers.
# Starts glava if neither is running, otherwise switches between them.
set -euo pipefail
if pgrep -x glava >/dev/null 2>&1; then
  pkill glava
  if command -v cava >/dev/null 2>&1; then
    cava &
  fi
elif pgrep -x cava >/dev/null 2>&1; then
  pkill cava
  if command -v glava >/dev/null 2>&1; then
    glava &
  fi
else
  if command -v glava >/dev/null 2>&1; then
    glava &
  elif command -v cava >/dev/null 2>&1; then
    cava &
  fi
fi
