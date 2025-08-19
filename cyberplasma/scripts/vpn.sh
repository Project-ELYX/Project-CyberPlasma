#!/usr/bin/env bash
# Output whether a VPN interface appears active as JSON.
# Avoids elevated privileges and ensures sanitized output.
set -euo pipefail

vpn=false
for iface in /sys/class/net/*; do
  name=$(basename "$iface")
  if [[ "$name" =~ ^(tun|tap|wg|ppp)[A-Za-z0-9_-]*$ ]]; then
    state=$(cat "$iface/operstate" 2>/dev/null)
    if [[ "$state" == "up" ]]; then
      vpn=true
      break
    fi
  fi
done

printf '{"vpn":%s}\n' "$vpn"
