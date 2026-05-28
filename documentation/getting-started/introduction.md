---
title: Introduction to Arimo
description: What Arimo is, its design goals, and core characteristics
tags: [getting-started]
date: 2026-05-22
---

# Introduction to Arimo

Arimo is a statically-typed, object-oriented systems programming language. The v1 `arc` compiler is written in Arimo and compiles `.arm` source files to native executables through its own backend.

## Design Goals

- **Null safety by default** — every nullable type is explicitly marked with `?`
- **Layered memory** — ARC + GC for managed objects, `@ManualMemory` for explicit control, BorrowChecker planned
- **Systems-capable** — inline assembly, `extern "C"`, raw pointers, SIMD types
- **OOP-first** — classes, interfaces, abstract classes, generics, inheritance
- **Zero surprises** — nothing is implicitly imported; every dependency is declared

## Key Characteristics

| Feature | Arimo |
|---|---|
| Typing | Static, strong, with type inference on locals |
| Null safety | `String?` for nullable, `String` never null |
| Memory | ARC + GC + Manual, BorrowChecker planned |
| Dispatch | `ClassName(args)` — no `new` keyword |
| Entry point | `public static main() : Void` |
| Source extension | `.arm` |
| Compiler | `arc` |
| Target | x86-64 native (Windows PE32+ / Linux ELF64) |

## Language Paradigm

Arimo is primarily object-oriented. Every program consists of classes, interfaces, enums, and structs. There are no top-level functions — all methods belong to a type.

```arm
package myapp;

public class Application {
    public static main() : Void {
        IO.println("Hello from Arimo!");
    }
}
```

## Version

This documentation covers **Arimo v1.0**. The Rust bootstrap compiler is historical Stage 0 context (`v0.5-beta`); the active v1 compiler lives in this repository and is written in Arimo.

## Related

- [installation](../getting-started/installation.md) — install `arc`
- [hello-world](../getting-started/hello-world.md) — first program step by step
- [arc-toml](../getting-started/arc-toml.md) — project configuration
- [versioning](../reference/versioning.md) — version history and SemVer policy
