import json
import sys
from pathlib import Path

# Ensure scripts directory is on the path for importing cp_layouts
scripts_dir = Path(__file__).resolve().parents[1] / "scripts"
sys.path.insert(0, str(scripts_dir))

import cp_layouts  # type: ignore


def _setup_state(monkeypatch, tmp_path):
    monkeypatch.setattr(cp_layouts, "STATE_DIR", str(tmp_path))
    monkeypatch.setattr(cp_layouts, "LAYOUT_FILE", str(tmp_path / "cp_layouts.json"))
    monkeypatch.setattr(cp_layouts, "MODE_FILE", str(tmp_path / "bismuth_mode"))
    monkeypatch.setattr(cp_layouts, "current_key", lambda: "screen_mode")


def _read_data(tmp_path):
    with open(tmp_path / "cp_layouts.json") as f:
        return json.load(f)


def test_cycle_changes_current(monkeypatch, tmp_path):
    _setup_state(monkeypatch, tmp_path)
    data = {"screen_mode": {"current": 0, "presets": [{}, {}]}}
    (tmp_path / "cp_layouts.json").write_text(json.dumps(data))

    cp_layouts.cycle("next")
    assert _read_data(tmp_path)["screen_mode"]["current"] == 1

    cp_layouts.cycle("prev")
    assert _read_data(tmp_path)["screen_mode"]["current"] == 0


def test_move_offsets_widgets(monkeypatch, tmp_path):
    _setup_state(monkeypatch, tmp_path)
    data = {"screen_mode": {"current": 0, "presets": [{"widget": {"x": 0, "y": 0}}]}}
    (tmp_path / "cp_layouts.json").write_text(json.dumps(data))

    cp_layouts.move("right")
    cp_layouts.move("down")

    preset = _read_data(tmp_path)["screen_mode"]["presets"][0]["widget"]
    assert preset == {"x": cp_layouts.STEP, "y": cp_layouts.STEP}
