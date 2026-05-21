---
title: arimo.lang
description: Core language classes — IO, Math, String, Integer, Float, Boolean, Char, StringBuilder, exceptions
tags: [stdlib]
date: 2026-05-22
---

# arimo.lang

All classes in `arimo.lang` are available without importing.

## IO

```arm
IO.print("text")           // print without newline
IO.println("text")         // print with newline
IO.println(42)             // Integer overload
IO.println(3.14)           // Float overload
IO.error("message")        // print to stderr
IO.read()                  // read one line from stdin → String
IO.readInt()               // read integer from stdin → Integer
```

## Math

```arm
Math.sqrt(x)               // → Float
Math.abs(x)                // → Integer or Float
Math.pow(base, exp)        // → Float

Math.PI                    // 3.14159265...
Math.E                     // 2.71828...
```

## String

```arm
String s = "Hello, World!";

s.length()                 // → Integer
s.isEmpty()                // → Boolean (length == 0)
s.isBlank()                // → Boolean (empty or only whitespace)
s.contains("World")        // → Boolean
s.startsWith("Hello")      // → Boolean
s.endsWith("!")            // → Boolean
s.indexOf("o")             // → Integer (first occurrence index, -1 if not found)
s.toUpper()                // → String
s.toLower()                // → String
s.substring(start, end)   // → String
s.replace(old, new)        // → String?
s.trim()                   // → String
s.repeat(n)                // → String
s.padStart(width)          // → String (right-align: pad with spaces on left)
s.padEnd(width)            // → String (left-align: pad with spaces on right)
s.compareTo(other)         // → Integer (-1 / 0 / 1)
s.charCodeAt(i)            // → Integer (Unicode code point)
s.charAt(i)                // → String (single char)
s.chars()                  // → List<String> (each character as single-char String)
s.split(delimiter)         // → List<String>
s.parseInt()               // → Integer (parse string as integer)
s.parseFloat()             // → Float   (parse string as float)
s + other                  // concatenation → String
```

## Integer

```arm
Integer.toString(n)        // → String
Integer.MAX                // maximum i64 value
Integer.MIN                // minimum i64 value
Integer.sizeOf()           // → 8

// Parse from string — call on the string:
"42".parseInt()            // → Integer
```

## Float

```arm
Float.toString(f)          // → String
Float.isNaN(f)             // → Boolean
Float.INFINITY             // positive infinity
Float.sizeOf()             // → 8

// Parse from string — call on the string:
"3.14".parseFloat()        // → Float
```

## Boolean

```arm
Boolean.parseBoolean("true")   // → Boolean
Boolean.toString(b)            // → String
```

## Char

```arm
Char c = 'A';

c.code()                   // → Integer (ASCII/Unicode value)
c.isDigit()                // → Boolean
c.isAlpha()                // → Boolean
c.toUpper()                // → Char
c.toLower()                // → Char
```

## StringBuilder

```arm
import arimo.lang.StringBuilder;   // or: it's part of arimo.lang

StringBuilder sb = StringBuilder();

sb.append(s)               // → StringBuilder (chainable)
sb.appendLine(s)           // append + newline → StringBuilder
sb.prepend(s)              // insert at front → StringBuilder
sb.length()                // → Integer
sb.isEmpty()               // → Boolean
sb.clear()                 // → Void
sb.toString()              // → String
```

```arm
StringBuilder sb = StringBuilder();
sb.append("Hello");
sb.append(", ");
sb.append("World");
String result = sb.toString();   // "Hello, World"
```

## Object

Root of the class hierarchy. Every class inherits:

```arm
obj.toString()             // → String
obj.equals(other)          // → Boolean
obj.hashCode()             // → Integer
```

## Exception Hierarchy

All available without import:

```
Exception
├── RuntimeException
│   ├── NullPointerException(message?)
│   ├── IllegalArgumentException(message)
│   ├── IllegalStateException(message)
│   ├── IndexOutOfBoundsException(index, size) or (message)
│   ├── ArithmeticException(message)
│   ├── NumberFormatException(message)
│   └── ClassCastException(message)
└── Error
    ├── OutOfMemoryError
    └── StackOverflowError
```

All exception classes have `message() : String`:

```arm
try {
    throw IllegalArgumentException("n must be positive");
} catch (IllegalArgumentException e) {
    IO.println(e.message());   // "n must be positive"
}

throw NullPointerException("value is null");
throw IndexOutOfBoundsException(5, 3);   // (index, size)
```

## System

```arm
System.exit(code)          // exit process with code
System.currentTimeMillis() // → Integer (Unix ms)
```

## Time (Built-in)

```arm
Time.now()                 // → String (current time)
Time.generateId()          // → String (unique ID)
Time.nowMillis()           // → Integer (Unix ms)
```

## Memory (Built-in)

```arm
Memory.alloc(size)         // → RawPtr<Void>
Memory.free(ptr)           // → Void
Memory.copy(dst, src, n)   // → Void
Memory.set(ptr, val, n)    // → Void
```

See [[low-level]] for full `Memory` and `RawPtr` usage.

## Related

- [[arimo-fs]] — file system
- [[arimo-util]] — ArrayList, Optional, Scanner, Random
- [[stdlib-overview]] — import rules
