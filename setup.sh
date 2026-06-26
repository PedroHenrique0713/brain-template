#!/usr/bin/env bash
# brain-template setup — instala plugins Obsidian e configura ferramentas de IA
set -e

SCRIPT_DIR="$(cd "$(dirname "$0")" && pwd)"
VAULT_DIR="$SCRIPT_DIR/vault"
PLUGINS_DIR="$VAULT_DIR/.obsidian/plugins"
ART_FILE="$SCRIPT_DIR/ascii-art.txt"
PREVIEW=false

case "${1:-}" in
  --preview|preview)
    PREVIEW=true
    ;;
  -h|--help)
    echo "Uso: bash setup.sh [--preview]"
    echo "  --preview  mostra o banner e a abertura do setup sem instalar nada"
    exit 0
    ;;
esac

# ──── Saída ─────────────────────────────────────────────────────────────────────
GREEN=''; YELLOW=''; RED=''; CYAN=''; BOLD=''; DIM=''; NC=''
ok()   { echo "  ✓ $1"; }
warn() { echo "  ! $1"; }
info() { echo "  → $1"; }

print_banner() {
  echo ""
  if [ -f "$ART_FILE" ]; then
    cat "$ART_FILE"
  else
    echo "Vault Brain"
  fi
  echo "  brain-template setup · AGENTS.md + Memória + HANDOVERS"
  echo ""
}

echo ""
print_banner

if $PREVIEW; then
  echo "Preview do setup:"
  ok "Banner carregado de: $ART_FILE"
  info "No modo normal, o setup cria a estrutura base, instala plugins e configura a IA."
  info "Rode: bash setup.sh"
  exit 0
fi

# ──── Estrutura base do vault ───────────────────────────────────────────────────
mkdir -p \
  "$VAULT_DIR/00 - INBOX" \
  "$VAULT_DIR/Memória" \
  "$VAULT_DIR/07 - HANDOVERS/Tarefas" \
  "$VAULT_DIR/07 - HANDOVERS/Arquivo" \
  "$VAULT_DIR/07 - HANDOVERS/Tarefas/Arquivo"

touch \
  "$VAULT_DIR/00 - INBOX/.gitkeep" \
  "$VAULT_DIR/07 - HANDOVERS/Tarefas/.gitkeep" \
  "$VAULT_DIR/07 - HANDOVERS/Arquivo/.gitkeep" \
  "$VAULT_DIR/07 - HANDOVERS/Tarefas/Arquivo/.gitkeep"

if [ ! -f "$VAULT_DIR/Memória/INDEX.md" ]; then
  cat > "$VAULT_DIR/Memória/INDEX.md" <<'EOF'
# Índice de Memória

> Memória semântica compartilhada entre IAs.
> Uma linha por fato durável. Protocolo: ver `../AGENTS.md` → seção **Memória viva**.

## Fatos

_Nenhum fato registrado ainda. Rode `/init_newbrain` para criar o perfil inicial._
EOF
fi

ok "Estrutura base criada: INBOX, Memória e HANDOVERS"
echo ""

# ──── Verificar dependências básicas ────────────────────────────────────────────
need_curl=false
command -v curl &>/dev/null || need_curl=true

if $need_curl; then
  echo -e "${RED}  ✗${NC} curl não encontrado. Instale com:"
  echo "    Linux: sudo apt install curl"
  echo "    Mac:   brew install curl"
  exit 1
fi

# ──── Download de plugin Obsidian ────────────────────────────────────────────────
download_plugin() {
  local repo="$1"        # ex: blacksmithgu/obsidian-dataview
  local plugin_id="$2"   # ex: dataview
  local dir="$PLUGINS_DIR/$plugin_id"

  mkdir -p "$dir"

  local base_url="https://github.com/$repo/releases/latest/download"

  echo -n "    Baixando $plugin_id... "

  if curl -sf "$base_url/main.js" -o "$dir/main.js" 2>/dev/null; then
    curl -sf "$base_url/manifest.json" -o "$dir/manifest.json" 2>/dev/null || true
    curl -sf "$base_url/styles.css" -o "$dir/styles.css" 2>/dev/null || true
    echo -e "${GREEN}ok${NC}"
  else
    echo -e "${YELLOW}falhou (sem conexão ou release não encontrada)${NC}"
    warn "Plugin '$plugin_id' precisará ser instalado manualmente no Obsidian."
  fi
}

# ──── Instalar plugins Obsidian ──────────────────────────────────────────────────
echo "Instalando plugins Obsidian..."
echo ""
download_plugin "blacksmithgu/obsidian-dataview"        "dataview"
download_plugin "SilentVoid13/Templater"                 "templater-obsidian"
download_plugin "liamcain/obsidian-calendar-plugin"      "obsidian-calendar-plugin"
download_plugin "liamcain/obsidian-periodic-notes"       "periodic-notes"
download_plugin "Vinzent03/obsidian-git"                 "obsidian-git"

echo ""
ok "Plugins instalados em: $PLUGINS_DIR"
echo ""

