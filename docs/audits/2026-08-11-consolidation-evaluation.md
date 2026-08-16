# Consolidation and Skills evaluation report: audit items 2, 3, 5, 6

Story: ST-411. Parent goal: GL-61 (agent inheritance and governed self-healing).
Source: `docs/audits/2026-08-10-capability-audit.md` (Story ST-401), backlog
items 2, 3, 5 and 6.

## Purpose

This report gives the pen decision-ready recommendations on the four
judgement items the capability audit deferred rather than decided: content-family
consolidation, `londonjs-content-creator` relocation, relay-agent necessity
versus artifact value, and Skills-versus-persona modelling. It is
read-only-plus-report: no agent definitions were changed to produce it, and
it approves nothing by itself. Every quantified claim below is exercised
(command shown with its output) rather than asserted.

## Item 2: content-family consolidation

### The claim being tested

The audit's rows 5, 15 and 21 assert that `content-creator.md`,
`release-notes-writer.md` and `technical-writer.md` have "near-identical"
Core Principles, Boundaries and Interaction Model sections. This section
replaces that assertion with measured evidence.

### Heading-level comparison

```text
$ for f in content-creator technical-writer release-notes-writer; do
    echo "--- $f ---"; grep -n '^##' agents/$f.md
  done
--- content-creator ---
10:## Core principles
18:## Content types
25:## Voice and structure
32:## Quality checklist
39:## Working method
47:## Boundaries
53:## Interaction model
--- technical-writer ---
10:## Core principles
18:## Document types
25:## Writing standards
32:## Quality checklist
39:## Working method
47:## Boundaries
53:## Interaction model
--- release-notes-writer ---
10:## Core principles
18:## Note structure
25:## Writing standards
32:## Quality checklist
39:## Working method
47:## Boundaries
53:## Interaction model
```

Five of seven headings (`Core principles`, `Quality checklist`,
`Working method`, `Boundaries`, `Interaction model`) are verbatim identical,
at identical line numbers, across all three files. The remaining two
headings differ only in the label attached to the same structural slot
("what kinds of thing you write" and "how you write it"); `technical-writer`
and `release-notes-writer` even share the label `Writing standards` for the
second slot.

### Line-count and similarity measurement

```text
$ wc -l agents/content-creator.md agents/technical-writer.md agents/release-notes-writer.md
  57 agents/content-creator.md
  57 agents/technical-writer.md
  57 agents/release-notes-writer.md
```

All three files are exactly 57 lines. A raw `diff` count is order-sensitive
and understates the overlap where matching blocks are separated by changed
ones, so similarity was measured with Python's `difflib.SequenceMatcher`
(longest-matching-block ratio), which is the standard non-asserted way to
quantify near-duplication:

```text
$ python3 -c "
import difflib, itertools
files = ['content-creator','technical-writer','release-notes-writer']
for a, b in itertools.combinations(files, 2):
    la = open(f'agents/{a}.md').readlines()
    lb = open(f'agents/{b}.md').readlines()
    sm = difflib.SequenceMatcher(None, la, lb)
    print(f'{a} vs {b}: ratio={sm.ratio():.3f} matching_lines={sum(t.size for t in sm.get_matching_blocks())}/{len(la)}')
"
content-creator vs technical-writer: ratio=0.421 matching_lines=24/57
content-creator vs release-notes-writer: ratio=0.421 matching_lines=24/57
technical-writer vs release-notes-writer: ratio=0.439 matching_lines=25/57
```

