---
title: Generics
description: Generic classes, methods, type parameters, and bounds
tags: [language]
date: 2026-05-22
---

# Generics

## Generic Class

```arm
public class Box<T> {
    private value : T;

    public constructor(v: T) {
        this.value = v;
    }

    public get() : T {
        return this.value;
    }
}

Box<String>  sb = Box("hello");
Box<Integer> nb = Box(42);
String s = sb.get();
```

## Bounded Type Parameter

Restrict `T` to types that implement a specific interface:

```arm
public class Renderer<T: Drawable> {
    public render(item: T) : Void {
        item.draw();
    }
}
```

## Multiple Bounds

```arm
public class Sorter<T: Comparable + Printable> {
    ...
}
```

## Generic with Interface

```arm
interface Printable {
    print() : Void;
}

public class Printer<T: Printable> {
    private item : T;

    public constructor(item: T) {
        this.item = item;
    }

    public run() : Void {
        this.item.print();
    }
}
```

## Generic Enum — Result<T, E>

`Result` is a built-in generic enum:

```arm
Result<String, String> ok  = Result.Ok("data");
Result<String, String> err = Result.Err("not found");

match ok {
    Result.Ok(content) => IO.println("got: ${content}"),
    Result.Err(msg)    => IO.println("error: ${msg}"),
}
```

## Generic Collections

`List<T>`, `HashMap<K, V>`, `Array<T, N>`, `Slice<T>`, `Pair<A, B>` are all generic. See [collections-overview](../collections/collections-overview.md).

```arm
List<Integer>        nums   = List();
HashMap<String, Integer> map = HashMap();
```

## Current Limitations

Generic type instantiation is shallow in v1.0.0. The type checker validates bounds, but full generic specialization (monomorphization) is planned for v1.1.0. Practical generic usage works correctly for collections and `Result`.

## Related

- [collections-overview](../collections/collections-overview.md) — generic collection types
- [result](../collections/result.md) — `Result<T, E>`
- [interfaces](../language/interfaces.md) — interface bounds
