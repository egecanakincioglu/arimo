---
title: Advanced Type System Features
description: Union types, intersection types, conditional types, mapped types, and template literal types — not in Arimo v1.0.0
tags: [missing-features, type-system]
date: 2026-05-22
---

# Advanced Type System Features

Features from TypeScript's structural/algebraic type system that are **not in Arimo v1.0.0**.

## Union Types

**TypeScript:**
```typescript
function format(value: string | number): string {
    return String(value);
}
```

Arimo has no union types. A variable has exactly one static type.

**Workaround:** Use a sealed class hierarchy or `Result<T, E>`:

```arm
abstract class StringOrNumber { }
public class StringVal extends StringOrNumber { public val : String; }
public class NumberVal extends StringOrNumber { public val : Integer; }

StringOrNumber x = StringVal();
```

For two-variant cases, [[result]] (`Result<T, E>`) covers success/failure unions.

## Intersection Types

**TypeScript:**
```typescript
type Named = { name: string };
type Aged  = { age: number };
type Person = Named & Aged;
```

Arimo has no intersection types. Use multiple interface implementation instead:

```arm
interface Named { getName() : String; }
interface Aged   { getAge()  : Integer; }

public class Person implements Named, Aged {
    // ...
}
```

## Conditional Types

**TypeScript:**
```typescript
type IsString<T> = T extends string ? "yes" : "no";
```

Not supported. Arimo generics use bounded type parameters (`<T extends Comparable<T>>`) but have no conditional type expressions.

## Mapped Types

**TypeScript:**
```typescript
type Readonly<T> = { readonly [K in keyof T]: T[K] };
type Partial<T>  = { [K in keyof T]?: T[K] };
```

Not supported. Arimo has no `keyof`, `typeof`, or mapped-type iteration over fields.

## Template Literal Types

**TypeScript:**
```typescript
type EventName = `on${string}`;
```

Not supported. Arimo [[string-interpolation]] is runtime-only; strings cannot be used as types.

## `typeof` / `keyof` Operators (Type Level)

**TypeScript:**
```typescript
type Keys   = keyof Person;       // "name" | "age"
type ValType = typeof someVar;    // infers type of variable
```

Not supported. `typeof` does not exist as a type-level operator in Arimo.

## Tuple Types

**TypeScript:**
```typescript
let pair: [string, number] = ["Alice", 30];
let [name, age] = pair;
```

Arimo has [[pair]] (`Pair<A, B>`) for two elements, but no general fixed-length heterogeneous tuple types, and no tuple destructuring.

## Declaration Merging

**TypeScript:**
```typescript
interface Box { width: number; }
interface Box { height: number; }  // merged: Box has both
```

Not supported. Arimo interfaces are closed; re-declaring an interface is an error.

## Property Getters / Setters (TypeScript / Java)

**TypeScript:**
```typescript
class Circle {
    private _r = 0;
    get radius()          { return this._r; }
    set radius(v: number) { this._r = v; }
}
```

**Java:**
```java
public int getRadius() { return r; }
public void setRadius(int v) { this.r = v; }
```

Arimo has no `get`/`set` keyword syntax. Use explicit methods:

```arm
public class Circle {
    private r : Float;

    public getRadius() : Float { return r; }
    public setRadius(val: Float) : Void { r = val; }
}
```

## Related

- [[variables-and-types]] — Arimo type system
- [[generics]] — Arimo generics
- [[generics-advanced]] — C++ template specialization gaps
- [[type-narrowing]] — instanceof and type guards
