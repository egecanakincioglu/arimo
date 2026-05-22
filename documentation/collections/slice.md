---
title: Slice
description: Slice<T> — non-owning view into contiguous memory
tags: [collections]
date: 2026-05-22
---

# Slice\<T\>

`Slice<T>` is a non-owning fat pointer: a `(pointer, length)` pair. It does not own the memory it points to and does not free it.

## Construction

From a `RawPtr`:

```arm
Slice<Float> s = Slice.of(rawPtr, count);
```

From an `Array`:

```arm
Array<Float, 8> data = Array.zeroed();
Slice<Float> view    = data.asSlice();
Slice<Float> s2      = data.slice();   // alternative
```

## Access

```arm
Integer len   = view.length();   // number of elements
Float   first = view[0];         // read by index
view.set(0, 1.0);                // write by index
Float   elem  = view.get(0);     // alternative read
```

## Type Alias

```arm
type Bytes = Slice<u8>;
```

## Use Cases

- Passing a subview of an array without copying
- Interfacing with raw memory from C functions
- Reading a portion of a buffer

```arm
@ManualMemory
public class Renderer {
    private vertexBuffer : RawPtr<Float>;

    public getVertexSlice(offset: Integer, count: Integer) : Slice<Float> {
        return Slice.of(this.vertexBuffer, count);
    }
}
```

## Ownership

`Slice<T>` does not own its memory. The underlying `Array` or `RawPtr` must remain valid while the slice is in use. Freeing the source while a slice exists causes undefined behavior.

## Related

- [array](../collections/array.md) — `Array<T,N>` — source of slices
- [low-level](../memory/low-level.md) — `RawPtr` — raw pointer source
- [collections-overview](../collections/collections-overview.md) — all collection types
