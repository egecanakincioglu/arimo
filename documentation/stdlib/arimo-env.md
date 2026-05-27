---
title: arimo.env
description: Env and Process — platform info, command-line args, process execution
tags: [stdlib]
date: 2026-05-22
---

# arimo.env

```arm
import arimo.env.*;
// or in arc.toml:
// include = ["arimo.env"]
```

## Env

Access environment information. All methods are static.

```arm
Env.platform() : String          // "windows" | "linux" | "macos"
Env.exit(code: Integer) : Void   // terminate process with exit code
Env.args() : List<String>        // command-line arguments
```

```arm
import arimo.env.*;

String plat = Env.platform();
IO.println("running on: ${plat}");   // "windows"

List<String> args = Env.args();
IO.println("argument count: ${args.length()}");

if (args.length() > 0) {
    IO.println("first arg: ${args.get(0)}");
}

if (shouldExit) {
    Env.exit(0);   // clean exit
}
```

## Process

Spawn external processes. All methods are static.

```arm
Process.exec(cmd: String) : Integer            // run command, return exit code
Process.execArgs(program: String, args: String) : Integer  // run with separate args
Process.success(cmd: String) : Boolean         // true if exit code == 0
```

```arm
import arimo.process.*;

Integer code = Process.exec("echo hello");
IO.println("exit code: ${code}");   // 0

Boolean ok = Process.success("arc check Main.arm");
if (!ok) {
    IO.println("compilation check failed");
}
```

## Env.exit vs Syscall.exit

| | `Env.exit(code)` | `Syscall.exit(code)` |
|---|---|---|
| Layer | stdlib | bare-metal |
| Requires | `arimo.env` import | `@ManualMemory` + `asm {}` |
| Use case | Normal programs | Kernel / freestanding code |

## Related

- [[stdlib-overview]] — import rules and package list
- [[low-level]] — `Syscall.exit` for freestanding code
