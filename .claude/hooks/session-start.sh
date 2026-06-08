#!/bin/bash
set -euo pipefail

if [ "${CLAUDE_CODE_REMOTE:-}" != "true" ]; then
  exit 0
fi

# Install nginx if missing
if ! command -v nginx &>/dev/null; then
  apt-get update -qq && apt-get install -y nginx
fi

# Start DeerFlow in background (dev mode)
cd "${CLAUDE_PROJECT_DIR}/deer-flow"
make dev > /tmp/deerflow-dev.log 2>&1 &

# Wait for gateway to be healthy (up to 60s)
for i in $(seq 1 60); do
  if curl -s http://localhost:2026/health | grep -q "healthy"; then
    echo "DeerFlow is running at http://localhost:2026"
    exit 0
  fi
  sleep 1
done

echo "WARNING: DeerFlow did not start within 60s — check /tmp/deerflow-dev.log"
exit 0
