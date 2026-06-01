#!/bin/bash
set -euo pipefail

# === Arimo V1 Self-Hosting Chain Test ===
# S1→S2→S3→S4 with memory monitoring at each stage
# Kills process if memory > 5GB
# arc build writes output to project dir, we copy to out/

PROJECT="/workspace/arimo"
S1="/workspace/arc.v1"
OUTDIR="/workspace/out"
MEMLOG="/workspace/out/memory.log"
KILL_LIMIT_KB=5242880  # 5 GB in KB

mkdir -p "$OUTDIR"

echo "=== Arimo V1 Self-Hosting Chain Test ===" | tee "$MEMLOG"
echo "=== Started: $(date)" | tee -a "$MEMLOG"
echo "=== Kernel: $(uname -r)" | tee -a "$MEMLOG"
echo "=== CPU: $(nproc) cores" | tee -a "$MEMLOG"
echo "=== RAM: $(free -m | awk '/Mem:/{print $2}') MB total" | tee -a "$MEMLOG"

# Verify S1 exists
S1_SIZE=$(stat -c%s "$S1" 2>/dev/null || echo 0)
S1_SHA=$(sha256sum "$S1" | awk '{print $1}')
echo "[S1]  Binary: ${S1_SIZE}bytes, SHA256=${S1_SHA}" | tee -a "$MEMLOG"

# --- memory monitor (background, subshell) ---
monitor_mem() {
    local pid=$1
    local label=$2
    local logfile=$3
    local max_kb=0
    local peak=0
    local killed=0
    while kill -0 "$pid" 2>/dev/null; do
        if [ -f "/proc/$pid/status" ]; then
            peak=$(grep VmPeak /proc/"$pid"/status 2>/dev/null | awk '{print $2}' || echo 0)
            if [ "$peak" -gt "$max_kb" ]; then
                max_kb=$peak
            fi
            if [ "$peak" -gt "$KILL_LIMIT_KB" ]; then
                echo "[FATAL] $label: VmPeak=${peak}KB > 5GB limit! Killing PID=$pid" | tee -a "$logfile"
                kill -9 "$pid" 2>/dev/null || true
                killed=1
                break
            fi
        fi
        sleep 0.1
    done
    wait "$pid" 2>/dev/null || true
    local exit_code=$?
    local max_mb=$((max_kb / 1024))
    if [ "$killed" -eq 1 ]; then
        echo "[MEM] $label: VmPeak=${max_mb}MB (KILLED — exceeded 5GB)" | tee -a "$logfile"
        return 99
    fi
    echo "[MEM] $label: VmPeak=${max_mb}MB (${max_kb}KB), ExitCode=${exit_code}" | tee -a "$logfile"
    return $exit_code
}

# --- compile step ---
compile_step() {
    local compiler="$1"
    local label="$2"
    local dest="$3"

    echo "" | tee -a "$MEMLOG"
    echo "=========================================" | tee -a "$MEMLOG"
    echo "=== $label" | tee -a "$MEMLOG"
    echo "=== Compiler: $(basename "$compiler")" | tee -a "$MEMLOG"
    echo "=== Time: $(date '+%H:%M:%S')" | tee -a "$MEMLOG"
    echo "=========================================" | tee -a "$MEMLOG"

    cd "$PROJECT"

    # Remove stale output binary so we can detect new one
    rm -f arc

    local start_ts=$(date +%s%3N)

    # Run compiler in subshell
    (
        "$compiler" build --target linux &
        local cpid=$!
        monitor_mem "$cpid" "$label" "$MEMLOG"
        exit $?
    )
    local exit_code=$?

    local end_ts=$(date +%s%3N)
    local elapsed=$((end_ts - start_ts))

    if [ "$exit_code" -eq 99 ]; then
        echo "[FATAL] $label: KILLED — memory exceeded 5GB" | tee -a "$MEMLOG"
        return 99
    fi

    if [ "$exit_code" -ne 0 ]; then
        echo "[FAIL] $label: Compile failed with exit code $exit_code" | tee -a "$MEMLOG"
        return 1
    fi

    # arc build writes output to ./arc in the project dir
    if [ ! -f "arc" ]; then
        echo "[FAIL] $label: Output binary not found at ./arc in project dir" | tee -a "$MEMLOG"
        echo "[FAIL] Files in project dir:" | tee -a "$MEMLOG"
        ls -la "$PROJECT/" >> "$MEMLOG" 2>&1 || true
        return 1
    fi

    # Copy to output directory with stage name
    cp arc "$dest"
    chmod +x "$dest"

    local size_bytes=$(stat -c%s "$dest" 2>/dev/null || echo 0)
    local sha=$(sha256sum "$dest" | awk '{print $1}')
    echo "[OK]   $label: ${elapsed}ms, Binary=${size_bytes}bytes" | tee -a "$MEMLOG"
    echo "[OK]   $label: SHA256=${sha}" | tee -a "$MEMLOG"

    # Save metadata
    echo "$sha" > "${dest}.sha256"
    echo "$elapsed" > "${dest}.elapsed"
    return 0
}

