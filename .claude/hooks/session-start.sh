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
    break
  fi
  sleep 1
done

# Start localtunnel and expose public URL
echo "Starting localtunnel..."
npx localtunnel --port 2026 > /tmp/localtunnel.log 2>&1 &
sleep 5

PUBLIC_URL=$(grep -o 'https://[^ ]*' /tmp/localtunnel.log | head -1)
if [ -n "$PUBLIC_URL" ]; then
  echo "Public URL: $PUBLIC_URL"
  # Persist URL for the session
  echo "export DEERFLOW_PUBLIC_URL=$PUBLIC_URL" >> "${CLAUDE_ENV_FILE:-/tmp/claude_env}"
else
  echo "WARNING: Could not get public URL — check /tmp/localtunnel.log"
fi

exit 0
