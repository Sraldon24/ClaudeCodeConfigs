---
paths:
  - "**/*.py"
  - "**/*.pyi"
---
# Python Testing
Extends [common/testing.md](../common/testing.md).
- **Framework:** `pytest`.
- **Coverage:** `pytest --cov=src --cov-report=term-missing`.
- **Organization:** Use `@pytest.mark.unit` / `.integration`.
- **Ref:** See `python-testing` skill for patterns/fixtures.
