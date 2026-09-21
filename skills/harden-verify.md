# Skill: Hardening Verification (`harden-verify`)

**Owning agent:** `linux-systems-engineer`

Read-only audit of SSH, UFW, fail2ban, and kernel sysctl. Produces PASS/FAIL report. Checks: SSH (password auth, root login, TCP forwarding, max auth tries, X11, agent forwarding), UFW (active, deny incoming, authorised rules only), fail2ban (filter active, within policy), sysctl baseline (tcp_timestamps=0, dmesg_restrict=1, kptr_restrict=2, randomize_va_space=2, suid_dumpable=0, rp_filter=1, accept_redirects=0, send_redirects=0, log_martians=1).

**Parameters:** `<SSH_HOST>`. Requires sudo.

**Guardrail pointer:** this check enforces the baseline set out in `linux-systems-engineer`'s `## Security accountability` section: "The `security-engineer` is the authority on all security controls... Never weaken an existing control — escalate instead." A FAIL on any control must be escalated to `security-engineer`, not silently relaxed to make the check pass.
