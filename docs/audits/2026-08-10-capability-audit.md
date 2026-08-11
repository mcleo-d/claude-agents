# Capability audit: agent definitions for the Fable 5 / Sonnet 5 era

Story: ST-401. Parent goal: GL-61 (agent inheritance and governed self-healing).

## Purpose

This audit grades every agent definition in the canonical `mcleo-d/claude-agents`
repository against current-model reality, then dispositions the six open
"ghost" board Stories that predate this audit. It is read-only: no agent
files were modified. The output is a modernisation queue for the governed
loop chartered under GL-61, not a set of applied changes.

## Enumeration

Command run against a fresh clone of `main`:

```text
find agents -maxdepth 1 -type f -name '*.md' | sort | wc -l
```

Result: **22** agent definitions. The count is not assumed from prior
Stories: several of those (ST-55) reference "18", which is stale, since the
tree has grown since.

A second check confirms there is no separate skills directory to enumerate:

```text
find . -type d -not -path './.git*'
```

Result: only `./agents` exists. There are no standalone skill definitions
in this repository at present; every capability is expressed as a full
agent persona under `agents/`.

## Methodology

Each definition was read in full and graded **keep**, **modernise**, or
**retire** against current-model (Sonnet 5 era) reality: whether its
choreography reflects genuine multi-agent need or work a single capable
session now absorbs; whether its instructions compensate for weaknesses
today's models no longer have; whether its `model:` pin is current; and
whether it is missing a capability worth adding.

One cross-cutting finding applies to nearly the whole roster and is
reported once here rather than repeated in every row: **21 of the 22
definitions pin `model: claude-sonnet-4-6` or `model: claude-opus-4-6`.**
Only `london-js-content-creator` uses `model: inherit`. Those pins are
stale: this audit is itself produced by a Sonnet 5 session, confirming
the repository's model line has moved on since the pins were written.
This is logged as a single backlog item (see Modernisation backlog,
item 1) rather than repeated as the "evidence" line for 21 separate rows,
so that the per-row evidence below can surface the more differentiating
findings.

## Graded definitions

| # | Agent (path) | Grade | Evidence |
|---|---|---|---|
| 1 | `agents/ai-ml-engineer.md` | Modernise | Mandates escalation to `security-engineer` for "all" injection-detection design decisions with no risk-based threshold: instruction weight consistent with compensating for judgement a current Sonnet 5 session already carries; worth narrowing to a risk-based trigger. |
| 2 | `agents/backend-developer.md` | Keep | Stack (Node 22 LTS, TS5 strict, Go 1.23, Fastify5, CouchDB) and TDD/security standards remain accurate to current practice; no redundant choreography. |
| 3 | `agents/business-analyst.md` | Keep | BDD/Gherkin, INVEST, and accessibility-by-default requirements are still the correct upstream anchor; content is model-agnostic and sound. |
| 4 | `agents/code-reviewer.md` | Keep | Structured Critical/Major/Minor verdict format is a genuine artifact (PR gate), not just relay overhead a single session absorbs; Opus-tier reasoning is a deliberate, still-justified choice for judgement calls. |
| 5 | `agents/content-creator.md` | Modernise | Core Principles/Boundaries/Interaction Model sections are near-identical in structure and wording to `technical-writer.md` and `release-notes-writer.md`, evidence of templated duplication across the "writing" family worth consolidating or re-scoping. |
| 6 | `agents/deploy-checklist.md` | Keep | Read-only go/no-go artifact with cloud and edge/bare-metal checklists remains a genuine distinct gate; DORA/Well-Architected grounding still current. |
| 7 | `agents/devops-engineer.md` | Keep | GitHub Actions/OpenTofu/ECS/Trivy/Syft toolchain and the Edge Deployment Procedures (`docker-preflight`, `compose-healthcheck`) are current and concretely useful. |
| 8 | `agents/frontend-developer.md` | Keep | React 19 / Next.js 15 App Router / WCAG 2.2 AA / Core Web Vitals thresholds are current and specific; no stale framework references found. |
| 9 | `agents/fullstack-developer.md` | Keep | Description explicitly exists to avoid "unnecessary coordination overhead" from splitting work across `backend-developer`/`frontend-developer`, already a model-reality-aware design that other multi-agent chains in this roster should follow. |
| 10 | `agents/linux-systems-engineer.md` | Keep | Bash-executing hardening agent for ARM64/Raspberry Pi OS with concrete `harden-verify`/`sysctl-drift` operational procedures; content is specific and current, not generic filler. |
| 11 | `agents/londonjs-content-creator.md` | Modernise | Only definition scoped to a single external community (London.js) rather than a generic engineering capability, a scope mismatch against the other 21 reusable role definitions; candidate to relocate out of the canonical capability library rather than remain alongside it. Note: `model: inherit` here is already current practice, unlike the rest of the roster. |
| 12 | `agents/platform-engineer.md` | Keep | Backstage/ArgoCD/Kong/Linkerd IDP toolchain and golden-path templates are current and well-bounded against `devops-engineer`. |
| 13 | `agents/python-developer.md` | Keep | stdlib-first, systemd-integrated, fail-open/fail-closed guidance is specific to the project's edge focus and remains accurate. |
| 14 | `agents/qa-engineer.md` | Keep | Test-pyramid, coverage gates, and Playwright/k6/Pact toolchain are thorough and current. |
| 15 | `agents/release-notes-writer.md` | Modernise | Same duplication finding as `content-creator.md`/`technical-writer.md`, near-identical Core Principles/Boundaries structure; candidate for family consolidation review. |
| 16 | `agents/scrum-master.md` | Keep | Scrum Guide/Kanban/DORA-as-health-indicator process content is durable and model-agnostic. |
| 17 | `agents/security-engineer.md` | Keep | Opus-tier reasoning remains appropriate for threat modelling and IAM design; Semgrep/Trivy/ZAP/detect-secrets toolchain is current; bare-metal Posture Review/Credential Audit procedures are concrete. |
| 18 | `agents/sre-engineer.md` | Keep | SLO/error-budget/golden-signal framework is durable; Bash-executing diagnostics access is an appropriate, already-current capability. |
| 19 | `agents/systematic-debugger.md` | Keep | Opus-tier hypothesis-driven methodology with stack-specific guides (Node/Go/CouchDB/AWS/Python) remains accurate and read-only-appropriate. |
| 20 | `agents/systems-architect.md` | Keep | ADR/C4/ISO 25010 process is sound; Opus-tier reasoning is a deliberate and still-justified choice for architecture-level judgement. |
| 21 | `agents/technical-writer.md` | Modernise | Same duplication finding as `content-creator.md`/`release-notes-writer.md`, near-identical Core Principles/Boundaries structure across the family. |
| 22 | `agents/ui-designer.md` | Keep | WCAG 2.2 / DTCG token format / Tailwind-config-generation scope is current and specific; no stale tooling references found. |

