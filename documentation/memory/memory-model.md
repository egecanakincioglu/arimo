---
title: Memory Model
description: Arimo's layered memory model — ARC implementation status, manual memory, and planned BorrowChecker
tags: [memory]
date: 2026-05-30
---

# Memory Model

Arimo's memory model is designed as a layered system. The v1 compiler is moving toward a managed ARC+GC algorithm for ordinary objects, opt-in manual memory for selected objects, and a later BorrowChecker layer.

## Layers

| Layer | Mechanism | When Active |
|---|---|---|
| Managed | ARC + GC cooperation | Default target for ordinary class instances |
| Manual | `Memory.alloc` / `Memory.free` | `@ManualMemory` annotated code |
| BorrowChecker | Compile-time analysis | Planned later v1 iteration |

## Managed Memory: ARC + GC

Ordinary, non-manual objects are managed by the ARC memory system in a phased rollout. ARC Phase 1 (refcount infrastructure, heap allocation/free, constructor refcount initialization) is merged and active. Phases 2-6 (retain/release helpers, assignment integration, scope exit, object tear-down, tests) are planned for immediate implementation.

ARC gives deterministic ownership tracking for object references. Manual-memory classes and raw pointers are outside the managed path.

```arm
Counter c = Counter(0);   // managed object
c.increment();
// runtime memory algorithm owns cleanup once managed lowering is enabled
```

Manual-memory classes and raw pointers are outside this managed path.

## Manual Memory

Classes annotated with `@ManualMemory` opt into explicit memory management. They can use `RawPtr` and the `Memory` API for low-level control:

Manual-memory objects skip the ordinary managed ARC+GC path. You are responsible for allocation and deallocation:

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

## Planned BorrowChecker

BorrowChecker is intentionally not implemented in the v1 compiler yet. It is planned as the final compile-time safety layer and will catch:

- **Use-after-move** — using a value after it was moved
- **Move-while-borrowed** — moving a value while a reference to it exists
- **Mutation-while-borrowed** — mutating a value while immutable references exist

The Rust bootstrap compiler has a historical BorrowChecker implementation, but v1 will have its own implementation later.

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
