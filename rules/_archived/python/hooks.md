---
paths:
  - "**/*.py"
  - "**/*.pyi"
---
# Python Hooks
Extends [common/hooks.md](../common/hooks.md).
- **PostToolUse:** Settings trigger `black`/`ruff` for format, `mypy`/`pyright` for types.
- **Warnings:** Warn if `print()` is used (use `logging` instead).
