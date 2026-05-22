---
title: Variables and Types
description: Variable declaration syntax, primitive types, nullable types, and type rules
tags: [language]
date: 2026-05-22
---

# Variables and Types

## Variable Declaration

Local variables use **type-before-name** syntax:

```arm
String  name  = "Arimo";
Integer count = 0;
Boolean done  = false;
Float   pi    = 3.14;
```

## Nullable Types

Append `?` to any type to allow `null`:

```arm
String?  title    = null;
Integer? maybeNum = null;
```

A non-nullable type **cannot** hold `null` — the compiler enforces this statically.

## Primitive Types

| Type | LLVM | Description |
|---|---|---|
| `Integer` | `i64` | 64-bit signed integer |
| `Float` | `f64` | 64-bit double precision |
| `Boolean` | `i1` | `true` or `false` |
| `String` | `ptr` | UTF-8, null-terminated |
| `Char` | `i8` | Single character |
| `Void` | `void` | No value (return type only) |
| `noreturn` | attribute | Function never returns |

## Sized Integer Types

For systems-level code, Arimo provides fixed-width integers:

| Type | Size | Signed |
|---|---|---|
| `i8` | 8-bit | Yes |
| `i16` | 16-bit | Yes |
| `i32` | 32-bit | Yes |
| `i64` | 64-bit | Yes |
| `u8` | 8-bit | No |
| `u16` | 16-bit | No |
| `u32` | 32-bit | No |
| `u64` | 64-bit | No |

```arm
u8  byte  = 255;
u32 word  = 0xDEADBEEF;
i32 signed = -1;
```

## Field Declaration

Inside a class, fields use **name-colon-type** syntax (reversed from locals):

```arm
public class Task {
    private readonly id    : String;
    private          title : String;
    public  static   MAX   : Integer = 100;
}
```

| Placement | Syntax | Example |
|---|---|---|
| Local variable | `Type name` | `String name = "x";` |
| Field | `name : Type` | `private id : String;` |
| Parameter | `name: Type` | `(radius: Float)` |
| Return type | `method() : Type` | `getArea() : Float` |

## Type Alias

```arm
type NodeId   = u32;
type Callback = (String) -> Void;
type Mat4     = Array<Float, 16>;
```

## sizeOf

```arm
Integer.sizeOf()   // 8
Float.sizeOf()     // 8
u32.sizeOf()       // 4
u8.sizeOf()        // 1
```

## SIMD Types

Four built-in vector types for SIMD operations:

| Type | Elements | Element Type | LLVM |
|---|---|---|---|
| `Vec4f` | 4 | `Float` | `<4 x float>` |
| `Vec8f` | 8 | `Float` | `<8 x float>` |
| `Vec4i` | 4 | `Integer` | `<4 x i32>` |
| `Vec8i` | 8 | `Integer` | `<8 x i32>` |

### Construction

```arm
Vec4f v4 = Vec4f(1.0, 2.0, 3.0, 4.0);
Vec8f v8 = Vec8f(1.0, 2.0, 3.0, 4.0, 5.0, 6.0, 7.0, 8.0);
Vec4i vi = Vec4i(1, 2, 3, 4);
```

### Methods

All SIMD types support:

```arm
v4 + other         // operator+
v4 - other         // operator-
v4 * other         // operator*
v4 / other         // operator/

Float len  = v4.length();       // vector magnitude
Vec4f norm = v4.normalize();    // unit vector
Float d    = v4.dot(other);     // dot product
```

> SIMD type registration is in the type system (v1.0.0). Full IR emission for all SIMD ops is targeted for a future release.

## Related

- [type-casting](../language/type-casting.md) — explicit casts with `as`
- [null-safety](../language/null-safety.md) — nullable types, `?.`, `??`
- [operators](../language/operators.md) — arithmetic and comparison operators
