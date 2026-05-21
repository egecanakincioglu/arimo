---
title: Type Narrowing
description: instanceof pattern matching, type predicates, type guards — not in Arimo v1.0.0
tags: [missing-features, type-system]
date: 2026-05-22
---

# Type Narrowing

Runtime type inspection features from Java and TypeScript that are **not in Arimo v1.0.0**.

## `instanceof` Pattern Matching (Java 16+)

**Java:**
```java
Object obj = getObject();
if (obj instanceof String s) {
    System.out.println(s.length());   // s is already String here
}
```

The variable is both checked and bound in one expression. Arimo does not have this form. Use `match` with an abstract base:

```arm
// Requires sealed hierarchy:
abstract class Shape { }
public class Circle extends Shape { public r : Float; }
public class Rect   extends Shape { public w : Float; public h : Float; }

Shape s = getShape();
match (s) {
    Circle c  -> IO.println(c.r);
    Rect rect -> IO.println(rect.w);
}
```

`match` works with sealed class hierarchies. For arbitrary object types, casting is manual.

## Type Predicates (TypeScript)

**TypeScript:**
```typescript
function isString(x: unknown): x is string {
    return typeof x === "string";
}

if (isString(val)) {
    console.log(val.toUpperCase());   // narrowed to string
}
```

Not supported. Arimo has no user-defined type predicate functions that influence control-flow narrowing.

## Type Guards with `typeof` (TypeScript)

**TypeScript:**
```typescript
if (typeof value === "number") {
    // value is narrowed to number here
}
```

Not supported. Arimo is statically typed — `typeof` as a runtime type query on arbitrary values is not available.

## `instanceof` Without Pattern Binding (Java / TypeScript)

**Java:**
```java
if (obj instanceof String) {
    String s = (String) obj;
}
```

**TypeScript:**
```typescript
if (val instanceof MyClass) {
    val.myMethod();   // narrowed automatically
}
```

Arimo does not have `instanceof`. Use [[type-casting]] with `as` (unchecked) combined with class hierarchy knowledge, or use `match` on sealed hierarchies for safe dispatch.

## Downcasting with Safety Check

**Java:**
```java
if (shape instanceof Circle c) { ... }   // safe
```

**Arimo (manual approach):**
```arm
try {
    Circle c = shape as Circle;
    IO.println(c.r);
} catch (ClassCastException e) {
    IO.println("not a circle");
}
```

`match` on an abstract/sealed parent is the preferred pattern — no try/catch needed.

## Dynamic Dispatch on Non-Sealed Hierarchies

Arimo `match` requires the type to be part of a sealed hierarchy. For open hierarchies with arbitrary runtime types, there is no exhaustive type switch. Use virtual method dispatch (polymorphism) instead.

## `Class<T>` / `getClass()` (Java)

**Java:**
```java
Class<?> cls = obj.getClass();
String name  = cls.getName();
boolean same = obj.getClass() == other.getClass();
```

Not supported. Arimo has no `getClass()` or `Class<T>` runtime representation. Type identity at runtime is not exposed to user code.

## Related

- [[type-casting]] — `as` cast in Arimo
- [[pattern-matching]] — `match` on sealed hierarchies and enums
- [[exceptions]] — `ClassCastException`
- [[reflection]] — full reflection API gap
- [[type-system-advanced]] — union types, conditional types
