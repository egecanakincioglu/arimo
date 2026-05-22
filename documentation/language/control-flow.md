---
title: Control Flow
description: if/else, while, for, for-each, switch, break, continue
tags: [language]
date: 2026-05-22
---

# Control Flow

## if / else if / else

```arm
if (x > 0) {
    IO.println("positive");
} else if (x == 0) {
    IO.println("zero");
} else {
    IO.println("negative");
}
```

## Ternary Expression

```arm
String label = isUrgent ? "urgent" : "normal";
```

## while

```arm
Integer count = 3;
while (count > 0) {
    IO.println("counting...");
    count--;
}
```

## for (C-style)

```arm
for (Integer i = 0; i < 10; i++) {
    IO.println("i = ${i}");
}
```

### break and continue

```arm
for (Integer i = 0; i < 10; i++) {
    if (i == 5) { break; }      // exit loop
    if (i % 2 != 0) { continue; } // skip to next iteration
    IO.println("even: ${i}");
}
```

## for-each

Iterate over a collection. Two equivalent syntaxes:

```arm
for (Task task : this.tasks) {
    IO.println(task.getTitle());
}

for (Task task in this.tasks) {   // alternative
    IO.println(task.getTitle());
}
```

Both `:` and `in` are accepted.

## switch

`switch` matches on an expression. No `break` needed — each case is a separate execution path that returns or exits. Use `break` to fall out of a `default` or non-returning case.

```arm
switch (priority) {
    case Priority.High:     return "high";
    case Priority.Critical: return "critical";
    default: IO.println("other"); break;
}
```

`switch` works on enums, integers, and strings.

## match

`match` is a pattern-matching expression that can return a value. See [pattern-matching](../language/pattern-matching.md) for full syntax.

```arm
String desc = match shape {
    Shape.Circle(r)       => "circle",
    Shape.Rectangle(w, h) => "rectangle",
    _                     => "other",
};
```

`match` supports:
- Enum variant destructuring
- String literals
- Integer literals
- Match guards (`if condition`)
- Multiple patterns (`"quit" | "exit" => ...`)
- Binding (`v => ...` or `v if v > 0 => ...`)

## Related

- [pattern-matching](../language/pattern-matching.md) — full `match` reference
- [enums](../language/enums.md) — enum pattern matching
- [operators](../language/operators.md) — comparison operators used in conditions
