---
title: Functions and Methods
description: Instance methods, static methods, constructors, default parameters, return types
tags: [language]
date: 2026-05-22
---

# Functions and Methods

Arimo has no top-level functions. All methods belong to a class, interface, struct, or enum.

## Instance Method

```arm
public class Counter {
    private count : Integer;

    public constructor(start: Integer) {
        this.count = start;
    }

    public increment() : Void {
        this.count = this.count + 1;
    }

    public getCount() : Integer {
        return this.count;
    }
}
```

## Static Method

```arm
public class MathUtils {
    public static square(x: Float) : Float {
        return x * x;
    }

    public static max(a: Integer, b: Integer) : Integer {
        return a > b ? a : b;
    }
}

Float result = MathUtils.square(3.0);
```

## Access Modifiers

| Modifier | Accessible From |
|---|---|
| `public` | Everywhere |
| `private` | This class only |
| `protected` | This class and subclasses |
| `internal` | Same module only |

## Default Parameters

Parameters can have default values:

```arm
public class Calculator {
    public static add(a: Integer, b: Integer = 0) : Integer {
        return a + b;
    }

    public static greet(name: String, prefix: String = "Hello") : String {
        return "${prefix}, ${name}!";
    }
}

Calculator.add(3);           // b = 0 → 3
Calculator.add(3, 4);        // 7
Calculator.greet("Ali");     // "Hello, Ali!"
Calculator.greet("Ali", "Hi"); // "Hi, Ali!"
```

Default arguments must come after required arguments.

## Return Type

Every method must declare its return type after `:`:

```arm
public getTitle() : String { return this.title; }
public process()  : Void   { ... }
public tryGet()   : String? { return null; }
```

## noreturn

A method that never returns (calls `exit`, throws unconditionally, or loops forever):

```arm
public static panic(msg: String) : noreturn {
    Syscall.exit(1);
}
```

## override

Use `override` when replacing a parent class method:

```arm
public override toString() : String {
    return "Circle(r=${this.radius})";
}
```

`override` is optional but recommended for clarity. The compiler does not require it.

## Calling Methods

```arm
Counter c = Counter(0);   // construct — no 'new'
c.increment();
Integer n = c.getCount();

MathUtils.square(4.0);   // static call
```

## Related

- [classes](../language/classes.md) — class structure
- [lambdas-and-closures](../language/lambdas-and-closures.md) — function types and lambda expressions
- [extension-methods](../language/extension-methods.md) — add methods to existing types
