#!/usr/bin/env bash
# Output IPv4 addresses for non-loopback interfaces as JSON.
# Avoids elevated privileges and ensures sanitized output.
set -euo pipefail

printf '{'
first=1
while IFS=' ' read -r num iface fam addr _; do
  ip=${addr%/*}
  iface_sanitized=$(printf '%s' "$iface" | tr -cd 'A-Za-z0-9_-')
  if [ $first -eq 0 ]; then printf ','; fi
  printf '"%s":"%s"' "$iface_sanitized" "$ip"
  first=0
done < <(ip -o -4 addr show scope global 2>/dev/null)
printf '}\n'
