#!/bin/sh
# Output per-core and average CPU usage as JSON.
# Avoids elevated privileges and ensures sanitized output.
set -eu

cores=$(nproc --all)

# capture initial per-core statistics
prev=$(grep '^cpu[0-9]' /proc/stat)
sleep 1
curr=$(grep '^cpu[0-9]' /proc/stat)

# adjust core count to available lines
lines=$(printf '%s\n' "$prev" | wc -l)
if [ "$lines" -lt "$cores" ]; then
  cores=$lines
fi

cores_json=""
sum=0

for i in $(seq 0 $((cores - 1))); do
  prev_line=$(printf '%s\n' "$prev" | sed -n "$((i + 1))p")
  curr_line=$(printf '%s\n' "$curr" | sed -n "$((i + 1))p")

  # shell splits fields for us
  set -- $prev_line
  prev_total=$(( $2 + $3 + $4 + $5 + $6 + $7 + $8 + $9 ))
  prev_idle=$(( $5 + $6 ))

  set -- $curr_line
  total=$(( $2 + $3 + $4 + $5 + $6 + $7 + $8 + $9 ))
  idle_all=$(( $5 + $6 ))

  delta_total=$(( total - prev_total ))
  delta_idle=$(( idle_all - prev_idle ))

  if [ "$delta_total" -gt 0 ]; then
    usage=$(awk -v t="$delta_total" -v i="$delta_idle" 'BEGIN{printf "%.2f", (1 - i/t) * 100}')
  else
    usage="0.00"
  fi

  cores_json="$cores_json$usage,"
  sum=$(awk -v s="$sum" -v u="$usage" 'BEGIN{printf "%.2f", s+u}')
done

cores_json=${cores_json%,}
avg=$(awk -v s="$sum" -v c="$cores" 'BEGIN{if (c>0) printf "%.2f", s/c; else print "0.00"}')

printf '{"usage":%s,"cores":[%s]}\n' "$avg" "$cores_json"
