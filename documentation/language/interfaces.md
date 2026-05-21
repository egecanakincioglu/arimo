---
title: Interfaces
description: Interface declaration, implementation, default methods
tags: [language]
date: 2026-05-22
---

# Interfaces

## Declaration

```arm
public interface Drawable {
    draw() : Void;      // abstract — no body
    area() : Float;

    default describe() : String {    // default implementation
        return "A drawable object";
    }
}
```

Interface methods are implicitly `public`. Do not write an access modifier.

## Implementation

```arm
public class Circle implements Drawable {
    private readonly radius : Float;

    public constructor(radius: Float) {
        this.radius = radius;
    }

    public draw() : Void {
        IO.println("Drawing circle r=${this.radius}");
    }

    public area() : Float {
        return 3.14159 * this.radius * this.radius;
    }
}
```

Every non-default method must be implemented. Missing implementations cause a compile error.

## Multiple Interfaces

```arm
public class Circle extends Shape implements Drawable, Movable {
    ...
}
```

A class can implement any number of interfaces.

## Default Methods

Default methods provide a fallback implementation. Classes can override them:

```arm
public interface Printable {
    print() : Void;

    default printWithBorder() : Void {
        IO.println("---");
        this.print();
        IO.println("---");
    }
}
```

## Interface as Type

```arm
Drawable d = Circle(5.0);    // polymorphic reference
d.draw();
d.area();
```

## @FunctionalInterface

Interfaces with exactly one abstract method can be annotated with `@FunctionalInterface`. This ensures the interface stays single-method:

```arm
@FunctionalInterface
interface Runnable {
    run() : Void;
}

@FunctionalInterface
interface Comparator {
    compare(a: Float, b: Float) : Integer;
}
```

## Built-in Interfaces

From `arimo.lang`:

| Interface | Method |
|---|---|
| `Comparable<T>` | `compareTo(other: T) : Integer` |
| `Iterable<T>` | enables `for-each` iteration |
| `Runnable` | `run() : Void` |
| `Callable<T>` | `call() : T` |
| `AutoCloseable` | `close() : Void` |

## Related

- [[classes]] — implementing interfaces
- [[abstract-classes]] — abstract base classes
- [[generics]] — generic interface bounds
- [[annotations]] — `@FunctionalInterface`
