---
title: Hello World
description: Your first Arimo program — step by step
tags: [getting-started]
date: 2026-05-22
---

# Hello World

## The Program

Create a file named `Main.arm`:

```arm
package myapp;

public class Application {
    public static main() : Void {
        IO.println("Hello, World!");
    }
}
```

## Compile and Run

```
arc run Main.arm
```

Output:

```
Hello, World!
```

## What Each Part Means

| Part | Meaning |
|---|---|
| `package myapp;` | Declares the package this file belongs to |
| `public class Application` | A public class — everything lives in a class |
| `public static main() : Void` | Entry point — every program needs exactly one |
| `IO.println(...)` | Prints a line to stdout (built-in, no import needed) |

## Notes

- No `new` keyword — `ClassName(args)` constructs objects
- No `import` needed for `IO` — it is part of `arimo.lang` which is always available
- The entry point class can have any name, as long as it has `public static main() : Void`
- Only one `main()` per program (across all compiled files)

## Next Steps

- [[variables-and-types]] — declare variables and use types
- [[control-flow]] — `if`, `while`, `for`
- [[classes]] — build your own classes
- [[arc-toml]] — set up a full project
