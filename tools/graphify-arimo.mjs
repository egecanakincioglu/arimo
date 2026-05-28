#!/usr/bin/env node
import { spawnSync } from "node:child_process";
import { existsSync, mkdirSync, readdirSync, readFileSync, statSync, writeFileSync } from "node:fs";
import { basename, dirname, extname, join, relative, resolve, sep } from "node:path";

const ROOT = process.cwd();
const DEFAULT_OUT = join(ROOT, ".graphify", "arimo-semantic.json");
const IGNORE_DIRS = new Set([
  ".git",
  ".graphify",
  "graphify-out",
  ".claude",
  ".codex",
  ".agents",
  "node_modules",
  "dist",
  "target",
]);

function usage() {
  console.log(`Usage:
  node tools/graphify-arimo.mjs build [--out <path>] [--scope tracked|all]
  node tools/graphify-arimo.mjs generate [--out <path>] [--scope tracked|all]

Commands:
  build     Generate Arimo semantic JSON and run graphify extract.
  generate  Generate only the semantic JSON.

Options:
  --out     Semantic JSON path. Default: .graphify/arimo-semantic.json
  --scope   tracked uses git ls-files; all walks the working tree. Default: tracked
`);
}

function parseArgs(argv) {
  const args = [...argv];
  const command = args.shift() ?? "build";
  const opts = { command, out: DEFAULT_OUT, scope: "tracked" };
  for (let i = 0; i < args.length; i += 1) {
    const arg = args[i];
    if (arg === "--help" || arg === "-h") {
      opts.help = true;
    } else if (arg === "--out") {
      opts.out = resolve(ROOT, args[++i] ?? "");
    } else if (arg === "--scope") {
      opts.scope = args[++i] ?? "tracked";
    } else {
      throw new Error(`unknown argument: ${arg}`);
    }
  }
  if (!["build", "generate"].includes(opts.command)) {
    throw new Error(`unknown command: ${opts.command}`);
  }
  if (!["tracked", "all"].includes(opts.scope)) {
    throw new Error("--scope must be tracked or all");
  }
  return opts;
}

function slash(path) {
  return path.split(sep).join("/");
}

function rel(path) {
  return slash(relative(ROOT, path));
}

function run(command, args, options = {}) {
  const result = spawnSync(command, args, {
    cwd: ROOT,
    encoding: "utf-8",
    stdio: options.stdio ?? "pipe",
  });
  if (result.status !== 0) {
    const detail = result.stderr?.trim() || result.stdout?.trim() || `${command} failed`;
    throw new Error(detail);
  }
  return result.stdout ?? "";
}

function gitFiles() {
  try {
    const output = run("git", ["ls-files", "-z", "--cached", "--others", "--exclude-standard"]);
    return output.split("\0").filter(Boolean).map((path) => resolve(ROOT, path));
  } catch {
    return walk(ROOT);
  }
}

function walk(dir, files = []) {
  for (const entryName of readdirSync(dir)) {
    const entry = join(dir, entryName);
    if (IGNORE_DIRS.has(entryName)) continue;
    const stat = statSync(entry);
    if (stat.isDirectory()) {
      walk(entry, files);
    } else if (stat.isFile()) {
      files.push(entry);
    }
  }
  return files;
}

function lineForOffset(text, offset) {
  let line = 1;
  for (let i = 0; i < offset; i += 1) {
    if (text.charCodeAt(i) === 10) line += 1;
  }
  return line;
}

