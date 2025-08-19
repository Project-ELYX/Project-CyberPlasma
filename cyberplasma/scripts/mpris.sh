#!/usr/bin/env bash
# Output current MPRIS metadata as JSON.
# Avoids elevated privileges and ensures sanitized output.
set -euo pipefail

if ! command -v playerctl >/dev/null 2>&1; then
  printf '{"status":"unavailable"}\n'
  exit 0
fi

player=$(playerctl -l 2>/dev/null | head -n1)
if [[ -z "$player" ]]; then
  printf '{"status":"stopped"}\n'
  exit 0
fi

format='{"title":"{{escape .Title}}","artist":"{{escape (join .Artist ", ")}}","status":"{{lc .Status}}"}'
metadata=$(playerctl metadata --format "$format" 2>/dev/null || true)

if [[ -n "$metadata" ]]; then
  printf '%s\n' "$metadata"
else
  printf '{"status":"stopped"}\n'
fi
