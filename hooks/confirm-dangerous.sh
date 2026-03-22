#!/usr/bin/env bash
# confirm-dangerous - PreToolUse hook that intercepts dangerous bash commands
# and asks the user to confirm or run manually instead of silently blocking.

set -euo pipefail

HOOK_INPUT=$(cat)
CMD=$(echo "$HOOK_INPUT" | jq -r '.tool_input.command // ""')

check() {
  local pattern="$1"
  local label="$2"
  local suggestion="$3"

  if echo "$CMD" | grep -qE "$pattern"; then
    jq -n \
      --arg reason "⚠️  Dangerous command detected: $label

Command: $CMD

Run it yourself if you're sure:
  $suggestion

Or confirm you want Claude to proceed (reply 'yes, run it')." \
      '{"decision": "block", "reason": $reason}'
    exit 0
  fi
}

# rm -rf (only match when rm is at start of command or after && | ; not inside strings/messages)
if echo "$CMD" | grep -qE '(^|&&|\|\||;)[[:space:]]*(sudo[[:space:]]+)?rm[[:space:]]+-[a-zA-Z]*r[a-zA-Z]*f|-[a-zA-Z]*f[a-zA-Z]*r[[:space:]]' && ! echo "$CMD" | grep -qE '^git '; then
  jq -n --arg reason "⚠️  Dangerous command detected: rm -rf (recursive force delete)

Command: $CMD

Run it yourself if you're sure:
  $CMD

Or confirm you want Claude to proceed (reply 'yes, run it')." \
    '{"decision": "block", "reason": $reason}'
  exit 0
fi

# git push --force
check 'git[[:space:]].*push[[:space:]].*--force|git[[:space:]].*push[[:space:]].*-f[[:space:]]' \
  "git push --force (overwrites remote history)" \
  "$CMD"

# git reset --hard
check 'git[[:space:]].*reset[[:space:]].*--hard' \
  "git reset --hard (discards all uncommitted changes)" \
  "$CMD"

exit 0
