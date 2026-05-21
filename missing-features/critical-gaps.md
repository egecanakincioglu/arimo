---
title: Critical Gaps — Priority Analysis
description: Missing features ranked by impact — what blocks real-world use vs. what is just inconvenient
tags: [missing-features, reference]
date: 2026-05-22
---

# Critical Gaps — Priority Analysis

Four severity levels:

| Level | Meaning |
|---|---|
| 🔴 **Critical** | Blocks entire categories of real-world programs |
| 🟠 **High** | Significant pain, no clean workaround |
| 🟡 **Medium** | Workaround exists but is verbose or fragile |
| 🟢 **Low** | Minor inconvenience, workaround is natural |

---

## 🔴 Critical

### 1. Regular Expressions

Without regex, every non-trivial string parsing task requires hand-written character loops. Validators (email, URL, date), parsers, log analyzers, config readers — all severely harder.

**Impact:** Any program that processes text input is affected.

**Workaround:** Manual `charAt` / `split` loops. Sufficient only for simple cases.

See [[string-formatting]].

---

### 2. Math — Floor, Ceil, Round, Min, Max

`Math.floor(x)`, `Math.ceil(x)`, `Math.round(x)`, `Math.min(a, b)`, `Math.max(a, b)` — none exist as builtins.

**Impact:** Every numeric algorithm that rounds or clamps is affected. Rendering, physics, financial calculations.

**Workaround:** `extern "C"` bindings to `floor`, `ceil`, `fmin`, `fmax` from C runtime. Requires `@ManualMemory` context and verbosity.

```arm
extern "C" {
    floor(x: Float) : Float;
    ceil(x: Float)  : Float;
    fmin(a: Float, b: Float) : Float;
    fmax(a: Float, b: Float) : Float;
}
```

See [[stdlib-gaps]].

---

### 3. No Dependency Management

`arc.toml` has no `[dependencies]` section. No package registry. No way to pull in third-party libraries.

**Impact:** Every project must hand-roll everything. No ecosystem possible.

**Workaround:** None. Copy source manually.

See [[modules-and-iteration]].

---

### 4. No Async/Await Runtime

`async`/`await` is parsed and accepted by the compiler but produces incorrect output at codegen. No coroutine scheduler exists.

**Impact:** Any I/O-heavy program (HTTP server, file processing pipeline, CLI tool with network calls) cannot use async. All I/O is blocking.

**Planned:** v1.2.0.

See [[async]], [[concurrency]].

---

### 5. No Threading

Single-threaded only. No `Thread`, no `Mutex`, no atomics.

**Impact:** Cannot utilize multicore CPUs. Long-running CPU work blocks the whole program.

**Planned:** No roadmap yet.

See [[concurrency]].

---

## 🟠 High

### 6. No String Formatting

No `String.format`, no `printf`-style, no fixed-decimal float output.

**Impact:** Every formatted output (tables, reports, logs with numbers) requires manual string building. `Float.toString(3.14159)` produces full precision — no way to write `"3.14"` without arithmetic.

**Workaround:** `StringBuilder` + manual arithmetic for decimal places. Painful at scale.

See [[string-formatting]].

---

### 7. No Date/Time API

`Time.now()` returns a `String`. `Time.nowMillis()` returns Unix ms. No structured date type, no arithmetic, no formatting.

**Impact:** Any application that works with dates (scheduling, logging, expiry checks) must parse and manipulate timestamps manually.

**Workaround:** Call C `time.h` functions via `extern "C"`.

See [[stdlib-gaps]].

---

### 8. No Custom Iterable Protocol

`for (T item : collection)` works only on `List<T>`, `Array<T, N>`, `Slice<T>`. User classes cannot implement iteration.

**Impact:** Every custom collection type (graph, tree, queue, lazy sequence) cannot participate in for-each. Must expose a `toList()` and pay the allocation cost.

**Workaround:** `toList()` + iterate result, or manual index loop.

See [[modules-and-iteration]].

---

### 9. No Reflection

No `getClass()`, no method enumeration, no dynamic invocation.

**Impact:** Impossible to build: serialization frameworks (JSON/binary), dependency injection containers, test frameworks that discover tests by annotation, ORMs.

**Workaround:** Manual visitor pattern or code generation. Does not scale to library use.

See [[reflection]].

---

### 10. Math — Trig and Log

