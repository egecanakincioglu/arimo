---
title: Missing Features
description: Features present in TypeScript, C, C++, or Java that are not in Arimo v1.0.0
tags: [missing-features, reference]
date: 2026-05-22
---

# Missing Features

This section documents language features that exist in TypeScript, C, C++, or Java but are **not present** in Arimo v1.0.0. Each page explains what the feature is, which languages have it, and the Arimo workaround (if any).

This is not a bug list — these are deliberate gaps in v1.0.0 scope. Some are planned for future versions.

**Start here for priority analysis:** [[critical-gaps]] — all gaps ranked 🔴🟠🟡🟢 by real-world impact.

## Pages

### Priority Analysis
- [[critical-gaps]] — all gaps ranked by severity 🔴🟠🟡🟢

### Type System
- [[type-system-advanced]] — Union types, intersection types, conditional types, mapped types, template literal types (TypeScript)
- [[generics-advanced]] — Template specialization, SFINAE, concepts, partial specialization (C++)
- [[type-narrowing]] — `instanceof` pattern matching, type predicates, type guards (TypeScript / Java)
- [[compile-time]] — `constexpr`, `static_assert`, `if constexpr`, compile-time evaluation (C++)

### OOP
- [[oop-advanced]] — Multiple inheritance, friend classes, nested/inner classes, anonymous classes, operator overloading on classes

### Memory / Low-Level
- [[memory-advanced]] — References (T&), move semantics, bitfields, variable-length arrays, compound literals (C/C++)
- [[preprocessor]] — C preprocessor: macros, `#define`, `#ifdef`, compound literals, designated initializers

### Runtime
- [[reflection]] — Reflection API, runtime type information, `Class<T>` (Java / TypeScript)
- [[concurrency]] — Threads, `synchronized`, atomics, mutex, `volatile` in Java sense (Java / C++)
- [[checked-exceptions]] — Enforced checked exception declarations (`throws`) (Java)

### Syntax / Ergonomics
- [[syntax-sugar]] — Destructuring assignment, spread operator, property getters/setters, named parameters at call site, records/data classes
- [[string-formatting]] — `String.format`, `printf`-style formatting, regular expressions

### Standard Library
- [[stdlib-gaps]] — Math trig/rounding functions, date/time, collections utilities, number formatting

### Modules / Build
- [[modules-and-iteration]] — Import aliasing, wildcard re-export, custom iterable protocol, package-private visibility, dependency management

## Related

- [[versioning]] — planned future features
- [[variables-and-types]] — what Arimo's type system does support
- [[generics]] — Arimo generics
