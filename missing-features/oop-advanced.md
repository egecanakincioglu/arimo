---
title: Advanced OOP Features
description: Multiple inheritance, friend classes, nested/inner classes, anonymous classes, operator overloading on classes — not in Arimo v1.0.0
tags: [missing-features, oop]
date: 2026-05-22
---

# Advanced OOP Features

OOP features from C++, Java, and TypeScript that are **not in Arimo v1.0.0**.

## Multiple Inheritance (C++)

**C++:**
```cpp
class Flyable { public: virtual void fly() = 0; };
class Swimmable { public: virtual void swim() = 0; };
class Duck : public Flyable, public Swimmable { ... };
```

Arimo supports single-class inheritance only (`extends` one class). Multiple **interfaces** (`implements A, B, C`) are supported.

**Workaround:** Use interfaces with default implementations:

```arm
interface Flyable  { fly()  : Void; }
interface Swimmable { swim() : Void; }

public class Duck implements Flyable, Swimmable {
    public fly()  : Void { IO.println("flying"); }
    public swim() : Void { IO.println("swimming"); }
}
```

## Friend Classes / Functions (C++)

**C++:**
```cpp
class Engine {
    friend class Car;   // Car can access Engine's private members
    private: int rpm;
};
```

Not supported. Arimo access modifiers are `public` / `private` / `protected` — no cross-class access grants.

## Nested / Inner Classes

**Java:**
```java
public class Outer {
    private int x = 10;
    class Inner {
        void show() { System.out.println(x); }  // accesses outer instance
    }
}
```

Arimo has no nested class syntax. All classes are top-level.

**Workaround:** Pass the outer instance as a constructor argument:

```arm
public class Inner {
    private outer : Outer;
    public Inner(o: Outer) { outer = o; }
}
```

## Static Nested Classes (Java)

**Java:**
```java
public class Graph {
    public static class Node { int value; }
}
```

Not supported. Use a separate top-level class with a naming convention:

```arm
public class GraphNode {
    public value : Integer;
}
```

## Anonymous Classes (Java)

**Java:**
```java
Runnable r = new Runnable() {
    @Override
    public void run() { System.out.println("running"); }
};
```

Not supported. Use lambdas for single-method interfaces:

```arm
() -> Void r = () -> { IO.println("running"); };
```

## Operator Overloading on Classes (C++)

**C++:**
```cpp
class Vec {
    Vec operator+(const Vec& other) const { ... }
    bool operator==(const Vec& other) const { ... }
};
```

Arimo supports operator overloading only on **structs**:

```arm
public struct Vec2 {
    public x : Float;
    public y : Float;

    public operator+(other: Vec2) : Vec2 {
        return Vec2(x + other.x, y + other.y);
    }
}
```

Classes cannot define operator overloads — use explicit named methods on classes.

## Mixin / Trait Composition (TypeScript / Scala)

**TypeScript:**
```typescript
type Constructor<T = {}> = new (...args: any[]) => T;
function Timestamped<TBase extends Constructor>(Base: TBase) {
    return class extends Base { timestamp = Date.now(); };
}
```

Not supported. Arimo has no first-class mixin or trait composition. Use interfaces with default methods as the closest approximation.

## Records / Data Classes (Java 16+)

**Java:**
```java
record Point(int x, int y) { }
// auto-generates: constructor, getters, equals, hashCode, toString
```

Not supported. Use a struct for value semantics or a class with manual methods:

```arm
public struct Point {
    public x : Integer;
    public y : Integer;
}
```

Structs give stack allocation and value equality but lack auto-generated `equals`/`toString`.

## Related

- [[classes]] — Arimo class system
- [[interfaces]] — multiple interface implementation
- [[structs]] — operator overloading, value types
- [[syntax-sugar]] — destructuring and other ergonomic gaps
