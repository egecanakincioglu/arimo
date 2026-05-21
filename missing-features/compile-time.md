---
title: Compile-Time Evaluation
description: constexpr, static_assert, if constexpr, compile-time computation — not in Arimo v1.0.0
tags: [missing-features, c++, compile-time]
date: 2026-05-22
---

# Compile-Time Evaluation

C++ compile-time features that are **not in Arimo v1.0.0**.

## `constexpr` Functions (C++11 / C++14)

**C++:**
```cpp
constexpr int factorial(int n) {
    return n <= 1 ? 1 : n * factorial(n - 1);
}

constexpr int f5 = factorial(5);   // computed at compile time
```

Not supported. Arimo has no `constexpr` qualifier. All function calls are runtime. Use literal constants for known values:

```arm
Integer F5 = 120;   // manually computed constant
```

## `static_assert` (C++11)

**C++:**
```cpp
static_assert(sizeof(int) == 4, "int must be 32 bits");
static_assert(std::is_trivially_copyable_v<MyStruct>, "must be trivial");
```

Not supported. Arimo has no static assertion mechanism. Type-level constraints are expressed only through bounded generics:

```arm
// Only way to constrain at "compile time":
public class Proc<T extends SomeInterface> { }
```

## `if constexpr` (C++17)

**C++:**
```cpp
template<typename T>
void serialize(T val) {
    if constexpr (std::is_integral_v<T>) {
        writeInt(val);
    } else {
        writeString(val.toString());
    }
}
```

Not supported. Arimo has no compile-time branch elimination. Use interface dispatch instead:

```arm
interface Serializable { serialize() : String; }

public serialize(val: Serializable) : String {
    return val.serialize();
}
```

## `consteval` (C++20)

**C++:**
```cpp
consteval int square(int n) { return n * n; }
// Must be called with a compile-time constant
```

Not supported. Arimo has no `consteval` (must-be-compile-time-evaluated) qualifier.

## `constinit` (C++20)

**C++:**
```cpp
constinit int counter = 0;   // guaranteed zero-initialized at startup
```

Not supported. Static/global variables in Arimo have no explicit initialization-order guarantees.

## Type Traits (C++)

**C++:**
```cpp
std::is_integral_v<T>
std::is_same_v<T, U>
std::is_base_of_v<Base, Derived>
std::remove_const_t<T>
```

Not supported. Arimo has no `<type_traits>` equivalent. Type introspection at compile time is not available.

## `noexcept` Specifier (C++)

**C++:**
```cpp
int add(int a, int b) noexcept { return a + b; }
```

Not supported. Arimo methods have no `noexcept` annotation. All methods are assumed to potentially throw.

## `sizeof` at Compile Time (C/C++)

**C++:**
```cpp
static_assert(sizeof(MyStruct) == 16, "unexpected padding");
size_t n = sizeof(arr) / sizeof(arr[0]);
```

Arimo's `Integer.sizeOf()`, `Float.sizeOf()`, etc. return sizes but are runtime calls, not compile-time constant expressions.

```arm
Integer size = Integer.sizeOf();   // 8 — runtime, not compile-time constant
```

## Related

- [[preprocessor]] — C macro-based compile-time substitution
- [[generics-advanced]] — template specialization / concepts
- [[variables-and-types]] — `sizeOf()` on primitive types
- [[annotations]] — `@Packed`, `@Align` compiler hints
