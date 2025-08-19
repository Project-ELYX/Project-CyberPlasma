#!/bin/sh
# Output whether a VPN interface appears active as JSON.
# Avoids elevated privileges and ensures sanitized output.
set -eu

vpn=false
for iface in /sys/class/net/*; do
  name=$(basename "$iface")
  case "$name" in
    tun*|tap*|wg*|ppp*)
      state=$(cat "$iface/operstate" 2>/dev/null)
      if [ "$state" = "up" ]; then
        vpn=true
        break
      fi
      ;;
  esac
done

printf '{"vpn":%s}\n' "$vpn"
