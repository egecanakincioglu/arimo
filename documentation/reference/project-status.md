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

**17/17 tests pass.** All compiler features verified:

- Classes, methods, constructors, inheritance, static methods
- String operations (concat, length, charAt, indexOf, substring)
- List operations, arithmetic, control flow

All 17 tests compile and run correctly with elf64 output on Linux.

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

The layered memory model is under active implementation in phases:

| Phase | Feature | Status |
|-------|---------|--------|
| ARC Phase 1 | Refcount slot allocation, heap alloc/free (mmap/munmap), ctor refcount=1 | ✅ Merged |
| ARC Phase 2 | Retain/release inline helpers (emitRetain/emitRelease) | 📋 Planned |
| ARC Phase 3 | Assignment retain/release (lowerAssign, lowerFieldStore, return) | 📋 Planned |
| ARC Phase 4 | Scope exit release (method/block cleanup) | 📋 Planned |
| ARC Phase 5 | Object tear-down (free → release fields recursively) | 📋 Planned |
| ARC Phase 6 | Tests, edge cases, self-hosting verification with ARC | 📋 Planned |

BorrowChecker is intentionally not implemented in the v1 compiler yet. The Rust bootstrap has a historical implementation; v1 needs its own later.

## Recent Bug Fixes

| PR | Category | Root Cause |
|----|----------|------------|
| [#106](https://github.com/egecanakincioglu/arimo/pull/106) | IRLower | NULL returnTy deref on void methods — `tyToClass` null guard |
| [#107](https://github.com/egecanakincioglu/arimo/pull/107) | IRLower | Primitive type dispatch — `tyToClass` didn't handle INTEGER/FLOAT/BOOLEAN |
| [#108](https://github.com/egecanakincioglu/arimo/pull/108) | IRLower | String toString() dispatch order — fell through to `__str_toString` (undefined) |

## Resolved Backend Questions

- **Runtime boundary:** Print helpers (`__arimo_println`, `__arimo_println_int`, `__arimo_print`) and string helpers (`__arimo_strlen`, `__arimo_strcat`, `__arimo_charat`, `__arimo_substr`, `__arimo_startswith`, `__arimo_endswith`, `__arimo_charcodeat`, `__arimo_i64_to_str`) are emitted inline by IRLower as IR functions.
- **ABI coverage:** Linux (syscall) and Windows (WinAPI) calling conventions implemented. Linux target uses syscall for IO, heap, exit. Windows target uses kernel32 imports.
- **Feature coverage:** All features used by the self-hosting compiler (62 modules) lower correctly. Unused features (interfaces, enums, generics, pattern matching, exceptions) are in parser/typechecker but not yet tested through IRLower.
- **Platform detection:** PR [#36](https://github.com/egecanakincioglu/arimo-bootstrap/pull/36) — default target uses `cfg!(target_os)` at bootstrap build time. `--target linux|windows` flag available.

## Known Issues

| Issue | Severity | Status |
|-------|----------|--------|
| ARC Phase 2-6 not implemented | HIGH | Planned, phased implementation |
| `Env.platform()` ELF native runtime crash | MEDIUM | Pre-existing, needs investigation |
| `inferClass` fallback (returns objCls for unknown methods) | LOW | Works in practice, defensive fix deferred |
| Interfaces, enums, generics untested in IRLower | LOW | Parser/typechecker support exists, not used by compiler |

## Documentation Policy

Docs separate:

- Implemented v1 behavior (current)
- Planned v1/v2 behavior (future)
- Historical Stage 0 bootstrap behavior (archived)
