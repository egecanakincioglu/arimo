---
title: defer
description: Deferred execution — cleanup that runs when the current scope exits
tags: [language]
date: 2026-05-22
---

# defer

`defer` schedules a statement to run when the current function scope exits — whether normally or due to an exception.

## Basic Usage

```arm
public static processFile(path: String) : Void {
    defer IO.println("cleanup done");

    IO.println("processing...");
    // ... work ...
    // "cleanup done" prints here, on scope exit
}
```

## Cleanup Pattern

```arm
public static openFile(path: String) : Void {
    defer f.close();   // always closes, even if exception thrown

    // ... read from f ...
}
```

## LIFO Order

Multiple `defer` statements execute in last-in-first-out order:

```arm
defer IO.println("first deferred");   // runs second
defer IO.println("second deferred");  // runs first

// Output (on scope exit):
// second deferred
// first deferred
```

## defer with Exception

`defer` runs even when an exception propagates:

```arm
try {
    defer cleanup();   // runs before exception propagates
    throw RuntimeException("oops");
} catch (RuntimeException e) {
    IO.println("caught");
}
```

## defer in Loops

Each loop iteration registers its own `defer`:

```arm
for (Integer i = 0; i < 3; i++) {
    defer IO.println("cleanup ${i}");
    // prints "cleanup 2", "cleanup 1", "cleanup 0" at end of each iteration
}
```

## Related

- [exceptions](../language/exceptions.md) — exception handling
- [functions-and-methods](../language/functions-and-methods.md) — scope and lifetime
