---
title: Operators
description: All operators in Arimo — arithmetic, logical, bitwise, null-safe, and more
tags: [language]
date: 2026-05-22
---

# Operators

## Arithmetic

```arm
Integer a = 10;
Integer b = 3;

Integer sum   = a + b;   // 13
Integer diff  = a - b;   // 7
Integer prod  = a * b;   // 30
Integer quot  = a / b;   // 3
Integer rem   = a % b;   // 1
```

Unary negation:

```arm
Integer neg = -a;   // -10
```

## Comparison

```arm
Boolean gt  = a > b;   // true
Boolean lt  = a < b;   // false
Boolean gte = a >= b;  // true
Boolean lte = a <= b;  // false
Boolean eq  = a == b;  // false
Boolean neq = a != b;  // true
```

## Logical

```arm
Boolean t = true;
Boolean f = false;

Boolean and_result = t && f;   // false
Boolean or_result  = t || f;   // true
Boolean not_result = !t;       // false
```

## Bitwise (Sized Integers)

```arm
u32 x = 0b1100;
u32 y = 0b1010;

u32 band  = x & y;    // 0b1000  — AND
u32 bor   = x | y;    // 0b1110  — OR
u32 bxor  = x ^ y;    // 0b0110  — XOR
u32 bnot  = ~x;       // bitwise NOT (complement)
u32 shl   = x << 2;   // shift left
u32 shr   = x >> 1;   // shift right
```

## Increment and Decrement

```arm
Integer i = 0;
i++;     // post-increment: i = 1
i--;     // post-decrement: i = 0
++i;     // pre-increment
--i;     // pre-decrement
```

## Assignment and Compound Assignment

```arm
Integer n = 5;
n = n + 1;   // simple assignment

n += 3;      // n = n + 3
n -= 1;      // n = n - 1
n *= 2;      // n = n * 2
n /= 4;      // n = n / 4
```

## Null-Safe Access (`?.`)

Accesses a method or field only if the receiver is non-null; returns `null` otherwise:

```arm
String? name = user?.getName();
Integer? len = name?.length();
String?  addr = user?.address;
```

See [null-safety](../language/null-safety.md) for full details.

## Null Coalescing (`??`)

Returns the left side if non-null, otherwise the right side:

```arm
Integer n = maybeValue ?? 0;
String s  = name?.toUpper() ?? "UNKNOWN";
```

## Ternary

```arm
String label = isUrgent ? "urgent" : "normal";
```

## String Concatenation

Use `+` to concatenate strings:

```arm
String full = "Hello, " + name + "!";
```

## Operator Overloading (Structs)

Structs can define operators:

```arm
public struct Vec3 {
    x : Float; y : Float; z : Float;

    public operator +(other: Vec3) : Vec3 {
        return Vec3(this.x + other.x, this.y + other.y, this.z + other.z);
    }

    public operator ==(other: Vec3) : Boolean {
        return this.x == other.x && this.y == other.y && this.z == other.z;
    }
}

Vec3 a = Vec3(1.0, 0.0, 0.0);
Vec3 b = Vec3(0.0, 1.0, 0.0);
Vec3 c = a + b;
```

Supported operator symbols: `+`, `-`, `*`, `/`, `==`

## Related

- [null-safety](../language/null-safety.md) — `?.` and `??` in detail
- [structs](../language/structs.md) — operator overloading on structs
- [variables-and-types](../language/variables-and-types.md) — types used with operators
