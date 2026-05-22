---
title: Null Safety
description: Nullable types, null-safe access operator, null coalescing, and smart cast
tags: [language]
date: 2026-05-22
---

# Null Safety

## Nullable Types

Append `?` to make a type nullable. Without `?`, a type can never be `null`:

```arm
String  name = "Arimo";    // cannot be null — compiler guarantees
String? name = null;       // explicitly nullable
```

Assigning `null` to a non-nullable type is a compile error.

## Smart Cast

Inside an `if (x != null)` block, the nullable type is automatically narrowed to non-nullable:

```arm
String? title = task.getTitle();
if (title != null) {
    IO.println(title.toUpper());   // title is String here, not String?
}
```

## Null-Safe Access (`?.`)

Access a method or field only if the receiver is non-null. Returns `null` if the receiver is `null`:

```arm
String?  upper = name?.toUpper();     // null if name is null
Integer? len   = name?.length();      // chain
String?  addr  = user?.address;       // field access
String?  found = user?.findTask("id"); // method with args
```

The result type is always nullable — `?.` can never produce a non-nullable value.

## Null Coalescing (`??`)

Returns the left side if non-null; otherwise the right side:

```arm
Integer n = maybeInt ?? 0;
String s  = name?.toUpper() ?? "UNKNOWN";
String display = user?.getName() ?? "anonymous";
```

The right side must be a non-nullable type matching the left side's base type.

## Combining `?.` and `??`

```arm
String label = task?.getTitle() ?? "Untitled";
Integer count = list?.length() ?? 0;
```

## Nullable Fields

```arm
public class User {
    private name    : String;
    private address : String?;   // optional field

    public getAddress() : String? {
        return this.address;
    }
}
```

## Related

- [variables-and-types](../language/variables-and-types.md) — nullable type syntax
- [operators](../language/operators.md) — `?.` and `??` operator precedence
- [type-casting](../language/type-casting.md) — casting nullable types
