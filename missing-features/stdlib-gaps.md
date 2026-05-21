---
title: Standard Library Gaps
description: Common stdlib functionality present in Java/C/Python but missing from arimo.lang in v1.0.0
tags: [missing-features, stdlib]
date: 2026-05-22
---

# Standard Library Gaps

Built-in functionality commonly found in mature standard libraries that is **not in Arimo v1.0.0**.

## Math — Missing Trigonometric and Rounding Functions

Arimo v1.0.0 provides only `sqrt`, `abs`, `pow`, `PI`, and `E`:

```arm
Math.sqrt(x)    // ✓ works
Math.abs(x)     // ✓ works
Math.pow(b, e)  // ✓ works
Math.PI         // ✓ works
Math.E          // ✓ works
```

**Not available:**

| Method | Java / C equivalent |
|---|---|
| `Math.sin(x)` | `Math.sin` / `sin()` |
| `Math.cos(x)` | `Math.cos` / `cos()` |
| `Math.tan(x)` | `Math.tan` / `tan()` |
| `Math.log(x)` | `Math.log` / `log()` |
| `Math.log10(x)` | `Math.log10` / `log10()` |
| `Math.floor(x)` | `Math.floor` / `floor()` |
| `Math.ceil(x)` | `Math.ceil` / `ceil()` |
| `Math.round(x)` | `Math.round` / `round()` |
| `Math.min(a, b)` | `Math.min` / `fmin()` |
| `Math.max(a, b)` | `Math.max` / `fmax()` |
| `Math.clamp(v, lo, hi)` | custom |

**Workaround:** Call C math functions via `extern "C"`:

```arm
extern "C" {
    sin(x: Float)  : Float;
    cos(x: Float)  : Float;
    log(x: Float)  : Float;
    floor(x: Float) : Float;
    ceil(x: Float)  : Float;
    fmin(a: Float, b: Float) : Float;
    fmax(a: Float, b: Float) : Float;
}
```

## Number Formatting

No built-in way to convert a number to a string with a specific format (decimal places, padding). See [[string-formatting]] for the full formatting gap.

**Workaround for float-to-string:**
```arm
String s = Float.toString(value);   // full precision, no rounding control
```

## Random Number Generation

`arimo.util.Random` (see [[arimo-util]]) provides `nextInt()` and `nextFloat()`. Not available without import:

```arm
import arimo.util.Random;

Random rng = Random();
Integer n = rng.nextInt(100);   // [0, 100)
Float   f = rng.nextFloat();    // [0.0, 1.0)
```

No global `Math.random()` shorthand.

## Date / Time

`Time.now()`, `Time.nowMillis()`, `Time.generateId()` are available without import. There is no structured date/time API:

- No `Date` class
- No date arithmetic (`date.plusDays(n)`)
- No date formatting (`"yyyy-MM-dd"`)
- No timezone handling

## Collections Utilities

No static utility class equivalent to Java's `Collections`:

| Missing | Java equivalent |
|---|---|
| Shuffle list | `Collections.shuffle(list)` |
| Binary search | `Collections.binarySearch(list, key)` |
| Frequency count | `Collections.frequency(list, obj)` |
| Unmodifiable wrap | `Collections.unmodifiableList(list)` |
| Fill | `Collections.fill(list, val)` |

Implement these manually with loops or use the existing `List` functional methods (`filter`, `sortedBy`, etc.).

## Related

- [[arimo-lang]] — Math, String, Integer, Float (what IS available)
- [[arimo-util]] — Random, Optional, Scanner
- [[string-formatting]] — formatting and regex gaps
- [[low-level]] — extern C as workaround for missing math functions
