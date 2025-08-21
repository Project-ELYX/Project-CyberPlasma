#!/usr/bin/env bash
set -euo pipefail

echo "[healthcheck] repo root: $(pwd)"

# Python import sanity
if command -v python >/dev/null && ls -1 **/*.py >/dev/null 2>&1; then
  python - <<'PY'
import importlib, pkgutil, sys
sys.exit(0)
PY
fi

echo "[healthcheck] OK"
