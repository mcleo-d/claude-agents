---
name: New agent proposal
about: Propose a new agent role for the collection
title: "New agent: <role-name>"
labels: new-agent
assignees: mcleo-d
---

## Role name

<!-- The proposed agent name in kebab-case, e.g. data-engineer -->

## What problem does this agent solve?

<!-- What work would this agent do that is not currently covered by the existing 18 agents? -->

## Why is this a distinct role?

<!-- Why can't this be achieved by extending an existing agent's interaction model or standards section? -->

## Domain expertise (vertical bar)

<!-- What deep, specialist knowledge would this agent have? List 5-8 specific things it knows that a generalist would not. -->

## Adjacent awareness (horizontal bar)

<!-- What cross-cutting concerns from other domains would this agent need to be aware of? -->

## Proposed interaction model

<!-- Which existing agents would this agent coordinate with, and in what direction? -->

- Receives from:
- Hands off to:
- Escalates to:

## Security considerations

<!-- Does this agent touch security concerns? If so, how would it defer to `security-engineer`? -->

## Draft description (frontmatter)

<!-- A one or two sentence "Use when..." trigger description for the agent's frontmatter -->

```
Use when ...
```

## Proposed tools

<!-- Minimum set required. Read-only agents (producing verdicts or reports) use Read, Glob, Grep only. -->

- [ ] Read
- [ ] Glob
- [ ] Grep
- [ ] Write
- [ ] Edit

## Proposed model tier

- [ ] `claude-sonnet-4-6` (standard)
- [ ] `claude-opus-4-6` (high-stakes judgements — security, architecture, complex diagnosis, code review)
