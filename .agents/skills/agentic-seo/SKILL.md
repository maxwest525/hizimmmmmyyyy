---
name: agentic-seo
description: "Audit websites and directories for Agentic Engine Optimization (AEO) using the agentic-seo CLI. Use this skill when the user wants to audit a site for AI agent discoverability, check AEO scores, scaffold llms.txt/AGENTS.md/skill.md files, or optimize a site for AI agents. Also use when the user mentions AEO, agentic SEO, llms.txt, AGENTS.md, or agent-readiness of a website."
---

# Agentic SEO Skill

Audit sites for **Agentic Engine Optimization (AEO)** — making websites discoverable and usable by AI agents.

## Installation

```bash
npm install -g agentic-seo
```

## Commands

### Audit a live URL
```bash
agentic-seo --url https://example.com
```

### Audit a local directory
```bash
agentic-seo ./my-site
```

### Scaffold missing AEO files (llms.txt, AGENTS.md, skill.md)
```bash
agentic-seo init
agentic-seo init ./my-site
```

### Quick score only (for CI)
```bash
agentic-seo score
agentic-seo score ./my-site
```

### Audit with JSON output
```bash
agentic-seo --json --url https://example.com
```

### Audit with verbose output
```bash
agentic-seo --verbose --url https://example.com
```

### CI mode (fail if score below threshold)
```bash
agentic-seo --json --threshold 60
```

## Key AEO Files

| File | Purpose |
|------|---------|
| `llms.txt` | Tells AI agents about your site's content and structure |
| `AGENTS.md` | Documents how agents should interact with your site |
| `skill.md` | Defines skills/capabilities your site exposes to agents |

## Workflow

1. Run `agentic-seo --url <site>` to get the current AEO score
2. Review findings and identify gaps
3. Run `agentic-seo init` to scaffold missing files
4. Edit the generated files with accurate content
5. Re-audit to verify score improvement
