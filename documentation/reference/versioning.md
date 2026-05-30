---
title: Versioning
description: Arimo semantic versioning policy, version history, release process, and self-hosting verification
tags: [reference]
date: 2026-05-30
---

# Versioning

Arimo uses a simple public version line for the v1 compiler: `MAJOR.MINOR`.

## Version Rules

| Part | Incremented When |
|---|---|
| `MAJOR` | Breaking syntax or semantic change — existing `.arm` files may stop compiling |
| `MINOR` | New language feature — new keyword, syntax construct, or major stdlib module |
| Patch/build metadata | Bug fix, compiler correctness improvement, or minor stdlib addition |

## Current Version

**v1.0** — first public v1 native compiler milestone

### What v1.0 includes

- Lexer, Parser, TypeChecker
- Full OOP: classes, abstract classes, interfaces, enums, structs, generics
- Native backend with ArimoIR, x86-64 encoding, PE/ELF writers
- ARC/GC/manual memory model design; implementation is staged
- Exception handling (`try`/`catch`/`finally`)
- Pattern matching (`match`) with guards, binding, multi-pattern
- Lambda expressions and closures
- Extension methods (`extend`)
- Null safety (`String?`, `?.`, `??`)
- Defer
- All annotations (`@ManualMemory`, `@ForceInline`, `@Packed`, etc.)
- Collections: `List<T>`, `HashMap<K,V>`, `TreeMap<K,V>`, `Array<T,N>`, `Slice<T>`, `Pair<A,B>`, `Result<T,E>`
- Standard library: `arimo.lang`, `arimo.fs`, `arimo.io`, `arimo.util`, `arimo.env`, `arimo.process`
- `arc` CLI: `build`, `run`, `check`, `init`, direct `.arm` file compilation
- Native code generation — no LLVM, no GCC required
- Self-hosting: `arc` is written in Arimo and compiled by itself (verified: S2≡S3≡S4 byte-identical, deterministic)
- Test suite: 17/17 pass (classes, strings, lists, constructors, inheritance)

BorrowChecker is intentionally not part of the v1.0 compiler implementation yet. The older Rust bootstrap includes a historical BorrowChecker; v1 will receive its own BorrowChecker in a later iteration.

## Bootstrap History

The Rust bootstrap compiler is historical Stage 0 context and should be labeled **v0.5-beta**. It exists to preserve the language's implementation history and bootstrap path, not as the current v1 native compiler.

## Planned Versions

| Version | Target Feature |
|---|---|
| v1.1 | Full generic instantiation (monomorphization) |
| v1.2 | `async`/`await`, coroutines |
| v1.3 | Operator overloading on classes (currently only structs) |
| v2.0 | Fully self-contained toolchain with completed memory-safety layers |

## arc --version

```
arc --version
```

Output:

```
arc v1.0
```

## Git Tags

Releases are tagged in the repository:

```
v1.0
```

## Related

- [[introduction]] — what Arimo is
- [[installation]] — install the current version
