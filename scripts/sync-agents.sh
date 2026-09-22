#!/bin/bash
# Install the pinned agent corpus onto a surface.
#
# Usage: bash scripts/sync-agents.sh [--target DIR] [--dry-run]
#
# Reads the tag named in the pin file, fetches it, and copies every definition
# at that tag into the install directory. A manifest of tag-owned files
# (.agents-manifest, in the install directory) is written on every successful
# sync. On the next sync, files the manifest says the PREVIOUS tag owned but
# the NEW tag no longer does are pruned: moved (never unlinked) to a dated
# backup directory outside the install. A file that has never appeared in any
# manifest is unmanaged and is never touched, pruned or otherwise.
#
# Rollback: edit the pin file to name a prior tag and run this again. Prune
# now makes rollback exact: the install ends up holding precisely the prior
# tag's file set, with anything the newer tag had added moved out.
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

NEW_FILES="$(git -C "${REPO_DIR}" ls-tree -r --name-only "${TAG}" -- agents/ | grep '\.md$' | xargs -n1 basename | sort)"

COUNT=0
while IFS= read -r base; do
  git -C "${REPO_DIR}" show "${TAG}:agents/${base}" > "${TARGET}/${base}"
  COUNT=$((COUNT + 1))
done <<< "${NEW_FILES}"

echo "installed ${COUNT} definitions at ${TAG} (${SHA}) into ${TARGET}"

# Prune what the PREVIOUS manifest says was tag-owned but the new tag no
# longer owns. Never touches a file absent from every manifest (unmanaged).
MANIFEST="${TARGET}/.agents-manifest"
PREV_FILES=""
[ -f "${MANIFEST}" ] && PREV_FILES="$(tail -n +2 "${MANIFEST}")"

PRUNED=0
if [ -n "${PREV_FILES}" ]; then
  while IFS= read -r base; do
    [ -z "${base}" ] && continue
    printf '%s\n' "${NEW_FILES}" | grep -qx "${base}" && continue
    [ -f "${TARGET}/${base}" ] || continue
    if [ "${PRUNED}" -eq 0 ]; then
      PRUNE_BACKUP="${TARGET}.pruned.${TAG}.$(date -u +%Y%m%dT%H%M%SZ)"
      mkdir -p "${PRUNE_BACKUP}"
    fi
    mv "${TARGET}/${base}" "${PRUNE_BACKUP}/${base}"
    echo "pruned: ${base} -> ${PRUNE_BACKUP}/${base}"
    PRUNED=$((PRUNED + 1))
  done <<< "${PREV_FILES}"
fi
echo "pruned ${PRUNED} file(s) no longer owned by ${TAG}"

# Manifest write is the last step and is atomic: temp file in the same
# directory, then rename, so a crash mid-sync never leaves a half-written
# manifest for the next run to trust.
MANIFEST_TMP="$(mktemp "${TARGET}/.agents-manifest.XXXXXX")"
{
  echo "tag=${TAG}"
  printf '%s\n' "${NEW_FILES}"
} > "${MANIFEST_TMP}"
mv "${MANIFEST_TMP}" "${MANIFEST}"
