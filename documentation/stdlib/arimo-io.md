---
title: arimo.io
description: InputStream, BufferedReader — stream-based file reading
tags: [stdlib]
date: 2026-05-22
---

# arimo.io

```arm
import arimo.io.*;
```

Or in `arc.toml`:

```toml
[stdlib]
include = ["arimo.fs"]   // arimo.io is included with arimo.fs
```

## BufferedReader

Line-by-line file reading. Preferred for text files.

```arm
constructor(path: String)
isOpen() : Boolean
readLine() : String        // returns "" (empty string) at EOF
close() : Void
```

Annotated with `@ManualMemory` — always call `close()` when done.

```arm
import arimo.io.*;

BufferedReader reader = BufferedReader("data.txt");

if (reader.isOpen()) {
    String line = reader.readLine();
    while (line.length() > 0) {
        IO.println("line: ${line}");
        line = reader.readLine();
    }
    reader.close();
}
```

`readLine()` returns an empty string at EOF (not `null`).

## InputStream

Binary / raw byte reading.

```arm
constructor(path: String)
isOpen() : Boolean
read(n: Integer) : RawPtr<Void>    // read n bytes
close() : Void
```

Annotated with `@ManualMemory` — manage the returned `RawPtr` and call `close()`.

```arm
import arimo.io.*;

InputStream is = InputStream("binary.dat");
if (is.isOpen()) {
    RawPtr<Void> data = is.read(64);
    // use data ...
    Memory.free(data);
    is.close();
}
```

## Stream Hierarchy (Planned)

Full hierarchy available in future versions:

```
InputStream (abstract)
├── FileInputStream
├── ByteArrayInputStream
└── BufferedInputStream

Reader (abstract)
├── FileReader
├── StringReader
└── BufferedReader     ← available now

Writer (abstract)
├── FileWriter
└── BufferedWriter
```

## Related

- [[arimo-fs]] — `File.read()` for simple string reads
- [[stdlib-overview]] — import rules
- [[low-level]] — `RawPtr`, `Memory` for raw buffers
