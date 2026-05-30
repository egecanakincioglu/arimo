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

Ordinary, non-manual objects are managed by the ARC memory system (complete, v1.0):
- Phase 1: Refcount infrastructure, heap allocation/free, ctor refcount=1
- Phase 2: Inline retain/release helpers with null guards
- Phase 3: IDENT + FIELD assignment ownership (retain new, release old, store)
- Phase 4: Scope exit auto-release, return ownership transfer, break/continue unwind
- Phase 5: Recursive field teardown, inheritance chain release
- Phase 6: ARC test suite (14 tests) + cycle documentation

31/31 tests pass (17 core + 14 ARC). Self-hosting deterministic with ARC active.

ARC gives deterministic ownership tracking for object references. Manual-memory classes and raw pointers are outside the managed path.

```arm
Counter c = Counter(0);   // managed object, refcount=1
Counter d = c;             // retain: refcount=2
// scope exit: release(d) → rc=1, release(c) → rc=0 → free
```

### Known ARC Limitation: Reference Cycles

ARC cannot detect or collect cyclic references. Two objects referencing each other will never be freed:

```arm
class A { B b; }
class B { A a; }
A a = A(); B b = B();
a.b = b;  // retain(b) → rc=2
b.a = a;  // retain(a) → rc=2
// scope exit: release(a) → rc=1, release(b) → rc=1
// Neither reaches 0 — memory leak
```

This is expected ARC behavior, not a bug. Future v1.x iterations may add a cycle collector or weak references. For now, avoid reference cycles in managed objects, or use `@ManualMemory` for explicit control.

Manual-memory classes and raw pointers are outside the managed path.

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
