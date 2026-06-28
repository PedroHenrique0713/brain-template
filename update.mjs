#!/usr/bin/env node
// brain-template update (Node) — cross-platform, zero dependências. Requer Node 18+.
//
// Uso (no terminal, dentro da pasta do seu vault):
//   node update.mjs              aplica a atualização
//   node update.mjs --dry-run    só mostra o que mudaria
//   node update.mjs --prune      também remove commands obsoletos
//
// Sincroniza SÓ o framework (.claude/commands/) e NUNCA toca em
// AGENTS.md, CLAUDE.md, GEMINI.md, Memória/, projetos, handovers ou INBOX.
import { readFile, writeFile, mkdir, readdir, rm } from "node:fs/promises";
import { existsSync } from "node:fs";
import { join, dirname } from "node:path";

const REPO = "PedroHenrique0713/brain-template";
const BRANCH = "main";
const RAW = `https://raw.githubusercontent.com/${REPO}/${BRANCH}`;
const API = `https://api.github.com/repos/${REPO}/contents`;

const args = process.argv.slice(2);
if (args.includes("-h") || args.includes("--help")) {
  console.log("Uso: node update.mjs [--dry-run] [--prune]");
  console.log("  --dry-run  mostra o que mudaria, sem escrever nada");
  console.log("  --prune    remove commands locais que não existem mais no template");
  process.exit(0);
}
const DRY = args.includes("--dry-run") || args.includes("-n");
const PRUNE = args.includes("--prune");

const ok = (m) => console.log("  ✓ " + m);
const warn = (m) => console.log("  ! " + m);
const info = (m) => console.log("  → " + m);
const fail = (m) => console.error("  ✗ " + m);

if (typeof fetch !== "function") {
  fail("Seu Node é antigo demais (precisa de fetch — Node 18+). Atualize em https://nodejs.org");
  process.exit(1);
}

async function getText(url) {
  const r = await fetch(url, { headers: { "User-Agent": "brain-template-update" } });
  if (!r.ok) throw new Error(`HTTP ${r.status} em ${url}`);
  return await r.text();
}
async function getJson(url) {
  const r = await fetch(url, {
    headers: { "User-Agent": "brain-template-update", Accept: "application/vnd.github+json" },
  });
  if (!r.ok) throw new Error(`HTTP ${r.status} em ${url}`);
  return await r.json();
}

// ── Banner (sempre do repo) ──────────────────────────────────────────────────
console.log("");
try {
  console.log(await getText(`${RAW}/ascii-art.txt`));
} catch {
  console.log("Vault Brain");
}
console.log("  brain-template update (node) · sincroniza o framework, preserva seus dados");
console.log("");

// ── Detecta o layout ─────────────────────────────────────────────────────────
let VAULT;
if (existsSync(".claude/commands") || existsSync("AGENTS.md")) VAULT = ".";
else if (existsSync("vault/.claude")) VAULT = "vault";
else {
  fail("Não encontrei um vault aqui.");
  info("Rode de dentro da pasta do seu vault (onde fica .claude/ ou AGENTS.md).");
  process.exit(1);
}

// ── Versões: local x remota ──────────────────────────────────────────────────
const verFile = join(VAULT, ".claude", ".brain-version");
let local = "";
try {
  local = (await readFile(verFile, "utf8")).trim();
} catch {}
let remote = "";
try {
  remote = (await getText(`${RAW}/VERSION`)).trim();
} catch {}
info(`Versão atual: ${local || "desconhecida (primeira atualização)"}`);
info(`Versão no template: ${remote || "?"}`);
console.log("");

// ── Release notes ────────────────────────────────────────────────────────────
console.log("Release notes");
console.log("─".repeat(42));
try {
  const ch = await getText(`${RAW}/CHANGELOG.md`);
  for (const line of ch.split("\n")) {
    if (/^## \[/.test(line) && local && line.includes(`[${local}]`)) break;
    console.log(line);
  }
} catch {
  warn("Não consegui baixar o CHANGELOG.md.");
}
console.log("─".repeat(42));
console.log("");

// ── Lista os arquivos de framework no template (via GitHub API) ───────────────
info("Consultando template...");
const pairs = []; // { url, dst }
async function addDir(apiPath, dstBase) {
  const items = await getJson(`${API}/${apiPath}?ref=${BRANCH}`);
  for (const it of items) {
    if (it.type === "file") pairs.push({ url: it.download_url, dst: join(dstBase, it.name) });
    else if (it.type === "dir") await addDir(`${apiPath}/${it.name}`, join(dstBase, it.name));
  }
}
try {
  await addDir("vault/.claude/commands", join(VAULT, ".claude", "commands"));
} catch (e) {
  fail("Falha ao consultar o GitHub: " + e.message);
  info("Pode ser limite de requisições anônimas. Tente de novo em alguns minutos.");
  process.exit(1);
}

// ── Calcula o diff ───────────────────────────────────────────────────────────
let added = 0,
  changed = 0;
const toWrite = [];
for (const p of pairs) {
  const text = await getText(p.url);
  let cur = null;
  try {
    cur = await readFile(p.dst, "utf8");
  } catch {}
  if (cur === null) {
    console.log("  + novo:       " + p.dst);
    added++;
    toWrite.push({ dst: p.dst, text });
  } else if (cur !== text) {
    console.log("  ~ atualizado: " + p.dst);
    changed++;
    toWrite.push({ dst: p.dst, text });
  }
}

// ── Commands obsoletos (existem aqui, não no template) ───────────────────────
const stale = [];
const remoteDst = new Set(pairs.map((p) => p.dst));
async function walk(d) {
  let entries;
  try {
    entries = await readdir(d, { withFileTypes: true });
  } catch {
    return;
  }
  for (const e of entries) {
    const full = join(d, e.name);
    if (e.isDirectory()) await walk(full);
    else if (!remoteDst.has(full)) stale.push(full);
  }
}
await walk(join(VAULT, ".claude", "commands"));
for (const s of stale) console.log("  - obsoleto:   " + s);

if (!added && !changed && !stale.length) {
  console.log("");
  ok("Nada a sincronizar — framework já está igual ao template.");
  process.exit(0);
}
console.log("");

// ── Aplica (ou para no dry-run) ──────────────────────────────────────────────
if (DRY) {
  info("Dry-run: nada foi escrito. Rode sem --dry-run para aplicar.");
  process.exit(0);
}

for (const w of toWrite) {
  await mkdir(dirname(w.dst), { recursive: true });
  await writeFile(w.dst, w.text);
}
ok(`Framework sincronizado (${added} novos, ${changed} atualizados).`);

if (stale.length) {
  if (PRUNE) {
    for (const s of stale) await rm(s);
    ok(`Removidos ${stale.length} commands obsoletos (--prune).`);
  } else {
    warn(`${stale.length} command(s) obsoleto(s) mantido(s). Revise e apague, ou rode com --prune.`);
  }
}

if (remote) {
  await mkdir(join(VAULT, ".claude"), { recursive: true });
  await writeFile(verFile, remote + "\n");
  ok(`Marcado como versão ${remote}.`);
}

console.log("");
ok("Pronto.");
info("AGENTS.md/CLAUDE.md não foram tocados — pra migrar da v1 use /update_brain.");
console.log("");
