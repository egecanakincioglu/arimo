---
title: Collections Overview
description: All collection types in Arimo — List, HashMap, Array, Slice, Pair, Result
tags: [collections]
date: 2026-05-22
---

# Collections Overview

Arimo has six collection types. Four are built-in to the compiler; two are value types.

## Summary

| Type | Kind | Heap/Stack | Resizable | Notes |
|---|---|---|---|---|
| `List<T>` | Sequence | Heap | Yes | Most common collection |
| `HashMap<K,V>` | Key-value map | Heap | Yes | Unordered |
| `TreeMap<K,V>` | Key-value map | Heap | Yes | Keys sorted |
| `Array<T,N>` | Sequence | Stack | No | Fixed size, compile-time N |
| `Slice<T>` | View | Neither | No | Non-owning pointer + length |
| `Pair<A,B>` | Tuple | Heap | No | Two values |
| `Result<T,E>` | Enum | — | No | Success or error |

## Choosing a Collection

| Situation | Use |
|---|---|
| Dynamic list of objects | `List<T>` |
| Key-value lookup | `HashMap<K,V>` |
| Key-value with sorted keys | `TreeMap<K,V>` |
| Fixed-size buffer, stack | `Array<T,N>` |
| View into array without copying | `Slice<T>` |
| Return two values | `Pair<A,B>` |
| Function that may fail | `Result<T,E>` |

## Construction

```arm
List<String>           names   = List();
List<String>           preset  = List.of("Alice", "Bob");
HashMap<String,Integer> scores = HashMap();
Array<Float, 4>        vec4    = Array.zeroed();
Pair<String,Integer>   p       = Pair.of("score", 100);
Result<String,String>  ok      = Result.Ok("data");
```

## Lambda Pipeline (List)

```arm
List<Task> urgent5 = this.tasks
    .filter((t)   -> !t.isDone() && t.isUrgent())
    .sortedBy((a, b) -> a.getDueDate().compareTo(b.getDueDate()))
    .take(5);
```

## Detailed References

- [list](../collections/list.md) — `List<T>` full API
- [hashmap](../collections/hashmap.md) — `HashMap<K,V>` and `TreeMap<K,V>`
- [array](../collections/array.md) — `Array<T,N>`
- [slice](../collections/slice.md) — `Slice<T>`
- [pair](../collections/pair.md) — `Pair<A,B>`
- [result](../collections/result.md) — `Result<T,E>`
