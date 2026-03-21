---
paths:
  - "**/*.py"
  - "**/*.pyi"
---
# Python Security
Extends [common/security.md](../common/security.md).
- **Secrets:** Use `dotenv` and `os.environ["KEY"]` (fails fast on missing).
- **Scanning:** Run `bandit -r src/`.
- **Ref:** See `django-security` skill if applicable.
