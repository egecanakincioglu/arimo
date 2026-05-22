---
title: Pattern Matching
description: match statement — enum destructuring, literal patterns, guards, binding, multi-pattern
tags: [language]
date: 2026-05-22
---

# Pattern Matching

## Basic match

`match` can be used as a statement or an expression:

```arm
match direction {
    Direction.North => IO.println("north"),
    Direction.South => IO.println("south"),
    _               => IO.println("other"),
}
```

As an expression (assigns to a variable):

```arm
String label = match priority {
    Priority.High     => "high",
    Priority.Critical => "critical",
    _                 => "normal",
};
```

## Enum Variant Destructuring

Extract data from data-carrying enum variants:

```arm
match shape {
    Shape.Circle(r)       => IO.println("radius ${r}"),
    Shape.Rectangle(w, h) => IO.println("${w} x ${h}"),
    Shape.Point           => IO.println("point"),
    _                     => IO.println("unknown"),
}
```

## String Patterns

```arm
String cmd = "quit";
String result = match cmd {
    "quit" | "exit" => "exiting",
    "help"          => "showing help",
    _               => "unknown command",
};
```

## Integer Patterns

```arm
Integer n = 2;
String s = match n {
    0 => "zero",
    1 => "one",
    2 => "two",
    _ => "other",
};
```

## Multi-Pattern (OR)

Use `|` to match multiple patterns with the same arm:

```arm
match cmd {
    "quit" | "exit" | "q" => IO.println("goodbye"),
    _                      => IO.println("continuing"),
}
```

## Match Guards

Add an `if` condition to a pattern arm:

```arm
Integer x = 42;
String g = match x {
    v if v < 0   => "negative",
    v if v == 0  => "zero",
    v if v < 100 => "small positive",
    v            => "large",
};
```

The binding name (`v`) is available in the guard and the arm body.

## Binding

Bind the matched value to a name:

```arm
match value {
    v if v > 0 => IO.println("positive: ${v}"),
    v          => IO.println("non-positive: ${v}"),
}
```

## Result Matching

```arm
Result<String, String> r = FileSystem.read("/path");

match r {
    Result.Ok(content) => IO.println("content: ${content}"),
    Result.Err(msg)    => IO.println("error: ${msg}"),
}
```

## Exhaustiveness

The `_` wildcard arm catches all unmatched cases. Without it, all enum variants must be explicitly listed. The compiler warns about non-exhaustive matches.

## Related

- [enums](../language/enums.md) — data-carrying enum variants
- [control-flow](../language/control-flow.md) — `switch` statement
- [result](../collections/result.md) — `Result<T, E>` matching
