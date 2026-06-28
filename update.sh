#!/usr/bin/env bash
# brain-template update — puxa o "framework" novo do template sem tocar nos seus dados.
#
# Uso rápido (dentro da pasta do seu vault):
#   curl -sL https://raw.githubusercontent.com/PedroHenrique0713/brain-template/main/update.sh | bash
#   curl -sL .../update.sh | bash -s -- --dry-run     # só mostra o que mudaria
#   curl -sL .../update.sh | bash -s -- --prune       # também remove commands obsoletos
#
# Sincroniza SÓ: .claude/commands/ , setup.sh , update.sh , ascii-art.txt
# NUNCA toca em: AGENTS.md, CLAUDE.md, GEMINI.md, Memória/, projetos, handovers, INBOX.
set -euo pipefail

REPO="PedroHenrique0713/brain-template"
BRANCH="main"
RAW="https://raw.githubusercontent.com/$REPO/$BRANCH"
TARBALL="https://github.com/$REPO/archive/refs/heads/$BRANCH.tar.gz"

DRY_RUN=false
PRUNE=false
for arg in "$@"; do
  case "$arg" in
    --dry-run|-n) DRY_RUN=true ;;
    --prune)      PRUNE=true ;;
    -h|--help)
      echo "Uso: update.sh [--dry-run] [--prune]"
      echo "  --dry-run  mostra o que mudaria, sem escrever nada"
      echo "  --prune    remove commands locais que não existem mais no template"
      exit 0 ;;
  esac
done

ok()   { echo "  ✓ $1"; }
warn() { echo "  ! $1"; }
info() { echo "  → $1"; }
err()  { echo "  ✗ $1" >&2; }

command -v curl &>/dev/null || { err "curl não encontrado."; exit 1; }
command -v tar  &>/dev/null || { err "tar não encontrado.";  exit 1; }

# ──── Banner (sempre do repo, pra funcionar mesmo via curl | bash) ───────────────
echo ""
if ! curl -sf "$RAW/ascii-art.txt" 2>/dev/null; then
  echo "Vault Brain"
fi
echo "  brain-template update · sincroniza o framework, preserva seus dados"
echo ""

# ──── Detecta o layout (vault vivo na raiz, ou clone do template) ────────────────
if [ -d ".claude/commands" ] || [ -f "AGENTS.md" ]; then
  VAULT="."                      # rodando dentro do vault vivo
elif [ -d "vault/.claude" ]; then
  VAULT="vault"                  # rodando na raiz de um clone do template
else
  err "Não encontrei um vault aqui."
  info "Rode este comando de dentro da pasta do seu vault (onde fica .claude/ ou AGENTS.md)."
  exit 1
fi

# ──── Versões: local x remota ────────────────────────────────────────────────────
VERSION_FILE="$VAULT/.claude/.brain-version"
LOCAL_VERSION="$( [ -f "$VERSION_FILE" ] && cat "$VERSION_FILE" || echo "" )"
REMOTE_VERSION="$(curl -sf "$RAW/VERSION" 2>/dev/null | tr -d '[:space:]' || echo "")"

if [ -n "$LOCAL_VERSION" ]; then
  info "Versão atual: $LOCAL_VERSION"
else
  info "Versão atual: desconhecida (primeira atualização via update.sh)"
fi
info "Versão no template: ${REMOTE_VERSION:-?}"
echo ""

if [ -n "$REMOTE_VERSION" ] && [ "$LOCAL_VERSION" = "$REMOTE_VERSION" ]; then
  ok "Você já está na versão mais recente ($REMOTE_VERSION)."
  $DRY_RUN || exit 0
  echo ""
fi

# ──── Release notes (tudo entre a sua versão e a mais nova) ───────────────────────
echo "Release notes"
echo "──────────────────────────────────────────"
CHANGELOG="$(curl -sf "$RAW/CHANGELOG.md" 2>/dev/null || true)"
if [ -n "$CHANGELOG" ]; then
  # imprime do topo até bater no cabeçalho da versão local (exclusivo)
  echo "$CHANGELOG" | awk -v v="$LOCAL_VERSION" '
    /^## \[/ { if (v != "" && index($0, "[" v "]")) exit }
    { print }
  '
