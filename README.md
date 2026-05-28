# Arimo

<p align="center">
  <img src="https://img.shields.io/badge/version-v1.0-blue?style=flat-square" alt="version">
  <img src="https://img.shields.io/badge/license-AGPL--3.0-darkred?style=flat-square" alt="license">
  <img src="https://img.shields.io/badge/compiler-arc-orange?style=flat-square" alt="compiler">
  <img src="https://img.shields.io/badge/extension-.arm-green?style=flat-square" alt="extension">
  <img src="https://img.shields.io/badge/memory-ARC%20%2B%20GC%20%2B%20Manual-purple?style=flat-square" alt="memory">
  <img src="https://img.shields.io/badge/IR-ArimoIR-red?style=flat-square" alt="IR">
  <img src="https://img.shields.io/badge/native-no%20LLVM%20%7C%20no%20GCC-black?style=flat-square" alt="native">
</p>

<p align="center">
  <strong>A statically-typed, object-oriented systems programming language with its own IR, layered memory management, and native code generation.</strong>
</p>

<p align="center">
  <a href="documentation/index.md">📖 Documentation</a> ·
  <a href="documentation/getting-started/hello-world.md">Quick Start</a> ·
  <a href="documentation/reference/project-status.md">Project Status</a> ·
  <a href="documentation/reference/versioning.md">Changelog</a>
</p>

---

## What is Arimo?

Arimo is a systems programming language designed to be usable at every level of the software stack — from OS kernels and game engines to enterprise OOP applications — without switching languages or compromising on safety.

```arm
package hello;

public class Application {
    public static main() : Void {
        IO.println("Hello, Arimo!");
    }
}
```

```
arc run
# Hello, Arimo!
```

The v1 `arc` compiler compiles `.arm` source files directly to native executables through its own intermediate representation (**ArimoIR**) and native backend.

---

## Why Arimo?

### Own IR — No External Toolchain

Most languages that target native code depend on LLVM or GCC. Arimo has its own IR pipeline:

```
.arm  →  AST  →  ArimoIR  →  x86-64 machine code  →  PE32+ / ELF executable
```

The v1 `arc` compiler is designed to produce native executables without depending on LLVM or GCC. This means:
- Reproducible builds on any machine
- No version mismatches between LLVM releases
- Full control over every compilation stage
- The compiler itself is self-hosting (arc compiles arc)

### Layered Memory Management

Most languages choose one approach. Arimo layers three:

| Layer | Mechanism | When |
|---|---|---|
| **Managed** | ARC + GC cooperation | Default target for ordinary objects |
| **Manual** | `Memory.alloc` / `Memory.free` | `@ManualMemory` — zero-overhead, kernel/driver code |
| **BorrowChecker** | Compile-time static analysis | Planned later v1 iteration |

You choose manual control per class with `@ManualMemory`. ARC+GC lowering is staged in v1; BorrowChecker is intentionally not part of the v1.0 compiler yet. The Rust bootstrap has a historical BorrowChecker implementation and v1 will get its own later.

```arm
// Managed — default
public class HttpServer { ... }

// Manual — zero overhead, kernel code
@ManualMemory
public class DmaBuffer {
    private ptr : RawPtr<u8>;
    public constructor(size: Integer) { this.ptr = Memory.alloc(size); }
    public dispose() : Void { Memory.free(this.ptr); }
}
```

### Null Safety Built In

Non-nullable types are the default. Null is explicit and compiler-enforced:

```arm
String  name   = "Alice";     // cannot be null — compiler error if assigned null
String? title  = null;        // explicitly nullable

String safe  = title ?? "unknown";   // null coalescing
Integer? len = title?.length();      // null-safe call — len is null if title is null
```

Unlike Java's `Optional<T>` boilerplate or C++'s `std::optional`, null safety in Arimo is built into the type system at zero cost.

### High-Level OOP + Low-Level Control in One Language

Arimo is not a systems language with OOP bolted on, nor a high-level language that leaks when you need performance. Both exist natively:

```arm
// High-level enterprise OOP
public class OrderService {
    private repo : OrderRepository;

    public placeOrder(order: Order) : Result<OrderId, OrderError> {
        if (!order.isValid()) {
            return Result.err(OrderError.INVALID);
        }
        return repo.save(order);
    }
}

// Low-level hardware access
@Freestanding
@CallingConvention("Interrupt")
public static irqHandler() : Void {
    volatile u32 status = 0;
    asm { "mov eax, [0xFEE00100]" };
}
```

---

## Use Cases

### Operating Systems / Kernels

```arm
@Freestanding          // no stdlib, no malloc
package kernel.boot;

@Section(".boot")
@CallingConvention("C")
public static kernelMain(multiboot: RawPtr<MultibootInfo>) : noreturn {
    VGA.clear();
    VGA.print("Arimo kernel booting...");

    GDT.init();
    IDT.init();
    Memory.initPaging();

    asm { "sti" };     // enable interrupts

    while (true) { asm { "hlt" }; }
}
```

