# Graphify Refresh

Graphify does not natively recognize Arimo `.arm` files yet. Use the project
adapter before relying on graph output:

```bash
node tools/graphify-arimo.mjs build
```

The adapter writes `.graphify/arimo-semantic.json`, then runs:

```bash
graphify extract . --semantic .graphify/arimo-semantic.json
```

What it extracts locally:

- `.arm` files, imports, declarations, methods, extern blocks, and annotations.
- Markdown headings from documentation.
- Lightweight references from documentation/config files to Arimo symbols.

Use `--scope all` when untracked, non-ignored files should be included:

```bash
node tools/graphify-arimo.mjs build --scope all
```

Generated `.graphify/` data stays local and ignored.
