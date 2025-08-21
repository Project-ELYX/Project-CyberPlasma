#!/usr/bin/env bats

setup() {
  tmpdir="$BATS_TEST_TMPDIR/work"
  mkdir -p "$tmpdir"
  cp scripts/apply_bismuth_mode.sh "$tmpdir/"
  cat >"$tmpdir/toggle_tiling.sh" <<'SH'
#!/usr/bin/env bash
set -euo pipefail
echo "$1" > "$(dirname "$0")/arg"
SH
  chmod +x "$tmpdir/toggle_tiling.sh"
  export XDG_STATE_HOME="$tmpdir/state"
  mkdir -p "$XDG_STATE_HOME"
}

@test "invalid mode defaults to free" {
  echo "weird" > "$XDG_STATE_HOME/bismuth_mode"
  pushd "$tmpdir" >/dev/null
  ./apply_bismuth_mode.sh
  popd >/dev/null
  read -r arg < "$tmpdir/arg"
  [ "$arg" = "--free" ]
}
