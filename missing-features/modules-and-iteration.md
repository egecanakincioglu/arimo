---
title: Modules, Imports, and Iteration Protocol
description: Import aliasing, wildcard re-export, custom iterable protocol, package-private visibility — not in Arimo v1.0.0
tags: [missing-features, modules]
date: 2026-05-22
---

# Modules, Imports, and Iteration Protocol

Module and iteration features present in mature languages that are **not in Arimo v1.0.0**.

## Import Aliasing

**Java / TypeScript:**
```typescript
import { readFileSync as readFile } from "fs";
import * as path from "path";
```

**Python:**
```python
import numpy as np
from os.path import join as path_join
```

Not supported. Arimo imports bind the class name as-is:

```arm
import arimo.fs.File;   // binds as "File"
```

There is no `as` keyword for import renaming. If two packages have a class with the same name, one must be referenced by full qualified path — but Arimo has no syntax for inline qualified access either.

## Wildcard Re-Export

**TypeScript:**
```typescript
export * from "./utils";
export { User, Group } from "./models";
```

Not supported. Arimo packages do not re-export symbols from other packages. Each package exposes only what is declared in its own `.arm` files.

## Custom Iterable Protocol

**Java:**
```java
class Range implements Iterable<Integer> {
    public Iterator<Integer> iterator() { ... }
}

for (int n : new Range(1, 10)) { ... }
```

**TypeScript:**
```typescript
class InfiniteCounter implements Iterable<number> {
    [Symbol.iterator]() { ... }
}
for (const n of counter) { ... }
```

Not supported. Arimo's `for (T item : collection)` and `for (T item in collection)` work only on built-in iterable types (`List<T>`, `Array<T, N>`, `Slice<T>`). User-defined classes cannot implement a custom iteration protocol to participate in for-each loops.

**Workaround:** Expose a `List<T>` and iterate that, or use an index-based `while` loop:

```arm
public class Range {
    private start : Integer;
    private end   : Integer;

    public toList() : List<Integer> {
        List<Integer> result = List();
        Integer i = start;
        while (i < end) {
            result.append(i);
            i += 1;
        }
        return result;
    }
}

Range r = Range(1, 10);
for (Integer n : r.toList()) { IO.println(n); }
```

## Package-Private Visibility

**Java:**
```java
class PackageHelper { }   // no modifier = package-private
```

Arimo has `public`, `private`, and `protected`. There is no package-private (default) visibility level. Classes and methods are either `public` (visible everywhere) or `private`/`protected`.

## Qualified Type Access Within Import

**Java:**
```java
java.util.List<Integer> list = new java.util.ArrayList<>();
```

Not supported inline. Arimo requires an `import` at the top of the file first — there is no inline fully-qualified type reference.

## Module Versioning / Dependency Management

**Rust `Cargo.toml` / Java Maven / TypeScript `package.json`:**
```toml
[dependencies]
serde = "1.0"
tokio = { version = "1", features = ["full"] }
```

`arc.toml` describes a single project (name, version, entry point) but has no dependency field. There is no package registry, no external dependency resolution, and no version pinning for third-party packages.

```toml
[project]
name    = "myapp"
version = "0.1.0"
entry   = "Main.arm"
# No [dependencies] section
```

## Circular Imports

No documented handling of circular imports between `.arm` files within the same project. The compiler processes files in declaration order — circular references between packages are unsupported.

## Related

- [[arc-toml]] — project configuration (no dependency field)
- [[stdlib-overview]] — import rules and package hierarchy
- [[arc-cli]] — `arc build`, `arc init`
- [[control-flow]] — for-each loop syntax
- [[list]] — `List<T>` as primary iterable type
