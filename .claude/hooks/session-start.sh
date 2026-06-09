#!/bin/bash
set -euo pipefail

if [ "${CLAUDE_CODE_REMOTE:-}" != "true" ]; then
  exit 0
fi

# Install nginx if missing
if ! command -v nginx &>/dev/null; then
  apt-get update -qq && apt-get install -y nginx
fi

# ── Start DeerFlow ──────────────────────────────────────────────────────────
cd "${CLAUDE_PROJECT_DIR}/deer-flow"
make dev > /tmp/deerflow-dev.log 2>&1 &

for i in $(seq 1 60); do
  if curl -s http://localhost:2026/health | grep -q "healthy"; then
    echo "✓ DeerFlow running at http://localhost:2026"
    break
  fi
  sleep 1
done

# ── Start Langflow ──────────────────────────────────────────────────────────
langflow run --host 0.0.0.0 --port 7860 > /tmp/langflow.log 2>&1 &

for i in $(seq 1 60); do
  if curl -s http://localhost:7860/health | grep -q "ok\|healthy\|status"; then
    echo "✓ Langflow running at http://localhost:7860"
    break
  fi
  sleep 1
done

# ── Expose both via localtunnel ─────────────────────────────────────────────
npx localtunnel --port 2026 > /tmp/lt-deerflow.log 2>&1 &
npx localtunnel --port 7860 > /tmp/lt-langflow.log 2>&1 &
sleep 8

DEERFLOW_URL=$(grep -o 'https://[^ ]*' /tmp/lt-deerflow.log | head -1)
LANGFLOW_URL=$(grep -o 'https://[^ ]*' /tmp/lt-langflow.log | head -1)

echo "🦌 DeerFlow:  ${DEERFLOW_URL:-unavailable}"
echo "🌊 Langflow:  ${LANGFLOW_URL:-unavailable}"

# Persist URLs for the session
{
  echo "export DEERFLOW_PUBLIC_URL=${DEERFLOW_URL:-}"
  echo "export LANGFLOW_PUBLIC_URL=${LANGFLOW_URL:-}"
} >> "${CLAUDE_ENV_FILE:-/tmp/claude_env}"

exit 0
