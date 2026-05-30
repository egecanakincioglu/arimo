---
title: Project Status
description: Current implementation status, verified self-hosting, ARC progress, and open questions
tags: [reference, status]
date: 2026-05-30
---

# Project Status

## Current Compiler

The active v1 compiler is the Arimo-written compiler in this repository. Its pipeline:

```text
.arm -> Lexer -> Parser -> TypeChecker -> NativeBackend -> PE/ELF executable
```

The Rust bootstrap compiler is historical Stage 0 context (`v0.5-beta`). The v1 compiler is self-hosted: compiled by itself, producing byte-identical output.

## Self-Hosting Verification

| Chain | Status | Verified |
|-------|--------|----------|
| S0→S1 | ✅ | Bootstrap Rust binary compiles arimo/ |
| S1→S2 | ✅ | S1 (LLVM-generated) compiles arimo/ → S2 |
| S2→S3 | ✅ | S2 (self-hosted) compiles arimo/ → S3 |
| S3→S4 | ✅ | S3 compiles arimo/ → S4 |
| Deterministic | ✅ | SHA256(S2) = SHA256(S3) = SHA256(S4) |

S2/S3/S4 are byte-identical. The compiler is deterministic on the same input.

## Test Suite

**31/31 tests pass.** 17 core language tests + 14 ARC memory management tests:

- Core: classes, methods, constructors, inheritance, static methods, string operations, list operations, arithmetic, control flow
- ARC: allocation, assignment, scope exit, nested scopes, return ownership, field assignment, shared ownership, break/continue unwind, recursive teardown

All 31 tests compile and run correctly with elf64 output on Linux.

## Native Backend Status

The active backend is `NativeBackend`:

- `IRLower` (~2480 lines) — lowers AST to ArimoIR
- `RegAlloc` (310 lines) — linear-scan register allocation (7 registers)
- `IRToX64` (490 lines) — IR → x86-64 machine code
- `X64Encoder` — x64 machine code emitter
- `PEWriter` — Windows PE32+ executables
- `ELFWriter` (239 lines) — Linux ELF64 executables

`arimo/compiler/codegen/CodeGen.arm` is older LLVM-text oriented codegen kept for context. It is not the active backend.

## Memory Model Status

ARC memory management is complete. All phases merged and verified:

| Phase | Feature | Status |
|-------|---------|--------|
| ARC Phase 1 | Refcount allocation, heap alloc/free, ctor refcount=1 | ✅ Merged |
| ARC Phase 2 | Retain/release inline helpers (emitRetain/emitRelease) | ✅ Merged |
| ARC Phase 3 | Assignment retain/release (IDENT + FIELD), VAR_DECL retain | ✅ Merged |
| ARC Phase 4 | Scope exit release, return ownership transfer, break/continue unwind | ✅ Merged |
| ARC Phase 5 | Recursive field teardown, inheritance chain, RETURN FIELD retain | ✅ Merged |
| ARC Phase 6 | Test suite (14 ARC tests) + documentation | ✅ Merged |

ARC is active in all self-hosted compilers (S2→S3). Null-safe: both retain and release include null guards. Deterministic: S2≡S3 byte-identical with ARC active.

BorrowChecker is intentionally not implemented in the v1 compiler yet. The Rust bootstrap has a historical implementation; v1 needs its own later.

## Recent Bug Fixes

| PR | Category | Root Cause |
|----|----------|------------|
| [#106](https://github.com/egecanakincioglu/arimo/pull/106) | IRLower | NULL returnTy deref on void methods |
| [#107](https://github.com/egecanakincioglu/arimo/pull/107) | IRLower | Primitive type dispatch — tyToClass missing INTEGER/FLOAT/BOOLEAN |
| [#108](https://github.com/egecanakincioglu/arimo/pull/108) | IRLower | String toString dispatch — fell through to undefined label |
| [#118](https://github.com/egecanakincioglu/arimo/pull/118) | IRLower | Empty constructor lowering — body.length()>0 filter |
| [#119](https://github.com/egecanakincioglu/arimo/pull/119) | IRLower | FIELD assignment ARC retain/release + emitRetain null guard |

## Resolved Backend Questions

- **Runtime boundary:** Print helpers and string helpers emitted inline by IRLower as IR functions.
- **ABI coverage:** Linux (syscall) and Windows (WinAPI) calling conventions implemented.
- **Feature coverage:** All features used by self-hosting compiler (62 modules) lower correctly. Unused features (interfaces, enums, generics, pattern matching) are in parser/typechecker but not yet tested through IRLower.
- **Platform detection:** PR [#36](https://github.com/egecanakincioglu/arimo-bootstrap/pull/36) — default target uses `cfg!(target_os)` at bootstrap build time. `--target linux|windows` flag available.
- **ARC memory:** Complete (Phases 1-6). All assignments, scope exit, return, break/continue, recursive teardown, inheritance, field stores covered. Null-safe.

## Known Issues

| Issue | Severity | Status |
|-------|----------|--------|
| `Env.platform()` ELF native runtime crash | MEDIUM | Pre-existing, needs investigation |
| `inferClass` fallback (returns objCls for unknown methods) | LOW | Works in practice, defensive fix deferred |
| `__this` magic-string → ownership metadata | LOW | Works correctly, refactor for extensibility |
| RETURN INDEX/DEREF retain | LOW | INDEX/DEREF not yet lowered in IRLower |
| Cycle collector / weak references | LOW | ARC limitation, documented in memory-model.md |
| Interfaces, enums, generics untested in IRLower | LOW | Parser/typechecker support exists, not used by compiler |

## Documentation Policy

Docs separate:

- Implemented v1 behavior (current)
- Planned v1/v2 behavior (future)
- Historical Stage 0 bootstrap behavior (archived)
