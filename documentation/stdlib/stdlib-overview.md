---
title: Standard Library Overview
description: Package system, import rules, arimo.lang auto-availability, and all stdlib packages
tags: [stdlib]
date: 2026-05-22
---

# Standard Library Overview

## Design Principle

Nothing is imported automatically. Every package your code depends on must be explicitly imported — except `arimo.lang`, which is always available.

## Package Hierarchy

```
arimo.base                      ← module (grouping concept — never imported)
├── arimo.lang                  ← always available (IO, Math, String, Integer...)
│   └── arimo.lang.prelude      ← curated essentials subset
├── arimo.fs                    ← file system
├── arimo.io                    ← streams and readers
├── arimo.util                  ← collections, Optional, Scanner, Random
├── arimo.env                   ← Env (args, platform, exit)
└── arimo.process               ← Process (exec)
```

## Import Syntax

```arm
import arimo.fs.*;                  // all classes from arimo.fs
import arimo.fs.File;               // single class
import arimo.util.Optional;         // single class
import arimo.lang.prelude.*;        // IO, Math, Integer, Float, prelude exceptions
import arimo.lang.*;                // everything in arimo.lang
```

Wildcard `*` imports all public classes from a package.

## arc.toml — Declaring Stdlib Dependencies

```toml
[stdlib]
include = ["arimo.fs", "arimo.util", "arimo.process"]
```

## arimo.lang — Always Available

These classes do not require any import:

| Class | Purpose |
|---|---|
| `IO` | Print, println, read from stdin |
| `Math` | Mathematical functions and constants |
| `String` | String type and methods |
| `Integer` | 64-bit integer wrapper |
| `Float` | 64-bit double wrapper |
| `Boolean` | Boolean wrapper |
| `Char` | Single character |
| `Object` | Root of class hierarchy |
| `StringBuilder` | Mutable string builder |
| `Exception` | Base exception class |
| `RuntimeException` | Base unchecked exception |

## @Freestanding — No Stdlib

```arm
@Freestanding
package kernel.boot;
```

Zero stdlib — not even `malloc`. For bare-metal / kernel code.

## Packages

- [[arimo-lang]] — IO, Math, Integer, Float, String, StringBuilder, exceptions
- [[arimo-fs]] — File, Path, Directory, FileMode
- [[arimo-io]] — InputStream, BufferedReader
- [[arimo-util]] — ArrayList, Optional, Scanner, Random
- [[arimo-env]] — Env, Process
