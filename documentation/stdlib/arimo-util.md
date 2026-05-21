---
title: arimo.util
description: ArrayList, Optional, Scanner, Random — utility classes
tags: [stdlib]
date: 2026-05-22
---

# arimo.util

```arm
import arimo.util.*;
// or individually:
import arimo.util.Optional;
import arimo.util.ArrayList;
```

## ArrayList

Integer-specialized dynamic list backed by a heap array. For generic collections, use the built-in `List<T>`.

```arm
constructor()
add(item: Integer) : Void
get(index: Integer) : Integer
size() : Integer
remove(index: Integer) : Void
contains(item: Integer) : Boolean
isEmpty() : Boolean
clear() : Void
```

```arm
ArrayList list = ArrayList();
list.add(10);
list.add(20);
list.add(30);

IO.println("size: ${list.size()}");       // 3
IO.println("get(0): ${list.get(0)}");     // 10
IO.println("contains(20): ${list.contains(20)}"); // true

list.remove(1);                           // removes index 1 (value 20)
IO.println("after remove size: ${list.size()}");  // 2
IO.println("get(1): ${list.get(1)}");     // 30
```

## Optional

Wraps a value that may or may not be present — an explicit alternative to `null`.

```arm
static of(v: Integer) : Optional
static empty() : Optional
isPresent() : Boolean
isEmpty() : Boolean
get() : Integer
orElse(other: Integer) : Integer
toString() : String
```

```arm
Optional opt1 = Optional.of(42);
IO.println("isPresent: ${opt1.isPresent()}");  // true
IO.println("get: ${opt1.get()}");              // 42
IO.println("orElse: ${opt1.orElse(99)}");      // 42

Optional opt2 = Optional.empty();
IO.println("isEmpty: ${opt2.isEmpty()}");      // true
IO.println("orElse: ${opt2.orElse(99)}");      // 99
```

> **Note:** Current `Optional` is Integer-specialized. Fully generic `Optional<T>` is planned for a future release.

## Random

Pseudorandom number generation. All methods are static.

```arm
Random.seed(s: Integer) : Void       // set seed
Random.seedTime() : Void             // seed with current time
Random.nextInt(max: Integer) : Integer   // [0, max)
Random.nextFloat() : Float           // [0.0, 1.0)
Random.nextBoolean() : Boolean       // true or false
```

```arm
Random.seed(42);
Integer r1 = Random.nextInt(100);    // 0..99
Integer r2 = Random.nextInt(100);
Float   f  = Random.nextFloat();     // 0.0..1.0
Boolean b  = Random.nextBoolean();

Random.seedTime();                   // non-deterministic seed
Integer r3 = Random.nextInt(10);
```

## Scanner (Planned)

For reading typed input from stdin:

```arm
Scanner sc = Scanner();
String  line = sc.nextLine();
Integer n    = sc.nextInt();
Float   f    = sc.nextFloat();
```

## Related

- [[list]] — `List<T>` generic dynamic array
- [[null-safety]] — nullable types vs `Optional`
- [[stdlib-overview]] — import rules