Tally: 16 keep, 6 modernise, 0 retire.

## Ghost Story dispositions

Six board Stories predate this audit and are dispositioned here as required
by GL-61 governance. None were independently re-opened or edited; each
disposition below is a proposal for the orchestrator to action.

| Ghost | Summary | Disposition | Reason |
|---|---|---|---|
| ST-53 | 2 stale agents | Absorbed by this audit | ST-401 supersedes the narrow "2 stale agents" framing with a full 22-definition grading pass, which finds the stale-reference problem is a repository-wide `model:` pin issue (21 of 22 files), not isolated to two agents. |
| ST-54 | First agent-retro | Absorbed by this audit | This audit is functionally the first agent-retro required by GL-61: every definition graded keep/modernise/retire with dated evidence, per the Definition of Done. |
| ST-55 | Audit all 18 | Absorbed by this audit | The "18" figure is itself stale; enumeration here confirms 22 definitions exist on `main`. ST-401 supersedes ST-55 with a verified count and full grading. |
| ST-56 | factory.ai reverse sync | Superseded by ST-402 (distribution) | Syncing definitions between this canonical repo and factory.ai is a distribution/propagation mechanism, out of scope for a read-only-plus-report audit. It belongs in the successor Story chartered to govern how canonical outputs reach and return from external tools. |
| ST-57 | Single source of truth | Superseded by ST-403 (governed loop) | Enforcing SSOT is an ongoing governance mechanism (ownership, drift detection, review cadence), not a one-off audit output. ST-403 is the named successor chartered for the governed loop this requires. |
| ST-65 | technical-writer agent | Absorbed by this audit | `agents/technical-writer.md` already exists on `main` (merged via PR #22, 2026-05-25 per repository history): the ghost's proposal is fulfilled. This audit additionally flags it (row 21 above) for the content-family duplication modernisation candidate. |

## Modernisation backlog (proposals only, no changes made)

Priority order; each item is a candidate for a future governed-loop Story,
not an instruction to act now.

1. **High: normalise stale `model:` pins.** 21 of 22 agents pin
   `claude-sonnet-4-6` or `claude-opus-4-6`. Align to the current model
   line, or move to `model: inherit` (as `london-js-content-creator`
   already does) where a specific tier is not a deliberate design choice.
   Keep explicit Opus pins only where higher-reasoning is a deliberate
   choice (`code-reviewer`, `security-engineer`, `systematic-debugger`,
   `systems-architect`).
2. **Medium: consolidate the content-writing family.** `content-creator`,
   `technical-writer`, and `release-notes-writer` share near-identical
   Core Principles, Boundaries, and Interaction Model sections. Evaluate
   whether a single parameterised agent, or Skills, better fit a single
   capable session than three near-duplicate personas.
3. **Medium: relocate `londonjs-content-creator.md`.** It is the only
   community/client-specific definition among 22 generic engineering-role
   agents. Consider moving it to a project-specific repository rather than
   the shared capability library.
4. **Medium: narrow `ai-ml-engineer`'s escalation protocol.** Replace the
   blanket "all design decisions" gate to `security-engineer` with a
   risk-based trigger appropriate to current model judgement.
5. **Low: review read-only relay agents for necessity vs artifact value.**
   `code-reviewer`, `systematic-debugger`, and `deploy-checklist` route
   work that a single Sonnet 5 session can reason through inline; retain
   them only where their structured output artifact (review verdict,
   root-cause report, go/no-go checklist) is itself the deliverable a
   downstream gate depends on.
6. **Low: evaluate Skills as an alternative to full agent personas.**
   No `skills/` directory exists in this repository. Narrow, composable
   capabilities, such as the content-writing family (item 2), or the
   embedded "Procedures" blocks inside `linux-systems-engineer.md`,
   `devops-engineer.md`, and `security-engineer.md`, may be better
   modelled as Skills than as full personas, mirroring the Agent/Skill
   split already available in current tooling.

## Scope note

This Story is read-only-plus-report: no agent definitions were edited.
All six backlog items and the ghost-Story dispositions above are proposals
for the governed loop under GL-61 to accept, refine, or reject; this
audit does not self-approve any of them.
