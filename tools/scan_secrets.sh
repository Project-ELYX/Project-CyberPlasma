#!/usr/bin/env bash
set -euo pipefail
IFS=$'\n\t'

echo "[secrets] scanning repo…"
grep -RIn --binary-files=without-match -E '(AWS_|AKIA|SECRET|PRIVATE KEY|BEGIN RSA|BEGIN OPENSSH|password=|token=|x-api-key|ghp_[A-Za-z0-9]{36})' . \
  2>/dev/null | grep -v "scan_secrets.sh" || echo "[secrets] none found"