# --- main ---

# --- S1 → S2 ---
echo "" | tee -a "$MEMLOG"
echo ">>> Phase 1: S1 → S2" | tee -a "$MEMLOG"
compile_step "$S1" "S1→S2" "$OUTDIR/arc.s2"
S2_RC=$?
if [ "$S2_RC" -eq 99 ]; then
    echo "" | tee -a "$MEMLOG"
    echo "❌ S1→S2 memory > 5GB — test ABORTED" | tee -a "$MEMLOG"
    exit 1
elif [ "$S2_RC" -ne 0 ]; then
    echo "" | tee -a "$MEMLOG"
    echo "❌ S1→S2 failed — test ABORTED" | tee -a "$MEMLOG"
    exit 1
fi

# --- S2 → S3 ---
echo "" | tee -a "$MEMLOG"
echo ">>> Phase 2: S2 → S3" | tee -a "$MEMLOG"
compile_step "$OUTDIR/arc.s2" "S2→S3" "$OUTDIR/arc.s3"
S3_RC=$?
if [ "$S3_RC" -eq 99 ]; then
    echo "" | tee -a "$MEMLOG"
    echo "❌ S2→S3 memory > 5GB — test ABORTED" | tee -a "$MEMLOG"
    exit 1
elif [ "$S3_RC" -ne 0 ]; then
    echo "" | tee -a "$MEMLOG"
    echo "❌ S2→S3 failed — test ABORTED" | tee -a "$MEMLOG"
    exit 1
fi

# --- S3 → S4 ---
echo "" | tee -a "$MEMLOG"
echo ">>> Phase 3: S3 → S4" | tee -a "$MEMLOG"
compile_step "$OUTDIR/arc.s3" "S3→S4" "$OUTDIR/arc.s4"
S4_RC=$?
if [ "$S4_RC" -eq 99 ]; then
    echo "" | tee -a "$MEMLOG"
    echo "❌ S3→S4 memory > 5GB — test ABORTED" | tee -a "$MEMLOG"
    exit 1
elif [ "$S4_RC" -ne 0 ]; then
    echo "" | tee -a "$MEMLOG"
    echo "❌ S3→S4 failed — test ABORTED" | tee -a "$MEMLOG"
    exit 1
fi

# --- Final Report ---
echo "" | tee -a "$MEMLOG"
echo "=========================================" | tee -a "$MEMLOG"
echo "=== FINAL REPORT" | tee -a "$MEMLOG"
echo "=========================================" | tee -a "$MEMLOG"

S2_SHA=$(cat "$OUTDIR/arc.s2.sha256")
S3_SHA=$(cat "$OUTDIR/arc.s3.sha256")
S4_SHA=$(cat "$OUTDIR/arc.s4.sha256")

S2_TIME=$(cat "$OUTDIR/arc.s2.elapsed")
S3_TIME=$(cat "$OUTDIR/arc.s3.elapsed")
S4_TIME=$(cat "$OUTDIR/arc.s4.elapsed")

