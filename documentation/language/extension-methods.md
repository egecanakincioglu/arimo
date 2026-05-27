---
title: Extension Methods
description: Adding methods to existing types with the extend keyword
tags: [language]
date: 2026-05-22
---

# Extension Methods

The `extend` keyword adds methods to an existing type without modifying its original class. This works for built-in types and user-defined types.

## Syntax

```arm
extend TypeName {
    methodName(params) : ReturnType {
        // 'this' refers to the extended value
    }
}
```

## Extending Built-in Types

```arm
extend Integer {
    isEven() : Boolean { return this % 2 == 0; }
    isOdd()  : Boolean { return this % 2 != 0; }

    abs() : Integer {
        if (this < 0) { return -this; }
        return this;
    }

    squared() : Integer { return this * this; }
}

extend Float {
    isPositive() : Boolean { return this > 0.0; }
}
```

Using the extensions:

```arm
IO.println("4.isEven: ${4.isEven()}");    // true
IO.println("7.isOdd: ${7.isOdd()}");      // true
IO.println("(-5).abs: ${(-5).abs()}");    // 5
IO.println("6.squared: ${6.squared()}");  // 36
```

## Extending User Types

```arm
public class Task {
    private title : String;
    private done  : Boolean;
    ...
}

extend Task {
    summary() : String {
        String status = this.done ? "✓" : "○";
        return "${status} ${this.title}";
    }
}
```

## Extending String

```arm
extend String {
    isBlank() : Boolean {
        return this.length() == 0;
    }
}
```

## Scope

Extension methods are available in the file (and package) where they are declared. They do not modify the original class and do not appear in other packages unless explicitly imported.

## Calling Extension Methods

Extensions are called exactly like regular methods:

```arm
Integer n = -7;
Integer positive = n.abs();   // extension method
```

## Related

- [classes](../language/classes.md) — regular method declaration
- [interfaces](../language/interfaces.md) — `@FunctionalInterface` single-method contract