# ──── Ferramenta de IA ───────────────────────────────────────────────────────────
echo "Qual ferramenta de IA você vai usar?"
echo "  1) Claude Code  (Anthropic)"
echo "  2) Gemini CLI   (Google)"
echo "  3) opencode     (open-source, múltiplos modelos)"
echo "  4) Todas / não sei ainda"
echo ""
read -rp "Opção (1-4): " ai_choice

setup_claude=false
setup_gemini=false
setup_opencode=false

case $ai_choice in
  1) setup_claude=true ;;
  2) setup_gemini=true ;;
  3) setup_opencode=true ;;
  *) setup_claude=true; setup_gemini=true; setup_opencode=true ;;
esac

echo ""

# ──── Claude Code ────────────────────────────────────────────────────────────────
if $setup_claude; then
  echo "Verificando Claude Code..."
  if command -v claude &>/dev/null; then
    ok "Claude Code já instalado"
  else
    warn "Claude Code não encontrado."
    info "Instale em: https://claude.ai/code"
    info "Ou: npm install -g @anthropic-ai/claude-code"
  fi
  ok "Commands em: $VAULT_DIR/.claude/commands/"
  info "/init_newbrain  /handover_chat  /handon_chat  /vault_scan  /vault_gc"
  echo ""
fi

# ──── Gemini CLI ─────────────────────────────────────────────────────────────────
if $setup_gemini; then
  echo "Verificando Gemini CLI..."
  if command -v gemini &>/dev/null; then
    ok "Gemini CLI já instalado"
  else
    warn "Gemini CLI não encontrado."
    info "Instale em: https://ai.google.dev/gemini-api/docs/gemini-cli"
    info "Ou: npm install -g @google/generative-ai-cli"
  fi
  ok "GEMINI.md configurado em: $VAULT_DIR/GEMINI.md"
  info "Gemini CLI não tem slash commands — use os arquivos em .claude/commands/ como contexto manual"
  echo ""
fi

# ──── opencode ───────────────────────────────────────────────────────────────────
if $setup_opencode; then
  echo "Verificando opencode..."
  if command -v opencode &>/dev/null; then
    ok "opencode já instalado"
  else
    warn "opencode não encontrado."
    info "Instale em: https://opencode.ai"
    info "Ou: npm install -g opencode-ai"
  fi

  OPENCODE_DIR="$VAULT_DIR/.opencode"
  if [ ! -f "$OPENCODE_DIR/config.toml" ]; then
    mkdir -p "$OPENCODE_DIR"
    cat > "$OPENCODE_DIR/config.toml" <<'EOF'
# opencode config — brain-template
# Configure o modelo e provedor desejados abaixo
# Exemplos:
#   provider = "anthropic"  model = "claude-sonnet-4-6"
#   provider = "google"     model = "gemini-2.0-flash"
#   provider = "openai"     model = "gpt-4o"
#   provider = "ollama"     model = "llama3.2"

[model]
# provider = "anthropic"
# model = "claude-sonnet-4-6"

[instructions]
file = "../AGENTS.md"
EOF
    ok ".opencode/config.toml criado"
  fi
  echo ""
fi

# ──── VS Code ────────────────────────────────────────────────────────────────────
read -rp "Usa VS Code? (s/n): " uses_vscode
if [[ "$uses_vscode" =~ ^[Ss]$ ]]; then
  VSCODE_DIR="$VAULT_DIR/.vscode"
  mkdir -p "$VSCODE_DIR"
  if [ ! -f "$VSCODE_DIR/extensions.json" ]; then
    cat > "$VSCODE_DIR/extensions.json" <<'EOF'
{
  "recommendations": [
    "anthropic.claude-code"
  ]
}
EOF
    ok ".vscode/extensions.json criado (recomenda Claude Code)"
  fi
  echo ""
fi

# ──── Obsidian ───────────────────────────────────────────────────────────────────
echo ""
echo -e "${GREEN}${BOLD}Tudo pronto.${NC}"
echo "──────────────────────────────────────────"
echo ""
echo "  Vault em: $VAULT_DIR"
echo ""
echo "  PRÓXIMOS PASSOS:"
echo ""
echo "  1. Abra o Obsidian"
echo "     → Clique em 'Abrir pasta como vault'"
echo "     → Selecione a pasta: vault/"
echo "     → Quando perguntar sobre plugins: clique em 'Confiar no autor'"
echo ""

if $setup_claude; then
  echo "  2. Abra a pasta vault/ no VS Code (ou terminal)"
  echo "     → No terminal dentro da pasta vault/: claude"
  echo "     → Digite: /init_newbrain"
  echo "     → Responda as perguntas — o vault vai se configurar automaticamente"
elif $setup_gemini; then
  echo "  2. Abra a pasta vault/ no terminal"
  echo "     → Digite: gemini"
  echo "     → Peça: 'Leia AGENTS.md e .claude/commands/init_newbrain.md, depois siga o onboarding'"
fi

echo ""
echo "  3. Use o vault!"
echo "     → /handover_chat — salvar sessão"
echo "     → /handon_chat   — retomar sessão"
echo "     → /vault_scan    — conectar notas"
echo "     → /vault_gc      — manutenção semanal"
echo ""
