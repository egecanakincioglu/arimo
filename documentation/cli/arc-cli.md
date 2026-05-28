---
title: arc CLI
description: arc v1 compiler commands — build, run, check, init, direct file mode, and flags
tags: [cli]
date: 2026-05-22
---

# arc CLI

`arc` is the Arimo v1 compiler and project tool.

## Commands

### arc build

Compile the current project using `arc.toml`:

```
arc build                    # compile project using arc.toml
```

`arc build` must be run from a directory containing `arc.toml`. The entry file comes from `[project].entry`; if missing, `Main.arm` is used.

### Direct file compilation

Pass one `.arm` file directly without a subcommand:

```
arc Main.arm                 # compile single file
```

Imports are discovered from the entry file. Direct multi-file command arguments are not part of the v1 CLI surface.

### arc run

Compile and immediately execute:

```
arc run                      # compile + run using arc.toml entry point
```

### arc check

Type-check without producing an executable:

```
arc check                    # type-check only using arc.toml entry point
```

BorrowChecker is planned for a later v1 iteration; `arc check` currently runs parser and type-checker validation.

### arc init

Initialize a new Arimo project in the current directory:

```
arc init myapp               # creates myapp/ with arc.toml and Main.arm
```

Generated `arc.toml`:

```toml
[project]
name    = "myapp"
version = "0.1.0"
entry   = "Main.arm"
```

The current v1 generator writes a Windows target by default. On Linux, use `--target linux` for compile commands or edit `[build].target` in `arc.toml` to a Linux target before building.

Generated `Main.arm`:

```arm
package myapp;

public class Main {
    public static main() : Void {
        IO.println("Hello, Arimo!");
    }
}
```

The current v1 generator writes `public class Main` in the scaffolded file.

## Flags

| Flag | Command | Effect |
|---|---|---|
| `--stdlib-path <dir>` | all | Override stdlib directory |
| `--target linux|windows` | all compile modes | Override target platform |
| `--check` | direct file mode | Type-check only |

## Stdlib Discovery

`arc` looks for `stdlib/` in the same directory as `arc.exe`. Override with `--stdlib-path`:

```
arc --stdlib-path C:/arimo/stdlib Main.arm
arc build --stdlib-path C:/arimo/stdlib
```

## Version

The v1 CLI banner is `arc v1.0`.

## Related

- [arc-toml](../getting-started/arc-toml.md) — project configuration
- [installation](../getting-started/installation.md) — installing arc
- [hello-world](../getting-started/hello-world.md) — first program