24-25 of 57 lines (42-44%) are identical in place between every pair, and
those lines are concentrated in the five shared headings above: the YAML
frontmatter keys, the persona sentence shape, and the full text of every
bullet under `Quality checklist`, `Working method`, `Boundaries` and
`Interaction model` follow the same five-bullet-per-section template with
only the noun swapped (compare, for example, `Boundaries`' third bullet in
all three: "Escalate... to the security engineer" / "Hand security-sensitive
wording to the security engineer" / "Refer any security-relevant change to
the security engineer" — same rule, three phrasings). The audit's
"near-identical" characterisation is accurate for roughly half of each file
by line count, and for the *entire* structural skeleton (5 of 7 headings)
by section.

### Options considered

**Status quo (keep three files).** Preserves each file's independent
`description:` frontmatter, which is the mechanism Claude Code uses to
auto-select the right subagent from context. No migration cost. Leaves the
measured duplication above unresolved: a change to the shared
`Boundaries`/`Quality checklist` template (for example, a wording fix to
the security-escalation bullet) has to be applied three times or drifts.

**Single parameterised agent.** Merge the three files into one
`content-writer.md`, keeping the five shared headings once and folding the
two differing headings into three named "Mode" subsections. This was
exercised as a real draft (not committed; scoped strictly to this report's
evidence-gathering, consistent with the two-file declaration below) to get
a measured result rather than an estimate:

```text
$ wc -l /tmp/merge-sketch/content-writer.md
55 /tmp/merge-sketch/content-writer.md
```

55 lines: within `CONTRIBUTING.md`'s own stated target ("Target 50-90 lines
for most agents") and comfortably under its 120-line trim-review threshold,
because the shared skeleton is written once instead of three times. The
real cost is routing, not line count: today three distinct `description:`
strings let Claude Code auto-invoke the right persona from context alone.
A single file needs either the caller to state which of the three modes is
wanted (workable, since content requests are usually unambiguous — "write
release notes for..." vs "write a blog post about...") or the merged
persona to infer mode from the request itself, which is a judgement call
moved from static frontmatter matching into every invocation.

**Skills.** Extract the five shared headings into a Skill and keep three
thin agent stubs (frontmatter plus the two domain-specific sections) that
reference it. This is the cleanest separation of "how to write well" from
"what to write", but this repository has zero prior Skills usage:

```text
$ find . -type d -not -path './.git*'
./agents
```

There is no `skills/` directory, no existing convention for how an agent
file would reference a Skill, and no CI/lint coverage for that shape. Item
6 below finds better-fitting Skill candidates elsewhere in the roster
(named, parameterised operational procedures); applying Skills here first,
with no precedent and no procedural boundary as clean as those, would be
speculative rather than evidence-based.

### Recommendation

**Preferred: single parameterised agent.** The exercised merge lands at 55
lines, under the repository's own conciseness target, and collapses the
measured 42-44% line-level duplication (and the five verbatim-identical
section headings) into one maintained copy. **Trade-off:** it trades away
independent auto-invocation triggers for the three writing tasks; the
merged `description:` must ask the caller to disambiguate mode, and mode
inference becomes a judgement call inside the single session rather than a
frontmatter match. Status quo is the fallback if that routing cost proves
material in practice; Skills is not recommended for this item specifically
because of the precedent gap noted above.

### Migration sketch (for the preferred option, not applied by this Story)

1. Create `agents/content-writer.md` with the shared frontmatter, persona
   sentence, and the five identical headings written once.
2. Fold `Content types`/`Document types`/`Note structure` into three `##
   Mode:` subsections, one per file's domain-specific bullets, unchanged in
   wording.
3. Fold `Voice and structure`/`Writing standards`/`Writing standards`
   likewise.
4. Update `description:` to name all three modes and instruct the caller
   (or the routing session) to state which is wanted.
5. Delete `content-creator.md`, `technical-writer.md`,
   `release-notes-writer.md`; update `README.md`'s agent table (three rows
   to one) and any `Interaction model` cross-references to the old names in
   other agents.
6. Update `CHANGELOG.md` under `### Changed`.

This is a sketch for a future governed-loop Story to execute and for
`code-reviewer` to gate, per this Story's read-only-plus-report scope.

## Item 3: `londonjs-content-creator` relocation

### Candidate destinations visible from the repo and its history

```text
$ git log --follow --oneline -- agents/londonjs-content-creator.md
4dddbd8 [agents] Promote host-only agents to upstream (ST-281, GL-41): londonjs-content-creator
```

The commit message itself, "Promote **host-only** agents to **upstream**",
records that this definition originated somewhere other than this
canonical repository and was deliberately promoted into it. The file's own
frontmatter confirms the scope mismatch the audit flagged:

```text
$ sed -n '1,10p' agents/londonjs-content-creator.md
---
name: london-js-content-creator
description: >
  Community content creator for London.js. Use when creating or editing event
  listings for Meetup.com, slide decks, website copy, speaker bios, or any
  community-facing content for London.js events. Proactively invoked for all
  London.js written content tasks. Enforces inclusive, DE&I-aligned language
  and reflects the London.js Code of Conduct in every output.
```

No other file in `agents/` names an external community or client; every
other of the 21 remaining definitions is a generic engineering role.
`README.md` and `CONTRIBUTING.md` contain no reference to "London" at all
(checked via `grep -n -i london README.md CONTRIBUTING.md`, no output),
confirming the audit's finding that this file has no documented place in
this repository's own stated scope.

The only visible candidate destination is the repository that actually
consumes this persona. `mcleo-d/london-js-slides` (present alongside this
repo on this host) is the London.js meetup's own slide-deck repository, and
its `AGENTS.md` already binds all London.js content production to this
exact subagent, by name, today:

```text
$ grep -n -A1 "londonjs-content-creator" /workspace/london-js-slides/AGENTS.md
All London.js community content produced for or about this repository MUST be authored
by the `londonjs-content-creator` subagent, defined at `~/.claude/agents/londonjs-content-creator.md`
on the host running Claude Code.
```

That rule already treats the definition as belonging to
`london-js-slides`, sourced only by the convention that it happens to sit
on the operator's `~/.claude/agents/` filesystem path. No other repository
visible on this host references it. `london-js-slides` has no existing
`agents/` or `.claude/` directory of its own:

```text
$ find /workspace/london-js-slides -iname "*.claude*" -o -iname "agents"
(no output)
```

so relocating the file there would be a new addition to that repo, not a
conflict with an existing structure.

### Recommendation

**Preferred: relocate `agents/londonjs-content-creator.md` to
`mcleo-d/london-js-slides`** (for example under a new `agents/` directory
there, mirroring this repo's layout). **What breaks:** this repository's
bulk-install instruction (`cp claude-agents/agents/*.md ~/.claude/agents/`
in `README.md`) would no longer distribute it, so operators working on
London.js content would need an explicit second install step from the
`london-js-slides` repo, and `AGENTS.md`'s current path reference
(`~/.claude/agents/londonjs-content-creator.md`) would need updating to
point at wherever it lands, or the promotion/install step documented
there. **What stays:** every other agent, the CI workflow, `CODEOWNERS`
(a path-independent `*` rule), and the audit's own historical record are
unaffected; `model: inherit` (the one frontmatter setting the audit
already flagged as ahead of the rest of the roster) travels with the file
unchanged. **Trade-off:** this is a one-file, low-risk move with a single
documented consumer, but it reverses the ST-281/GL-41 promotion decision
that put it here; that decision's original rationale is not visible in
this repo (the commit message states the action, not the reason), so the
governed-loop Story executing this should confirm with whoever made that
promotion call that the original reason no longer applies.

## Item 5: relay agents — necessity vs artifact value

The audit's backlog item 5 asks whether `code-reviewer`,
`systematic-debugger` and `deploy-checklist` route work a single capable
session could reason through inline, or whether their structured output is
itself a dependency something downstream relies on. Each is assessed
against visible evidence; where no consumer is visible, that is stated
directly rather than inferred.

**`code-reviewer`.** Its `Review format` section fixes a
Summary/Critical/Major/Minor/Positive structure with a closed `APPROVE |
REQUEST_CHANGES | COMMENT` verdict. This repository names that artifact as
a gate on itself, not just a description of the persona:

```text
$ grep -n "code-reviewer" README.md CONTRIBUTING.md
README.md:29:| `code-reviewer` | Multi-language PR review with structured severity framework | Reviewing any pull request or code change |
README.md:89:- `code-reviewer` — final quality gate before merge
CONTRIBUTING.md:35:- **Read-only where appropriate.** Agents that produce verdicts or checklists (code-reviewer, deploy-checklist, systematic-debugger) do not modify files. Their `tools:` frontmatter reflects this.
```

`README.md:89` states plainly that `code-reviewer` is this repository's
"final quality gate before merge" — this Story's own `CODEOWNERS` gate
(`@mcleo-d` review required on every file, checked below) operates
alongside it. The structured verdict is grounded evidence of downstream
dependency in this repo, not asserted.

```text
$ cat .github/CODEOWNERS
# All files require review from the project maintainer.
* @mcleo-d
```

**`deploy-checklist`.** Its verdict format specifies `GO | NO-GO` and
instructs the agent to store the completed checklist at
`docs/deployments/YYYY-MM-DD-<service>-<environment>.md`. No such directory
or file exists anywhere visible on this host:

```text
$ find / -type d -name "deployments" 2>/dev/null
(no output)
```

This is the honest negative case the Story asks for: there is no visible
evidence, in this repo or in `london-js-slides` (the only other repo
present), that a `deploy-checklist` artifact has ever been produced or
consumed. That does not mean it has no value — `README.md:31` documents it
as "Pre-deployment go/no-go validation for cloud and edge targets", and its
own file cross-references `devops-engineer` and `sre-engineer` as
producer/consumer — but that interaction model is declared in the file,
not demonstrated by a stored artifact on this host. Say so honestly rather
than asserting downstream dependency that is not visible.

**`systematic-debugger`.** Its `Output format` section mandates a
failure-characterisation/hypotheses/evidence/root-cause/regression-test
report with a named `Handoff:` routing table to five other agents by name.
As with `deploy-checklist`, no stored debugging report is visible on this
host to confirm the handoff has actually been exercised; the artifact
structure is well-specified in the file itself but its consumption is not
independently visible here.

### Recommendation

**Retain `code-reviewer`** as a genuine relay agent: its verdict artifact
is demonstrably a downstream dependency, documented in this repository's
own `README.md` as the merge gate and reinforced by the live
`CODEOWNERS` review requirement. **Retain `deploy-checklist` and
`systematic-debugger` provisionally**, but flag both for the governed loop
under GL-61 to confirm with real evidence (a stored checklist, a stored
debug report, or a citation from a consuming repository) rather than
carrying the audit's assumption forward unverified. **Trade-off:** downgrading
either now would be an assertion in the same direction the audit warned
against ("near-identical" without evidence); keeping them provisionally
costs nothing but review attention, while removing a relay agent that
turns out to have a real silent consumer would be a regression.

## Item 6: Skills split for embedded Procedures blocks

`linux-systems-engineer.md`, `devops-engineer.md` and `security-engineer.md`
each carry a named, parameterised "Procedures" section distinct from the
rest of the persona:

```text
$ grep -n -B1 '^### ' agents/linux-systems-engineer.md agents/devops-engineer.md agents/security-engineer.md
agents/linux-systems-engineer.md:### Hardening Verification (`harden-verify`)
agents/linux-systems-engineer.md:### Sysctl Drift Detection (`sysctl-drift`)
agents/devops-engineer.md:### Docker Preflight (`docker-preflight`)
agents/devops-engineer.md:### Compose Health Check (`compose-healthcheck`)
agents/security-engineer.md:### Posture Review (`posture-review`)
agents/security-engineer.md:### Credential Audit (`credential-audit`)
```

All six share the same shape: a `name` in backticks, a one-line
description of what is checked, and an explicit `**Parameters:**` line
(`<SSH_HOST>`, plus role-specific flags such as `<MIN_DOCKER_VERSION>` or
`<COMPOSE_DIR>`). This is structurally different from the rest of each
persona (open-ended principles and standards) and structurally identical
to what a Claude Code Skill is: a named, parameterised, independently
invocable capability rather than a whole persona. Unlike the content
family in item 2, these procedures do not depend on the surrounding
persona's voice or judgement calls — `harden-verify` does not need the
`linux-systems-engineer` identity to run a read-only SSH/UFW/fail2ban/sysctl
check, it needs the check definition and its parameters.

Two things temper a full split, both drawn from the files themselves
rather than assumed:

- Every procedure's pass/fail criteria reference domain knowledge the
  surrounding persona also states once, in `Core principles` or
  `Security accountability` (for example, `linux-systems-engineer`'s
  `sysctl-drift` procedure directly depends on the "Never weaken an
  existing control — escalate instead" rule declared in `Security
  accountability` above it). A bare Skill extracted without that context
  would need to restate the escalation rule or risk a caller applying the
  check without the guardrail.
- As with item 2's Skills option, there is no `skills/` directory,
  reference convention, or CI coverage in this repository today (see the
  `find` output in item 2). This would be the first Skill in the
  repository, not a mechanical extraction of an established pattern.

### Recommendation

**Split: extract the six named procedures into Skills**, one per
procedure (`harden-verify`, `sysctl-drift`, `docker-preflight`,
`compose-healthcheck`, `posture-review`, `credential-audit`), each
carrying its own parameters and pass/fail criteria, and have the three
agent files reference them from their `Operational Procedures` /
`Edge Deployment Procedures` / `Bare-Metal Security Procedures` headings
rather than embedding the full check definition inline. **Trade-off:**
this is the first use of Skills in the repository, so it carries
one-time-setup cost (establishing the `skills/` directory shape, a lint
or CI check for it, and a documented reference convention in
`CONTRIBUTING.md`) that item 2's content family would not need to repeat
once this lands. Each Skill's pass/fail criteria must still carry an
explicit pointer back to the owning agent's accountability rule (for
example, `sysctl-drift`'s Skill file should still state "escalate to
`security-engineer`, never weaken a control") so the guardrail is not
lost in extraction; this is a scoping requirement for whoever implements
the split, not a reason to reject it.

## Decision table

| Item | Recommendation | Effort | Risk | Blocked on |
|---|---|---|---|---|
| 2. Content family | Single parameterised agent (`content-writer.md`); 55-line exercised draft, under the repo's 50-90 line target | Medium: merge 3 files, update `README.md` table and cross-references | Low-medium: loses independent auto-invocation trigger per writing task | None; ready for a governed-loop Story |
| 3. `londonjs-content-creator` | Relocate to `mcleo-d/london-js-slides` | Low: one file move, one `AGENTS.md` path update | Low: single documented consumer, reverses an undocumented prior promotion decision | Confirmation from whoever made the ST-281/GL-41 promotion call that its rationale no longer applies |
| 5. Relay agents | Retain `code-reviewer` (evidenced gate); retain `deploy-checklist` and `systematic-debugger` provisionally, unverified | Low: no change now; verification effort for the other two | Low: no action taken; provisional retention is the safe default | Evidence of a stored `deploy-checklist`/`systematic-debugger` artifact or a citation from a consuming repo |
| 6. Skills split | Split the six named Procedures blocks into Skills, one per procedure | Medium-high: first Skills usage in the repo; needs a `skills/` convention and CI coverage | Medium: extraction must preserve each procedure's linked accountability rule or the guardrail is lost | A `skills/` directory convention and CI lint coverage do not yet exist; needs the same governed-loop Story as item 2 if both land together |

## Scope note

This Story is read-only-plus-report: no agent definitions in `agents/`
were modified to produce it, and the exercised merge draft referenced in
item 2 was written to a scratch path outside this repository and removed,
not committed. All four recommendations above are proposals for the named
pen decision and the governed loop under GL-61 to accept, refine or
reject; this report does not self-approve any of them.