- `@Freestanding` — no standard library linked
- `@Section(".name")` — precise linker control
- `@CallingConvention("Interrupt")` — CPU-correct interrupt handlers
- `volatile` — MMIO reads/writes not optimized away
- `asm {}` — inline x86 assembly
- `RawPtr<T>` — unmanaged pointer arithmetic
- `noreturn` — compiler knows this function never returns

### Game Engines

```arm
@Align(16)
public struct Transform {
    public position : Vec4f;
    public rotation : Vec4f;
    public scale    : Vec4f;

    public modelMatrix() : Vec4f {
        return position * rotation * scale;
    }
}

public class PhysicsSystem {
    private bodies : List<RigidBody>;

    public step(dt: Float) : Void {
        this.bodies.forEach((body) -> {
            body.integrate(dt);
            body.resolveCollisions(this.bodies);
        });
    }
}
```

- Built-in SIMD types: `Vec4f`, `Vec8f`, `Vec4i`, `Vec8i` with `dot()`, `normalize()`, `length()`
- `@Align(16)` / `@Packed` structs for cache-friendly layouts
- `@Pure` methods for optimizer hints
- `@ForceInline` for hot-path elimination
- Lambdas + closures for event systems and callbacks
- Stack-allocated structs — no heap allocation for math types

### Enterprise / High-Level OOP

```arm
public class UserService {
    private users : HashMap<String, User>;

    public findByEmail(email: String) : User? {
        return users.get(email);
    }

    public register(dto: RegisterDto) : Result<User, ValidationError> {
        if (users.containsKey(dto.email)) {
            return Result.err(ValidationError.EMAIL_TAKEN);
        }
        User user = User(dto.name, dto.email);
        users.set(dto.email, user);
        return Result.ok(user);
    }
}

public interface Serializable {
    serialize()   : String;
    deserialize(s: String) : Void;
}

public abstract class BaseEntity implements Serializable {
    protected readonly id        : String;
    protected readonly createdAt : Integer;

    public constructor() {
        this.id        = Time.generateId();
        this.createdAt = Time.nowMillis();
    }
}
```

- Generics with multiple bounds: `<T extends Comparable<T> & Serializable>`
- Pattern matching: `match`, destructured enum variants
- Exception hierarchy: `RuntimeException`, `IllegalArgumentException`, etc.
- `Result<T, E>` for explicit error handling without exceptions
- `defer` for deterministic cleanup
- Extension methods to add behavior to existing types
- `@Deprecated`, `@Experimental`, `@Throws` documentation annotations

---

## Language Highlights

### Pattern Matching

```arm
match (shape) {
    Circle c    -> IO.println("circle r=${c.r}");
    Rect(w, h)  -> IO.println("rect ${w}x${h}");
    _           -> IO.println("unknown");
}

// Match as expression with guard:
String label = match (score) {
    n if n >= 90 -> "A";
    n if n >= 80 -> "B";
    n if n >= 70 -> "C";
    _            -> "F";
};
```

### Generics with Bounds

```arm
public class SortedSet<T extends Comparable<T> & Serializable> {
    private items : List<T>;

    public add(item: T) : Void {
        items.append(item);
        items = items.sortedBy((a, b) -> a.compareTo(b));
    }
}
```

### Lambdas and Functional Collections

```arm
List<Order> urgent = orders
    .filter((o)  -> o.isPending() && o.value() > 1000)
    .sortedBy((a, b) -> a.deadline().compareTo(b.deadline()))
    .take(10);

String summary = urgent
    .map((o) -> "${o.id()}: $${o.value()}")
    .joinToString("\n");
```

### Defer

```arm
public processFile(path: String) : Void {
    File f = File.open(path, FileMode.READ);
    defer f.close();   // runs on scope exit — even if exception thrown

    String content = f.readAll();
    IO.println(content);
}
```

### Extension Methods

```arm
extend String {
    public toSlug() : String {
        return this.toLower().replace(" ", "-").trim();
    }
}

"Hello World".toSlug()   // "hello-world"
```

### Enums with Data

```arm
public enum Shape {
    Circle(radius: Float),
    Rectangle(width: Float, height: Float),
    Triangle(base: Float, height: Float)
}

Float area = match (shape) {
    Circle(r)    -> Math.PI * r * r;
    Rectangle(w, h) -> w * h;
    Triangle(b, h)  -> 0.5 * b * h;
};
```

---

## The `arc` Compiler

```bash
arc build                   # compile project from arc.toml
arc run                     # compile + run project
arc check                   # type-check only (no output)
arc Main.arm                # compile a single file directly
arc init  myapp             # scaffold new project
```

Key flags:

| Flag | Effect |
|---|---|
| `--stdlib-path <dir>` | Override stdlib location |
| `--target linux|windows` | Override target platform |

```toml
# arc.toml
[project]
name    = "myapp"
version = "0.1.0"
entry   = "Main.arm"
```

---

## Annotations

Arimo's annotation system covers the full range from high-level OOP to bare-metal:

