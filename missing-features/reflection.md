---
title: Reflection
description: Runtime type information, reflection API, Class<T>, dynamic invocation — not in Arimo v1.0.0
tags: [missing-features, reflection]
date: 2026-05-22
---

# Reflection

Runtime reflection features from Java and TypeScript that are **not in Arimo v1.0.0**.

## Java Reflection API

**Java:**
```java
Class<?> cls      = obj.getClass();
String   name     = cls.getName();
Method[] methods  = cls.getMethods();
Field[]  fields   = cls.getFields();

Method m      = cls.getMethod("toString");
Object result = m.invoke(obj);
```

Not supported. Arimo has no `Class<T>`, `Method`, `Field`, or `Constructor` reflection types. Fields and methods cannot be enumerated at runtime.

## Dynamic Method Invocation

**Java:**
```java
Method m = SomeClass.class.getDeclaredMethod("compute", int.class);
m.setAccessible(true);
Object result = m.invoke(instance, 42);
```

Not supported. Method calls in Arimo are resolved at compile time. No runtime method lookup by name.

## `Class.forName` / Dynamic Loading

**Java:**
```java
Class<?> cls = Class.forName("com.example.MyClass");
Object   obj = cls.getDeclaredConstructor().newInstance();
```

Not supported. Arimo has no dynamic class loading or runtime class name resolution.

## Annotations at Runtime (Java)

**Java:**
```java
@Retention(RetentionPolicy.RUNTIME)
@interface MyAnnotation { String value(); }

MyAnnotation ann = obj.getClass().getAnnotation(MyAnnotation.class);
```

Arimo [[annotations]] are compile-time hints only (`@Override`, `@Deprecated`, `@Sealed`, etc.). No runtime annotation retention or retrieval.

## TypeScript / JavaScript `Object.keys`

**TypeScript:**
```typescript
const keys = Object.keys(obj);   // runtime array of property names
```

Not supported. Arimo objects do not expose property names at runtime.

## Proxy / Reflection Metadata (TypeScript)

**TypeScript:**
```typescript
import "reflect-metadata";
const type = Reflect.getMetadata("design:type", target, propertyKey);
```

Not supported. No `Reflect` API, no metadata decorators.

## RTTI (C++ `typeid` / `dynamic_cast`)

**C++:**
```cpp
typeid(obj).name()           // runtime type name
dynamic_cast<Derived*>(ptr)  // safe downcast, null on failure
```

Not supported. Arimo has no `typeid` or `dynamic_cast`. Use `match` on sealed hierarchies or `as` cast (throws `ClassCastException` on failure).

## What Arimo Does Support

- Virtual dispatch — override methods resolve polymorphically at runtime.
- `match` on sealed hierarchies — exhaustive type dispatch without reflection.
- `toString()`, `equals()`, `hashCode()` — inherited from `Object`, overridable.

```arm
abstract class Shape { }
public class Circle extends Shape {
    public toString() : String { return "Circle"; }
}

Shape s = Circle();
IO.println(s.toString());   // "Circle" — runtime dispatch, no reflection needed
```

## Related

- [[type-narrowing]] — instanceof and type guard gaps
- [[pattern-matching]] — match as reflection-free dispatch
- [[annotations]] — compile-time-only annotations
- [[classes]] — virtual dispatch in Arimo
