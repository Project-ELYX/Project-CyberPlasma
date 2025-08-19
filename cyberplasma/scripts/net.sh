#!/usr/bin/env bash
# Output network bytes for an interface as JSON.
# Usage: net.sh <interface>
# Ensures input sanitization and avoids elevated privileges.
set -euo pipefail

if [[ $# -ne 1 ]]; then
  printf 'Usage: %s <interface>\n' "$(basename "$0")" >&2
  exit 1
fi
iface="$1"
# Allow only alphanumeric, hyphen, and underscore in interface name.
if [[ ! "$iface" =~ ^[A-Za-z0-9_-]+$ ]]; then
  printf 'Invalid interface name\n' >&2
  exit 1
fi

rx_path="/sys/class/net/$iface/statistics/rx_bytes"
tx_path="/sys/class/net/$iface/statistics/tx_bytes"
if [[ ! -r "$rx_path" || ! -r "$tx_path" ]]; then
  printf 'Interface not found\n' >&2
  exit 1
fi
rx=$(cat "$rx_path")
tx=$(cat "$tx_path")

printf '{"interface":"%s","rx_bytes":%s,"tx_bytes":%s}\n' "$iface" "$rx" "$tx"
