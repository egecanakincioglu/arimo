---
title: Introduction to Arimo
description: What Arimo is, its design goals, and core characteristics
tags: [getting-started]
date: 2026-05-22
---

# Introduction to Arimo

Arimo is a statically-typed, object-oriented systems programming language. It compiles `.arm` source files to native executables using the `arc` compiler — no LLVM, no GCC, no runtime required.

## Design Goals

- **Null safety by default** — every nullable type is explicitly marked with `?`
- **No garbage collector** — memory managed through ARC (Automatic Reference Counting) and a BorrowChecker
- **Systems-capable** — inline assembly, `extern "C"`, raw pointers, SIMD types
- **OOP-first** — classes, interfaces, abstract classes, generics, inheritance
- **Zero surprises** — nothing is implicitly imported; every dependency is declared

## Key Characteristics

| Feature | Arimo |
|---|---|
| Typing | Static, strong, with type inference on locals |
| Null safety | `String?` for nullable, `String` never null |
| Memory | ARC + BorrowChecker (no GC) |
| Dispatch | `ClassName(args)` — no `new` keyword |
| Entry point | `public static main() : Void` |
| Source extension | `.arm` |
| Compiler | `arc` |
| Target | x86-64 native (Windows PE32+) |

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

This documentation covers **Arimo v1.0.0** — the first public release. The compiler (`arc`) is self-hosting: `arc` is written in Arimo and compiled by itself.

## Related

- [installation](../getting-started/installation.md) — install `arc`
- [hello-world](../getting-started/hello-world.md) — first program step by step
- [arc-toml](../getting-started/arc-toml.md) — project configuration
- [versioning](../reference/versioning.md) — version history and SemVer policy
