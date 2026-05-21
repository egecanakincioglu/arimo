---
title: Arimo Language Documentation
description: Complete reference for the Arimo programming language v1.0.0
tags: [index, docs]
date: 2026-05-22
---

# Arimo Language Documentation

> Version: **v1.0.0** · Compiler: `arc` · Extension: `.arm`

Arimo is a statically-typed, object-oriented systems programming language with automatic reference counting, null safety, and native code generation. It compiles directly to native executables without requiring LLVM or an external C compiler.

## Getting Started

- [[introduction]] — What Arimo is and why it exists
- [[installation]] — Install `arc` and set up your environment
- [[hello-world]] — Your first Arimo program
- [[arc-toml]] — Project configuration file

## Language

- [[variables-and-types]] — Variables, primitive types, nullable types
- [[operators]] — Arithmetic, logical, bitwise, null-safe operators
- [[control-flow]] — `if`, `while`, `for`, `switch`, `match`
- [[functions-and-methods]] — Methods, static methods, default parameters
- [[classes]] — Class declaration, constructors, inheritance
- [[interfaces]] — Interfaces and default method implementations
- [[abstract-classes]] — Abstract classes
- [[enums]] — Enumerations with and without associated data
- [[structs]] — Stack-allocated value types
- [[generics]] — Generic classes and bounded type parameters
- [[lambdas-and-closures]] — Lambda expressions, closures, function types
- [[exceptions]] — `try` / `catch` / `finally` / `throw`
- [[null-safety]] — Nullable types, null-safe access, null coalescing
- [[pattern-matching]] — `match` statement and pattern syntax
- [[defer]] — Deferred execution
- [[extension-methods]] — Extending types with `extend`
- [[annotations]] — Built-in annotations
- [[string-interpolation]] — String formatting and interpolation
- [[type-casting]] — Explicit casts and type compatibility rules
- [[async]] — `async` / `await` (parser support, v1.2.0 runtime)

## Memory

- [[memory-model]] — Three-layer memory: BorrowChecker, ARC, GC
- [[low-level]] — `RawPtr`, `Memory`, `extern "C"`, inline assembly

## Collections

- [[collections-overview]] — All collection types at a glance
- [[list]] — `List<T>` — dynamic array
- [[hashmap]] — `HashMap<K, V>` and `TreeMap<K, V>`
- [[array]] — `Array<T, N>` — compile-time fixed-size, stack-allocated
- [[slice]] — `Slice<T>` — non-owning view into memory
- [[pair]] — `Pair<A, B>` — two-element tuple
- [[result]] — `Result<T, E>` — success or error value

## Standard Library

- [[stdlib-overview]] — Package system and import rules
- [[arimo-lang]] — `IO`, `Math`, `String`, `Integer`, `Float`, `Boolean`, `Char`, `StringBuilder`
- [[arimo-fs]] — `File`, `Path`, `Directory`, `FileMode`
- [[arimo-io]] — `InputStream`, `BufferedReader`, stream hierarchy
- [[arimo-util]] — `ArrayList`, `Optional`, `Scanner`, `Random`
- [[arimo-env]] — `Env`, `Process`

## CLI

- [[arc-cli]] — `arc build`, `arc run`, `arc check`, `arc clean`, `arc init`

## Reference

- [[syntax-cheatsheet]] — One-page syntax quick reference
- [[vs-java-typescript]] — Arimo vs Java vs TypeScript comparison
- [[versioning]] — Semantic versioning and release history

## Missing Features

Features from TypeScript, C, C++, and Java not present in Arimo v1.0.0:

- [[missing-features-overview]] — overview and navigation
- [[type-system-advanced]] — Union types, intersection types, conditional/mapped types (TypeScript)
- [[generics-advanced]] — Template specialization, SFINAE, concepts (C++)
- [[type-narrowing]] — `instanceof` pattern matching, type predicates (TypeScript / Java)
- [[compile-time]] — `constexpr`, `static_assert`, `if constexpr` (C++)
- [[oop-advanced]] — Multiple inheritance, friend classes, nested classes, anonymous classes
- [[memory-advanced]] — References, move semantics, bitfields, VLA (C/C++)
- [[preprocessor]] — C macros, `#define`, `#ifdef`, conditional compilation
- [[reflection]] — Reflection API, `Class<T>`, dynamic invocation (Java / TypeScript)
- [[concurrency]] — Threads, `synchronized`, atomics, mutex (Java / C++)
- [[checked-exceptions]] — Enforced checked exception declarations (Java)
- [[syntax-sugar]] — Destructuring, spread, named params, labeled break, getters/setters
- [[string-formatting]] — `String.format`, `printf`, regular expressions
- [[modules-and-iteration]] — Import aliasing, custom iterable protocol, dependency management
