---
title: Low-Level Programming
description: RawPtr, Memory API, extern C, inline assembly, union, volatile
tags: [memory, low-level]
date: 2026-05-22
---

# Low-Level Programming

## RawPtr\<T\>

`RawPtr<T>` is an unmanaged pointer — no ARC, no bounds checking:

```arm
RawPtr<u8>   ptr  = Memory.alloc(1024) as RawPtr<u8>;
RawPtr<Void> vptr = Memory.alloc(256);
```

### RawPtr Methods

| Method | Returns | Description |
|---|---|---|
| `read()` | `T` | Read value at current pointer |
| `write(value)` | `Void` | Write value at current pointer |
| `offset(n)` | `RawPtr<T>` | Advance pointer by `n` elements, returns new pointer |

```arm
ptr.write(255 as u8);
u8 val = ptr.read();
RawPtr<u8> next = ptr.offset(4);   // advance 4 elements
next.write(0 as u8);
```

## Memory API

```arm
Memory.alloc(size)           // → RawPtr<Void>  — allocate `size` bytes
Memory.free(ptr)             // → Void          — free previously allocated memory
Memory.copy(dst, src, n)     // → Void          — copy n bytes from src to dst
Memory.set(ptr, val, n)      // → Void          — fill n bytes with val (memset)
```

```arm
RawPtr<Void> buf = Memory.alloc(1024);
Memory.set(buf, 0, 1024);               // zero the buffer
Memory.free(buf);
```

## extern "C"

Declare external C functions for interop:

```arm
extern "C" {
    printf(fmt: RawPtr<u8>, ...) : i32;   // variadic with ...
    malloc(size: u64)            : RawPtr<Void>;
    free(ptr: RawPtr<Void>)      : Void;
    fopen(path: String, mode: String) : RawPtr<Void>;
    fread(buf: RawPtr<Void>, size: Integer, n: Integer, f: RawPtr<Void>) : Integer;
}
```

- Variadic functions use `...` after the last named parameter
- Return types follow Arimo type conventions mapped to C types

## Inline Assembly

Use `asm {}` for raw x86-64 assembly:

```arm
@ManualMemory
public class Syscall {
    public static exit(code: i32) : noreturn {
        asm {
            mov rax, 60
            syscall
        }
    }
}
```

`asm` blocks are only valid in `@ManualMemory` methods. Instructions are x86-64 AT&T or Intel syntax strings emitted directly into the code.

## union

A `union` maps multiple fields to the same memory:

```arm
public union Register {
    full  : u32;
    bytes : Array<u8, 4>;
}
```

Reading one field after writing another is well-defined — unions share a single memory region. Size equals the largest member.

## volatile

Prevent the optimizer from eliding memory accesses (for memory-mapped I/O):

```arm
volatile u32 status = 0;      // read from memory every time
```

## sizeOf

Get the byte size of a type at compile time:

```arm
Integer.sizeOf()   // 8
Float.sizeOf()     // 8
u32.sizeOf()       // 4
u8.sizeOf()        // 1
```

## noreturn

Functions that never return to the caller:

```arm
public static halt(msg: String) : noreturn {
    Syscall.exit(1);
}
```

## Linker Annotations

```arm
@Section(".boot")
@CallingConvention("C")
public static start() : Void { ... }

@CallingConvention("Interrupt")
public static onTimer() : Void { ... }
```

## @Freestanding — Bare-Metal

```arm
@Freestanding
package kernel.boot;
```

No stdlib linked — not even `malloc`. For OS kernels and embedded targets with no OS.

## Related

- [memory-model](../memory/memory-model.md) — ARC vs manual memory
- [annotations](../language/annotations.md) — `@ManualMemory`, `@Section`, `@CallingConvention`
- [structs](../language/structs.md) — `@Packed`, `@Align`, `union`
