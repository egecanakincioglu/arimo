---
title: Concurrency
description: Threads, synchronized, atomics, mutex, thread-local storage — not in Arimo v1.0.0
tags: [missing-features, concurrency]
date: 2026-05-22
---

# Concurrency

Threading and synchronization features from Java and C++ that are **not in Arimo v1.0.0**.

## Threads (Java)

**Java:**
```java
Thread t = new Thread(() -> {
    System.out.println("running in thread");
});
t.start();
t.join();
```

Not supported. Arimo v1.0.0 has no threading API. Programs are single-threaded.

## `synchronized` / Monitors (Java)

**Java:**
```java
synchronized (lock) {
    sharedCounter++;
}

public synchronized void increment() {
    counter++;
}
```

Not supported. No monitor or intrinsic lock mechanism.

## `java.util.concurrent` (Java)

**Java:**
```java
ExecutorService pool = Executors.newFixedThreadPool(4);
Future<Integer> f    = pool.submit(() -> compute());
int result           = f.get();
```

Not supported. No executor, future, or thread-pool API in `arimo.*`.

## `std::thread` / `std::mutex` (C++)

**C++:**
```cpp
std::mutex mtx;
std::thread t([&]() {
    std::lock_guard<std::mutex> lock(mtx);
    data.push_back(42);
});
t.join();
```

Not supported.

## Atomics (C++ / Java)

**C++:**
```cpp
std::atomic<int> counter = 0;
counter.fetch_add(1, std::memory_order_relaxed);
```

**Java:**
```java
AtomicInteger counter = new AtomicInteger(0);
counter.incrementAndGet();
```

Not supported. Arimo has no atomic types or memory ordering primitives.

## `volatile` in Java Sense

Java's `volatile` guarantees cross-thread visibility:

```java
volatile boolean running = true;
```

Arimo's `volatile` (from [[memory-model]]) is for memory-mapped I/O — prevents compiler caching of loads. No thread-visibility semantics because there are no threads.

## Thread-Local Storage

**C++ / Java:**
```cpp
thread_local int counter = 0;
```

Not supported.

## `async` / `await` Status

Arimo has parser-level support for `async` methods and `await` expressions (see [[async]]), but the runtime (cooperative coroutine scheduler) is **not yet implemented** in v1.0.0. Full support is planned for v1.2.0.

This is coroutine-based cooperative concurrency, not OS-thread-based.

## Planned Path

- v1.2.0 — `async`/`await` cooperative coroutines
- Threading API — not on the current roadmap (see [[versioning]])

## Related

- [[async]] — async/await parser support (v1.2.0 runtime)
- [[memory-model]] — `volatile` for MMIO (not threading)
- [[versioning]] — planned releases
