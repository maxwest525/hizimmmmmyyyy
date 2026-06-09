---
name: agent-starter-pack
description: "Build production-ready AI agents on Google Cloud using the Agent Starter Pack. Use this skill when building agents with Google ADK, LangGraph, Vertex AI, or the A2A protocol. Use when scaffolding new agents, setting up RAG pipelines, building real-time audio/video agents, or deploying to Cloud Run or Agent Engine. Also use when the user mentions ADK, Agent Development Kit, Vertex AI agents, A2A protocol, agentic RAG, or agent-starter-pack."
---

# Google Cloud Agent Starter Pack

Production-ready agent templates for Google Cloud, supporting ADK, LangGraph, Vertex AI, and the A2A protocol.

## Source
https://github.com/GoogleCloudPlatform/agent-starter-pack

## Available Agent Templates

### 1. `adk` — Minimal ADK Agent
Basic agent using Google Agent Development Kit (ADK) with Gemini.
- Model: `gemini-2.5-flash`
- Tools: `get_weather`, `get_current_time`
- Best for: Learning ADK basics, simple tool-calling agents

```bash
agent-starter-pack create my-agent --agent adk
```

### 2. `adk_a2a` — ADK + Agent2Agent Protocol
ADK agent with A2A protocol support for distributed multi-agent communication.
- Interoperates with agents across frameworks and languages
- Includes A2A Protocol Inspector for validation: `make inspector`
- Supports Cloud Run and Agent Engine deployment

```bash
agent-starter-pack create my-agent --agent adk_a2a
```

### 3. `adk_live` — Real-Time Multimodal Agent
Live audio/video/text agent using Gemini's Live API.
- Python backend (ADK) + React frontend
- Supports audio, video, and text interactions
- Native tool calling in real-time

```bash
agent-starter-pack create my-agent --agent adk_live
```

### 4. `agentic_rag` — Production RAG Pipeline
RAG agent with Vertex AI Search or Vector Search, automated ingestion pipeline.
- Built on ADK
- Vertex AI Pipelines for data ingestion (scheduled, recurring, on-demand)
- Terraform deployment + CI/CD integration
- Choose datastore: Vertex AI Search or Vertex AI Vector Search

```bash
agent-starter-pack create my-agent --agent agentic_rag
```

### 5. `langgraph` — LangGraph ReAct Agent + A2A
LangGraph ReAct agent with A2A protocol for distributed agent communication.
- Streaming support via Vertex AI
- A2A Protocol Inspector: `make inspector`
- Works with Cloud Run and Agent Engine

```bash
agent-starter-pack create my-agent --agent langgraph
```

### 6. `adk_ts` — TypeScript ADK Agent
ADK agent implemented in TypeScript.

### 7. `adk_go` — Go ADK Agent
ADK agent implemented in Go.

### 8. `adk_java` — Java ADK Agent
ADK agent implemented in Java.

## Common Setup

```bash
# Install
pip install agent-starter-pack

# Create a new agent project
agent-starter-pack create my-agent --agent <template>

# Local development
cd my-agent
make run       # start locally
make test      # run tests
make deploy    # deploy to Cloud Run or Agent Engine

# Validate A2A implementation
make inspector
```

## Deployment Targets

| Target | Command | Notes |
|--------|---------|-------|
| Cloud Run | `make deploy` | Default, serverless |
| Agent Engine | `make deploy-agent-engine` | Managed runtime |

## Key Concepts

- **ADK (Agent Development Kit)**: Google's framework for building agents with Gemini, integrates with Vertex AI ecosystem
- **A2A Protocol**: Agent2Agent protocol for cross-framework agent communication and interoperability
- **Agent Engine**: Managed runtime for deploying agents on Vertex AI