`Math.sin`, `Math.cos`, `Math.tan`, `Math.log`, `Math.log10` — not available.

**Impact:** Any graphics, physics, audio DSP, or scientific computing is blocked without calling into C.

**Workaround:** `extern "C"` to C runtime.

See [[stdlib-gaps]].

---

## 🟡 Medium

### 11. No Import Aliasing

`import arimo.fs.File as F` — not supported. Name collisions between packages require restructuring.

**Workaround:** Rename local variables after construction. Awkward but functional.

See [[modules-and-iteration]].

### 12. No Multi-Catch

Each exception type needs a separate `catch` block. Verbose for methods that throw several types.

**Workaround:** Catch base `Exception`, check `message()` content.

See [[checked-exceptions]].

### 13. No Destructuring

`List<String> [a, b, c]` not supported. Must call `get(0)`, `get(1)`, etc.

**Workaround:** Verbose but straightforward.

See [[syntax-sugar]].

### 14. No Named Parameters at Call Site

`createUser(name: "Alice", age: 30)` — not supported.

**Impact:** Long constructors with same-type parameters (e.g., `Rect(x, y, w, h)` — all Integers) are easy to call in the wrong order.

**Workaround:** Create a builder class, or use clear variable names before calling.

See [[syntax-sugar]].

### 15. No Union Types

No `String | Integer`. Must use sealed class hierarchy or `Result<T, E>`.

**Workaround:** Clean but verbose. Interface-based polymorphism covers most cases.

See [[type-system-advanced]].

### 16. No Multiple Inheritance

Single `extends` only. All multi-parent patterns require interfaces (which cannot hold state).

**Workaround:** Interfaces with default methods + composition via fields.

See [[oop-advanced]].

---

## 🟢 Low

### 17. No Compile-Time Evaluation (`constexpr`)

Constants computed at compile time are not possible. All function calls are runtime.

**Workaround:** Pre-compute manually and use a literal constant.

See [[compile-time]].

### 18. No Labeled Break / Continue

Breaking out of nested loops requires a flag variable.

**Workaround:** `Boolean found = false` + loop condition.

See [[syntax-sugar]].

### 19. No Spread / Destructuring for Collections

`[...list1, ...list2]` not supported.

**Workaround:** Manual loop to append.

See [[syntax-sugar]].

### 20. No Template / Macro System

No compile-time code generation, no `#define` shorthand.

**Workaround:** Functions cover most cases. Boilerplate exists in some patterns.

See [[preprocessor]], [[compile-time]].

### 21. No C++ References (`T&`)

Pass-by-reference for primitives not available. Return values instead.

**Workaround:** Return new value from function.

See [[memory-advanced]].

---

## Summary Table

| # | Gap | Severity | Workaround Quality |
|---|---|---|---|
| 1 | Regular expressions | 🔴 Critical | Poor |
| 2 | Math floor/ceil/min/max | 🔴 Critical | Requires extern C |
| 3 | Dependency management | 🔴 Critical | None |
| 4 | Async/await runtime | 🔴 Critical | None (planned v1.2.0) |
| 5 | Threading | 🔴 Critical | None |
| 6 | String formatting | 🟠 High | Verbose |
| 7 | Date/Time API | 🟠 High | Requires extern C |
| 8 | Custom iterable | 🟠 High | toList() allocation |
| 9 | Reflection | 🟠 High | Manual visitor |
| 10 | Math trig/log | 🟠 High | Requires extern C |
| 11 | Import aliasing | 🟡 Medium | Rename variables |
| 12 | Multi-catch | 🟡 Medium | Catch base Exception |
| 13 | Destructuring | 🟡 Medium | get(0), get(1) |
| 14 | Named parameters | 🟡 Medium | Builder pattern |
| 15 | Union types | 🟡 Medium | Sealed hierarchy |
| 16 | Multiple inheritance | 🟡 Medium | Interface + composition |
| 17 | constexpr | 🟢 Low | Manual literal |
| 18 | Labeled break | 🟢 Low | Flag variable |
| 19 | Spread operator | 🟢 Low | Manual loop |
| 20 | Macros | 🟢 Low | Functions |
| 21 | References (T&) | 🟢 Low | Return value |

## Related

- [[missing-features-overview]] — full feature gap index
- [[versioning]] — what's planned for future versions
