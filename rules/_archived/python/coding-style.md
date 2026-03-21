---
paths:
  - "**/*.py"
  - "**/*.pyi"
---
# Python Style
Extends [common/coding-style.md](../common/coding-style.md).
- **Standards:** PEP 8, type annotations on all functions.
- **Immutability:** Use `@dataclass(frozen=True)` or `NamedTuple`.
- **Formatting/Linting:** `black`, `isort`, `ruff`.
- **Ref:** See `python-patterns` skill.
