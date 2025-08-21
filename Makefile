.PHONY: test-shell

test-shell:
	@if command -v bats >/dev/null 2>&1; then \
		bats tests/shell; \
	else \
		echo "bats not found. To run shell tests, execute:"; \
		echo "  docker run --rm -v $$PWD:/repo -w /repo bats/bats:1.11.0 bats tests/shell"; \
	fi
