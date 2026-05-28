---
title: Installation
description: How to install the arc compiler and set up your Arimo development environment
tags: [getting-started]
date: 2026-05-22
---

# Installation

## Requirements

- **OS:** Windows x86-64 or Linux x86-64
- **Disk:** ~5 MB for the compiler and standard library

## Download

Download the latest `arc` release from the official GitHub repository. The release package includes:

- `arc.exe` on Windows, or `arc` on Linux — the Arimo compiler
- `stdlib/` — standard library source files

Place both in the same directory. `arc` auto-discovers `stdlib/` from its own location.

## Verify Installation

```
arc --version
```

Expected output:

```
arc v1.0
```

## Directory Layout

```
arc.exe              # Windows
# or: arc            # Linux
stdlib/
  arimo/
    lang/
    fs/
    io/
    util/
    env/
    process/
```

## Compile and Run a Program

```
arc build
./myapp              # Linux
myapp.exe            # Windows
```

Or in one step:

```
arc run
```

## Related

- [hello-world](../getting-started/hello-world.md) — first program
- [arc-cli](../cli/arc-cli.md) — all compiler commands
- [arc-toml](../getting-started/arc-toml.md) — project configuration
