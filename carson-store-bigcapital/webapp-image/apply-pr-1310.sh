#!/usr/bin/env bash
# Apply upstream PR 1310 (Generate API Key dialog) onto a bigcapital checkout.
# Expected tree: bigcapitalhq/bigcapital at tag v0.25.35.
# Skips e2e/api-keys.spec.ts — that file is not needed to build the webapp image.
set -euo pipefail

ROOT="$(cd "$(dirname "$0")" && pwd)"
TARGET="${1:-.}"
OVERLAY="${ROOT}/overlays"
PR_HEAD="cc3fb611a91843d5a78257ec6151b3c2837ad3a2"

FILES=(
  "packages/webapp/src/containers/Dialogs/ApiKeysGenerateDialog/ApiKeysGenerateDialog.tsx"
  "packages/webapp/src/containers/Dialogs/ApiKeysGenerateDialog/ApiKeysGenerateDialogContent.tsx"
  "packages/webapp/src/containers/Dialogs/ApiKeysGenerateDialog/index.tsx"
  "packages/webapp/src/hooks/query/api-keys/queries.ts"
  "shared/sdk-ts/src/api-keys.ts"
)

if [[ ! -f "${TARGET}/packages/webapp/Dockerfile" ]]; then
  echo "error: ${TARGET} is not a bigcapital checkout (missing packages/webapp/Dockerfile)" >&2
  exit 1
fi

copy_overlays() {
  local f src dest
  for f in "${FILES[@]}"; do
    src="${OVERLAY}/${f}"
    dest="${TARGET}/${f}"
    if [[ ! -f "${src}" ]]; then
      echo "error: missing overlay ${src}" >&2
      exit 1
    fi
    mkdir -p "$(dirname "${dest}")"
    cp "${src}" "${dest}"
  done
}

applied_from_github=0
if [[ -d "${TARGET}/.git" ]] && command -v git >/dev/null 2>&1; then
  if git -C "${TARGET}" fetch --depth=1 https://github.com/bigcapitalhq/bigcapital.git \
    "pull/1310/head:refs/heads/pr-1310" 2>/dev/null \
    || git -C "${TARGET}" fetch --depth=1 https://github.com/bigcapitalhq/bigcapital.git \
      "${PR_HEAD}:refs/heads/pr-1310" 2>/dev/null; then
    if git -C "${TARGET}" checkout pr-1310 -- "${FILES[@]}"; then
      echo "Applied PR 1310 files from GitHub (head ${PR_HEAD})."
      applied_from_github=1
    fi
  fi
fi

if [[ "${applied_from_github}" -ne 1 ]]; then
  echo "GitHub fetch of PR 1310 unavailable; using vendored overlays."
  copy_overlays
fi

dialog="${TARGET}/packages/webapp/src/containers/Dialogs/ApiKeysGenerateDialog/ApiKeysGenerateDialog.tsx"
sdk="${TARGET}/shared/sdk-ts/src/api-keys.ts"
if ! grep -q "withDialogRedux" "${dialog}"; then
  echo "error: ApiKeysGenerateDialog.tsx is missing withDialogRedux after patch" >&2
  exit 1
fi
if ! grep -q "GenerateApiKeyResponse" "${sdk}"; then
  echo "error: shared/sdk-ts/src/api-keys.ts is missing GenerateApiKeyResponse after patch" >&2
  exit 1
fi

echo "Patched Generate API Key dialog files:"
for f in "${FILES[@]}"; do
  echo "  ${f}"
done
