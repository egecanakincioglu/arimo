---
title: HashMap and TreeMap
description: HashMap<K,V> and TreeMap<K,V> — key-value map API
tags: [collections]
date: 2026-05-22
---

# HashMap and TreeMap

## HashMap\<K, V\>

Unordered key-value map backed by a hash table.

### Construction

```arm
HashMap<String, Integer> scores  = HashMap();
HashMap<String, Integer> preset  = HashMap.of("alice", 100, "bob", 90);
HashMap<String, Integer> alt     = HashMap.create();
```

### Core API

| Method | Returns | Description |
|---|---|---|
| `set(key, value)` | `Void` | Insert or update |
| `get(key)` | `V?` | Get value — **nullable**, returns `null` if missing |
| `getOrDefault(key, default)` | `V` | Get value, or `default` if missing |
| `length()` | `Integer` | Number of entries |
| `remove(key)` | `Void` | Delete entry |
| `containsKey(key)` | `Boolean` | Check existence |
| `keys()` | `List<K>` | All keys as list |
| `values()` | `List<V>` | All values as list |
| `entries()` | `List<Pair<K,V>>` | All key-value pairs |
| `forEach((k, v) -> ...)` | `Void` | Iterate all entries |

### Usage

```arm
HashMap<String, Integer> scores = HashMap();
scores.set("alice", 100);
scores.set("bob", 90);

Integer?  val     = scores.get("alice");           // 100
Integer   safe    = scores.getOrDefault("eve", 0); // 0
Integer   count   = scores.length();               // 2

scores.remove("bob");

List<String>  keys = scores.keys();
List<Integer> vals = scores.values();
```

### get() Returns Nullable

```arm
Integer? result = scores.get("alice");
if (result != null) {
    IO.println("score: ${result}");
}

// Or with null coalescing:
Integer score = scores.get("alice") ?? 0;
```

## TreeMap\<K, V\>

Same API as `HashMap`, but keys are kept in sorted order.

```arm
TreeMap<String, Integer> sorted = TreeMap();
sorted.set("b", 2);
sorted.set("a", 1);
sorted.set("c", 3);

List<String> ks = sorted.keys();   // ["a", "b", "c"] — sorted
```

## Map Interface

Both `HashMap` and `TreeMap` implement the `Map<K,V>` interface:

```arm
Map<String, Integer> m = HashMap();   // polymorphic reference
```

## Related

- [collections-overview](../collections/collections-overview.md) — all collection types
- [pair](../collections/pair.md) — `entries()` returns `List<Pair<K,V>>`
- [null-safety](../language/null-safety.md) — handling nullable `get()` result
