#!/usr/bin/env python3
"""Manage CyberPlasma HUD layouts.

Layouts are stored in ``~/.local/state/cp_layouts.json`` and are keyed by
``<screen>_<mode>``. Each entry contains the currently selected preset index and
an array of presets. A preset is a mapping of widget name to ``{"x": int,
"y": int}`` coordinates.

This script provides two subcommands:

``cycle <next|prev>``
    Switch to the next or previous layout preset for the current screen/mode.

``move <direction>``
    Offset all widget coordinates in the current preset. Direction may be
    ``left``, ``right``, ``up`` or ``down``.

The script intentionally keeps interaction with the window manager minimal. It
only reads/writes the layout JSON file. Integrations with external tools such as
``eww`` can build on top of this state file.
"""

from __future__ import annotations

import json
import os
import subprocess
import sys
from typing import Dict, Any

STATE_DIR = os.environ.get("XDG_STATE_HOME", os.path.expanduser("~/.local/state"))
LAYOUT_FILE = os.path.join(STATE_DIR, "cp_layouts.json")
MODE_FILE = os.path.join(STATE_DIR, "bismuth_mode")
STEP = 25  # pixels to move widgets per arrow press


def load_data() -> Dict[str, Any]:
    try:
        with open(LAYOUT_FILE) as f:
            return json.load(f)
    except FileNotFoundError:
        return {}


def save_data(data: Dict[str, Any]) -> None:
    os.makedirs(STATE_DIR, exist_ok=True)
    with open(LAYOUT_FILE, "w") as f:
        json.dump(data, f, indent=2)


def current_screen() -> str:
    """Return the name of the primary screen.

    Falls back to ``unknown`` if ``xrandr`` is not available.
    """

    try:
        output = subprocess.check_output(["xrandr", "--current"], text=True)
    except Exception:
        return "unknown"

    first_connected: str | None = None
    for line in output.splitlines():
        if " connected" in line:
            screen = line.split()[0]
            if " primary" in line:
                return screen
            if first_connected is None:
                first_connected = screen
    return first_connected or "unknown"


def current_mode() -> str:
    try:
        with open(MODE_FILE) as f:
            return f.read().strip() or "default"
    except FileNotFoundError:
        return "default"


def current_key() -> str:
    return f"{current_screen()}_{current_mode()}"


def cycle(direction: str) -> None:
    data = load_data()
    key = current_key()
    entry = data.setdefault(key, {"current": 0, "presets": [{}]})
    presets = entry["presets"]
    idx = entry.get("current", 0)
    if direction == "next":
        idx = (idx + 1) % len(presets)
    else:
        idx = (idx - 1) % len(presets)
    entry["current"] = idx
    save_data(data)


def move(direction: str) -> None:
    data = load_data()
    key = current_key()
    entry = data.setdefault(key, {"current": 0, "presets": [{}]})
    preset = entry["presets"][entry["current"]]
    dx = dy = 0
    if direction == "left":
        dx = -STEP
    elif direction == "right":
        dx = STEP
    elif direction == "up":
        dy = -STEP
    elif direction == "down":
        dy = STEP
    for widget, pos in preset.items():
        pos["x"] = pos.get("x", 0) + dx
        pos["y"] = pos.get("y", 0) + dy
    save_data(data)


def main(argv: list[str]) -> int:
    if len(argv) < 2:
        print(__doc__)
        return 1

    cmd = argv[1]
    if cmd == "cycle" and len(argv) >= 3:
        if argv[2] in {"next", "prev"}:
            cycle(argv[2])
            return 0
    elif cmd == "move" and len(argv) >= 3:
        if argv[2] in {"left", "right", "up", "down"}:
            move(argv[2])
            return 0

    print(__doc__)
    return 1


if __name__ == "__main__":
    raise SystemExit(main(sys.argv))
