# Performance Optimization

## Model Selection Strategy

**Haiku 4.5** (90% of Sonnet capability, 3x cost savings):
- Lightweight agents with frequent invocation
- Pair programming and code generation
- Worker agents in multi-agent systems

**Sonnet 4.6** (Best coding model):
- Main development work
- Orchestrating multi-agent workflows
- Complex coding tasks

**Opus 4.5** (Deepest reasoning):
- Complex architectural decisions
- Maximum reasoning requirements
- Research and analysis tasks

## Context Window Management

Auto-compaction fires at 60% context fill (`CLAUDE_AUTOCOMPACT_PCT_OVERRIDE=60` in settings.json).
Manual `/compact` triggers summarization on demand.

Compact proactively at logical breakpoints — do NOT wait for auto-compact to fire mid-task:
- After finishing a feature or bug fix
- Before switching to a new unrelated task
- When context fill feels heavy (lots of file reads, tool outputs)
- Use `/compact focus on <topic>` to guide what survives

Use `/clear` (full reset) when:
- Starting a completely unrelated task
- Context is polluted with irrelevant history

Use `/compact` (summarize) when:
- You need to retain key decisions/code from earlier in session
- Switching sub-tasks within same feature

Avoid last 20% of context window for:
- Large-scale refactoring
- Feature implementation spanning multiple files
- Debugging complex interactions

Lower context sensitivity tasks (safe to run late in session):
- Single-file edits
- Independent utility creation
- Documentation updates
- Simple bug fixes

## WebFetch — Biggest Per-Call Token Burn

**WebFetch averages 3,800 tokens/call, peaks at 12,000.** It fetches raw HTML including nav, ads, scripts.

Rules:
- **ALWAYS use `defuddle` skill** before WebFetch for any URL (docs, articles, blog posts, pages) — extracts clean markdown, strips clutter, saves ~70–90% tokens
- Only fall back to WebFetch if defuddle fails or content is not a standard web page
- Never WebFetch the same URL twice in a session — it's in context already

## Reading Large Files — Second Biggest Burn

Reading a large file (e.g. `~/.claude.json` at 200KB) dumps everything into context at once.

Rules:
- **Use `Grep` first** — search for specific content without reading the whole file
- **Use `Bash` with `jq`/`python3`** to extract specific fields from JSON/YAML instead of `Read`
- **Use `Read` with `offset`+`limit`** when you know which lines you need
- Never re-read a file already read this session — it's in context
- Never `Read` a file just to check if a field exists — use `Grep` for existence checks

## Repeated Tool Calls — Hidden Accumulator

Every tool call appends its output to context permanently for the session.

Rules:
- Before any tool call, ask: "Is this data already in context from earlier?"
- Bash output, file reads, search results — all stay in context; use them, don't re-fetch
- Prefer `Grep` over multiple `Read` calls when searching across files

## MCP Token Management (CRITICAL)

MCP responses have no size cap — any call can dump 10k+ tokens and silently wreck context.
Hard cap enforced via `MAX_MCP_OUTPUT_TOKENS=10000` in settings.json.
Apply to ALL MCP servers, all projects.

### How Claude Code protects you automatically
- **Tool Search** (auto-enabled): defers MCP tool definitions when they exceed 10% of context. Cuts initial overhead from ~77k → ~8.7k tokens (95% reduction).
- **Warning threshold**: `⚠ Large MCP response` fires when any response exceeds ~10k tokens.

### Behavioral rules (every MCP call)
- **Never print raw MCP output** — process silently; surface only extracted info
- **Prefer targeted over broad** — use search/filter/get-by-id before list-all/catalog/get-everything
- **Call once per session** — mentally cache results; never re-call for data already in context
- **After `⚠ Large MCP response`** — do not call similar tools again this session
- **Catalog/listing tools are high-risk** — "get all X" patterns dump everything; extract and discard

### Pre-call checklist (run before any MCP call)
1. Does a filtered/search version exist? → Use it.
2. Is this data already in context? → Skip entirely.
3. Will response be a list/catalog? → Extract only needed fields, never echo.

## Compaction Instructions (preserved across /compact)

When compacting, always preserve:
- Modified files list and their purposes
- Current task state and next steps
- Any errors encountered and how they were fixed
- Key architectural decisions made this session

## Extended Thinking

Extended thinking is off by default (`alwaysThinkingEnabled: false`).
Budget capped at 10,000 tokens via `MAX_THINKING_TOKENS=10000`.

Enable only for: complex architectural decisions, deep debugging, multi-step planning.
Toggle: Alt+T | Verbose: Ctrl+O

## Build Troubleshooting

If build fails:
1. Use **build-error-resolver** agent
2. Analyze error messages
3. Fix incrementally
4. Verify after each fix
