---
title: Syntax Sugar and Ergonomics
description: Destructuring, spread operator, named call-site parameters, getters/setters, labeled break — not in Arimo v1.0.0
tags: [missing-features, syntax]
date: 2026-05-22
---

# Syntax Sugar and Ergonomics

Convenience syntax from TypeScript, Kotlin, C++, and Java that is **not in Arimo v1.0.0**.

## Destructuring Assignment

**TypeScript / JavaScript:**
```typescript
const [first, second] = array;
const { name, age }   = person;
const [head, ...tail] = list;
```

Not supported. Arimo requires explicit field access:

```arm
String first  = list.get(0);
String second = list.get(1);
String name   = person.getName();
```

## Spread / Rest Operator

**TypeScript:**
```typescript
const merged = [...arr1, ...arr2];
const copy   = { ...obj, extra: true };
function log(...args: string[]) { }
```

Not supported. Use explicit loop:

```arm
List<String> merged = List<String>();
for (String s : arr1) { merged.add(s); }
for (String s : arr2) { merged.add(s); }
```

## Named Parameters at Call Site

**Kotlin:**
```kotlin
createUser(name = "Alice", age = 30, active = true)
```

Not supported. Arimo calls use positional arguments only:

```arm
createUser("Alice", 30, true);
```

Default parameter values are supported (see [[functions-and-methods]]), but argument names cannot be specified at the call site.

## Multi-Line String Literals

**TypeScript:**
```typescript
const html = `
  <div>
    <h1>${title}</h1>
  </div>
`;
```

Arimo has no multi-line string literals. Use `StringBuilder`:

```arm
StringBuilder sb = StringBuilder();
sb.appendLine("  <div>");
sb.appendLine("    <h1>" + title + "</h1>");
sb.appendLine("  </div>");
String html = sb.toString();
```

## Labeled `break` / `continue` (Java)

**Java:**
```java
outer:
for (int i = 0; i < 10; i++) {
    for (int j = 0; j < 10; j++) {
        if (condition) break outer;
    }
}
```

Not supported. Arimo `break` and `continue` exit the innermost loop only. Use a flag variable:

```arm
Boolean found = false;
Integer i = 0;
while (i < 10 && !found) {
    Integer j = 0;
    while (j < 10 && !found) {
        if (condition) { found = true; }
        j += 1;
    }
    i += 1;
}
```

## Optional Chaining (Deep)

**TypeScript:**
```typescript
const city = user?.address?.city?.toUpperCase();
```

Arimo `?.` works for single-level nullable access. Chaining three or more requires intermediate variables:

```arm
String? city = null;
if (user != null && user.address != null && user.address.city != null) {
    city = user.address.city.toUpper();
}
```

## `for...of` with Index (`enumerate`)

**Python:**
```python
for i, val in enumerate(items):
    print(i, val)
```

Not supported as a built-in form. Use a manual counter:

```arm
Integer i = 0;
for (String val : items) {
    IO.println(Integer.toString(i) + ": " + val);
    i += 1;
}
```

## Property Shorthand (TypeScript)

**TypeScript:**
```typescript
const name = "Alice";
const user = { name, age: 30 };   // equivalent to { name: name, age: 30 }
```

Not supported. Constructor arguments are positional in Arimo.

## Related

- [[functions-and-methods]] — default parameters
- [[control-flow]] — Arimo for, while, match
- [[pattern-matching]] — string and integer match
- [[null-safety]] — `?.` and `??` operators
- [[string-interpolation]] — `${expr}` in strings
