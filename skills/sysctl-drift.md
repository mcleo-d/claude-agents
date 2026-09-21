# Skill: Sysctl Drift Detection (`sysctl-drift`)

**Owning agent:** `linux-systems-engineer`

Compares live sysctl values against `99-hardening.conf` baseline. Detects drift from kernel upgrades, reboots, or manual changes. Read-only. Note: `log_martians` may revert to 0 at runtime — known Pi OS behaviour, not config drift. Force-apply with `sysctl -w`.

**Parameters:** `<SSH_HOST>`. Requires sudo.

**Guardrail pointer:** this check directly depends on `linux-systems-engineer`'s `## Security accountability` rule: "Never weaken an existing control — escalate instead." Detected drift that lowers a control below baseline must be escalated to `security-engineer`, never re-baselined downward to match the drifted value.
