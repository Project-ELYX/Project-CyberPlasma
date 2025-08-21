.PHONY: lint test test-py test-sh typecheck coverage all

lint:
	@[ -d .github/workflows ] && actionlint || true
	@command -v ruff >/dev/null 2>&1 && ruff check . || true
	@command -v eslint >/dev/null 2>&1 && ls -1 **/*.js **/*.ts >/dev/null 2>&1 && eslint . || true
	@command -v markdownlint >/dev/null 2>&1 && markdownlint '**/*.md' || true
	@command -v yamllint >/dev/null 2>&1 && yamllint . || true
	@command -v hadolint >/dev/null 2>&1 && hadolint Dockerfile || true
	@shellcheck -S warning $(shell git ls-files '*.sh') || true

test: test-py test-sh

test-py:
	@if ls -1 **/*.py >/dev/null 2>&1; then \
  pytest -q; \
else echo "No Python files detected; skipping pytest."; fi

test-sh:
	@if ls -1 tests/shell/*.bats >/dev/null 2>&1; then \
  bats tests/shell; \
else echo "No Bats tests; skipping."; fi

typecheck:
	@command -v mypy >/dev/null 2>&1 && [ -f mypy.ini ] && mypy || true
	@command -v tsc >/dev/null 2>&1 && [ -f tsconfig.json ] && tsc --noEmit || true

coverage:
	@if ls -1 **/*.py >/dev/null 2>&1; then \
  coverage run -m pytest && coverage report -m; \
else echo "No Python files; skipping coverage."; fi

all: lint typecheck test
