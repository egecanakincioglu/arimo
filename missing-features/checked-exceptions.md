---
title: Checked Exceptions
description: Enforced checked exception declarations with throws — not in Arimo v1.0.0
tags: [missing-features, exceptions]
date: 2026-05-22
---

# Checked Exceptions

Java's enforced checked exception system is **not in Arimo v1.0.0**.

## Java Checked Exceptions

**Java:**
```java
public String readFile(String path) throws IOException {
    // caller MUST catch IOException or declare throws IOException
    return Files.readString(Path.of(path));
}
```

The compiler enforces that every checked exception is either caught or re-declared with `throws`. This creates a statically verified exception contract.

## Arimo Behavior

All exceptions in Arimo are **unchecked** (similar to Java's `RuntimeException`). Methods do not declare `throws` and the compiler does not enforce catch-or-declare:

```arm
public readFile(path: String) : String {
    File f = File.open(path, FileMode.READ);
    return f.readAll();
}
```

The caller can choose to catch or ignore without compiler error.

## Exception Cause Chaining (Java)

**Java:**
```java
try {
    doWork();
} catch (IOException e) {
    throw new ServiceException("work failed", e);   // e is the cause
}

Throwable cause = ex.getCause();
```

Arimo exceptions have `message()` but no cause chaining:

```arm
try {
    doWork();
} catch (Exception e) {
    throw IllegalStateException("work failed: " + e.message());
    // original exception not attached as cause
}
```

No `getCause()` or `initCause()` equivalent exists.

## Multi-Catch (Java 7)

**Java:**
```java
try {
    riskyOperation();
} catch (IOException | SQLException e) {
    handle(e);
}
```

Arimo requires separate `catch` blocks per exception type:

```arm
try {
    riskyOperation();
} catch (IOException e) {
    handle(e.message());
} catch (Exception e) {
    handle(e.message());
}
```

## `throws` in Method Signatures

```java
// Java — compiler checks callers:
public void connect() throws ConnectionException, TimeoutException { }
```

No equivalent in Arimo. Exception types thrown are not part of the method signature.

## `AutoCloseable` / try-with-resources (Java)

**Java:**
```java
try (InputStream in = new FileInputStream(path)) {
    // in.close() called automatically on exit
}
```

Arimo uses [[defer]] for cleanup:

```arm
File f = File.open(path, FileMode.READ);
defer f.close();
// f is closed when scope exits, including on exception
```

## Related

- [[exceptions]] — Arimo exception hierarchy and try/catch/finally
- [[defer]] — deferred cleanup as try-with-resources alternative
- [[arimo-fs]] — File and IOException
