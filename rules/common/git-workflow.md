# Git Workflow
## Commits
Format: `<type>: <description>\n\n<body>`
Types: feat, fix, refactor, docs, test, chore, perf, ci. (Attribution disabled).
## PRs
1. Analyze full history.
2. `git diff [base]...HEAD`
3. Draft summary & test plan.
4. Push with `-u` for new branches.
## GitHub Ops (gh CLI) - CRITICAL
NEVER use GitHub MCP. It is removed to save tokens.
ALWAYS use `gh` CLI via Bash:
- `gh pr create/view/merge/status`
- `gh issue list/view/create`
- `gh repo view/clone`