else
  warn "Não consegui baixar o CHANGELOG.md."
fi
echo "──────────────────────────────────────────"
echo ""

# ──── Baixa o template pra um temp ───────────────────────────────────────────────
TMP="$(mktemp -d)"
trap 'rm -rf "$TMP"' EXIT
info "Baixando template..."
curl -sL "$TARBALL" | tar xz -C "$TMP"
SRC="$(find "$TMP" -maxdepth 1 -type d -name 'brain-template-*' | head -1)"
SRCV="$SRC/vault"
[ -d "$SRCV/.claude/commands" ] || { err "Tarball sem .claude/commands — abortando."; exit 1; }

# ──── Plano: o que muda ──────────────────────────────────────────────────────────
# Pares "origem|destino" dos arquivos de framework.
declare -a PAIRS=()
while IFS= read -r f; do
  rel="${f#"$SRCV/.claude/commands/"}"
  PAIRS+=("$f|$VAULT/.claude/commands/$rel")
done < <(find "$SRCV/.claude/commands" -type f)

# Arquivos de framework só fazem sentido num clone (layout com vault/)
if [ "$VAULT" = "vault" ]; then
  for root_f in setup.sh update.sh ascii-art.txt VERSION CHANGELOG.md; do
    [ -f "$SRC/$root_f" ] && PAIRS+=("$SRC/$root_f|$root_f")
  done
fi

changed=0; added=0
for pair in "${PAIRS[@]}"; do
  src="${pair%%|*}"; dst="${pair#*|}"
  if [ ! -f "$dst" ]; then
    echo "  + novo:      $dst"; added=$((added+1))
  elif ! cmp -s "$src" "$dst"; then
    echo "  ~ atualizado: $dst"; changed=$((changed+1))
  fi
done

# Commands obsoletos (existem aqui mas não no template)
declare -a STALE=()
if [ -d "$VAULT/.claude/commands" ]; then
  while IFS= read -r local_cmd; do
    rel="${local_cmd#"$VAULT/.claude/commands/"}"
    [ -f "$SRCV/.claude/commands/$rel" ] || STALE+=("$local_cmd")
  done < <(find "$VAULT/.claude/commands" -type f)
fi
for s in "${STALE[@]:-}"; do
  [ -n "$s" ] && echo "  - obsoleto:  $s"
done

if [ "$changed" -eq 0 ] && [ "$added" -eq 0 ] && [ "${#STALE[@]}" -eq 0 ]; then
  echo ""
  ok "Nada a sincronizar — framework já está igual ao template."
  exit 0
fi
echo ""

# ──── Aplica (ou para no dry-run) ────────────────────────────────────────────────
if $DRY_RUN; then
  info "Dry-run: nada foi escrito. Rode sem --dry-run para aplicar."
  exit 0
fi

for pair in "${PAIRS[@]}"; do
  src="${pair%%|*}"; dst="${pair#*|}"
  mkdir -p "$(dirname "$dst")"
  cp "$src" "$dst"
done
ok "Framework sincronizado ($((added)) novos, $((changed)) atualizados)."

if [ "${#STALE[@]}" -gt 0 ] && [ -n "${STALE[0]:-}" ]; then
  if $PRUNE; then
    for s in "${STALE[@]}"; do rm -f "$s"; done
    ok "Removidos ${#STALE[@]} commands obsoletos (--prune)."
  else
    warn "${#STALE[@]} command(s) obsoleto(s) mantido(s). Revise e apague à mão, ou rode com --prune."
  fi
fi

# ──── Marca a versão ─────────────────────────────────────────────────────────────
if [ -n "$REMOTE_VERSION" ]; then
  mkdir -p "$VAULT/.claude"
  echo "$REMOTE_VERSION" > "$VERSION_FILE"
  ok "Marcado como versão $REMOTE_VERSION."
fi

echo ""
ok "Pronto."
info "Estrutura/perfil (AGENTS.md, CLAUDE.md) não foi tocado — pra migrar da v1 use /update_brain."
echo ""
