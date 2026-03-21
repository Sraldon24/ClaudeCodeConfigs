# Claude Code Config

Personal Claude Code configuration — rules, agents, skills, and commands.

## Structure

```
~/.claude/
├── settings.json        # Claude Code settings (tokens, permissions, context)
├── rules/
│   └── common/          # Universal coding rules (style, git, testing, security)
├── agents/              # Specialized sub-agents
├── skills/              # Deep reference skills for specific tasks
├── commands/            # Slash commands
└── memory/              # Persistent memory across sessions
```

## Rules

Located in `rules/common/`:

| File | Purpose |
|------|---------|
| `coding-style.md` | Immutability, file organization, error handling |
| `git-workflow.md` | Commit format, PR workflow, gh CLI usage |
| `development-workflow.md` | Research → Plan → TDD → Review → Commit |
| `testing.md` | 80% coverage, TDD mandatory, test types |
| `security.md` | Pre-commit checks, secret management |
| `agents.md` | When and how to use sub-agents |
| `hooks.md` | PreToolUse / PostToolUse / Stop hooks |
| `patterns.md` | Repository pattern, API response format |
| `azure-devops-workflow.md` | Azure DevOps CLI usage |

## Commands

| Command | Purpose |
|---------|---------|
| `/arch` | Plan implementation (requires confirm) |
| `/audit` | Security review |
| `/check` | Run checks |
| `/clean` | Refactor cleanup |
| `/db` | Database migrations |
| `/fix` | Fix build errors |
| `/review` | Code review |
| `/test` | TDD / testing guidelines |
| `/save` | Checkpoint current work |
| `/sync` | Update docs |
| `/find` | Search archived patterns |
| `/browser` | Load Playwright MCP |

## Key Settings

- `MAX_MCP_OUTPUT_TOKENS=10000` — prevents MCP token bloat
- `CLAUDE_AUTOCOMPACT_PCT_OVERRIDE=50` — auto-compact at 50% context
- `defaultMode: bypassPermissions` — skips permission prompts
- `context.discoveryMaxDirs: 200` — scans up to 200 dirs for CLAUDE.md

## What's Excluded

- `.credentials.json` — Claude auth token (never commit)
- `plugins/` — managed separately
- `cache/`, `sessions/`, `history.jsonl` — runtime data
