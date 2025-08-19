#!/bin/sh
# Output the current public IPv4 address as JSON.
# Avoids elevated privileges and ensures sanitized output.
set -eu

state_dir="${XDG_STATE_HOME:-"$HOME/.local/state"}"
cache_file="$state_dir/public_ip"
cache_max_age=60

mkdir -p "$state_dir"
now=$(date +%s)

if [ -f "$cache_file" ]; then
  mod_time=$(stat -c %Y "$cache_file")
  age=$((now - mod_time))
  if [ "$age" -lt "$cache_max_age" ]; then
    ip=$(cat "$cache_file")
    if printf '%s' "$ip" | grep -Eq '^([0-9]{1,3}\.){3}[0-9]{1,3}$'; then
      printf '{"ip":"%s"}\n' "$ip"
      exit 0
    fi
  fi
fi

ip=$(curl --max-time 2 -fsS https://api.ipify.org 2>/dev/null || true)
if printf '%s' "$ip" | grep -Eq '^([0-9]{1,3}\.){3}[0-9]{1,3}$'; then
  printf '%s' "$ip" > "$cache_file"
  printf '{"ip":"%s"}\n' "$ip"
  exit 0
fi

if [ -f "$cache_file" ]; then
  ip=$(cat "$cache_file")
  if printf '%s' "$ip" | grep -Eq '^([0-9]{1,3}\.){3}[0-9]{1,3}$'; then
    printf '{"ip":"%s"}\n' "$ip"
    exit 0
  fi
fi
printf '{"ip":null}\n'
