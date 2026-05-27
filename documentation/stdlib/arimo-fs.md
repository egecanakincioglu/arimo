---
title: arimo.fs
description: File, Path, FileMode — file system operations
tags: [stdlib]
date: 2026-05-22
---

# arimo.fs

```arm
import arimo.fs.*;
```

Or include in `arc.toml`:

```toml
[stdlib]
include = ["arimo.fs"]
```

## File

All methods are static.

| Method | Returns | Description |
|---|---|---|
| `File.exists(path)` | `Boolean` | True if file exists |
| `File.read(path)` | `String` | Read entire file as string |
| `File.write(path, content)` | `Void` | Write (overwrite) file |
| `File.append(path, content)` | `Void` | Append to file |
| `File.delete(path)` | `Boolean` | Delete file, returns success |
| `File.size(path)` | `Integer` | File size in bytes |

```arm
import arimo.fs.*;

String path = "output.txt";

File.write(path, "hello arimo\n");

Boolean exists  = File.exists(path);      // true
String  content = File.read(path);        // "hello arimo\n"
Integer size    = File.size(path);

File.append(path, "second line\n");

Boolean deleted = File.delete(path);      // true
Boolean gone    = File.exists(path);      // false
```

## Path

`Path` represents a file system path.

| Method | Returns | Description |
|---|---|---|
| `Path.of(s)` | `Path` | Create from string |
| `path.join(other)` | `Path` | Append segment |
| `path.toString()` | `String` | Convert back to string |
| `path.exists()` | `Boolean` | Check if path exists |
| `path.filename()` | `String` | Last component (file name) |

```arm
Path base = Path.of("C:/projects/myapp");
Path src  = base.join("Main.arm");

IO.println(src.toString());      // C:/projects/myapp/Main.arm
IO.println(src.filename());      // Main.arm
IO.println(src.exists());        // true/false
```

## FileMode

Enum representing file open modes.

| Variant | Meaning |
|---|---|
| `FileMode.Read` | Open for reading |
| `FileMode.Write` | Open for writing (truncate) |
| `FileMode.Append` | Open for appending |
| `FileMode.ReadWrite` | Open for reading and writing |

## IOException

```arm
public class IOException extends Exception {
    public constructor(message: String)
}
```

Thrown by file operations on failure. Import from `arimo.fs`:

```arm
try {
    String content = File.read("missing.txt");
} catch (IOException ex) {
    IO.println("error: ${ex.getMessage()}");
}
```

## Related

- [[arimo-io]] — InputStream, BufferedReader
- [[stdlib-overview]] — import rules
