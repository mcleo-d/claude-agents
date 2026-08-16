#!/bin/bash
# Install the pinned agent corpus onto a surface.
#
# Usage: bash scripts/sync-agents.sh [--target DIR] [--dry-run]
#
# Reads the tag named in the pin file, fetches it, and copies every definition
# at that tag into the install directory. Files present locally but absent from
# the tag are left alone: this script adds and updates, it never deletes, so an
# unmanaged local definition survives a sync and is reported by check-drift.sh.
#
# Rollback: edit the pin file to name a prior tag and run this again.
#
# Exit codes: 0 = installed, 2 = configuration error.
#
# Environment:
#   AGENTS_PIN         pin file path (default: ~/.claude/agents.pin)
#   CLAUDE_AGENTS_DIR  claude-agents clone (default: ~/Projects/claude-agents)
#   AGENTS_INSTALL_DIR install directory (default: ~/.claude/agents)
set -euo pipefail

TARGET=""
DRY_RUN=0
while [ $# -gt 0 ]; do
  case "$1" in
    --target)  TARGET="${2:-}"; shift 2 ;;
    --dry-run) DRY_RUN=1;       shift ;;
    *) echo "Error: unknown argument: $1" >&2; exit 2 ;;
  esac
done

PIN_FILE="${AGENTS_PIN:-${HOME}/.claude/agents.pin}"
REPO_DIR="${CLAUDE_AGENTS_DIR:-${HOME}/Projects/claude-agents}"
TARGET="${TARGET:-${AGENTS_INSTALL_DIR:-${HOME}/.claude/agents}}"
REMOTE="https://github.com/mcleo-d/claude-agents.git"

[ -f "${PIN_FILE}" ] || { echo "Error: no pin file at ${PIN_FILE}" >&2; exit 2; }
TAG="$(grep -v '^#' "${PIN_FILE}" | grep -v '^$' | head -1 | tr -d '[:space:]')"
[ -n "${TAG}" ] || { echo "Error: pin file ${PIN_FILE} names no tag" >&2; exit 2; }

if [ ! -d "${REPO_DIR}/.git" ]; then
  echo "Cloning ${REMOTE} to ${REPO_DIR}"
  git clone --quiet "${REMOTE}" "${REPO_DIR}"
fi
git -C "${REPO_DIR}" fetch --quiet --tags origin
git -C "${REPO_DIR}" rev-parse -q --verify "${TAG}^{commit}" >/dev/null 2>&1 \
  || { echo "Error: tag ${TAG} not found in ${REPO_DIR}" >&2; exit 2; }

SHA="$(git -C "${REPO_DIR}" rev-list -n1 --abbrev-commit "${TAG}")"
mkdir -p "${TARGET}"

if [ "${DRY_RUN}" -eq 1 ]; then
  echo "DRY RUN: would install ${TAG} (${SHA}) into ${TARGET}"
  git -C "${REPO_DIR}" ls-tree -r --name-only "${TAG}" -- agents/ | grep '\.md$'
  exit 0
fi

# The install directory is live configuration, so back it up before writing.
BACKUP="${TARGET}.pre-${TAG}.$(date -u +%Y%m%dT%H%M%SZ)"
cp -R "${TARGET}" "${BACKUP}"
echo "backup: ${BACKUP}"

COUNT=0
while IFS= read -r path; do
  git -C "${REPO_DIR}" show "${TAG}:${path}" > "${TARGET}/$(basename "${path}")"
  COUNT=$((COUNT + 1))
done < <(git -C "${REPO_DIR}" ls-tree -r --name-only "${TAG}" -- agents/ | grep '\.md$')

echo "installed ${COUNT} definitions at ${TAG} (${SHA}) into ${TARGET}"
