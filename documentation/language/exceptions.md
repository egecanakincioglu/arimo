---
title: Exceptions
description: Exception classes, try/catch/finally, throw, and the exception hierarchy
tags: [language]
date: 2026-05-22
---

# Exceptions

## Exception Hierarchy

```
Throwable
├── Exception                       ← checked exceptions
│   ├── RuntimeException
│   │   ├── NullPointerException
│   │   ├── IllegalArgumentException
│   │   ├── IllegalStateException
│   │   ├── IndexOutOfBoundsException
│   │   ├── ArithmeticException
│   │   ├── NumberFormatException
│   │   └── ClassCastException
│   └── IOException
└── Error                           ← unrecoverable
    ├── OutOfMemoryError
    └── StackOverflowError
```

All built-in exceptions are available without importing (part of `arimo.lang`). `IOException` requires `import arimo.fs.*;`.

## Defining Custom Exceptions

```arm
public class TaskNotFoundException extends Exception {
    private readonly taskId : String;

    public constructor(taskId: String) {
        this.taskId = taskId;
    }

    public getTaskId() : String { return this.taskId; }
}
```

The `exception` keyword is also accepted as an alias for `class` when extending `Exception`:

```arm
public exception IOException extends Exception {
    private path : String;
    public constructor(p: String) { this.path = p; }
}
```

## throw

```arm
throw TaskNotFoundException("abc-123");
throw RuntimeException("something went wrong");
throw IllegalArgumentException("value must be positive");
```

## try / catch / finally

```arm
try {
    Task task = repo.findById(id);
    IO.println("found: ${task}");
} catch (TaskNotFoundException ex) {
    IO.println("not found: ${ex.getTaskId()}");
} catch (IOException ex) {
    IO.println("IO error");
} finally {
    IO.println("always runs — even after exception");
}
```

- Multiple `catch` blocks are evaluated top-to-bottom
- The first matching type is caught
- `finally` always runs, whether or not an exception was thrown
- Code after the `try` block continues if no exception is thrown (or after `catch` handles it)

## try Without Exception

If no exception is thrown, `catch` blocks are skipped and `finally` still runs:

```arm
try {
    IO.println("no exception here");
} catch (RuntimeException e) {
    IO.println("never runs");
} finally {
    IO.println("runs anyway");
}
IO.println("continues here");
```

## @Throws

Document that a method may throw:

```arm
@Throws(IOException)
public static read(path: String) : String {
    return File.read(path);
}
```

This is documentation-only — Arimo does not enforce checked exceptions at the call site.

## Related

- [[arimo-lang]] — built-in exception classes
- [[annotations]] — `@Throws`
- [[pattern-matching]] — using `match` to handle `Result` instead of exceptions
