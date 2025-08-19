#!/bin/sh
# Output CPU usage percentage as JSON.
# Avoids elevated privileges and ensures sanitized output.
set -eu

read -r _ user nice system idle iowait irq softirq steal guest < /proc/stat
prev_total=$((user + nice + system + idle + iowait + irq + softirq + steal))
prev_idle=$((idle + iowait))

sleep 1

read -r _ user nice system idle iowait irq softirq steal guest < /proc/stat
total=$((user + nice + system + idle + iowait + irq + softirq + steal))
idle_all=$((idle + iowait))

delta_total=$((total - prev_total))
delta_idle=$((idle_all - prev_idle))

usage=$(awk -v total="$delta_total" -v idle="$delta_idle" '
BEGIN {
  if (total > 0) {
    printf "%.2f", (1 - idle / total) * 100
  } else {
    print "0.00"
  }
}')

printf '{"usage":%s}\n' "$usage"
