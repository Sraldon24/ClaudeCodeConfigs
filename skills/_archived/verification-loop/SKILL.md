---
name: verification-loop
description: Verification system for Claude Code sessions.
origin: ECC
---
# Verification Loop
Before PR or after refactoring, run:
1. Build: `npm run build` or `pnpm build`
2. Types: `tsc --noEmit` or `pyright .`
3. Lint: `npm run lint` or `ruff check .`
4. Test: `npm test -- --coverage`
5. Security: search for `sk-`, `api_key`, `console.log`
6. Diff review: `git diff HEAD~1`
Output report `VERIFICATION REPORT` with PASS/FAIL statuses.
