# /check
Run comprehensive verification in order:
1. Build check (STOP if fails)
2. Type check (report file:line)
3. Lint (report warnings/errors)
4. Test suite (report pass/fail, coverage %)
5. `console.log` audit (report locations)
6. Git status (uncommitted/modified)

Output concise report:
```
VERIFICATION: [PASS/FAIL]
Build: [OK/FAIL] | Types: [OK/X errs] | Lint: [OK/X issues]
Tests: [X/Y pass, Z%] | Secrets/Logs: [OK/X]
Ready for PR: [YES/NO]. List critical issues/fixes.
```

Args: `quick` (build+types), `full` (default), `pre-commit`, `pre-pr` (+security).
