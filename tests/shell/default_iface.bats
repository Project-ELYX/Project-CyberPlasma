#!/usr/bin/env bats

setup() {
  stub_dir="${BATS_TEST_TMPDIR}/bin"
  mkdir -p "$stub_dir"
  PATH="$stub_dir:$PATH"
  cat <<'EOF' >"$stub_dir/ip"
#!/bin/sh
echo "1.0.0.0 dev eth0 src 192.168.1.10"
EOF
  chmod +x "$stub_dir/ip"
}

@test "default_iface prints interface name" {
  run "${BATS_TEST_DIRNAME}/../../cyberplasma/scripts/default_iface.sh"
  [ "$status" -eq 0 ]
  [ "$output" = "eth0" ]
}
