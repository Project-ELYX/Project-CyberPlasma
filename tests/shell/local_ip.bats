#!/usr/bin/env bats

setup() {
  stub_dir="${BATS_TEST_TMPDIR}/bin"
  mkdir -p "$stub_dir"
  PATH="$stub_dir:$PATH"
  cat <<'EOF' >"$stub_dir/ip"
#!/bin/sh
cat <<'OUT'
1: eth0    inet 192.168.1.10/24 brd 192.168.1.255 scope global eth0
2: wlan0   inet 10.0.0.5/24 brd 10.0.0.255 scope global wlan0
OUT
EOF
  chmod +x "$stub_dir/ip"
}

@test "local_ip outputs JSON mapping interfaces to IPs" {
  run "${BATS_TEST_DIRNAME}/../../cyberplasma/scripts/local_ip.sh"
  [ "$status" -eq 0 ]
  [ "$output" = '{"eth0":"192.168.1.10","wlan0":"10.0.0.5"}' ]
}
