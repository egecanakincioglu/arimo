---
title: Classes
description: Class declaration, constructors, inheritance, fields, access modifiers
tags: [language]
date: 2026-05-22
---

# Classes

## Declaration

```arm
public class Circle extends Shape implements Drawable, Movable {

    private readonly id     : String;
    private readonly radius : Float;
    private          color  : String;

    public constructor(id: String, radius: Float, color: String) {
        this.id     = id;
        this.radius = radius;
        this.color  = color;
    }

    public static create(radius: Float) : Circle {
        return Circle(Time.generateId(), radius, "red");
    }

    public getRadius() : Float { return this.radius; }
    public setColor(c: String) : Void { this.color = c; }

    public override toString() : String {
        return "Circle(r=${this.radius})";
    }
}
```

## Key Rules

- No `new` keyword — use `ClassName(args)` or a factory method
- Constructor is declared with the `constructor` keyword
- `this` refers to the current instance
- `readonly` fields can only be assigned in the constructor
- `static` members belong to the class, not an instance

## Fields

```arm
private readonly id     : String;             // immutable after construction
private          color  : String = "red";     // mutable, default value
public  static   MAX    : Integer = 50;       // class-level constant
public  static readonly VERSION : String = "1.0.0";
```

## Access Modifiers

| Modifier | Scope |
|---|---|
| `public` | All code |
| `private` | This class only |
| `protected` | This class and subclasses |
| `internal` | Same module |

## Constructors

```arm
public constructor(radius: Float) {
    this.radius = radius;
}
```

Only one constructor per class. Use static factory methods for alternate construction patterns.

## super()

Call the parent constructor from a subclass:

```arm
public class ColoredCircle extends Circle {
    public constructor(radius: Float, color: String) {
        super(Time.generateId(), radius, color);
    }
}
```

## Inheritance

A class can extend one class:

```arm
public class Square extends Shape implements Drawable {
    ...
}
```

`extends` — single class inheritance  
`implements` — one or more interfaces (comma-separated)

## Static Methods and Fields

```arm
public class Config {
    public static readonly MAX_SIZE : Integer = 1000;

    public static create() : Config {
        return Config();
    }
}

Config.MAX_SIZE       // access static field
Config cfg = Config.create();  // call static method
```

## toString()

Every class inherits `toString() : String` from `Object`. Override it:

```arm
public override toString() : String {
    return "[${this.status}] ${this.title}";
}
```

String interpolation calls `toString()` automatically:

```arm
IO.println("Task: ${task}");  // calls task.toString()
```

## Object Lifecycle

```arm
Counter c = Counter(0);   // created — ARC retains
c.increment();
// when 'c' goes out of scope — ARC releases
```

See [[memory-model]] for ARC details.

## Related

- [[interfaces]] — `implements` targets
- [[abstract-classes]] — `extends` abstract base
- [[functions-and-methods]] — method syntax
- [[memory-model]] — ARC lifecycle
