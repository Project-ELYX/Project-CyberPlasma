#!/usr/bin/env bash
# Output the current public IPv4 address as JSON.
# Avoids elevated privileges and ensures sanitized output.
set -euo pipefail

ip=$(curl -fsS https://api.ipify.org 2>/dev/null || true)
if [[ "$ip" =~ ^([0-9]{1,3}\.){3}[0-9]{1,3}$ ]]; then
  printf '{"ip":"%s"}\n' "$ip"
else
  printf '{"ip":null}\n'
fi
