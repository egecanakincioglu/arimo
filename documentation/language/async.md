---
title: async / await
description: Asynchronous programming syntax — parser support and implementation status
tags: [language]
date: 2026-05-22
---

# async / await

## Syntax

Arimo supports `async` and `await` at the parser and AST level:

```arm
public async fetchUser(id: String) : String {
    String result = await ApiService.getData(id);
    return result;
}
```

```arm
async foo() : Integer {
    Integer val = await computeAsync();
    return val;
}
```

## Current Status (v1.0)

The parser accepts `async` methods and `await` expressions and produces the correct AST nodes. The async runtime (state machine transformation, coroutine scheduling) is **not yet implemented** in the code generator.

Attempting to compile an `async` method with `await` in v1.0 will parse successfully but may fail or produce incorrect output at codegen.

Full `async`/`await` support is planned for **v1.2.0**.

## Planned Semantics

- `async` methods return a `Future<T>` (or similar) implicitly
- `await` suspends the current coroutine until the value is ready
- No threads required — cooperative multitasking via a coroutine scheduler
- Interop with `arimo.net` (HTTP, sockets) in future stdlib

## Related

- [versioning](../reference/versioning.md) — v1.2.0 async milestone
- [functions-and-methods](../language/functions-and-methods.md) — regular (synchronous) methods
