---
title: Memory Model
description: Arimo's three-layer memory management — BorrowChecker, ARC, and manual memory
tags: [memory]
date: 2026-05-22
---

# Memory Model

Arimo uses a three-layer memory management system. No garbage collector runs at runtime.

## Three Layers

| Layer | Mechanism | When Active |
|---|---|---|
| 1. BorrowChecker | Compile-time analysis | Always (static checks) |
| 2. ARC | Automatic Reference Counting | For class instances (heap) |
| 3. Manual | `Memory.alloc` / `Memory.free` | `@ManualMemory` annotated code |

## Layer 1: BorrowChecker

The BorrowChecker runs at compile time and catches:

- **Use-after-move** — using a value after it was moved
- **Move-while-borrowed** — moving a value while a reference to it exists
- **Mutation-while-borrowed** — mutating a value while immutable references exist

These errors are reported at compile time before any binary is produced.

## Layer 2: ARC (Automatic Reference Counting)

Every class instance (heap-allocated object) has a reference count. When the count drops to zero, the object is freed automatically.

```arm
Counter c = Counter(0);   // ref count = 1
c.increment();
// scope ends — ref count = 0 — freed automatically
```

Cycles between objects are currently not broken automatically. Avoid reference cycles or use `@ManualMemory` for those cases.

ARC overhead is avoided for:
- Structs (stack-allocated, no ref count)
- `@ManualMemory` classes
- `RawPtr` values

## Layer 3: Manual Memory

Classes annotated with `@ManualMemory` skip ARC entirely. You are responsible for allocation and deallocation:

```arm
@ManualMemory
public class Renderer {
    private buffer : RawPtr<Float>;

    public constructor() {
        this.buffer = Memory.alloc(1024 * Float.sizeOf());
    }

    public dispose() : Void {
        Memory.free(this.buffer);
    }
}
```

See [low-level](../memory/low-level.md) for `Memory` and `RawPtr` API.

## Value Types (Structs)

Structs are stack-allocated and copied on assignment. They do not participate in ARC:

```arm
Vec3 a = Vec3(1.0, 0.0, 0.0);
Vec3 b = a;   // b is a copy — independent from a
```

## Volatile

For memory-mapped I/O, use `volatile` to prevent the compiler from optimizing away reads/writes:

```arm
volatile u32 status = 0;   // read always happens
```

## Related

- [low-level](../memory/low-level.md) — `RawPtr`, `Memory`, inline assembly
- [structs](../language/structs.md) — value types vs reference types
- [annotations](../language/annotations.md) — `@ManualMemory`, `@Immutable`
