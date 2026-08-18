# Skill: Compose Health Check (`compose-healthcheck`)

**Owning agent:** `devops-engineer`

Post-deployment health check for a Docker Compose stack. Verifies: container state, health status, restart counts, error logs, gateway endpoint, upstream reachability, resource limits. Run after `docker compose up -d`.

**Parameters:** `<SSH_HOST>`, `<COMPOSE_DIR>`, `<GATEWAY_URL>` (optional).

**Guardrail pointer:** this check is the operational expression of `devops-engineer`'s core principle "Infrastructure is code — test it." Its output is the signal `devops-engineer` exposes under `## Interaction model`: "Expose deployment SLIs to `sre-engineer`." A failing health check is reliability signal for `sre-engineer`, not a result to be suppressed or re-run until green.
