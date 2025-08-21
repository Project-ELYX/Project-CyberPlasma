#!/bin/sh
# Output RAM usage as JSON.
# Avoids elevated privileges and ensures sanitized output.
set -eu

meminfo=/proc/meminfo
total=$(awk '/^MemTotal:/ {print $2}' "$meminfo")
available=$(awk '/^MemAvailable:/ {print $2}' "$meminfo")
used=$((total - available))

percent=$(awk -v u="$used" -v t="$total" 'BEGIN { if (t > 0) printf "%.2f", (u / t) * 100; else print "0.00" }')
used_dots=$(awk -v u="$used" -v t="$total" 'BEGIN { if (t > 0) { v=int((u / t) * 240); if (v > 240) v=240; print v } else print 0 }')

printf '{"total_kb":%s,"used_kb":%s,"percent":%s,"used_dots":%s}\n' "$total" "$used" "$percent" "$used_dots"
