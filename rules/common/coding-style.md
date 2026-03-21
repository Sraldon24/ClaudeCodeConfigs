# Coding Style

- **Immutability (CRITICAL):** ALWAYS create new objects, NEVER mutate (WRONG: `modify(obj)`, CORRECT: `update(obj)`). Prevents side effects.
- **Files:** Many small files > few large files. High cohesion, 200-400 lines (800 max). Organize by domain not type.
- **Errors:** Handle comprehensively at all levels. Provide UI errors, server logs. Never silently swallow.
- **Validation:** Validate all input at boundaries. Fail fast. Never trust external data.
- **Completion Check:** Readable, small functions (<50L), small files (<800L), nesting <4, handle errors, no hardcodes, immutable.
- **Token Limits (CRITICAL):** Simple answers <500, code edits <2k, complex <4k. Absolute cap 5k. Never dump raw MCP output; use internally. Use `/clear` or `/compact` to manage context.
