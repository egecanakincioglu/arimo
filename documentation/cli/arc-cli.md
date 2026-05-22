---
title: arc CLI
description: arc compiler commands — build, run, check, clean, init, and flags
tags: [cli]
date: 2026-05-22
---

# arc CLI

`arc` is the Arimo compiler and project tool.

## Commands

### arc build

Compile an `.arm` file or project to a native executable:

```
arc build Main.arm           # compile single file → Main.exe
arc build                    # compile project using arc.toml
arc build --release          # optimized build (profile: release)
```

### Direct file compilation (legacy mode)

Pass `.arm` files directly without a subcommand:

```
arc Main.arm                 # compile single file
arc Main.arm Lib.arm         # compile multiple files
arc Main.arm --emit-ir       # compile + emit IR
```

### arc run

Compile and immediately execute:

```
arc run Main.arm             # compile + run
arc run                      # compile + run using arc.toml entry point
```

### arc check

Type-check without producing an executable:

```
arc check Main.arm           # type-check + borrow-check only
arc check --strict           # enable additional warnings
```

### arc clean

Remove build artifacts:

```
arc clean                    # remove output executables and build cache
```

### arc init

Initialize a new Arimo project in the current directory:

```
arc init myapp               # creates myapp/ with arc.toml and Main.arm
arc init                     # initialize in current directory
```

Generated `arc.toml`:

```toml
[project]
name    = "myapp"
version = "0.1.0"
entry   = "Main.arm"
```

Generated `Main.arm`:

```arm
package myapp;

public class Application {
    public static main() : Void {
        IO.println("Hello, Arimo!");
    }
}
```

## Flags

| Flag | Command | Effect |
|---|---|---|
| `--release` | `build`, `run` | Enable optimizations (from profile) |
| `--emit-ir` | `build`, direct | Output LLVM IR text (`.ll`) and exit |
| `-O2` | `build`, direct | Optimization level 2 |
| `-O3` | direct | Optimization level 3 |
| `-c` | `build`, direct | Compile only — produce `.o`, skip linking |
| `--stdlib-path <dir>` | all | Override stdlib directory |
| `--version` / `version` / `-v` | — | Print compiler version |
| `--help` | — | Print usage |

## Stdlib Discovery

`arc` looks for `stdlib/` in the same directory as `arc.exe`. Override with `--stdlib-path`:

```
arc build Main.arm --stdlib-path C:/arimo/stdlib
```

## Version

```
arc --version
```

Output:

```
arc 1.0.0 (arimo-language)
```

## Related

- [arc-toml](../getting-started/arc-toml.md) — project configuration
- [installation](../getting-started/installation.md) — installing arc
- [hello-world](../getting-started/hello-world.md) — first program
