---
title: Abstract Classes
description: Abstract class declaration, abstract methods, and inheritance rules
tags: [language]
date: 2026-05-22
---

# Abstract Classes

An abstract class cannot be instantiated directly. It defines a partial implementation and requires subclasses to provide the missing methods.

## Declaration

```arm
public abstract class Shape implements Drawable {
    private readonly color : String;

    protected constructor(color: String) {
        this.color = color;
    }

    public getColor() : String { return this.color; }

    public abstract draw()  : Void;    // must be implemented by subclass
    public abstract area()  : Float;   // must be implemented by subclass
}
```

## Extending an Abstract Class

```arm
public class Circle extends Shape {
    private readonly radius : Float;

    public constructor(radius: Float, color: String) {
        super(color);
        this.radius = radius;
    }

    public draw() : Void {
        IO.println("Drawing circle");
    }

    public area() : Float {
        return 3.14159 * this.radius * this.radius;
    }
}
```

All `abstract` methods must be implemented. Failing to do so causes a compile error.

## Rules

- Abstract classes use `abstract` keyword before `class`
- Abstract methods use `abstract` before the return type
- Abstract methods have no body — no `{}`
- Abstract classes can have concrete (non-abstract) methods
- Abstract classes can have constructors, called via `super()`
- Cannot instantiate an abstract class directly

```arm
Shape s = Shape("red");   // ERROR — cannot instantiate abstract class
Shape s = Circle(5.0, "red");  // OK — polymorphic reference
```

## @Sealed

Annotate with `@Sealed` to restrict subclassing to the same package:

```arm
@Sealed
public abstract class Shape {
    public abstract area() : Float;
}
```

## Related

- [classes](../language/classes.md) — concrete class declaration
- [[interfaces]] — interface contracts
- [[annotations]] — `@Sealed`
