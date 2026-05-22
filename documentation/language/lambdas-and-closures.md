---
title: Lambdas and Closures
description: Lambda expressions, function types, closures, and higher-order methods
tags: [language]
date: 2026-05-22
---

# Lambdas and Closures

## Function Type Syntax

```arm
(ParamType) -> ReturnType
(ParamType1, ParamType2) -> ReturnType
() -> ReturnType
```

## Lambda Expression

```arm
(Integer) -> Boolean isPositive = (x) -> x > 0;
(Integer, Integer) -> Integer add = (a, b) -> a + b;
(String) -> Void logger = (msg) -> IO.println(msg);
```

Call a lambda like a method:

```arm
Boolean result = isPositive(42);   // true
Integer sum    = add(3, 4);        // 7
logger("hello");
```

## Closures — Capturing Variables

Lambdas capture variables from their enclosing scope:

```arm
Integer x = 10;
(Integer) -> Integer addX = (n) -> n + x;   // captures x

Integer result = addX(5);   // 15
```

Multiple captures:

```arm
Integer a = 3;
Integer b = 7;
(Integer) -> Integer sumAB = (n) -> n + a + b;   // captures a and b
Integer result = sumAB(0);   // 10
```

## Inline Usage

Lambdas are most commonly passed directly to collection methods:

```arm
List<Task> done = tasks.filter((t) -> t.isDone());
tasks.forEach((t) -> IO.println(t.getTitle()));
List<Task> sorted = tasks.sortedBy((a, b) -> a.getTitle().compareTo(b.getTitle()));
```

## Method Chaining with Lambdas

```arm
List<Task> urgent5 = this.tasks
    .filter((t)   -> t.isUrgent() && !t.isDone())
    .sortedBy((a, b) -> a.getDueDate().compareTo(b.getDueDate()))
    .take(5);
```

## Passing Lambdas as Variables

```arm
(Integer) -> Boolean isEven = (x) -> x % 2 == 0;

List<Integer> nums = List();
nums.append(1); nums.append(2); nums.append(3); nums.append(4);

List<Integer> evens = nums.filter(isEven);   // pass stored lambda
```

## Lambda Implementation

Closures are implemented as fat pointers: a function pointer plus a heap-allocated capture struct. No garbage collection — the capture struct is freed when the lambda goes out of scope.

## Related

- [list](../collections/list.md) — `filter`, `map`, `forEach`, `sortedBy`
- [functions-and-methods](../language/functions-and-methods.md) — regular method syntax
- [memory-model](../memory/memory-model.md) — closure capture lifetime
