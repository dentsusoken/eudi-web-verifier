#!/bin/bash
# _local ファイルを patches/ から生成するスクリプト
set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
REPO_ROOT="$(cd "$SCRIPT_DIR/.." && pwd)"
PATCHES_DIR="$REPO_ROOT/patches"

apply_patch() {
    local original="$1"
    local output="$2"
    local patchfile="$3"
    if patch --no-backup-if-mismatch --output="$output" "$original" < "$patchfile" > /dev/null 2>&1; then
        echo "  OK: $(basename "$output")"
    else
        rm -f "$output"
        echo "  CONFLICT: $(basename "$patchfile") - manual resolution needed"
    fi
}

echo ""
echo "=== eudi-web-verifier ==="
cd "$REPO_ROOT"

ATTESTATION_DIR="src/app/core/models/attestation"
CONSTANTS_DIR="src/app/core/constants"

apply_patch "$ATTESTATION_DIR/AttestationType.ts"          "$ATTESTATION_DIR/AttestationType_local.ts"          "$PATCHES_DIR/AttestationType.patch"
apply_patch "$CONSTANTS_DIR/attestation-definitions.ts"    "$CONSTANTS_DIR/attestation-definitions_local.ts"    "$PATCHES_DIR/attestation-definitions.patch"
apply_patch "$CONSTANTS_DIR/attestations-per-format.ts"    "$CONSTANTS_DIR/attestations-per-format_local.ts"    "$PATCHES_DIR/attestations-per-format.patch"

echo ""
echo "Done!"
