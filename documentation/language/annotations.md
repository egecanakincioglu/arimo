---
title: Annotations
description: All built-in annotations in Arimo and their effects
tags: [language]
date: 2026-05-22
---

# Annotations

Annotations begin with `@` and appear before a class, method, field, or struct.

## Code Generation

| Annotation | Target | Effect |
|---|---|---|
| `@ForceInline` | Method | Always inlined — no call overhead |
| `@Pure` | Method | No side effects — safe for optimization |
| `@ManualMemory` | Class/Method | Skip ARC — manual memory management |
| `@Section(".name")` | Method/Field | Place in specific linker section |
| `@CallingConvention("C")` | Method | Use C calling convention |
| `@CallingConvention("Windows")` | Method | Use Windows stdcall |
| `@CallingConvention("Interrupt")` | Method | CPU interrupt handler |

```arm
@ForceInline
public dot(other: Vec3) : Float {
    return this.x * other.x + this.y * other.y + this.z * other.z;
}

@Pure
public static square(x: Float) : Float {
    return x * x;
}
```

## Memory Layout

| Annotation | Target | Effect |
|---|---|---|
| `@Packed` | Struct | Remove padding bytes |
| `@Align(N)` | Struct/Field | Set minimum alignment to N bytes |

```arm
@Packed
public struct PacketHeader {
    magic   : u16;
    version : u8;
    flags   : u8;
}

@Align(16)
public struct SimdVec {
    data : Array<Float, 4>;
}
```

## Memory Management

| Annotation | Effect |
|---|---|
| `@ManualMemory` | Disable ARC for this class; manage memory manually |
| `@Immutable` | All fields are `readonly` — enforced by compiler |

```arm
@ManualMemory
public class HardwareDriver {
    public static readStatus() : u32 { ... }
}

@Immutable
public class Point {
    private readonly x : Float;
    private readonly y : Float;
    ...
}
```

## Developer Intent

| Annotation | Effect |
|---|---|
| `@Deprecated("msg")` | Compiler emits warning when this is used |
| `@Experimental` | API may change without notice |
| `@SuppressWarnings("type")` | Suppress a specific warning |
| `@Throws(ExceptionType)` | Document that method may throw |
| `@Sealed` | Only subclassable within same package |
| `@FunctionalInterface` | Interface must have exactly one abstract method |

```arm
@Deprecated("Use NewService instead")
public class OldService { ... }

@Experimental
public class GpuCompute { ... }

@Throws(IOException)
public static read(path: String) : String { ... }

@Sealed
public abstract class Shape { ... }
```

## Branch Hints

| Annotation | Effect |
|---|---|
| `@Likely` | Branch is usually taken (hint to optimizer) |
| `@Unlikely` | Branch is rarely taken |

```arm
if @Likely (x > 0) {
    ...
}
if @Unlikely (err != null) {
    ...
}

@Pure
public static clamp(v: Float, min: Float, max: Float) : Float {
    if @Likely (v >= min && v <= max) {
        return v;
    }
    return v < min ? min : max;
}
```

## Freestanding (Bare-Metal)

```arm
@Freestanding
package kernel.boot;
```

Applied to the `package` declaration. No stdlib code is linked — not even `malloc`. For OS kernel or embedded targets.

## Related

- [structs](../language/structs.md) — `@Packed`, `@Align`
- [memory-model](../memory/memory-model.md) — `@ManualMemory`
- [low-level](../memory/low-level.md) — `@Section`, `@CallingConvention`
- [interfaces](../language/interfaces.md) — `@FunctionalInterface`
- [abstract-classes](../language/abstract-classes.md) — `@Sealed`
