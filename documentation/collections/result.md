---
title: Result
description: Result<T, E> — success or error value without exceptions
tags: [collections]
date: 2026-05-22
---

# Result\<T, E\>

`Result<T, E>` is a built-in generic enum that represents either a successful value (`Ok`) or an error (`Err`). It is an alternative to exceptions for functions that can fail.

## Construction

```arm
Result<String, String> ok  = Result.Ok("success");
Result<String, String> err = Result.Err("file not found");

Result<Integer, String> num   = Result.Ok(42);
Result<Integer, String> error = Result.Err("invalid input");
```

## Checking the Result

```arm
Result<String, String> r = readFile("/etc/hosts");

if (r.isOk()) {
    String content = r.getValue();
    IO.println("content: ${content}");
}

if (r.isErr()) {
    String msg = r.getError();
    IO.println("error: ${msg}");
}
```

## API

| Method | Returns | Description |
|---|---|---|
| `isOk()` | `Boolean` | True if `Ok` |
| `isErr()` | `Boolean` | True if `Err` |
| `getValue()` | `T` | Extract value — only call when `isOk()` |
| `getError()` | `E` | Extract error — only call when `isErr()` |

## Pattern Matching on Result

The idiomatic way to handle `Result`:

```arm
match r {
    Result.Ok(content) => IO.println("got: ${content}"),
    Result.Err(msg)    => IO.println("error: ${msg}"),
}
```

With guards:

```arm
match r {
    Result.Ok(content) if content.length() > 0 => IO.println("non-empty"),
    Result.Ok(_)                                => IO.println("empty"),
    Result.Err(msg)                             => IO.println("failed: ${msg}"),
}
```

## Returning Result from a Function

```arm
public static readConfig(path: String) : Result<String, String> {
    Boolean exists = File.exists(path);
    if (!exists) {
        return Result.Err("config not found: ${path}");
    }
    String content = File.read(path);
    return Result.Ok(content);
}
```

## Result vs Exceptions

| | `Result<T,E>` | Exception |
|---|---|---|
| Error handling | Explicit — caller must check | Implicit — propagates up |
| Caller awareness | Required | Optional |
| Performance | No stack unwind | Stack unwind on throw |
| Use case | Expected failures (file not found, parse error) | Unexpected failures |

## Related

- [exceptions](../language/exceptions.md) — try/catch/throw
- [pattern-matching](../language/pattern-matching.md) — `match` on Result
- [enums](../language/enums.md) — Result is a generic enum
