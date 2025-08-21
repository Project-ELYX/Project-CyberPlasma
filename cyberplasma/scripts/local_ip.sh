#!/bin/sh
# Output IPv4 addresses for non-loopback interfaces as JSON.
# Avoids elevated privileges and ensures sanitized output.
set -eu

printf '{'
first=1
ip -o -4 addr show scope global 2>/dev/null | while IFS=' ' read -r _ iface _ addr _; do
  ip_addr=${addr%/*}
  iface_sanitized=$(printf '%s' "$iface" | tr -cd 'A-Za-z0-9_-')
  if [ "$first" -eq 0 ]; then printf ','; fi
  printf '"%s":"%s"' "$iface_sanitized" "$ip_addr"
  first=0
done
printf '}\n'
