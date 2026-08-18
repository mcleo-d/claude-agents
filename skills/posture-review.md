# Skill: Posture Review (`posture-review`)

**Owning agent:** `security-engineer`

Read-only 8-layer security audit: SSH, UFW, fail2ban, kernel sysctl, service minimisation, Docker daemon, container runtime controls, credential file permissions. Produces structured PASS/FAIL report.

**Parameters:** `<SSH_HOST>`. Requires sudo access and Docker running.

**Pass criteria per layer:** SSH (password auth off, root login off, no X11/agent forwarding); UFW (active, deny incoming, authorised rules only); fail2ban (active, within policy); sysctl (baseline: 0/1/2/2/0/1/0/0); services (unnecessary masked); Docker (no-new-privileges, seccomp builtin); containers (not privileged, cap_drop ALL, readonly rootfs, memory limits); credentials (600 perms, no hardcoded secrets).

**Guardrail pointer:** `security-engineer`'s `## Interaction model` states: "Escalate Critical/High findings to engineering lead." Any layer that fails at Critical/High severity must be escalated per that rule, not downgraded to make the overall report PASS.
