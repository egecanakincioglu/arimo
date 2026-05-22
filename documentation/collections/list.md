---
title: List
description: List<T> — dynamic array API, functional methods, and usage examples
tags: [collections]
date: 2026-05-22
---

# List\<T\>

`List<T>` is a heap-allocated dynamic array. It is the most commonly used collection type.

## Construction

```arm
List<Task>   tasks = List();                    // empty
List<String> names = List.of("Alice", "Bob");   // with initial values
List<Task>   empty = List.empty();              // alternative empty
```

## Core API

| Method | Returns | Description |
|---|---|---|
| `append(item)` | `Void` | Add item to end |
| `length()` | `Integer` | Number of elements |
| `isEmpty()` | `Boolean` | True if length is 0 |
| `get(index)` | `T` | Get element at index |
| `set(index, item)` | `Void` | Replace element at index |
| `removeAt(index)` | `Void` | Remove element at index |

```arm
List<Integer> nums = List();
nums.append(10);
nums.append(20);
nums.append(30);

Integer first = nums.get(0);       // 10
nums.set(0, 99);                   // replace first element
nums.removeAt(1);                  // remove second element
IO.println("length: ${nums.length()}");  // 2
IO.println("empty: ${nums.isEmpty()}");  // false
```

## Functional Methods

| Method | Returns | Description |
|---|---|---|
| `filter(fn)` | `List<T>` | Keep elements where `fn` returns `true` |
| `map(fn)` | `List<R>` | Transform each element |
| `forEach(fn)` | `Void` | Execute `fn` for each element |
| `sortedBy(comparator)` | `List<T>` | Sort by comparator — negative/zero/positive |
| `take(n)` | `List<T>` | First `n` elements |
| `takeLast(n)` | `List<T>` | Last `n` elements |
| `flatMap(fn)` | `List<R>` | Map then flatten |
| `reduce(initial, fn)` | `R` | Fold into a single value |
| `any(fn)` | `Boolean` | True if any element satisfies `fn` |
| `all(fn)` | `Boolean` | True if all elements satisfy `fn` |
| `distinct()` | `List<T>` | Remove duplicates |
| `joinToString(sep)` | `String` | Join all elements with separator |

```arm
List<Task> done    = tasks.filter((t) -> t.isDone());
List<String> titles = tasks.map((t) -> t.getTitle());

tasks.forEach((t) -> IO.println(t.getTitle()));

List<Integer> sorted = nums.sortedBy((a, b) -> a - b);  // ascending
List<Integer> first5 = nums.take(5);
String csv   = nums.joinToString(", ");  // "1, 2, 3"
```

## Chaining

```arm
List<Task> urgent5 = this.tasks
    .filter((t)   -> !t.isDone() && t.isUrgent())
    .sortedBy((a, b) -> a.getDueDate().compareTo(b.getDueDate()))
    .take(5);
```

## For-Each Loop

```arm
for (Task task : tasks) {
    IO.println(task.getTitle());
}

for (Task task in tasks) {   // alternative syntax
    IO.println(task.getTitle());
}
```

## List of Objects

Lists can hold class instances:

```arm
List<Token> tokens = List();
tokens.append(Token(1, "package"));
tokens.append(Token(2, "arimo"));

Token t0 = tokens.get(0);
IO.println("kind: ${t0.getKind()}  value: ${t0.getValue()}");
```

## Related

- [collections-overview](../collections/collections-overview.md) — all collection types
- [lambdas-and-closures](../language/lambdas-and-closures.md) — lambda syntax for functional methods
