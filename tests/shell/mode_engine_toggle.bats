#!/usr/bin/env bats

setup() {
  stub_dir="${BATS_TEST_TMPDIR}/bin"
  mkdir -p "$stub_dir"
  PATH="$stub_dir:$PATH"
  XDG_STATE_HOME="${BATS_TEST_TMPDIR}/state"
  mkdir -p "$XDG_STATE_HOME"
  XRANDR_STATE="${BATS_TEST_TMPDIR}/xrandr_state"
  : > "$XRANDR_STATE"
  export XDG_STATE_HOME XRANDR_STATE

  cat <<'JQ' >"$stub_dir/jq"
#!/usr/bin/env python3
import sys, json, os
args = sys.argv[1:]
file = args[-1] if args else None
expr = None
screen = None
mode = None
raw = False
i = 0
while i < len(args) - 1:
    if args[i] == '-r':
        raw = True
        i += 1
    elif args[i] == '--arg':
        key = args[i+1]; val = args[i+2]
        if key == 's':
            screen = val
        elif key == 'm':
            mode = val
        i += 3
    else:
        expr = args[i]
        i += 1
if file is None:
    sys.exit(0)
if os.path.exists(file):
    content = open(file).read().strip()
    data = json.loads(content) if content else {}
else:
    data = {}
if expr == '.[$s]=$m':
    data[screen] = mode
    print(json.dumps(data))
elif expr == '.[$s] // empty':
    val = data.get(screen, "")
    if raw:
        print(val)
    else:
        print(json.dumps(val))
elif expr and expr.startswith('to_entries[]'):
    for k, v in data.items():
        print(f"{k} {v}")
elif expr == 'keys[]':
    for k in data.keys():
        print(k)
JQ
  chmod +x "$stub_dir/jq"

  cat <<'XR' >"$stub_dir/xrandr"
#!/bin/sh
state_file="$XRANDR_STATE"
case "$1" in
  --query)
    [ -f "$state_file" ] && while read -r s m; do
      if [ "$m" = "off" ]; then
        echo "$s connected"
      else
        echo "$s connected $m+0+0"
      fi
    done < "$state_file"
    ;;
  --output)
    screen="$2"
    if [ "$3" = "--mode" ]; then
      mode="$4"
      awk -v s="$screen" -v m="$mode" 'BEGIN{found=0} $1==s{print s, m; found=1; next} {print} END{if(!found)print s, m}' "$state_file" 2>/dev/null > "$state_file.tmp"
      mv "$state_file.tmp" "$state_file"
    elif [ "$3" = "--off" ]; then
      awk -v s="$screen" 'BEGIN{found=0} $1==s{print s, "off"; found=1; next} {print} END{if(!found)print s, "off"}' "$state_file" 2>/dev/null > "$state_file.tmp"
      mv "$state_file.tmp" "$state_file"
    fi
    ;;
esac
XR
  chmod +x "$stub_dir/xrandr"
}

script="${BATS_TEST_DIRNAME}/../../scripts/mode_engine.sh"

@test "toggle_screen turns off then on using saved mode" {
  run "$script" --screen HDMI-1 --mode 1920x1080
  [ "$status" -eq 0 ]
  run "$script" --screen HDMI-1 --toggle
  [ "$status" -eq 0 ]
  grep -q "HDMI-1 off" "$XRANDR_STATE"
  run "$script" --screen HDMI-1 --toggle
  [ "$status" -eq 0 ]
  grep -q "HDMI-1 1920x1080" "$XRANDR_STATE"
}

@test "toggle_all toggles each saved screen" {
  run "$script" --screen HDMI-1 --mode 1920x1080
  run "$script" --screen DP-1 --mode 1280x720
  grep -q "HDMI-1 1920x1080" "$XRANDR_STATE"
  grep -q "DP-1 1280x720" "$XRANDR_STATE"
  run "$script" --toggle-all
  grep -q "HDMI-1 off" "$XRANDR_STATE"
  grep -q "DP-1 off" "$XRANDR_STATE"
  run "$script" --toggle-all
  grep -q "HDMI-1 1920x1080" "$XRANDR_STATE"
  grep -q "DP-1 1280x720" "$XRANDR_STATE"
}
