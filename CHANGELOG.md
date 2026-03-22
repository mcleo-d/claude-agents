# Changelog

All notable changes to this project will be documented in this file.

The format follows [Keep a Changelog](https://keepachangelog.com/en/1.0.0/).

## [Unreleased]

### Changed

- `devops-engineer` — added Bash capability; added Edge Deployment Procedures section with `docker-preflight` and `compose-healthcheck` patterns for bare-metal Docker Compose deployments
- `linux-systems-engineer` — added Bash capability; added Operational Verification Procedures section with `harden-verify` and `sysctl-drift` patterns for hardened Linux hosts
- `python-developer` — added Bash capability; added Proxy Verification Procedures section with `proxy-preflight` and `proxy-healthcheck` patterns for stdlib-only Ollama proxy deployments
- `security-engineer` — added Bash capability; added Bare-Metal and Edge Security Posture Review section with `posture-review` (8-layer) and `credential-audit` patterns
- `sre-engineer` — added Bash capability for operational checks and diagnostics

## [1.1.0] - 2026-03-12

### Added
- CI workflow (`.github/workflows/ci.yml`) — secret scanning and markdown linting on every push and PR, GitHub Actions pinned to full SHA
- Pre-commit hooks (`.pre-commit-config.yaml`) — detect-secrets and markdownlint run locally on every commit, mirroring CI
- Dependabot (`.github/dependabot.yml`) — weekly automated updates for GitHub Actions versions
- `.markdownlint.json` — lint rules configured to match the agent file conventions
- `.secrets.baseline` — detect-secrets baseline for the repository
- Pre-commit setup instructions in `CONTRIBUTING.md`
- CI status badge in `README.md`

### Fixed
- `CODEOWNERS` — corrected GitHub username to `@mcleo-d`
- `README.md` — corrected clone URL and GitHub username references
- `.github/ISSUE_TEMPLATE/new-agent.md` — corrected assignee to `mcleo-d`
- `.github/ISSUE_TEMPLATE/agent-improvement.md` — corrected assignee to `mcleo-d`

### Changed
- `code-reviewer` — added AI/ML configuration review checklist and formal interaction model
- `deploy-checklist` — added missing interaction model section
- `ui-designer`, `qa-engineer` — added `fullstack-developer` as a coordination partner
- `sre-engineer` — added back-references to `scrum-master` and `frontend-developer`
- `scrum-master` — added `code-reviewer` coordination; adapted environmental and TDD principles
- `systematic-debugger` — added security escalation path and explicit handoff partner list
- `devops-engineer`, `platform-engineer` — clarified ArgoCD and OpenTofu ownership boundary

## [1.0.0] - 2026-03-12

### Added
- Initial release of 18 Claude Code subagent definitions covering the full software delivery lifecycle
- `ai-ml-engineer` — local and edge LLM deployment, Ollama benchmarking, model selection
- `backend-developer` — Node.js/TypeScript, Go, CouchDB, REST and GraphQL APIs
- `business-analyst` — requirements, user stories, BDD Gherkin, journey mapping
- `code-reviewer` — multi-language PR review with structured severity framework
- `deploy-checklist` — pre-deployment go/no-go validation for cloud and edge targets
- `devops-engineer` — GitHub Actions, AWS ECS/ECR, OpenTofu, Docker, ArgoCD
- `frontend-developer` — React/Next.js, TypeScript, accessibility, Core Web Vitals
- `fullstack-developer` — vertical-slice feature delivery across database, API, and UI
- `linux-systems-engineer` — hardened bare-metal ARM64/edge Linux configuration
- `platform-engineer` — Backstage, golden path templates, ArgoCD, Kong, Linkerd
- `python-developer` — Python 3.9+, stdlib HTTP services, systemd logging, TDD
- `qa-engineer` — test pyramid, Playwright E2E, k6 load tests, Pact contracts
- `scrum-master` — sprint ceremonies, Definition of Done, retrospectives, DORA metrics
- `security-engineer` — threat modelling, OWASP, STRIDE, IAM, DevSecOps pipeline
- `sre-engineer` — SLOs, error budgets, Prometheus, Grafana, on-call runbooks
- `systematic-debugger` — hypothesis-driven fault diagnosis across the full stack
- `systems-architect` — ADRs, C4 diagrams, technology selection, cross-cutting concerns
- `ui-designer` — design tokens, Tailwind config, component specs, accessibility standards
