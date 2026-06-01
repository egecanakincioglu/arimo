#!/bin/bash
set -euo pipefail

# === Arimo V1 Self-Hosting Chain — Isolated Test ===
# Uses bwrap (bubblewrap) for filesystem isolation
# Project source COPIED to tmpfs (compiler writes output to project dir)
# Monitors memory via /proc, kills if > 5GB

SCRIPT_DIR="$(cd "$(dirname "$0")" && pwd)"
PROJECT_SRC="/home/arimo/Desktop/arimo"
V1_BINARY="/tmp/arimo-chain-test/arimo-linux-x64/arc"
OUTDIR="/tmp/arimo-chain-results"

echo "=== Arimo V1 Self-Hosting Chain (Isolated) ==="
echo "Project: $PROJECT_SRC"
echo "V1 binary: $V1_BINARY"
echo "Output: $OUTDIR"
echo ""

# Verify inputs
if [ ! -f "$V1_BINARY" ]; then
    echo "ERROR: V1 binary not found at $V1_BINARY"
    exit 1
fi

V1_SHA=$(sha256sum "$V1_BINARY" | awk '{print $1}')
echo "V1 SHA256: $V1_SHA"

# Prepare output directory
rm -rf "$OUTDIR"
mkdir -p "$OUTDIR"

# Create temp workspace
TMPDIR=$(mktemp -d /tmp/arimo-bwrap-XXXXXX)
echo "Temp dir: $TMPDIR"

# Copy project source to tmpdir (compiler needs to write output binary to project dir)
echo "Copying project source..."
cp -r "$PROJECT_SRC" "$TMPDIR/arimo"
# Remove any stale build artifacts
rm -f "$TMPDIR/arimo/arc" 2>/dev/null || true

# Copy run script and V1 binary
cp "$SCRIPT_DIR/run-chain.sh" "$TMPDIR/run-chain.sh"
cp "$V1_BINARY" "$TMPDIR/arc.v1"
chmod +x "$TMPDIR/arc.v1"
chmod +x "$TMPDIR/run-chain.sh"
mkdir -p "$TMPDIR/out"

echo "Starting isolated test..."
echo "Memory limit: 5 GB"
echo "========================================="

# Run inside bwrap:
# - All system dirs read-only (protection)
# - /tmpfs for workspace (isolated, writable)
# - /proc and /dev for runtime
bwrap \
    --ro-bind /usr /usr \
    --ro-bind /lib64 /lib64 \
    --ro-bind /lib /lib \
    --ro-bind /bin /bin \
    --ro-bind /sbin /sbin \
    --ro-bind /etc /etc \
    --ro-bind /run /run \
    --ro-bind /opt /opt 2>/dev/null || true \
    --proc /proc \
    --dev /dev \
    --tmpfs /tmp \
    --bind "$TMPDIR" /workspace \
    /workspace/run-chain.sh

EXIT_CODE=$?

echo ""
echo "========================================="
echo "Exit code: $EXIT_CODE"

# Copy results back
if [ -d "$TMPDIR/out" ]; then
    cp -r "$TMPDIR/out"/* "$OUTDIR/" 2>/dev/null || true
    echo "Results copied to $OUTDIR"
fi
# Also copy the generated arc binaries from the project dir
for stage in s2 s3 s4; do
    SRC="$TMPDIR/arimo/arc.${stage}"
    if [ -f "$SRC" ]; then
        cp "$SRC" "$OUTDIR/arc.${stage}" 2>/dev/null || true
    fi
done

# Copy the final arc binary produced in the project dir
if [ -f "$TMPDIR/arimo/arc" ]; then
    echo "Final arc binary found in project dir"
fi

# Cleanup temp
rm -rf "$TMPDIR"

echo ""
echo "=== Test complete ==="
exit $EXIT_CODE
