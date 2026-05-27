---
title: Type Casting
description: Explicit casts with as, type compatibility rules, and implicit conversions
tags: [language]
date: 2026-05-22
---

# Type Casting

## Explicit Cast — `as`

Use `as` to explicitly convert between compatible types:

```arm
u64 big   = 1000000;
u32 small = big as u32;

u32 word   = someU64 as u32;
i32 signed = someU32 as i32;
u8  low    = someU32 as u8;

Float f = someInteger as Float;
```

`as` truncates on narrowing conversions — no runtime check, no exception.

## Implicit Conversions

Arimo allows these implicit conversions:

| From | To | Condition |
|---|---|---|
| Integer literal | `Float` | Literal only — `Float f = 3;` → `3.0` |
| Integer literal | Any sized integer (`u8`..`i64`) | Literal only |
| Sized integer | `Integer` | Always — `Integer n = someU32;` |
| `HashMap` / `TreeMap` | `Map<K,V>` interface | Always |

```arm
Float pi    = 3;           // literal 3 → 3.0
u8    b     = 255;         // literal 255 → u8
Integer n   = someU32;    // u32 → Integer always OK
```

## No Implicit Widening

Non-literal widening requires explicit cast:

```arm
u32   a = 5;
// u64 b = a;     // ERROR — implicit widening not allowed
u64   b = a as u64;   // OK
```

## Object Casting

Casting between class types uses `as`. Invalid casts produce a runtime error:

```arm
Shape s = Circle(5.0);
Circle c = s as Circle;
```

## Related

- [variables-and-types](../language/variables-and-types.md) — primitive types and sized integers
- [null-safety](../language/null-safety.md) — nullable type narrowing via smart cast
- [operators](../language/operators.md) — `as` operator precedence
