---
title: Arimo vs Java vs TypeScript
description: Side-by-side comparison of syntax and features
tags: [reference]
date: 2026-05-22
---

# Arimo vs Java vs TypeScript

## Syntax Comparison

| Feature | Arimo | Java | TypeScript |
|---|---|---|---|
| Variable (local) | `String name = "x";` | `String name = "x";` | `let name: string = "x";` |
| Field | `private id : String;` | `private String id;` | `private id: string;` |
| Parameter | `(radius: Float)` | `(float radius)` | `(radius: number)` |
| Return type | `method() : Type` | `Type method()` | `method(): Type` |
| Constructor | `constructor` keyword | class name | `constructor` |
| No `new` | `Circle(5.0)` | `new Circle(5.0)` | `new Circle(5.0)` |
| Readonly field | `readonly` | `final` | `readonly` |
| Null safety | `String?` | — | `string \| null` |
| String interpolation | `"${name}"` | — | `` `${name}` `` |
| Interface method | no modifier (public) | optional | no modifier |
| Override | `override` (optional) | `@Override` | `override` |
| Entry point | `public static main() : Void` | `public static void main(String[])` | — |

## OOP

| Feature | Arimo | Java | TypeScript |
|---|---|---|---|
| Single inheritance | `extends` | `extends` | `extends` |
| Multiple interfaces | `implements A, B` | `implements A, B` | `implements A, B` |
| Abstract class | `abstract class` | `abstract class` | `abstract class` |
| Interface defaults | `default method() {}` | `default method() {}` | — |
| Enum methods | Yes | Yes | Limited |
| Enum with data | Yes (typed variants) | No | No |
| Extension methods | `extend Type {}` | No | Prototype (unsafe) |
| Structs | Yes (stack, value) | No | No |

## Type System

| Feature | Arimo | Java | TypeScript |
|---|---|---|---|
| Generics | Yes (bounded) | Yes | Yes |
| Null safety | Built-in (`?`) | Optional (Java 8+) | Strict mode |
| Type inference | Locals only | `var` (Java 10+) | Yes |
| Explicit cast | `x as Type` | `(Type) x` | `x as Type` |
| Sized integers | `u8`..`i64` | No (primitives) | No |

## Memory and Performance

| Feature | Arimo | Java | TypeScript |
|---|---|---|---|
| GC | None (ARC) | Yes (GC) | Yes (GC) |
| Raw pointers | Yes (`RawPtr<T>`) | No | No |
| Inline assembly | Yes (`asm {}`) | No | No |
| extern C | Yes | JNI | No |
| Stack allocation | Yes (structs) | No | No |
| SIMD types | Yes (`Vec4f` etc.) | No | No |

## Collections

| Feature | Arimo | Java | TypeScript |
|---|---|---|---|
| Dynamic list | `List()` | `new ArrayList<>()` | `[]` |
| Map | `HashMap()` | `new HashMap<>()` | `{}` |
| Null-safe get | `map.get(k) ?? def` | `map.getOrDefault(k,d)` | `map.get(k) ?? def` |
| Pattern on enum | `match shape { Shape.Circle(r) => }` | No | No |

## Related

- [[introduction]] — Arimo design goals
- [[versioning]] — version history
