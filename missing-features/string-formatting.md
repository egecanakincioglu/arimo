---
title: String Formatting and Regular Expressions
description: String.format, printf-style formatting, regular expressions — not in Arimo v1.0.0
tags: [missing-features, strings]
date: 2026-05-22
---

# String Formatting and Regular Expressions

String manipulation features from Java, C, and TypeScript that are **not in Arimo v1.0.0**.

## `String.format` / `printf` (Java / C)

**Java:**
```java
String s = String.format("Name: %s, Age: %d, Score: %.2f", name, age, score);
System.out.printf("%-20s %5d%n", name, id);
```

**C:**
```c
char buf[256];
snprintf(buf, sizeof(buf), "Name: %s, Age: %d", name, age);
```

Not supported. Use string interpolation or `StringBuilder`:

```arm
String s = "Name: ${name}, Age: ${age}";

StringBuilder sb = StringBuilder();
sb.append("Name: ").append(name)
  .append(", Age: ").append(Integer.toString(age));
String result = sb.toString();
```

Float formatting to a fixed number of decimal places is not natively available.

## Formatted Number Output

**Java:**
```java
System.out.printf("%.2f%n", 3.14159);   // "3.14"
String.format("%,d", 1000000);          // "1,000,000"
```

No equivalent. Workaround: integer arithmetic to split the decimal manually, or `Float.toString(f)` then `String.substring()`.

## Regular Expressions

**Java:**
```java
Pattern p = Pattern.compile("\\d+");
Matcher m = p.matcher("abc123def");
if (m.find()) {
    String match = m.group();   // "123"
}

String result = "hello world".replaceAll("\\s+", "_");
```

**TypeScript:**
```typescript
const match    = "2026-05-22".match(/(\d{4})-(\d{2})-(\d{2})/);
const replaced = str.replace(/\s+/g, "_");
```

Not supported. Arimo has no `Regex`, `Pattern`, or `Matcher` type in v1.0.0.

**Workaround:** Manual string parsing with `String.contains()`, `String.split()`, and character iteration:

```arm
String input = "abc123def";
StringBuilder digits = StringBuilder();
Integer i = 0;
while (i < input.length()) {
    Integer code = input.charCodeAt(i);
    if (code >= 48 && code <= 57) {   // '0'..'9'
        digits.append(input.charAt(i));
    }
    i += 1;
}
String found = digits.toString();   // "123"
```

## String Padding / Alignment

**Java:**
```java
String.format("%-10s", name)   // left-pad to 10 chars
String.format("%05d", 42)      // zero-pad to 5 digits
```

Not supported. Manual padding with `String.repeat()`:

```arm
String padded = name + " ".repeat(Math.max(0, 10 - name.length()));
```

## `String.join` (Java)

**Java:**
```java
String result = String.join(", ", list);
```

Arimo `List<String>` has `joinToString(separator)` — this IS supported:

```arm
String result = parts.joinToString(", ");
```

See [[list]].

## `String.matches` (Java)

**Java:**
```java
boolean ok = "hello123".matches("[a-z]+\\d+");
```

Not supported — no regex.

## Tagged Template Literals (TypeScript)

**TypeScript:**
```typescript
const query = sql`SELECT * FROM users WHERE id = ${id}`;
```

Not supported. Arimo `${expr}` interpolation is simple value insertion — no tagged templates.

## Related

- [[string-interpolation]] — `${expr}` in Arimo
- [[arimo-lang]] — `String` and `StringBuilder` API
- [[list]] — `joinToString(sep)` on `List<String>`
- [[syntax-sugar]] — multi-line strings gap
