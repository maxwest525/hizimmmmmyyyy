# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## What This Repo Is

This is a personal Claude Code workspace that hosts a full DeerFlow installation (`deer-flow/` submodule) plus agent skills and session automation.

## DeerFlow — the main app

DeerFlow is a full-stack AI agent harness running at **http://localhost:2026**.

- Backend: Python 3.12, LangGraph + FastAPI gateway (`backend/`)
- Frontend: Next.js 16 + React 19 + TypeScript (`frontend/`)
- Nginx reverse proxy on port 2026 unifying both services
- Config: `deer-flow/config.yaml` (gitignored) — LLM providers, tools, sandbox
- Secrets: `deer-flow/.env` (gitignored) — API keys

### Starting DeerFlow

```bash
cd deer-flow && make dev          # dev mode with hot-reload
cd deer-flow && make stop         # stop all services
```

DeerFlow auto-starts via the SessionStart hook on every remote Claude Code session. Check `/tmp/deerflow-dev.log` if it fails.

### Admin account

- URL: http://localhost:2026
- Email: `admin@gmail.com`
- Password: `DeerFlow123!`

Auth flow for API calls:
```bash
curl -sc /tmp/df_cookies.txt http://localhost:8001/api/v1/auth/login/local \
  -X POST -H "Content-Type: application/x-www-form-urlencoded" \
  -d 'username=admin@gmail.com&password=DeerFlow123!'
CSRF=$(cat /tmp/df_cookies.txt | grep csrf | awk '{print $7}')
```

### Configured LLM models

| Name | Provider | Status |
|------|----------|--------|
| `gemini-2.5-pro` | Google Gemini | ✅ Working |
| `claude-sonnet-4` | Anthropic | ❌ Key needs credits |
| `gpt-4o` | OpenAI | ❌ Key out of quota |

Update keys in `deer-flow/.env`:
```
ANTHROPIC_API_KEY=...
OPENAI_API_KEY=...
GEMINI_API_KEY=...
```

### DeerFlow bootstrap (first time or fresh clone)

```bash
cd deer-flow
make check        # verify nginx, node, pnpm, uv
make install      # install all deps
make config       # generate config.yaml (only if it doesn't exist)
make doctor       # verify config + API keys
make dev          # start
```

**nginx IPv6 fix** (required in this container — already applied):
`docker/nginx/nginx.local.conf` must have only `listen 2026;` (no `listen [::]:2026;`).

### Backend lint/test (run from `deer-flow/backend/`)

```bash
make lint         # ruff check
make test         # pytest (277 tests)
```

### Frontend lint/build (run from `deer-flow/frontend/`)

```bash
pnpm lint
pnpm typecheck
BETTER_AUTH_SECRET=local-dev-secret pnpm build
```

## Agent Skills

23 skills from `addyosmani/agent-skills` are installed and available in Antigravity, Antigravity CLI, Claude Code, Cline, Codex, and 12+ other agents:

- `.agents/skills/` — skill source files
- `.claude/skills/` — symlinks for Claude Code
- `.agents/Antigravity/` — symlinks for Antigravity

Skills include: `spec-driven-development`, `test-driven-development`, `planning-and-task-breakdown`, `code-review-and-quality`, `debugging-and-error-recovery`, `security-and-hardening`, `frontend-ui-engineering`, `performance-optimization`, `shipping-and-launch`, `idea-refine`, and more.

To add more skills:
```bash
npx skills add <github-url>
```

## Session Hook

`.claude/hooks/session-start.sh` runs on every session start and:
1. Installs nginx if missing
2. Starts DeerFlow in background (`make dev`)
3. Waits up to 60s for gateway health at `localhost:2026`

Hook is registered in `.claude/settings.json`.

## Key Files

```
.claude/
  hooks/session-start.sh   # auto-starts DeerFlow
  settings.json            # hook registration
  skills/                  # symlinks to agent skills
.agents/
  skills/                  # 23 skill SKILL.md files
  Antigravity/             # Antigravity-specific symlinks
deer-flow/                 # DeerFlow submodule (bytedance/deer-flow)
  config.yaml              # gitignored — LLM providers + tools
  .env                     # gitignored — API keys
  docker/nginx/nginx.local.conf  # IPv6 fix applied here
```