S2_SIZE=$(stat -c%s "$OUTDIR/arc.s2")
S3_SIZE=$(stat -c%s "$OUTDIR/arc.s3")
S4_SIZE=$(stat -c%s "$OUTDIR/arc.s4")

echo "" | tee -a "$MEMLOG"
echo "Binary | Time(ms) | Size(B)  | SHA256" | tee -a "$MEMLOG"
echo "-------+----------+----------+------------------------------------------" | tee -a "$MEMLOG"
echo "S2     | ${S2_TIME}ms | ${S2_SIZE}B | ${S2_SHA}" | tee -a "$MEMLOG"
echo "S3     | ${S3_TIME}ms | ${S3_SIZE}B | ${S3_SHA}" | tee -a "$MEMLOG"
echo "S4     | ${S4_TIME}ms | ${S4_SIZE}B | ${S4_SHA}" | tee -a "$MEMLOG"
echo "" | tee -a "$MEMLOG"

# Determinism check
DETERMINISM_RESULT=""
if [ "$S2_SHA" = "$S3_SHA" ] && [ "$S3_SHA" = "$S4_SHA" ]; then
    echo "✅ DETERMINISTIC: S2 == S3 == S4 (identical SHA256)" | tee -a "$MEMLOG"
    DETERMINISM_RESULT="DETERMINISTIC ✅"
elif [ "$S2_SHA" = "$S3_SHA" ]; then
    echo "⚠️  PARTIAL: S2 == S3, but S4 differs" | tee -a "$MEMLOG"
    DETERMINISM_RESULT="PARTIAL ⚠️"
elif [ "$S3_SHA" = "$S4_SHA" ]; then
    echo "⚠️  CONVERGED: S3 == S4, but differs from S2" | tee -a "$MEMLOG"
    DETERMINISM_RESULT="CONVERGED ⚠️"
else
    echo "❌ NOT DETERMINISTIC: All three binaries differ" | tee -a "$MEMLOG"
    DETERMINISM_RESULT="NOT DETERMINISTIC ❌"
fi

# Memory growth analysis
echo "" | tee -a "$MEMLOG"
echo "=== Memory Analysis ===" | tee -a "$MEMLOG"

MEM_S1S2=$(grep 'S1→S2' "$MEMLOG" | grep '\[MEM\]' | grep -oP 'VmPeak=\K[0-9]+' || echo 0)
MEM_S2S3=$(grep 'S2→S3' "$MEMLOG" | grep '\[MEM\]' | grep -oP 'VmPeak=\K[0-9]+' || echo 0)
MEM_S3S4=$(grep 'S3→S4' "$MEMLOG" | grep '\[MEM\]' | grep -oP 'VmPeak=\K[0-9]+' || echo 0)

echo "VmPeak trend: S1→S2: ${MEM_S1S2}MB, S2→S3: ${MEM_S2S3}MB, S3→S4: ${MEM_S3S4}MB" | tee -a "$MEMLOG"

if [ "$MEM_S1S2" -gt 0 ] && [ "$MEM_S2S3" -gt 0 ] && [ "$MEM_S3S4" -gt 0 ]; then
    if [ "$MEM_S3S4" -gt "$MEM_S2S3" ] && [ "$MEM_S2S3" -gt "$MEM_S1S2" ]; then
        echo "⚠️  Memory GROWS each generation!" | tee -a "$MEMLOG"
    elif [ "$MEM_S2S3" -le "$MEM_S1S2" ] && [ "$MEM_S3S4" -le "$MEM_S2S3" ]; then
        echo "✅ Memory STABLE or DECREASING across generations" | tee -a "$MEMLOG"
    else
        echo "➡️  Memory pattern MIXED (no clear trend)" | tee -a "$MEMLOG"
    fi
fi

echo "" | tee -a "$MEMLOG"
echo "=== Test completed: $(date) ===" | tee -a "$MEMLOG"

# Return status
if echo "$DETERMINISM_RESULT" | grep -q "DETERMINISTIC"; then
    exit 0
else
    exit 1
fi
