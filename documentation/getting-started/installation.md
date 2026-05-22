---
title: Installation
description: How to install the arc compiler and set up your Arimo development environment
tags: [getting-started]
date: 2026-05-22
---

# Installation

## Requirements

- **OS:** Windows x86-64 (Windows 10 or later)
- **Disk:** ~5 MB for the compiler and standard library

## Download

Download the latest `arc` release from the official GitHub repository. The release package includes:

- `arc.exe` — the Arimo compiler
- `stdlib/` — standard library source files

Place both in the same directory. `arc` auto-discovers `stdlib/` from its own location.

## Verify Installation

```
arc --version
```

Expected output:

```
arc 1.0.0 (arimo-language)
```

## Directory Layout

```
arc.exe
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
arc build Main.arm
Main.exe
```

Or in one step:

```
arc run Main.arm
```

## Related

- [hello-world](../getting-started/hello-world.md) — first program
- [arc-cli](../cli/arc-cli.md) — all compiler commands
- [arc-toml](../getting-started/arc-toml.md) — project configuration