```arm
// Optimization
@ForceInline          // always inline — no call overhead
@Pure                 // no side effects — optimizer hint

// Memory layout
@Packed               // remove struct padding
@Align(16)            // minimum alignment

// Memory management
@ManualMemory         // disable ARC — full manual control
@Immutable            // all fields readonly

// Low-level
@Section(".rodata")            // place in specific linker section
@CallingConvention("C")        // C ABI
@CallingConvention("Interrupt") // CPU interrupt handler

// Bare-metal
@Freestanding         // no stdlib — OS/kernel/embedded use

// Developer intent
@Deprecated("msg")    // usage warning
@Experimental         // API may change
@Sealed               // subclassable within same package only
@Throws(IOException)  // documents possible exceptions
@FunctionalInterface  // enforce single-abstract-method

// Branch prediction
@Likely               // branch usually taken
@Unlikely             // branch rarely taken
```

---

## Standard Library

All `arimo.lang` classes are available without import:

| Package | Contents |
|---|---|
| `arimo.lang` (auto) | `IO`, `Math`, `String`, `Integer`, `Float`, `Boolean`, `Char`, `StringBuilder`, `Time`, `Memory`, `System`, exception hierarchy |
| `arimo.fs` | `File`, `Path`, `Directory`, `FileMode`, `IOException` |
| `arimo.io` | `InputStream`, `BufferedReader` |
| `arimo.util` | `ArrayList`, `Optional`, `Scanner`, `Random` |
| `arimo.env` | `Env`, `Process` |

Collections (`List<T>`, `HashMap<K,V>`, `TreeMap<K,V>`, `Array<T,N>`, `Slice<T>`, `Pair<A,B>`, `Result<T,E>`) are built-in.

---

## Quick Comparison

| | **Arimo** | Java | C++ | Rust | Go |
|---|---|---|---|---|---|
| Memory model | ARC + GC + Manual, BorrowChecker planned | GC | Manual | Ownership | GC |
| Null safety | Built-in (`?`) | Optional (verbose) | None | `Option<T>` | None |
| Own IR | ✅ ArimoIR | JVM bytecode | LLVM/direct | LLVM | Go IR |
| Manual opt-out | ✅ `@ManualMemory` | ❌ | ✅ | Limited | ❌ |
| OS/kernel target | ✅ `@Freestanding` | ❌ | ✅ | ✅ | Limited |
| SIMD built-in | ✅ `Vec4f` etc. | ❌ | Partial | Partial | ❌ |
| Inline assembly | ✅ `asm {}` | ❌ | ✅ | ✅ | ❌ |
| Pattern matching | ✅ | Java 21+ | Limited | ✅ | ❌ |
| Null-safe chaining | ✅ `?.` `??` | ❌ | ❌ | `?` | ❌ |
| OOP + functional | ✅ | ✅ | Partial | Partial | Partial |

---

## Getting Started

### Install

```bash
# Download arc for your platform from Releases
# Place arc.exe (Windows) or arc (Linux/macOS) on your PATH
arc --version
# arc v1.0
```

### Hello World

```arm
package hello;

public class Application {
    public static main() : Void {
        IO.println("Hello, Arimo!");
    }
}
```

```bash
arc run
# Hello, Arimo!
```

### New Project

```bash
arc init myapp
cd myapp
arc run
```

---

## Documentation

Full language reference: **[documentation/index.md](documentation/index.md)**

| Section | Contents |
|---|---|
| [Getting Started](documentation/getting-started/introduction.md) | Installation, hello world, arc.toml |
| [Language](documentation/language/variables-and-types.md) | Types, operators, control flow, OOP, generics, pattern matching, async |
| [Memory](documentation/memory/memory-model.md) | ARC+GC target model, manual memory, planned BorrowChecker |
| [Collections](documentation/collections/collections-overview.md) | List, HashMap, Array, Slice, Result |
| [Standard Library](documentation/stdlib/stdlib-overview.md) | arimo.lang, arimo.fs, arimo.io, arimo.util, arimo.env |
| [CLI](documentation/cli/arc-cli.md) | arc build, run, check, init, direct file mode |
| [Project Status](documentation/reference/project-status.md) | Current v1.0 scope, gaps, and planned work |

---

## Versioning

| Version | Status | Highlights |
|---|---|---|
| **v1.0** | Active milestone | Arimo-written compiler, ArimoIR, native backend, core OOP/type system |
| v0.5-beta | Historical | Rust bootstrap compiler retained for language history |
| v1.1 | Planned | stdlib expansion, Math trig, regex |
| v1.2 | Planned | `async`/`await` runtime, coroutine scheduler |
| v2.0 | Future | Completed memory-safety layers and package ecosystem |

---

## License

GNU Affero General Public License v3.0 — see [LICENSE](LICENSE)

Any use, modification, or distribution — including network services — must be released under the same AGPL-3.0 terms.

---

<p align="center">
  Built with <strong>arc</strong> · Written in <strong>.arm</strong> · <a href="documentation/index.md">Read the docs</a>
</p>
