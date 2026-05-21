---
title: Pair
description: Pair<A, B> — two-element tuple
tags: [collections]
date: 2026-05-22
---

# Pair\<A, B\>

`Pair<A, B>` holds two typed values. Use it to return two values from a method or to represent key-value entries.

## Construction

```arm
Pair<String, Integer> p  = Pair.of("score", 100);
Pair<String, Integer> p2 = Pair("score", 100);    // direct constructor
```

## Access

```arm
String  key = p.getFirst();    // "score"
Integer val = p.getSecond();   // 100
```

## Common Use — HashMap Entries

`HashMap.entries()` returns `List<Pair<K, V>>`:

```arm
HashMap<String, Integer> scores = HashMap();
scores.set("alice", 100);
scores.set("bob", 90);

List<Pair<String, Integer>> entries = scores.entries();

for (Pair<String, Integer> entry : entries) {
    IO.println("${entry.getFirst()}: ${entry.getSecond()}");
}
```

## Related

- [[collections-overview]] — all collection types
- [[hashmap]] — `entries()` returns pairs
