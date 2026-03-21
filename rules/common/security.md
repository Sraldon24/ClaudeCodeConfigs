# Security
## Checks Before Commit
- No hardcoded secrets (API keys, passwords)
- Validate all user input
- SQL injection prevention (parameterized)
- XSS/CSRF protection
- Auth verified, rate limiting enabled
- Error messages don't leak data
## Secret Management
NEVER hardcode. Use env vars/secret manager. Validate at startup. Rotate if exposed.
## Response Protocol
Found issue? 1. STOP. 2. Use `security-reviewer` agent. 3. Fix CRITICAL issues. 4. Rotate secrets. 5. Review codebase.
