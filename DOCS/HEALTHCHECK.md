# Health Check Summary

The project uses the following stacks:

- **Shell** scripts in `scripts/` and `cyberplasma/scripts/`
- **Python** utilities such as `scripts/cp_layouts.py` with `pytest` tests
- **GitHub Actions** workflow in `.github/workflows/ci.yml`
- **Markdown/YAML** configuration and docs

No JavaScript/TypeScript or Dockerfiles were detected.

## Running Checks

Run all linters and tests:

```bash
make all
```

A lightweight wiring check is available:

```bash
scripts/healthcheck.sh
```
