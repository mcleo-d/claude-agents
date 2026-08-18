# Skill: Credential Audit (`credential-audit`)

**Owning agent:** `security-engineer`

Audits credential hygiene: file permissions, plaintext secrets in compose files, git tracking, world-readable files.

**Parameters:** `<SSH_HOST>`, `<COMPOSE_DIR>`, `<CONFIG_DIR>`.

**Guardrail pointer:** `security-engineer`'s `## Interaction model` states: "Escalate Critical/High findings to engineering lead." A discovered plaintext secret or world-readable credential file is a Critical/High finding and must be escalated per that rule, not remediated silently without report.
