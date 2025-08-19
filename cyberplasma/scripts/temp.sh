#!/bin/sh
# Output temperatures from thermal zones in Celsius as JSON.
# Avoids elevated privileges and ensures sanitized output.
set -eu

printf '{'
first=1
for zone in /sys/class/thermal/thermal_zone*/temp; do
  [ -r "$zone" ] || continue
  zone_dir=${zone%/temp}
  name=$(tr -cd 'A-Za-z0-9_-' < "$zone_dir/type")
  temp_raw=$(cat "$zone")
  case "$temp_raw" in
    *[!0-9]*|'') continue ;;
  esac
  temp_c=$(awk -v t="$temp_raw" 'BEGIN { printf "%.1f", t/1000 }')
  if [ "$first" -eq 0 ]; then printf ','; fi
  printf '"%s":%s' "$name" "$temp_c"
  first=0
done
printf '}\n'
