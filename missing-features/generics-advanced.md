---
title: Advanced Generics
description: Template specialization, SFINAE, concepts, partial specialization — not in Arimo v1.0.0
tags: [missing-features, generics]
date: 2026-05-22
---

# Advanced Generics

Features from C++ templates and TypeScript/Java generic utilities that are **not in Arimo v1.0.0**.

## Template Specialization (C++)

**C++:**
```cpp
template<typename T>
struct Serializer {
    static std::string serialize(T val) { /* default */ }
};

// Full specialization for int:
template<>
struct Serializer<int> {
    static std::string serialize(int val) { return std::to_string(val); }
};
```

Arimo generics do not support specialization. One generic class has one implementation for all type arguments.

**Workaround:** Interface dispatch — define a `Serializable` interface and implement per class.

## Partial Specialization (C++)

**C++:**
```cpp
template<typename T>
struct Wrapper<T*> { /* pointer specialization */ };
```

Not supported. Arimo has no pointer-level type patterns.

## SFINAE / `enable_if` (C++)

**C++:**
```cpp
template<typename T, typename = std::enable_if_t<std::is_integral_v<T>>>
T increment(T x) { return x + 1; }
```

Compile-time conditional instantiation based on type traits is not available. Arimo bounds are limited to named interfaces/classes.

## Concepts (C++20)

**C++:**
```cpp
template<typename T>
concept Numeric = std::is_integral_v<T> || std::is_floating_point_v<T>;

template<Numeric T>
T add(T a, T b) { return a + b; }
```

Not supported. Arimo bounds use `<T extends SomeInterface>` only — no inline predicate constraints.

## Variadic Templates (C++)

**C++:**
```cpp
template<typename... Args>
void log(Args... args) { (std::cout << ... << args); }
```

Not supported. Arimo methods have fixed arity. No variadic generics or variadic type lists.

## Higher-Kinded Types

**Haskell / Scala / TypeScript advanced:**
```typescript
interface Functor<F<_>> {
    map<A, B>(fa: F<A>, f: (a: A) => B): F<B>;
}
```

Not supported. Arimo type parameters are first-order only — `T` cannot itself be generic.

## Wildcards / Bounded Wildcards (Java)

**Java:**
```java
void printList(List<? extends Number> list) { ... }
void addNumbers(List<? super Integer> list) { ... }
```

Not supported. Arimo uses exact type arguments only. No covariant (`out T`) or contravariant (`in T`) variance annotations on generics.

## What Arimo Does Support

```arm
public class Box<T> {
    private value : T;
    public Box(v: T) { value = v; }
    public get() : T { return value; }
}

public class BoundedBox<T extends Comparable<T>> {
    private value : T;
    public isGreaterThan(other: T) : Boolean {
        return value.compareTo(other) > 0;
    }
}
```

Multiple bounds:
```arm
public class Processor<T extends Serializable & Comparable<T>> { }
```

## Related

- [[generics]] — Arimo generics (what is supported)
- [[interfaces]] — Interface-based dispatch as workaround
- [[type-system-advanced]] — TypeScript union/conditional types
