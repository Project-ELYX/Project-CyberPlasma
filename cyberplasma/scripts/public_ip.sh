#!/bin/sh
# Output the current public IPv4 address as JSON.
# Avoids elevated privileges and ensures sanitized output.
set -eu

ip=$(curl --max-time 5 -fsS https://api.ipify.org 2>/dev/null || true)
if printf '%s' "$ip" | grep -Eq '^([0-9]{1,3}\.){3}[0-9]{1,3}$'; then
  printf '{"ip":"%s"}\n' "$ip"
else
  printf '{"ip":null}\n'
fi
