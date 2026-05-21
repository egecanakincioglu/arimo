---
title: C Preprocessor
description: Macros, #define, #ifdef, conditional compilation — not in Arimo v1.0.0
tags: [missing-features, c, preprocessor]
date: 2026-05-22
---

# C Preprocessor

C/C++ preprocessor features that are **not in Arimo v1.0.0**.

## Object-Like Macros (`#define`)

**C:**
```c
#define MAX_SIZE 1024
#define PI 3.14159265358979
```

Not supported. Use constants or static fields:

```arm
public class Config {
    public static MAX_SIZE : Integer = 1024;
}

Float pi = Math.PI;
```

## Function-Like Macros

**C:**
```c
#define MAX(a, b) ((a) > (b) ? (a) : (b))
#define SQUARE(x) ((x) * (x))
```

Not supported. Use generic methods:

```arm
public static max<T extends Comparable<T>>(a: T, b: T) : T {
    return a.compareTo(b) > 0 ? a : b;
}
```

## Conditional Compilation (`#ifdef`, `#if`, `#endif`)

**C:**
```c
#ifdef DEBUG
    printf("debug: value = %d\n", value);
#endif

#if PLATFORM == WINDOWS
    // Windows-specific code
#endif
```

Not supported. Guard debug code with runtime flags:

```arm
Boolean DEBUG = true;
if (DEBUG) {
    IO.println("debug: " + value);
}
```

## `#include` / Header Files

Not applicable. Arimo uses `import` statements — no header/source split, no textual inclusion.

```arm
import arimo.fs.File;
import mypackage.MyClass;
```

## Stringification (`#`) and Token Pasting (`##`)

**C:**
```c
#define STRINGIFY(x) #x
#define CONCAT(a, b) a##b
```

Not supported. No preprocessor text manipulation.

## `__LINE__`, `__FILE__`, `__FUNCTION__`

**C:**
```c
printf("Error at %s:%d in %s\n", __FILE__, __LINE__, __FUNCTION__);
```

Not supported. No compile-time source location macros.

## Pragma Directives

**C:**
```c
#pragma once
#pragma pack(push, 1)
```

Not supported. Struct packing uses annotations in Arimo:

```arm
@Packed
public struct NetworkHeader {
    public magic  : u32;
    public length : u16;
}
```

## `#error` / `#warning`

**C:**
```c
#if !defined(REQUIRED_FLAG)
#error "REQUIRED_FLAG must be defined"
#endif
```

Not supported. Use runtime checks or rely on the compiler's static analysis.

## Macros with Variadic Arguments (`__VA_ARGS__`)

**C:**
```c
#define LOG(fmt, ...) fprintf(stderr, fmt, __VA_ARGS__)
```

Not supported. Use explicit arguments or `StringBuilder`:

```arm
StringBuilder sb = StringBuilder();
sb.append("log: ").append(msg);
IO.error(sb.toString());
```

## Related

- [[compile-time]] — `constexpr`, `static_assert`, compile-time evaluation (C++)
- [[annotations]] — Arimo `@Packed`, `@Align`, compiler hints
- [[memory-advanced]] — bitfields, compound literals
- [[low-level]] — extern C, inline assembly
