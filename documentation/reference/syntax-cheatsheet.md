---
title: Syntax Cheatsheet
description: One-page quick reference for Arimo syntax
tags: [reference]
date: 2026-05-22
---

# Syntax Cheatsheet

## File Structure

```arm
package myapp;

import arimo.fs.*;
import arimo.util.Optional;

public class MyClass extends BaseClass implements InterfaceA, InterfaceB {
    // ...
}
```

## Variables

```arm
String  name  = "Arimo";      // local: type before name
Integer count = 0;
String? maybe = null;         // nullable
```

## Fields

```arm
private readonly id    : String;          // immutable
private          color : String = "red";  // mutable + default
public  static   MAX   : Integer = 100;   // class constant
```

## Methods

```arm
public getTitle() : String { return this.title; }
public static create() : Circle { return Circle(0.0); }
public process(name: String, size: Integer = 1) : Void { ... }
public override toString() : String { return "..."; }
```

## Constructor

```arm
public constructor(id: String, radius: Float) {
    super(id);             // call parent constructor
    this.radius = radius;
}
```

## Control Flow

```arm
if (x > 0) { ... } else if (x == 0) { ... } else { ... }

String s = cond ? "yes" : "no";   // ternary

while (count > 0) { count--; }

for (Integer i = 0; i < 10; i++) { ... }
for (Task t : list) { ... }
for (Task t in list) { ... }   // same

switch (direction) {
    case Direction.North: return "N";
    default: break;
}

String label = match shape {
    Shape.Circle(r)       => "circle",
    Shape.Rectangle(w, h) => "rect",
    _ if x > 0            => "other-positive",
    _                     => "other",
};
```

## Classes

```arm
public class Circle extends Shape implements Drawable {
    private readonly radius : Float;
    public constructor(r: Float) { this.radius = r; }
    public area() : Float { return 3.14 * this.radius * this.radius; }
}
Circle c = Circle(5.0);   // no 'new'
```

## Interface

```arm
public interface Drawable {
    draw() : Void;
    default describe() : String { return "drawable"; }
}
```

## Abstract Class

```arm
public abstract class Shape {
    public abstract area() : Float;
    public getType() : String { return "shape"; }
}
```

## Enum

```arm
public enum Color { Red, Green, Blue; }
public enum Shape { Circle(Float), Rectangle(Float, Float), Point; }
Color c = Color.Red;
Shape s = Shape.Circle(5.0);
```

## Struct

```arm
public struct Vec3 {
    x : Float; y : Float; z : Float;
    public operator +(other: Vec3) : Vec3 { ... }
}
Vec3 v = Vec3(1.0, 0.0, 0.0);
```

## Lambda

```arm
(Integer) -> Boolean isPos = (x) -> x > 0;
(Integer, Integer) -> Integer add = (a, b) -> a + b;
tasks.filter((t) -> t.isDone());
tasks.sortedBy((a, b) -> a.getTitle().compareTo(b.getTitle()));
```

## Null Safety

```arm
String? name = null;
String? up   = name?.toUpper();
Integer n    = name?.length() ?? 0;
if (name != null) { IO.println(name); }   // smart cast
```

## Exceptions

```arm
throw IllegalArgumentException("bad input");
try { ... } catch (IOException ex) { ... } finally { ... }
```

## defer

```arm
defer file.close();   // runs on scope exit, LIFO
```

## Extensions

```arm
extend Integer {
    isEven() : Boolean { return this % 2 == 0; }
}
```

## extern C + asm

```arm
extern "C" {
    malloc(size: u64) : RawPtr<Void>;
}
@ManualMemory
public class Sys {
    public static exit(code: i32) : noreturn { asm { mov rax, 60; syscall } }
}
```

## Generics

```arm
public class Box<T> { private value : T; }
public class Renderer<T: Drawable> { ... }
```

## Type Alias

```arm
type NodeId = u32;
type Mat4   = Array<Float, 16>;
```

## Collections Quick Reference

```arm
List<String>          names = List();
HashMap<String,Integer> map = HashMap();
Array<Float, 4>       vec4  = Array.zeroed();
Pair<String,Integer>  pair  = Pair.of("k", 1);
Result<String,String> ok    = Result.Ok("data");
```

## Modifiers Quick Reference

```arm
public / private / protected / internal
readonly   static   abstract   override   volatile
```

## Annotations Quick Reference

```arm
@ForceInline  @Pure  @ManualMemory  @Immutable
@Packed  @Align(N)  @Section(".name")
@CallingConvention("C"|"Windows"|"Interrupt")
@Deprecated("msg")  @Experimental  @Throws(ExType)
@Sealed  @FunctionalInterface  @SuppressWarnings("x")
@Likely  @Unlikely  @Freestanding
```

## Full References

- [[variables-and-types]] · [[operators]] · [[control-flow]]
- [[classes]] · [[interfaces]] · [[enums]] · [[structs]]
- [[lambdas-and-closures]] · [[pattern-matching]] · [[null-safety]]
- [[exceptions]] · [[defer]] · [[annotations]]
- [[collections-overview]] · [[arimo-lang]] · [[arc-cli]]
