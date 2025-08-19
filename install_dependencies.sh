#!/usr/bin/env bash
# Install system packages required for the CyberPlasma environment.
# The script detects common Linux package managers and installs the
# dependencies used by the configuration.

set -euo pipefail

APT_PKGS=(
  git
  plasma-desktop
  kwin-x11
  kwin-bismuth
  eww
  glava
  yakuake
)

PACMAN_PKGS=(
  git
  plasma-desktop
  kwin
  bismuth
  eww
  glava
  yakuake
)

if command -v apt-get >/dev/null 2>&1; then
  sudo apt-get update
  sudo apt-get install -y "${APT_PKGS[@]}"
elif command -v pacman >/dev/null 2>&1; then
  sudo pacman -Sy --needed "${PACMAN_PKGS[@]}"
else
  echo "Unsupported package manager. Install the following packages manually:" >&2
  echo "${APT_PKGS[*]}" >&2
  exit 1
fi
