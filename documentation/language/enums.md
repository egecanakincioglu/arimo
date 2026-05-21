---
title: Enums
description: Enumeration types — simple variants and data-carrying variants
tags: [language]
date: 2026-05-22
---

# Enums

## Simple Enum

```arm
public enum Direction {
    North,
    South,
    East,
    West;

    public label() : String {
        switch (this) {
            case Direction.North: return "North";
            case Direction.South: return "South";
            case Direction.East:  return "East";
            case Direction.West:  return "West";
        }
    }
}
```

## Using a Simple Enum

```arm
Direction d = Direction.North;

switch (d) {
    case Direction.North: IO.println("heading north");
    case Direction.South: IO.println("heading south");
    case Direction.East:  IO.println("heading east");
    case Direction.West:  IO.println("heading west");
}

if (d == Direction.North) {
    IO.println("north!");
}
```

## Enum with Methods

```arm
public enum Priority {
    Low, Medium, High, Critical;

    public isUrgent() : Boolean {
        return this == Priority.High || this == Priority.Critical;
    }
}

Priority p = Priority.High;
if (p.isUrgent()) {
    IO.println("urgent!");
}
```

## Data-Carrying Variants

Variants can carry associated values:

```arm
public enum Shape {
    Circle(Float),
    Rectangle(Float, Float),
    Triangle(Float, Float, Float),
    Point;

    public area() : Float {
        return match this {
            Shape.Circle(r)           => 3.14159 * r * r,
            Shape.Rectangle(w, h)     => w * h,
            Shape.Triangle(a, b, c)   => a,
            Shape.Point               => 0.0,
        };
    }
}
```

## Destructuring Data Variants

Use `match` to extract the values:

```arm
Shape s = Shape.Circle(5.0);

match s {
    Shape.Circle(r)       => IO.println("circle r=${r}"),
    Shape.Rectangle(w, h) => IO.println("${w}x${h}"),
    Shape.Point           => IO.println("point"),
    _                     => IO.println("other"),
}
```

You can also use `match` as an expression:

```arm
String name = match s {
    Shape.Circle(r)       => "circle",
    Shape.Rectangle(w, h) => "rectangle",
    Shape.Point           => "point",
    _                     => "unknown",
};
```

## Result — Built-in Enum

`Result<T, E>` is a built-in generic enum:

```arm
Result<String, String> ok  = Result.Ok("success");
Result<String, String> err = Result.Err("not found");
```

See [[result]] for full API.

## LLVM Representation

Enum variants are stored as `i32` values internally. Data-carrying variants use a tagged union layout.

## Related

- [[pattern-matching]] — `match` with guards and binding
- [[control-flow]] — `switch` on enums
- [[result]] — `Result<T, E>`
