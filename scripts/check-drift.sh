#!/bin/bash
# Report whether a surface's installed agent definitions match the pinned tag.
#
# Usage:
#   bash scripts/check-drift.sh [--surface NAME] [--target DIR]
#   bash scripts/check-drift.sh --ci
#
# Output is exactly one of:
#   IN SYNC (<tag>, <sha>)
#   DRIFT: <surface> <n> files diverge from <tag>
# The script never exits silently: one of those two lines is always printed.
#
# <n> counts tag-managed definitions that are missing from the install or whose
# content differs. Files present in the install but absent from the tag are
# unmanaged; they are reported on their own line and are never deleted, because
# this script reports drift and does not repair it.
#
# Exit codes: 0 = in sync, 1 = drift detected, 2 = configuration error.
#
# Environment:
#   AGENTS_PIN         pin file path (default: ~/.claude/agents.pin)
#   CLAUDE_AGENTS_DIR  claude-agents clone (default: ~/Projects/claude-agents)
#   AGENTS_INSTALL_DIR install directory (default: ~/.claude/agents)
set -euo pipefail

SURFACE=""
TARGET=""
CI_MODE=0

while [ $# -gt 0 ]; do
  case "$1" in
    --surface) SURFACE="${2:-}"; shift 2 ;;
    --target)  TARGET="${2:-}";  shift 2 ;;
    --ci)      CI_MODE=1;        shift ;;
    *) echo "Error: unknown argument: $1" >&2; exit 2 ;;
  esac
done

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
REPO_DIR="${CLAUDE_AGENTS_DIR:-$(cd "${SCRIPT_DIR}/.." && pwd)}"

# --- CI mode: validate the corpus and show the delta against the newest tag ---
# A definition that cannot load strands every surface, so that is a hard gate.
# A definition that differs from the newest tag is not an error: it means
# surfaces pinned to that tag will not receive it until a new tag is cut. That
# is the fact this job exists to make visible at review time.
if [ "${CI_MODE}" -eq 1 ]; then
  fail=0
  count=0
  for f in "${REPO_DIR}"/agents/*.md; do
    count=$((count + 1))
    for key in name description model; do
      if ! grep -q "^${key}:" "$f"; then
        echo "STRANDED: $(basename "$f") has no '${key}:' in its frontmatter"
        fail=1
      fi
    done
  done
  echo "Validated ${count} definitions in ${REPO_DIR}/agents"

  tag="$(git -C "${REPO_DIR}" tag -l 'agents-v*' --sort=-v:refname | head -1)"
  if [ -z "${tag}" ]; then
    echo "No agents-v* tag exists yet; nothing is distributed to any surface."
  else
    delta="$(git -C "${REPO_DIR}" diff --name-only "${tag}" -- agents/ | wc -l | tr -d ' ')"
    if [ "${delta}" -eq 0 ]; then
      echo "IN SYNC (${tag}, $(git -C "${REPO_DIR}" rev-list -n1 --abbrev-commit "${tag}"))"
    else
      echo "DRIFT: repo ${delta} files diverge from ${tag}"
      echo "Surfaces pinned to ${tag} will not receive these until a new tag is cut."
    fi
  fi
  exit "${fail}"
fi

# --- surface mode: compare a live install against the pin ---
PIN_FILE="${AGENTS_PIN:-${HOME}/.claude/agents.pin}"
TARGET="${TARGET:-${AGENTS_INSTALL_DIR:-${HOME}/.claude/agents}}"
[ -n "${SURFACE}" ] || SURFACE="$(hostname -s)"

[ -f "${PIN_FILE}" ] || { echo "Error: no pin file at ${PIN_FILE}" >&2; exit 2; }
TAG="$(grep -v '^#' "${PIN_FILE}" | grep -v '^$' | head -1 | tr -d '[:space:]')"
[ -n "${TAG}" ] || { echo "Error: pin file ${PIN_FILE} names no tag" >&2; exit 2; }
[ -d "${REPO_DIR}/.git" ] || { echo "Error: no claude-agents clone at ${REPO_DIR}" >&2; exit 2; }
git -C "${REPO_DIR}" rev-parse -q --verify "${TAG}^{commit}" >/dev/null 2>&1 \
  || { echo "Error: tag ${TAG} not found in ${REPO_DIR}" >&2; exit 2; }
[ -d "${TARGET}" ] || { echo "Error: no install directory at ${TARGET}" >&2; exit 2; }

SHA="$(git -C "${REPO_DIR}" rev-list -n1 --abbrev-commit "${TAG}")"
MISSING=""
DIFFERS=""
N=0

while IFS= read -r path; do
  base="$(basename "${path}")"
  if [ ! -f "${TARGET}/${base}" ]; then
    MISSING="${MISSING} ${base}"
    N=$((N + 1))
  elif ! git -C "${REPO_DIR}" show "${TAG}:${path}" | diff -q - "${TARGET}/${base}" >/dev/null 2>&1; then
    DIFFERS="${DIFFERS} ${base}"
    N=$((N + 1))
  fi
done < <(git -C "${REPO_DIR}" ls-tree -r --name-only "${TAG}" -- agents/ | grep '\.md$')

EXTRA=""
for f in "${TARGET}"/*.md; do
  [ -e "${f}" ] || continue
  base="$(basename "${f}")"
  git -C "${REPO_DIR}" cat-file -e "${TAG}:agents/${base}" 2>/dev/null || EXTRA="${EXTRA} ${base}"
done

echo "surface: ${SURFACE}  install: ${TARGET}  pin: ${TAG} (${SHA})"
[ -n "${MISSING}" ] && echo "missing:${MISSING}"
[ -n "${DIFFERS}" ] && echo "differs:${DIFFERS}"
if [ -n "${EXTRA}" ]; then
  echo "unmanaged (present locally, not in ${TAG}, not counted, never deleted):${EXTRA}"
fi

if [ "${N}" -eq 0 ]; then
  echo "IN SYNC (${TAG}, ${SHA})"
  exit 0
fi
echo "DRIFT: ${SURFACE} ${N} files diverge from ${TAG}"
exit 1
