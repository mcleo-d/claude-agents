# Contributing to claude-agents

Thank you for contributing. This collection is only as good as the diversity of experience and perspective that goes into it.

## Development setup

The repository uses pre-commit hooks to mirror the CI checks locally, so issues are caught before they reach the pipeline.

**Prerequisites:** Python 3.x, Node.js (LTS)

```bash
# Install pre-commit
pip install pre-commit

# Install the hooks into your local clone
pre-commit install

# Run against all files manually (optional)
pre-commit run --all-files
```

The hooks run automatically on every `git commit` and check for:
- **Secret scanning** (`detect-secrets`) — prevents accidental credential commits
- **Markdown lint** (`markdownlint`) — enforces consistent document structure

CI runs the same checks on every push and pull request.

## What makes a good agent

Each agent in this collection represents a senior practitioner in their domain. Before contributing, read two or three existing agents to absorb the structural conventions and quality bar. The short version:

- **T-shaped.** Deep domain expertise (the vertical bar) plus genuine awareness of adjacent roles and concerns (the horizontal bar). A backend developer who knows nothing about accessibility or security is not a senior engineer.
- **Collaborative.** Every agent has an `## Interaction model` section that declares which other agents it coordinates with, what it hands off to them, and what it receives. Collaboration is explicit, not assumed.
- **Principled.** Every agent adapts the five core principles to its domain (see below). Adaptation means the principle is genuinely expressed through the agent's specific concerns — not copied and pasted.
- **Read-only where appropriate.** Agents that produce verdicts or checklists (code-reviewer, deploy-checklist, systematic-debugger) do not modify files. Their `tools:` frontmatter reflects this.

## The five core principles

All agents express these five principles, adapted to their domain:

1. **Customer orientation** — who is this agent's customer, and how does its work serve them?
2. **Accessibility first** — how does this role ensure accessibility is not an afterthought?
3. **Ethical engineering and diversity of thought** — what ethical concerns are specific to this domain?
4. **Environmental and cost responsibility** — what are the cost and environmental consequences of decisions in this domain?
5. **Test-driven development / evidence-based practice** — how does this role enforce quality and evidence?

Some roles adapt principle 5 to their domain (e.g., `linux-systems-engineer` uses "Hardening is code — verify it"; `ai-ml-engineer` uses "Evidence-based decisions"). The adaptation must preserve the intent: work is verified, not assumed correct.

## Agent structure

Every agent file follows this structure:

```markdown
---
name: <kebab-case-name>
description: "<trigger description — written from the perspective of when to invoke this agent>"
tools: <comma-separated list from: Read, Glob, Grep, Write, Edit>
model: claude-sonnet-4-6 | claude-opus-4-6
---

<Opening persona paragraph — one paragraph establishing identity, domain, and read-only/read-write stance>

## Core principles

<Five adapted principles>

## <Domain-specific sections>

<Standards, patterns, accountability model, checklists — as appropriate for the role>

## Interaction model

<Bulleted list of coordination relationships with other agents>
```

### Frontmatter guidance

- `name` — kebab-case, matches the filename without `.md`
- `description` — written as a trigger condition: "Use when..." Describes the situations that should invoke this agent, not what the agent is. Be specific enough that Claude Code can distinguish it from overlapping agents.
- `tools` — use the minimum set needed. Read-only agents (reviewers, checkers) use `Read, Glob, Grep` only. Producing agents add `Write` and/or `Edit`.
- `model` — use `claude-opus-4-6` for agents that make high-stakes, nuanced judgments (security, architecture, complex debugging, code review). Use `claude-sonnet-4-6` for all others.

### Security authority model

The `security-engineer` agent is the authority on security design decisions across the entire collection. If your agent touches security concerns:
- Declare explicit deference: "escalate to `security-engineer`" or "requires `security-engineer` review"
- Do not design security controls unilaterally within another agent
- If your agent may discover security issues during its work (e.g., a debugger finding a vulnerability), include an explicit security escalation instruction

## Proposing a new agent

Before writing a new agent, open an issue using the **New agent** template. This gives the community a chance to discuss whether the role is genuinely distinct from existing agents and what its boundaries should be.

A new agent is justified when:
- It represents a distinct practitioner role with a non-trivial body of domain knowledge
- It has clear coordination boundaries with at least two existing agents
- It cannot be achieved by extending an existing agent's interaction model

## Improving an existing agent

Use the **Agent improvement** issue template. When submitting a PR:
- Read the existing agent in full before making changes
- Preserve the structural conventions — do not reorder sections or remove the interaction model
- If you are changing the interaction model, consider whether the corresponding agents need back-references updated
- Do not weaken security deference or the accessibility-first stance
- If you are adapting an agent for a specific technology stack, consider whether the change generalises or whether it should live in a fork

## Pull request checklist

- [ ] Agent follows the standard structure (frontmatter, opening paragraph, five principles, domain sections, interaction model)
- [ ] `description` is written as a "Use when..." trigger condition
- [ ] `tools` is the minimum set required
- [ ] All five core principles are present and genuinely adapted to the domain
- [ ] `## Interaction model` is present and lists at least two coordination relationships
- [ ] Security deference is explicit if the agent touches security concerns
- [ ] No project-specific references (internal tool names, URLs, file paths, port numbers, model names tied to a specific deployment)
- [ ] No `<your-value>` placeholders left unfilled in non-template content
- [ ] CHANGELOG.md updated under `[Unreleased]`

## Licence

By contributing, you agree that your contributions will be licensed under the Apache License 2.0 that covers this project.
