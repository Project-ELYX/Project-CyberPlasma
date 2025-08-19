#!/usr/bin/env bash
# Output top processes by CPU usage as a JSON array.
# Avoids elevated privileges and ensures sanitized output.
set -euo pipefail

count=${1:-5}
if [[ ! "$count" =~ ^[0-9]+$ ]]; then
  count=5
fi

printf '['
first=1
ps -eo pid,comm,%cpu --no-headers | sort -k3 -nr | head -n "$count" |
while read -r pid comm cpu; do
  comm_clean=$(printf '%s' "$comm" | tr -cd 'A-Za-z0-9_.-')
  cpu_fmt=$(awk -v c="$cpu" 'BEGIN{printf "%.2f", c}')
  if [ $first -eq 0 ]; then printf ','; fi
  printf '{"pid":%s,"cmd":"%s","cpu":%s}' "$pid" "$comm_clean" "$cpu_fmt"
  first=0
done
printf ']\n'
