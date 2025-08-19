#!/bin/sh
# Output network transfer rate in kB/s for an interface as JSON.
# Usage: net.sh <interface>
# Ensures input sanitization and avoids elevated privileges.
set -eu

if [ $# -ne 1 ]; then
  printf 'Usage: %s <interface>\n' "$(basename "$0")" >&2
  exit 1
fi
iface=$1
# Allow only alphanumeric, hyphen, and underscore in interface name.
case "$iface" in
  *[!A-Za-z0-9_-]*|'')
    printf 'Invalid interface name\n' >&2
    exit 1
    ;;
esac

rx_path="/sys/class/net/$iface/statistics/rx_bytes"
tx_path="/sys/class/net/$iface/statistics/tx_bytes"
if [ ! -r "$rx_path" ] || [ ! -r "$tx_path" ]; then
  printf 'Interface not found\n' >&2
  exit 1
fi

rx1=$(cat "$rx_path")
tx1=$(cat "$tx_path")
sleep 1
rx2=$(cat "$rx_path")
tx2=$(cat "$tx_path")

rx_rate=$(awk -v r1="$rx1" -v r2="$rx2" 'BEGIN {printf "%.2f", (r2 - r1)/1024}')
tx_rate=$(awk -v t1="$tx1" -v t2="$tx2" 'BEGIN {printf "%.2f", (t2 - t1)/1024}')

printf '{"interface":"%s","rx_kBps":%s,"tx_kBps":%s}\n' "$iface" "$rx_rate" "$tx_rate"
