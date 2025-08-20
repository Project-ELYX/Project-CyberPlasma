#!/usr/bin/env bash
# Install Python packages defined in requirements.txt.

set -euo pipefail

if command -v python3 >/dev/null 2>&1; then
  PYTHON=python3
elif command -v python >/dev/null 2>&1; then
  PYTHON=python
else
  echo "Error: Python is required but was not found." >&2
  exit 1
fi

if ! $PYTHON -m pip --version >/dev/null 2>&1; then
  echo "Error: pip is not installed for $PYTHON." >&2
  exit 1
fi

$PYTHON -m pip install -r requirements.txt
