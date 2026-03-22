#!/usr/bin/env bash
# todo-enforcer - Stop hook that blocks Claude from exiting with incomplete todos.

set -euo pipefail

readonly DEBUG_LOG="$HOME/.claude/hooks/todo-enforcer.log"
readonly MAX_CONSECUTIVE_BLOCKS=10

log() {
  echo "[$(date '+%Y-%m-%d %H:%M:%S')] [${2:-INFO}] $1" >> "$DEBUG_LOG" 2>/dev/null || true
}

if ! command -v jq &>/dev/null; then
  exit 0
fi

HOOK_INPUT=$(cat)

log "Hook started"

read -r SESSION_ID TRANSCRIPT_PATH STOP_HOOK_ACTIVE < <(
  echo "$HOOK_INPUT" | jq -r '[.session_id // "unknown", .transcript_path // "", .stop_hook_active // false] | @tsv'
)

log "Session: $SESSION_ID | stop_hook_active: $STOP_HOOK_ACTIVE"

[[ -z "$TRANSCRIPT_PATH" || ! -f "$TRANSCRIPT_PATH" ]] && exit 0

# Safety valve: if already in a stop hook loop, allow exit after max blocks
BLOCK_COUNT_FILE="$HOME/.claude/hooks/todo-enforcer-count-${SESSION_ID}.tmp"
BLOCK_COUNT=0
[[ -f "$BLOCK_COUNT_FILE" ]] && BLOCK_COUNT=$(cat "$BLOCK_COUNT_FILE" 2>/dev/null || echo 0)

if [[ "$STOP_HOOK_ACTIVE" == "true" ]]; then
  BLOCK_COUNT=$((BLOCK_COUNT + 1))
  echo "$BLOCK_COUNT" > "$BLOCK_COUNT_FILE"
  if [[ "$BLOCK_COUNT" -ge "$MAX_CONSECUTIVE_BLOCKS" ]]; then
    log "Safety valve triggered after $MAX_CONSECUTIVE_BLOCKS blocks" "WARN"
    rm -f "$BLOCK_COUNT_FILE"
    exit 0
  fi
fi

TODOS_JSON=$(jq -s '
  [.[] | .message.content[]? | select(.type == "tool_use" and .name == "TodoWrite") | .input.todos] |
  last // empty
' "$TRANSCRIPT_PATH" 2>/dev/null || echo "")

if [[ -z "$TODOS_JSON" || "$TODOS_JSON" == "null" ]]; then
  rm -f "$BLOCK_COUNT_FILE"
  exit 0
fi

read -r PENDING IN_PROGRESS < <(
  echo "$TODOS_JSON" | jq -r '[
    ([.[] | select(.status == "pending")] | length),
    ([.[] | select(.status == "in_progress")] | length)
  ] | @tsv'
)

INCOMPLETE=$((PENDING + IN_PROGRESS))

if [[ "$INCOMPLETE" -eq 0 ]]; then
  rm -f "$BLOCK_COUNT_FILE"
  exit 0
fi

log "Blocking: $INCOMPLETE incomplete todos"

TASK_LIST=$(echo "$TODOS_JSON" | jq -r '
  ([.[] | select(.status == "in_progress") | "  → [in_progress] \(.content)"] +
   [.[] | select(.status == "pending")     | "  ○ [pending]     \(.content)"]) |
  join("\n")
')

jq -n --arg reason "You have $INCOMPLETE incomplete todo(s):
$TASK_LIST

Finish these before stopping. Mark each as 'completed' with TodoWrite." \
  '{"decision": "block", "reason": $reason}'
