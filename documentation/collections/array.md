---
title: Array
description: Array<T, N> — compile-time fixed-size, stack-allocated array
tags: [collections]
date: 2026-05-22
---

# Array\<T, N\>

`Array<T, N>` is a fixed-size, stack-allocated array. `N` must be a compile-time constant. It does not grow.

## Construction

```arm
Array<Float, 4> vec4   = Array.zeroed();   // all zeros
Array<u8, 256>  buffer = Array.zeroed();
```

There is currently one constructor: `Array.zeroed()` — creates an array with all elements zero-initialized.

## Access

```arm
Array<Float, 4> vec = Array.zeroed();

vec[0] = 1.0;           // write by index
vec[1] = 2.0;
Float f = vec[0];       // read by index

vec.set(2, 3.0);        // alternative write
Float g = vec.get(2);   // alternative read

Integer len = vec.length();   // always N (4 in this case)
```

## Convert to Slice

```arm
Slice<Float> view = vec.asSlice();
Slice<Float> s2   = vec.slice();    // same — alternative name
```

## Type Alias

```arm
type Mat4  = Array<Float, 16>;
type Bytes = Array<u8, 256>;

Mat4 m = Array.zeroed();
```

## Structs with Array Fields

```arm
@Align(16)
public struct SimdVec {
    data : Array<Float, 4>;
}

SimdVec v = SimdVec(Array.zeroed());
v.data[0] = 1.0;
```

## Array vs List

| | `Array<T,N>` | `List<T>` |
|---|---|---|
| Size | Fixed at compile time | Dynamic |
| Allocation | Stack | Heap |
| ARC | None | Yes |
| Use case | Buffers, SIMD, fixed vectors | General collections |

## Related

- [[slice]] — non-owning view into an array
- [[collections-overview]] — all collection types
- [[low-level]] — `RawPtr` for manual arrays
