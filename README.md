# claud-agents

A collection of 18 Claude Code subagent definitions that form a complete virtual engineering team. Drop them into your `~/.claude/agents/` directory and Claude Code gains a bench of senior practitioners — each with deep domain expertise, clear accountability to the others, and a shared set of engineering principles.

## What this is

Claude Code supports [subagents](https://docs.anthropic.com/en/docs/claude-code/sub-agents): specialised AI personas defined in Markdown files that Claude can invoke automatically or on request. Each agent in this collection represents a senior role in a software delivery team — from business analyst through to SRE — and is designed to work alongside the others, not in isolation.

The collection covers the full delivery lifecycle:

| Agent | Role | Invocation trigger |
|---|---|---|
| `business-analyst` | Requirements, user stories, BDD Gherkin, journey mapping | Capturing or refining requirements; writing acceptance criteria |
| `systems-architect` | ADRs, C4 diagrams, technology selection, cross-cutting concerns | Significant design decisions; new services; API contracts |
| `backend-developer` | Node.js/TypeScript, Go, CouchDB, REST and GraphQL APIs | Server-side services, background workers, data models |
| `frontend-developer` | React/Next.js, TypeScript, accessibility, Core Web Vitals | UI components, pages, client-side state, browser TypeScript |
| `fullstack-developer` | Vertical-slice feature delivery across database, API, and UI | Self-contained features spanning all layers |
| `python-developer` | Python 3.9+, stdlib services, systemd logging, TDD | Python code — services, CLI tools, HTTP servers, automation |
| `ai-ml-engineer` | Local/edge LLM deployment, Ollama, model selection and benchmarking | Selecting, tuning, or benchmarking LLMs on constrained hardware |
| `ui-designer` | Design tokens, Tailwind config, component specs, accessibility standards | Design system, colour palette, typography, component specifications |
| `qa-engineer` | Test pyramid, Playwright E2E, k6 load tests, Pact contracts | Test strategy, test suites, coverage standards |
| `security-engineer` | Threat modelling, OWASP, STRIDE, IAM, DevSecOps pipeline | Security reviews, secrets management, IAM policies |
| `devops-engineer` | GitHub Actions, AWS ECS/ECR, OpenTofu, Docker, ArgoCD | CI/CD pipelines, infrastructure, deployment strategies |
| `platform-engineer` | Backstage, golden path templates, ArgoCD, Kong, Linkerd | Internal developer platform, self-service workflows |
| `sre-engineer` | SLOs, error budgets, Prometheus, Grafana, on-call runbooks | Reliability targets, alerting, post-incident reviews |
| `linux-systems-engineer` | Hardened bare-metal and edge Linux configuration | systemd, SSH hardening, UFW, fail2ban, ARM64 deployments |
| `code-reviewer` | Multi-language PR review with structured severity framework | Reviewing any pull request or code change |
| `systematic-debugger` | Hypothesis-driven fault diagnosis across the full stack | Bugs, production incidents, test failures |
| `deploy-checklist` | Pre-deployment go/no-go validation for cloud and edge targets | Immediately before promoting a build to staging or production |
| `scrum-master` | Sprint ceremonies, Definition of Done, retrospectives, DORA metrics | Sprint facilitation, process health, team impediments |

## Installation

```bash
# Clone the repository
git clone https://github.com/jamesmcleod/claud-agents.git

# Copy all agents to your Claude Code agents directory
cp claud-agents/agents/*.md ~/.claude/agents/
```

After copying, Claude Code will make the agents available immediately — no restart required. You can verify by running `/agents` in a Claude Code session.

### Install a subset

If you only want specific agents, copy individual files:

```bash
cp claud-agents/agents/code-reviewer.md ~/.claude/agents/
cp claud-agents/agents/security-engineer.md ~/.claude/agents/
```

### Keep up to date

```bash
cd claud-agents && git pull && cp agents/*.md ~/.claude/agents/
```

## Design philosophy

### T-shaped agents

Each agent is designed with a T-shape: deep expertise in its domain (the vertical bar) and genuine awareness of adjacent concerns (the horizontal bar). A backend developer who knows nothing about accessibility or the security engineer's authority model is not a senior engineer.

### Collaborative by design

Agents are not standalone — they coordinate. Every agent declares an explicit `## Interaction model` that names which other agents it hands work to and receives work from. The relationships are bidirectional: if `qa-engineer` references `backend-developer`, `backend-developer` references `qa-engineer` back.

### Security authority model

The `security-engineer` is the explicit authority on security design decisions across the entire team. Every agent that touches security concerns declares deference: it may identify and escalate, but it does not design security controls unilaterally. This prevents security fragmentation without creating a bottleneck.

### Five shared principles

All agents share five core principles, each adapted to the specific concerns of their domain:

1. **Customer orientation** — every decision traces back to user impact
2. **Accessibility first** — accessibility is a first-class quality gate, not an afterthought
3. **Ethical engineering and diversity of thought** — challenge monoculture assumptions; surface bias
4. **Environmental and cost responsibility** — right-size compute, data, and infrastructure choices
5. **Test-driven development** — evidence and verification over assumption

### Model tiers

Agents that make high-stakes, nuanced judgements run on `claude-opus-4-6`:

- `code-reviewer` — final quality gate before merge
- `security-engineer` — security design authority
- `systems-architect` — architectural decision authority
- `systematic-debugger` — complex, multi-hypothesis fault diagnosis

All other agents run on `claude-sonnet-4-6`.

## Customising for your stack

The agents are intentionally stack-agnostic within their domain. You will likely want to adapt:

- **Technology choices** — swap CouchDB for PostgreSQL in `backend-developer`, or replace AWS with GCP in `devops-engineer`
- **Tool names** — update specific tooling references (e.g., Playwright → Cypress in `qa-engineer`)
- **Interaction model** — add or remove agent relationships to match your actual team structure
- **Coverage gates** — adjust percentage thresholds in `qa-engineer` to match your project's standards

When adapting, preserve the five core principles, the interaction model section, and the security deference model. These are the structural elements that make the agents work as a team.

## Contributing

Contributions are welcome. See [CONTRIBUTING.md](CONTRIBUTING.md) for the agent structure requirements, quality bar, and PR checklist.

Use the issue templates to propose a new agent or suggest improvements to an existing one.

## Licence

Copyright 2026 James McLeod

Licensed under the Apache License, Version 2.0. See [LICENSE](LICENSE) for the full text.