function cleanLabel(value) {
  return value.replace(/\s+/g, " ").replace(/[;{].*$/u, "").trim();
}

function moduleToPath(moduleName) {
  return `${moduleName.replace(/\./g, "/")}.arm`;
}

function makeGraph() {
  const nodes = new Map();
  const edges = new Map();
  const symbolByName = new Map();

  function node(id, attrs) {
    if (!nodes.has(id)) {
      nodes.set(id, {
        id,
        label: attrs.label,
        file_type: attrs.file_type ?? "code",
        source_file: attrs.source_file,
        confidence: attrs.confidence ?? "EXTRACTED",
        ...attrs,
      });
      if (attrs.symbol_name) {
        const list = symbolByName.get(attrs.symbol_name) ?? [];
        list.push(id);
        symbolByName.set(attrs.symbol_name, list);
      }
    }
    return id;
  }

  function edge(source, target, relation, attrs = {}) {
    const key = `${source}\0${target}\0${relation}\0${attrs.source_file ?? ""}`;
    if (!edges.has(key)) {
      edges.set(key, {
        source,
        target,
        relation,
        confidence: attrs.confidence ?? "EXTRACTED",
        confidence_score: attrs.confidence_score ?? 1,
        source_file: attrs.source_file ?? "",
        ...attrs,
      });
    }
  }

  return { nodes, edges, symbolByName, node, edge };
}

function addFileNode(graph, file, fileType) {
  const sourceFile = rel(file);
  return graph.node(`file:${sourceFile}`, {
    label: basename(file),
    file_type: fileType,
    source_file: sourceFile,
    node_type: "file",
  });
}

function precedingAnnotations(text, offset) {
  const prefix = text.slice(0, offset).split(/\r?\n/u);
  const annotations = [];
  for (let i = prefix.length - 1; i >= 0; i -= 1) {
    const line = prefix[i].trim();
    if (!line) continue;
    const match = line.match(/^@([A-Za-z_]\w*)/u);
    if (!match) break;
    annotations.push(match[1]);
  }
  return annotations.reverse();
}

function extractArm(graph, file) {
  const text = readFileSync(file, "utf-8");
  const sourceFile = rel(file);
  const fileNode = addFileNode(graph, file, "code");

  for (const match of text.matchAll(/^\s*import\s+([A-Za-z_][\w.]*)\s*;/gmu)) {
    const importName = match[1];
    const importNode = graph.node(`module:${importName}`, {
      label: importName,
      file_type: "code",
      source_file: moduleToPath(importName),
      source_location: `${sourceFile}:${lineForOffset(text, match.index ?? 0)}`,
      node_type: "module",
    });
    graph.edge(fileNode, importNode, "imports", { source_file: sourceFile });
  }

  if (/extern\s+"C"/u.test(text)) {
    const externNode = graph.node(`extern:${sourceFile}:C`, {
      label: `${basename(file)} extern C`,
      file_type: "code",
      source_file: sourceFile,
      node_type: "extern_block",
    });
    graph.edge(fileNode, externNode, "declares", { source_file: sourceFile });
  }

  const declarations = [];
  const declRe = /^\s*(?:(public|private|protected)\s+)?(class|interface|enum|struct|exception|union)\s+([A-Za-z_]\w*)(?:\s+extends\s+([A-Za-z_][\w.]*))?(?:\s+implements\s+([^{]+))?/gmu;
  for (const match of text.matchAll(declRe)) {
    const [, visibility, kind, name, extendsName, implementsRaw] = match;
    const line = lineForOffset(text, match.index ?? 0);
    const id = graph.node(`symbol:${sourceFile}:${name}`, {
      label: name,
      file_type: "code",
      source_file: sourceFile,
      source_location: `${sourceFile}:${line}`,
      node_type: kind,
      visibility: visibility ?? "package",
      symbol_name: name,
    });
    declarations.push({ id, name, offset: match.index ?? 0, line });
    graph.edge(fileNode, id, "defines", { source_file: sourceFile });

    for (const annotation of precedingAnnotations(text, match.index ?? 0)) {
      const annotationNode = graph.node(`annotation:${annotation}`, {
        label: `@${annotation}`,
        file_type: "concept",
        source_file: sourceFile,
        node_type: "annotation",
      });
      graph.edge(id, annotationNode, "annotated_with", { source_file: sourceFile });
    }

    if (extendsName) {
      const target = graph.node(`type:${extendsName}`, {
        label: extendsName,
        file_type: "code",
        source_file: sourceFile,
        node_type: "type_reference",
        symbol_name: extendsName.split(".").pop(),
      });
      graph.edge(id, target, "extends", { source_file: sourceFile });
    }

    if (implementsRaw) {
      for (const iface of implementsRaw.split(",").map(cleanLabel).filter(Boolean)) {
        const target = graph.node(`type:${iface}`, {
          label: iface,
          file_type: "code",
          source_file: sourceFile,
          node_type: "type_reference",
          symbol_name: iface.split(".").pop(),
        });
        graph.edge(id, target, "implements", { source_file: sourceFile });
      }
    }
  }

  const methodRe = /^\s*(?:(public|private|protected)\s+)?(?:(static)\s+)?([A-Za-z_]\w*)\s*\([^;{}]*\)\s*:\s*([A-Za-z_][\w<>, ?]*)/gmu;
  for (const match of text.matchAll(methodRe)) {
    const [, visibility, staticFlag, name, returnTypeRaw] = match;
    const offset = match.index ?? 0;
    const line = lineForOffset(text, offset);
    const owner = declarations.filter((decl) => decl.offset < offset).at(-1);
    const qualified = owner ? `${owner.name}.${name}()` : `${name}()`;
    const id = graph.node(`symbol:${sourceFile}:${qualified}`, {
      label: qualified,
      file_type: "code",
      source_file: sourceFile,
      source_location: `${sourceFile}:${line}`,
      node_type: "method",
      visibility: visibility ?? "package",
      static: Boolean(staticFlag),
      return_type: cleanLabel(returnTypeRaw),
      symbol_name: name,
    });
    graph.edge(owner?.id ?? fileNode, id, owner ? "contains" : "defines", { source_file: sourceFile });
  }
}

function extractMarkdown(graph, file) {
  const text = readFileSync(file, "utf-8");
  const sourceFile = rel(file);
  const fileNode = addFileNode(graph, file, "document");
  for (const match of text.matchAll(/^(#{1,6})\s+(.+)$/gmu)) {
    const depth = match[1].length;
    const title = cleanLabel(match[2].replace(/#+$/u, ""));
    const line = lineForOffset(text, match.index ?? 0);
    const id = graph.node(`doc:${sourceFile}:${line}:${title}`, {
      label: title,
      file_type: "document",
      source_file: sourceFile,
      source_location: `${sourceFile}:${line}`,
      node_type: `heading_${depth}`,
    });
    graph.edge(fileNode, id, "contains", { source_file: sourceFile });
  }
}

function extractConfig(graph, file) {
  const sourceFile = rel(file);
  const fileNode = addFileNode(graph, file, "document");
  const projectNode = graph.node("concept:arimo-project-config", {
    label: "Arimo project configuration",
    file_type: "concept",
    source_file: sourceFile,
    node_type: "configuration",
  });
  graph.edge(fileNode, projectNode, "describes", { source_file: sourceFile });
}

function addDocSymbolReferences(graph, files) {
  const labels = [...graph.symbolByName.keys()].filter((label) => label.length >= 4);
  for (const file of files) {
    const sourceFile = rel(file);
    const text = readFileSync(file, "utf-8");
    const fileNode = `file:${sourceFile}`;
    for (const label of labels) {
      if (!new RegExp(`\\b${label.replace(/[.*+?^${}()|[\]\\]/g, "\\$&")}\\b`, "u").test(text)) continue;
      const targets = graph.symbolByName.get(label) ?? [];
      for (const target of targets.slice(0, 6)) {
        graph.edge(fileNode, target, "references", {
          source_file: sourceFile,
          confidence: "INFERRED",
          confidence_score: 0.7,
        });
      }
    }
  }
}

function buildExtraction(scope) {
  const files = (scope === "all" ? walk(ROOT) : gitFiles())
    .map((file) => resolve(file))
    .filter((file) => existsSync(file));
  const armFiles = files.filter((file) => extname(file) === ".arm").sort();
  const markdownFiles = files.filter((file) => [".md", ".txt"].includes(extname(file))).sort();
  const configFiles = files.filter((file) => [".toml", ".yaml", ".yml"].includes(extname(file))).sort();
  const graph = makeGraph();

  for (const file of armFiles) extractArm(graph, file);
  for (const file of markdownFiles) extractMarkdown(graph, file);
  for (const file of configFiles) extractConfig(graph, file);
  addDocSymbolReferences(graph, [...markdownFiles, ...configFiles]);

  return {
    nodes: [...graph.nodes.values()],
    edges: [...graph.edges.values()],
    hyperedges: [],
    input_tokens: 0,
    output_tokens: 0,
  };
}

function writeExtraction(outPath, extraction) {
  mkdirSync(dirname(outPath), { recursive: true });
  writeFileSync(outPath, `${JSON.stringify(extraction, null, 2)}\n`, "utf-8");
}

function runGraphify(outPath, scope) {
  const args = ["extract", ".", "--semantic", outPath];
  if (scope === "all") args.push("--all");
  run("graphify", args, { stdio: "inherit" });
}

try {
  const opts = parseArgs(process.argv.slice(2));
  if (opts.help) {
    usage();
    process.exit(0);
  }
  const extraction = buildExtraction(opts.scope);
  writeExtraction(opts.out, extraction);
  console.log(`[arimo-graphify] wrote ${rel(opts.out)}: ${extraction.nodes.length} nodes, ${extraction.edges.length} edges`);
  if (opts.command === "build") {
    runGraphify(opts.out, opts.scope);
  }
} catch (error) {
  console.error(`[arimo-graphify] ${error instanceof Error ? error.message : String(error)}`);
  process.exit(1);
}
