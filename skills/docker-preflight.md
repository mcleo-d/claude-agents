# Skill: Docker Preflight (`docker-preflight`)

**Owning agent:** `devops-engineer`

Go/no-go check before `docker compose up` on an edge host. Verifies: SSH connectivity, CPU architecture, Docker version (>=29), daemon health, daemon.json validation, disk space, RAM, hello-world smoke test. Read-only except for the smoke test.

**Parameters:** `<SSH_HOST>`, `<MIN_DOCKER_VERSION>` (default 29), `<MIN_DISK_GB>` (default 3), `<MIN_RAM_GB>` (default 4).

**Guardrail pointer:** the `daemon.json` this check validates is governed by `linux-systems-engineer`'s Docker configuration standard: "Preserve `icc: false`, `no-new-privileges: true`, `live-restore: true`, `userland-proxy: false`. Changes reviewed by `devops-engineer` + `security-engineer`." This is restated in `devops-engineer`'s own `## Interaction model`: "Receive `daemon.json` change requests from `linux-systems-engineer` for review." A daemon.json validation failure must be routed through that joint review, not patched unilaterally.
