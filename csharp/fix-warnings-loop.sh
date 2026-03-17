#!/usr/bin/env bash
#
# Loop: while there are compiler warnings, run a new Cursor agent to fix one
# by following process/fix-warning.md (one warning per run, then merge to main).
#
# Prerequisites:
#   - Cursor Agent CLI installed (https://cursor.com/docs/cli/using)
#   - Start from a clean working tree
#   - Run from this directory (where first-warning.sh lives)
#
# Usage: ./fix-warnings-loop.sh
#
set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
cd "$SCRIPT_DIR"

# Prefer 'agent'; some installs expose it as 'cursor agent'
if command -v agent &>/dev/null; then
  AGENT_CMD="agent"
elif command -v cursor &>/dev/null; then
  AGENT_CMD="cursor agent"
else
  echo "Error: Cursor Agent CLI not found. Install from https://cursor.com/docs/cli/using" >&2
  exit 1
fi

PROMPT="Follow the process in process/fix-warning.md exactly."

round=0
while true; do
  round=$((round + 1))
  echo "=== Round $round: checking for warnings ==="
  if ./first-warning.sh; then
    echo "No warnings left. Done."
    exit 0
  fi
  echo "Warnings present. Starting Cursor agent to fix one (process/fix-warning.md)."
  $AGENT_CMD -p --workspace "$SCRIPT_DIR" "$PROMPT"
  echo "Agent finished. Re-checking for warnings..."
done
