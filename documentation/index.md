---
title: Arimo Language Documentation
description: Complete reference for the Arimo programming language v1.0
tags: [index, docs]
date: 2026-05-22
---

# Arimo Language Documentation

> Version: **v1.0** · Compiler: `arc` · Extension: `.arm`

Arimo is a statically-typed, object-oriented systems programming language with null safety, a layered memory model, and native code generation. The v1 compiler emits native executables through ArimoIR and its own backend.

## Getting Started

- [introduction](./getting-started/introduction.md) — What Arimo is and why it exists
- [installation](./getting-started/installation.md) — Install `arc` and set up your environment
- [hello-world](./getting-started/hello-world.md) — Your first Arimo program
- [arc-toml](./getting-started/arc-toml.md) — Project configuration file

## Language

- [variables-and-types](./language/variables-and-types.md) — Variables, primitive types, nullable types
- [operators](./language/operators.md) — Arithmetic, logical, bitwise, null-safe operators
- [control-flow](./language/control-flow.md) — `if`, `while`, `for`, `switch`, `match`
- [functions-and-methods](./language/functions-and-methods.md) — Methods, static methods, default parameters
- [classes](./language/classes.md) — Class declaration, constructors, inheritance
- [interfaces](./language/interfaces.md) — Interfaces and default method implementations
- [abstract-classes](./language/abstract-classes.md) — Abstract classes
- [enums](./language/enums.md) — Enumerations with and without associated data
- [structs](./language/structs.md) — Stack-allocated value types
- [generics](./language/generics.md) — Generic classes and bounded type parameters
- [lambdas-and-closures](./language/lambdas-and-closures.md) — Lambda expressions, closures, function types
- [exceptions](./language/exceptions.md) — `try` / `catch` / `finally` / `throw`
- [null-safety](./language/null-safety.md) — Nullable types, null-safe access, null coalescing
- [pattern-matching](./language/pattern-matching.md) — `match` statement and pattern syntax
- [defer](./language/defer.md) — Deferred execution
- [extension-methods](./language/extension-methods.md) — Extending types with `extend`
- [annotations](./language/annotations.md) — Built-in annotations
- [string-interpolation](./language/string-interpolation.md) — String formatting and interpolation
- [type-casting](./language/type-casting.md) — Explicit casts and type compatibility rules
- [async](./language/async.md) — `async` / `await` (parser support, v1.2.0 runtime)

## Memory

- [memory-model](./memory/memory-model.md) — Layered memory: ARC, GC, manual memory, planned BorrowChecker
- [low-level](./memory/low-level.md) — `RawPtr`, `Memory`, `extern "C"`, inline assembly

## Collections

- [collections-overview](./collections/collections-overview.md) — All collection types at a glance
- [list](./collections/list.md) — `List<T>` — dynamic array
- [hashmap](./collections/hashmap.md) — `HashMap<K, V>` and `TreeMap<K, V>`
- [array](./collections/array.md) — `Array<T, N>` — compile-time fixed-size, stack-allocated
- [slice](./collections/slice.md) — `Slice<T>` — non-owning view into memory
- [pair](./collections/pair.md) — `Pair<A, B>` — two-element tuple
- [result](./collections/result.md) — `Result<T, E>` — success or error value

## Standard Library

- [stdlib-overview](./stdlib/stdlib-overview.md) — Package system and import rules
- [arimo-lang](./stdlib/arimo-lang.md) — `IO`, `Math`, `String`, `Integer`, `Float`, `Boolean`, `Char`, `StringBuilder`
- [arimo-fs](./stdlib/arimo-fs.md) — `File`, `Path`, `Directory`, `FileMode`
- [arimo-io](./stdlib/arimo-io.md) — `InputStream`, `BufferedReader`, stream hierarchy
- [arimo-util](./stdlib/arimo-util.md) — `ArrayList`, `Optional`, `Scanner`, `Random`
- [arimo-env](./stdlib/arimo-env.md) — `Env`, `Process`

## CLI

- [arc-cli](./cli/arc-cli.md) — `arc build`, `arc run`, `arc check`, `arc init`, direct file mode

## Reference

- [syntax-cheatsheet](./reference/syntax-cheatsheet.md) — One-page syntax quick reference
- [vs-java-typescript](./reference/vs-java-typescript.md) — Arimo vs Java vs TypeScript comparison
- [versioning](./reference/versioning.md) — Semantic versioning and release history
- [project-status](./reference/project-status.md) — Current implementation status and open architecture questions

## Missing Features

Features from TypeScript, C, C++, and Java not present in Arimo v1.0:

- [missing-features-overview](#) — overview and navigation
- [type-system-advanced](#) — Union types, intersection types, conditional/mapped types (TypeScript)
- [generics-advanced](#) — Template specialization, SFINAE, concepts (C++)
- [type-narrowing](#) — `instanceof` pattern matching, type predicates (TypeScript / Java)
- [compile-time](#) — `constexpr`, `static_assert`, `if constexpr` (C++)
- [oop-advanced](#) — Multiple inheritance, friend classes, nested classes, anonymous classes
- [memory-advanced](#) — References, move semantics, bitfields, VLA (C/C++)
- [preprocessor](#) — C macros, `#define`, `#ifdef`, conditional compilation
- [reflection](#) — Reflection API, `Class<T>`, dynamic invocation (Java / TypeScript)
- [concurrency](#) — Threads, `synchronized`, atomics, mutex (Java / C++)
- [checked-exceptions](#) — Enforced checked exception declarations (Java)
- [syntax-sugar](#) — Destructuring, spread, named params, labeled break, getters/setters
- [string-formatting](#) — `String.format`, `printf`, regular expressions
- [modules-and-iteration](#) — Import aliasing, custom iterable protocol, dependency management
