---
title: arc.toml — Project Configuration
description: Project manifest file format and all supported fields
tags: [getting-started, cli]
date: 2026-05-22
---

# arc.toml — Project Configuration

`arc.toml` is the project manifest file. It lives in the project root.

## Minimal Example

```toml
[project]
name    = "myapp"
version = "1.0.0"
entry   = "Main.arm"
```

## Full Reference

```toml
[project]
name        = "arc"
version     = "0.1.0"
description = "Short description of your project"
entry       = "Main.arm"          # source file containing main()
license     = "MIT"
readme      = "README.md"
keywords    = ["compiler", "lang"]
homepage    = "https://example.com"
repository  = "https://github.com/user/repo"

[[project.authors]]
name  = "Your Name"
email = "you@example.com"

# Build configuration
[build]
target = "x86_64-pc-windows-gnu"   # compilation target

# Optimization profiles
[profiles.release]
optimize = true

[profiles.dev]
optimize = false

# Standard library modules to include
[stdlib]
include = ["arimo.fs", "arimo.process"]

# Package dependencies (future)
[dependencies]
# arimo-http = "1.0.0"

[dev-dependencies]
# arimo-test = "0.1.0"

# Custom scripts
[scripts]
# lint = "arc check --strict"
# docs = "arc doc"
```

## Key Fields

| Field | Required | Description |
|---|---|---|
| `project.name` | Yes | Package name |
| `project.version` | Yes | SemVer version string |
| `project.entry` | Yes | Entry point `.arm` file |
| `build.target` | No | Compilation target triple |
| `stdlib.include` | No | Explicit stdlib packages to include |

## stdlib.include

By default, no stdlib packages are included automatically. List the packages your program needs:

```toml
[stdlib]
include = ["arimo.fs", "arimo.io", "arimo.util"]
```

`arimo.lang` (IO, Math, String, Integer, etc.) is always available without listing it here.

## Related

- [arc-cli](../cli/arc-cli.md) — `arc build`, `arc run`, `arc init`
- [stdlib-overview](../stdlib/stdlib-overview.md) — available stdlib packages
