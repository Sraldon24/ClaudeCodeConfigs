---
name: search-first
description: Research-before-coding workflow.
origin: ECC
---
# search-first
Always research before coding newly required functionality:
1. Repo -> `rg`
2. Packages -> npm/PyPI
3. MCP -> Check `~/.claude/settings.json`
4. Skills -> Check `~/.claude/skills/`
5. GitHub -> Read existing code
For complex research, launch `general-purpose` subagent to search npm/MCP/skills/GitHub and return a decision matrix (Adopt/Extend/Compose/Build).
Never jump to building straight away without checking existing battle-tested dependencies.
