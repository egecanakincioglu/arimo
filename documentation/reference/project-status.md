---
title: Project Status
description: Current implementation status, historical bootstrap context, and open architecture questions
tags: [reference, status]
date: 2026-05-28
---

# Project Status

## Current Compiler

The active v1 compiler is the Arimo-written compiler in this repository. Its main pipeline is:

```text
.arm -> Lexer -> Parser -> TypeChecker -> NativeBackend -> PE/ELF executable
```

The Rust bootstrap compiler is historical Stage 0 context and should be labeled `v0.5-beta`. It remains useful for understanding older implementation decisions, but it is not the current v1 native compiler.

## Native Backend Status

The active backend is `NativeBackend`:

- `IRLower` lowers AST to ArimoIR.
- `RegAlloc` assigns physical registers/spill slots.
- `IRToX64` emits x86-64 machine code.
- `PEWriter` writes Windows PE32+ executables.
- `ELFWriter` writes Linux ELF64 executables.

`arimo/compiler/codegen/CodeGen.arm` is older LLVM-text oriented codegen kept for context. It is not the active backend called by `Main.arm`.

## Open Native Backend Questions

These need explicit project decisions before the backend can be described as stable:

- Runtime boundary: which helpers are emitted by native backend versus treated as stdlib/runtime calls.
- Managed memory lowering: exact ARC+GC object layout and where `@ManualMemory` bypasses it.
- ABI coverage: Windows and Linux calling conventions, stack alignment, varargs, and extern calls.
- Feature coverage: which parser/typechecker features are guaranteed to lower correctly today.
- Legacy cleanup: whether `CodeGen.arm` stays as archive context, moves to a legacy folder, or is removed.

## Memory Model Status

The intended model is ARC + GC for ordinary objects, `@ManualMemory` for explicit control, and a later BorrowChecker layer.

BorrowChecker is intentionally not implemented in the v1 compiler yet. The Rust bootstrap has a historical BorrowChecker implementation; v1 needs its own implementation later.

## Documentation Policy

Docs must separate:

- implemented v1 behavior
- planned v1/v2 behavior
- historical Stage 0 bootstrap behavior
