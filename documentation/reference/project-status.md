---
title: Project Status
description: Current implementation status, V1.1-V2.0 roadmap, verified self-hosting, ARC progress
tags: [reference, status]
date: 2026-05-31
---

# Project Status

**Canonical source:** `docs/status/project-status.md` — this file is a tracked mirror.

## Executive Summary

V1.0 release candidate ready. Self-hosting compiler, deterministic output, ARC memory management complete. 31/31 tests pass. P0/P1 bugs: zero.

## Current Baseline

| Metric | Value |
|--------|-------|
| Core tests | 17/17 PASS |
| ARC tests | 14/14 PASS |
| **Total tests** | **31/31 PASS** |
| IRLower lines | 2704 |
| S2 binary size | 262,112 bytes |
| Self-hosting S2→S3 | ✅ byte-identical |
| Deterministic | ✅ YES |
| P0/P1 bugs | **0** |

## ARC Status — COMPLETE

All 6 phases merged. Inline retain/release. Scope exit, return, break/continue, recursive teardown, inheritance chain. 14 ARC tests pass. Deterministic with ARC active.

## V1.1 Roadmap — "Memory Performance"

**⚠️ 2026-05-31: Re-prioritized based on benchmark data.**
See: [`docs/performance-report.md`](../../docs/performance-report.md) → [`docs/audit/v1.1-performance-roadmap-audit.md`](../../docs/audit/v1.1-performance-roadmap-audit.md)

| Priority | Task | Type | Impact |
|----------|------|------|--------|
| **P0** | **Bump Allocator** | Runtime | ARC workload 87× → ~5× |
| **P0** | **Freelist / Allocation Pooling** | Runtime | RSS 389MB → <50MB |
| **P0** | **StringBuilder Runtime + SSO** | Runtime | String ops 12× → ~2.5× |
| P1 | mmap Batch / Arena Allocator | Runtime | Allocation granularity |
| P2 | `__this` ownership metadata refactor | ARC | Technical debt |
| P2 | RETURN INDEX/DEREF retain | ARC | ARC coverage |
| P2 | Env.args() + Env.exePath() | Feature | Startup ABI |

## V1.2 Roadmap — "Compiler Optimizations"

Constant folding, DCE, loop unrolling, CSE, strength reduction, peephole optimizer, function inlining, register allocation tuning.

## V1.3 Roadmap — "Language Features"

Inheritance, generics, interfaces, enums, pattern matching, lambdas/closures.

## V2.0+ Roadmap — "Advanced"

Advanced optimizer (GVN, LICM, SROA, auto-vectorization), operator overloading, exception lowering, cycle collector, JIT/ARM64 backend.

## Performance

→ [Comprehensive Benchmark Report](../../docs/performance-report.md) — 8 tests, 4 languages (C, C++, Go, Arimo).
→ [Performance Summary](../../docs/performance-notes.md) — concise V1 performance profile.
→ [Roadmap Audit](../../docs/audit/v1.1-performance-roadmap-audit.md) — benchmark-based reprioritization.

## Related

- [[versioning]] — version history and planned versions
- [[syntax-cheatsheet]] — quick syntax reference
