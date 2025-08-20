#!/bin/sh
# Output temperatures from thermal zones in Celsius as JSON.
# Avoids elevated privileges and ensures sanitized output.
set -eu

sensor=$(printf '%s' "${1:-}" | tr -cd 'A-Za-z0-9_-')

if [ -n "$sensor" ]; then
  found=0
  for zone in /sys/class/thermal/thermal_zone*/temp; do
    [ -r "$zone" ] || continue
    zone_dir=${zone%/temp}
    name=$(tr -cd 'A-Za-z0-9_-' < "$zone_dir/type")
    [ "$name" = "$sensor" ] || continue
    temp_raw=$(cat "$zone")
    case "$temp_raw" in
      *[!0-9]*|'') continue ;;
    esac
    temp_c=$(awk -v t="$temp_raw" 'BEGIN { printf "%.1f", t/1000 }')
    printf '{"temp":%s}\n' "$temp_c"
    found=1
    break
  done
  if [ "$found" -eq 0 ]; then
    printf '{"temp":0}\n'
  fi
  exit 0
fi

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
