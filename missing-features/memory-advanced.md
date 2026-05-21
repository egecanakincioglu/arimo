---
title: Advanced Memory Features
description: C++ references, move semantics, bitfields, VLAs, compound literals — not in Arimo v1.0.0
tags: [missing-features, memory]
date: 2026-05-22
---

# Advanced Memory Features

Low-level memory features from C and C++ that are **not in Arimo v1.0.0**.

## References (C++)

**C++:**
```cpp
void increment(int& x) { x++; }

int n = 5;
increment(n);   // n is now 6
```

Arimo has no reference types (`T&`). Pass-by-reference semantics are not available for primitive types.

**Workaround:** Return a value:

```arm
public increment(x: Integer) : Integer { return x + 1; }
Integer n = 5;
n = increment(n);
```

Or use a wrapper class:

```arm
public class Ref<T> { public value : T; }
```

## Move Semantics / Rvalue References (C++)

**C++:**
```cpp
std::vector<int> a = makeVector();
std::vector<int> b = std::move(a);  // a is now empty, no copy
```

Not supported. Arimo uses ARC (automatic reference counting) — objects are reference-counted, not moved. The BorrowChecker tracks single-owner moves at compile time, but there is no `std::move` equivalent and no explicit destructor calls on move.

See [[memory-model]] for Arimo's three-layer memory approach.

## Bitfields (C)

**C:**
```c
struct Flags {
    unsigned int active : 1;
    unsigned int mode   : 3;
    unsigned int level  : 4;
};
```

Not supported. Arimo structs have no bitfield syntax. Use explicit masking with sized integer types:

```arm
public struct Flags {
    public raw : u8;   // bit 0 = active, bits 1-3 = mode, bits 4-7 = level
}
```

## Variable-Length Arrays / VLA (C99)

**C:**
```c
void process(int n) {
    int buf[n];   // stack array sized at runtime
}
```

Not supported. Arimo arrays are fixed-size at compile time (`Array<T, N>`). Use `List<T>` for runtime-sized collections:

```arm
public process(n: Integer) : Void {
    List<Integer> buf = List<Integer>(n);
}
```

## Compound Literals (C99)

**C:**
```c
draw_point((struct Point){ .x = 3, .y = 4 });
```

Not supported as an expression. Arimo struct literals must be assigned to a named variable:

```arm
Point p = Point(3, 4);
drawPoint(p);
```

## Designated Initializers (C99 / C++20)

**C:**
```c
struct Config { int width; int height; int depth; };
Config cfg = { .width = 1920, .height = 1080 };   // depth = 0 implicitly
```

Not supported. Arimo constructors use positional arguments only:

```arm
Config cfg = Config(1920, 1080, 0);
```

## `restrict` Keyword (C)

**C:**
```c
void copy(int* restrict dst, const int* restrict src, int n);
```

Not supported. No pointer aliasing hint mechanism exists in Arimo.

## Flexible Array Members (C)

**C:**
```c
struct Header {
    int count;
    char data[];   // flexible trailing array
};
```

Not supported. Use [[low-level]] `RawPtr` for raw memory layouts.

## `const` Pointers vs `const` Data (C/C++)

**C:**
```c
const int* p;        // pointer to const int
int* const p;        // const pointer to int
const int* const p;  // const pointer to const int
```

Arimo has `readonly` for fields and no mutable/immutable pointer qualifiers. `RawPtr` is always mutable.

## Stack Allocation of Classes

In C++ any class can be stack-allocated. In Arimo, classes are always heap-allocated. Only [[structs]] are stack-allocated.

## Related

- [[memory-model]] — Arimo ARC + BorrowChecker + Manual
- [[low-level]] — RawPtr, Memory.alloc, extern C, inline asm
- [[structs]] — stack-allocated value types
- [[preprocessor]] — C macro / compile-time substitution gaps
