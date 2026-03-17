#!/usr/bin/env bash
set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
cd "$SCRIPT_DIR"

BUILD_OUTPUT=$(dotnet build --no-incremental 2>&1) || true
FIRST_WARNING=$(echo "$BUILD_OUTPUT" | grep -m1 -E "warning CS|: warning " || true)

if [[ -n "$FIRST_WARNING" ]]; then
  echo "$FIRST_WARNING"
  exit 1
fi
exit 0
