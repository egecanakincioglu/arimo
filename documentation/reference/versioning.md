---
title: Versioning
description: Arimo semantic versioning policy, version history, and release process
tags: [reference]
date: 2026-05-22
---

# Versioning

Arimo uses **Semantic Versioning (SemVer)**: `MAJOR.MINOR.PATCH`

## Version Rules

| Part | Incremented When |
|---|---|
| `MAJOR` | Breaking syntax or semantic change — existing `.arm` files may stop compiling |
| `MINOR` | New language feature — new keyword, syntax construct, or major stdlib module |
| `PATCH` | Bug fix, compiler correctness improvement, or minor stdlib addition |

## Current Version

**v1.0.0** — first public release

### What v1.0.0 includes

- Lexer, Parser, TypeChecker, BorrowChecker
- Full OOP: classes, abstract classes, interfaces, enums, structs, generics
- ARC memory management
- Exception handling (`try`/`catch`/`finally`)
- Pattern matching (`match`) with guards, binding, multi-pattern
- Lambda expressions and closures
- Extension methods (`extend`)
- Null safety (`String?`, `?.`, `??`)
- Defer
- All annotations (`@ManualMemory`, `@ForceInline`, `@Packed`, etc.)
- Collections: `List<T>`, `HashMap<K,V>`, `TreeMap<K,V>`, `Array<T,N>`, `Slice<T>`, `Pair<A,B>`, `Result<T,E>`
- Standard library: `arimo.lang`, `arimo.fs`, `arimo.io`, `arimo.util`, `arimo.env`, `arimo.process`
- `arc` CLI: `build`, `run`, `check`, `clean`, `init`
- Native code generation — no LLVM, no GCC required
- Self-hosting: `arc` is written in Arimo and compiled by itself

## Planned Versions

| Version | Target Feature |
|---|---|
| v1.1.0 | Full generic instantiation (monomorphization) |
| v1.2.0 | `async`/`await`, coroutines |
| v1.3.0 | Operator overloading on classes (currently only structs) |
| v2.0.0 | Fully self-contained toolchain with no external dependencies |

## arc --version

```
arc --version
```

Output:

```
arc 1.0.0 (arimo-language)
```

## Git Tags

Releases are tagged in the repository:

```
v1.0.0
```

## Related

- [[introduction]] — what Arimo is
- [[installation]] — install the current version
