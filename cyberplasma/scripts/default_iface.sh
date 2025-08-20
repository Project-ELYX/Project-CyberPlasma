#!/bin/sh
# Output default network interface used for outbound connections.
# Avoids elevated privileges and ensures sanitized output.
set -eu
ip route get 1 2>/dev/null | awk '{for(i=1;i<=NF;i++) if($i=="dev"){print $(i+1); exit}}'

