---
title: String Interpolation
description: Embedding expressions in string literals, string methods, and String API
tags: [language]
date: 2026-05-22
---

# String Interpolation

## Syntax

Embed any expression inside `${}` in a string literal:

```arm
String name = "Arimo";
IO.println("Hello, ${name}!");         // Hello, Arimo!
IO.println("2 + 2 = ${2 + 2}");       // 2 + 2 = 4
IO.println("Circle(r=${this.radius})");
```

Any expression that produces a value works inside `${}`. Objects call their `toString()` method automatically:

```arm
IO.println("Task: ${task}");    // calls task.toString()
IO.println("Count: ${list.length()}");
IO.println("Flag: ${a > b}");
```

## String Concatenation

Use `+` to join strings:

```arm
String full = "Hello, " + name + "!";
String path = dir + "/" + filename;
```

## String Methods

| Method | Returns | Description |
|---|---|---|
| `length()` | `Integer` | Number of characters |
| `contains(s)` | `Boolean` | Whether `s` is a substring |
| `startsWith(s)` | `Boolean` | Starts with `s` |
| `endsWith(s)` | `Boolean` | Ends with `s` |
| `toUpper()` | `String` | Uppercase copy |
| `toLower()` | `String` | Lowercase copy |
| `substring(start, end)` | `String` | Extract slice |
| `replace(old, new)` | `String?` | Replace first occurrence |
| `trim()` | `String` | Strip leading/trailing whitespace |
| `repeat(n)` | `String` | Repeat string `n` times |
| `compareTo(other)` | `Integer` | Lexicographic comparison |
| `charCodeAt(i)` | `Integer` | Unicode code point at index |
| `charAt(i)` | `String` | Character at index as string |
| `split(delimiter)` | `List<String>` | Split into list by delimiter |

```arm
String s = "Hello, World!";

Integer len      = s.length();            // 13
Boolean hasWorld = s.contains("World");   // true
Boolean starts   = s.startsWith("Hello"); // true
String  up       = s.toUpper();           // "HELLO, WORLD!"
String  lo       = s.toLower();           // "hello, world!"
String  sub      = s.substring(0, 5);    // "Hello"
Integer code     = s.charCodeAt(0);      // 72 ('H')
String  ch       = s.charAt(1);          // "e"
```

## Multi-line Strings

Arimo uses standard string literals. For multi-line content, use `StringBuilder`:

```arm
StringBuilder sb = StringBuilder();
sb.append("line one\n");
sb.append("line two\n");
String result = sb.toString();
```

See [[arimo-lang]] for the full `StringBuilder` API.

## Related

- [[variables-and-types]] — `String` type
- [[arimo-lang]] — `StringBuilder`, `String` class details
- [[classes]] — `toString()` override
