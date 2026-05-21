---
title: Structs
description: Stack-allocated value types with optional operator overloading
tags: [language]
date: 2026-05-22
---

# Structs

Structs are stack-allocated value types. Unlike classes, structs are copied on assignment — they do not use ARC.

## Declaration

```arm
public struct Vec3 {
    x : Float;
    y : Float;
    z : Float;

    @ForceInline
    public operator +(other: Vec3) : Vec3 {
        return Vec3(this.x + other.x, this.y + other.y, this.z + other.z);
    }

    public operator ==(other: Vec3) : Boolean {
        return this.x == other.x && this.y == other.y && this.z == other.z;
    }

    @ForceInline
    public dot(other: Vec3) : Float {
        return this.x * other.x + this.y * other.y + this.z * other.z;
    }

    public length() : Float {
        return Math.sqrt(this.dot(this));
    }
}
```

## Construction

Auto-constructor uses field declaration order:

```arm
Vec3 pos = Vec3(0.0, 1.0, 0.0);
Vec3 vel = Vec3(1.0, 0.0, 0.5);
```

## Operator Overloading

Structs can define `operator` methods for `+`, `-`, `*`, `/`, `==`:

```arm
Vec3 sum    = pos + vel;
Vec3 diff   = pos - vel;
Vec3 scaled = vel * 2.0;
Boolean eq  = pos == vel;
```

## Static Constants

```arm
public struct Color {
    r : u8; g : u8; b : u8; a : u8;

    public static readonly WHITE : Color = Color(255, 255, 255, 255);
    public static readonly BLACK : Color = Color(0, 0, 0, 255);

    public withAlpha(alpha: u8) : Color {
        return Color(this.r, this.g, this.b, alpha);
    }
}

Color red   = Color(255, 0, 0, 255);
Color faded = red.withAlpha(128);
```

## @Packed

Remove padding bytes from struct layout:

```arm
@Packed
public struct PacketHeader {
    magic   : u16;
    version : u8;
    flags   : u8;
}
```

## @Align

Set minimum alignment:

```arm
@Align(16)
public struct SimdVec {
    data : Array<Float, 4>;
}
```

## Type Alias for Structs

```arm
type Vec2 = Vec3;
```

## Structs vs Classes

| | Struct | Class |
|---|---|---|
| Allocation | Stack | Heap |
| Assignment | Copied (value semantics) | Reference (shared) |
| Memory management | None (automatic) | ARC |
| Inheritance | None | Single class |
| Operator overloading | Yes | No |

## Related

- [[annotations]] — `@Packed`, `@Align`, `@ForceInline`
- [[classes]] — heap-allocated reference types
- [[memory-model]] — ARC vs value types
- [[low-level]] — union, raw memory
