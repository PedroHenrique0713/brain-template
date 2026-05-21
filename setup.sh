#!/usr/bin/env bash
set -e

VAULT_DIR="$(cd "$(dirname "$0")/vault" && pwd)"

echo ""
echo "╔══════════════════════════════════════╗"
echo "║       brain-template — setup         ║"
echo "╚══════════════════════════════════════╝"
echo ""
echo "Vault encontrado em: $VAULT_DIR"
echo ""

# ──── Detectar ferramenta de IA ────────────────────────────────────────────────

echo "Qual(is) ferramenta(s) de IA você vai usar?"
echo "  1) Claude Code"
echo "  2) Gemini CLI"
echo "  3) opencode"
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
  4) setup_claude=true; setup_gemini=true; setup_opencode=true ;;
  *) echo "Opção inválida. Configurando tudo por padrão."; setup_claude=true; setup_gemini=true ;;
esac

# ──── Claude Code ───────────────────────────────────────────────────────────────

if $setup_claude; then
  echo ""
  echo "▶ Configurando Claude Code..."

  if command -v claude &>/dev/null; then
    echo "  ✓ Claude Code já instalado ($(claude --version 2>/dev/null || echo 'versão desconhecida'))"
  else
    echo "  ✗ Claude Code não encontrado."
    echo "    Instale com: npm install -g @anthropic-ai/claude-code"
    echo "    Ou acesse: https://claude.ai/code"
  fi

  echo "  ✓ Skills disponíveis em: $VAULT_DIR/.claude/skills/"
  echo "    → /init_newbrain  /handover_chat  /handon_chat  /vault_scan"
fi

# ──── Gemini CLI ────────────────────────────────────────────────────────────────

if $setup_gemini; then
  echo ""
  echo "▶ Configurando Gemini CLI..."

  if command -v gemini &>/dev/null; then
    echo "  ✓ Gemini CLI já instalado"
  else
    echo "  ✗ Gemini CLI não encontrado."
    echo "    Instale com: npm install -g @google/generative-ai-cli"
    echo "    Ou acesse: https://ai.google.dev/gemini-api/docs/gemini-cli"
  fi

  # Gemini CLI usa GEMINI.md na raiz do projeto
  if [ -f "$VAULT_DIR/GEMINI.md" ]; then
    echo "  ✓ GEMINI.md encontrado — contexto pronto"
  fi

  echo "  ℹ Gemini CLI não tem slash commands nativos."
  echo "    As skills ficam em .claude/skills/ e podem ser coladas como contexto."
fi

# ──── opencode ──────────────────────────────────────────────────────────────────

if $setup_opencode; then
  echo ""
  echo "▶ Configurando opencode..."

  if command -v opencode &>/dev/null; then
    echo "  ✓ opencode já instalado"
  else
    echo "  ✗ opencode não encontrado."
    echo "    Instale com: npm install -g opencode-ai"
    echo "    Ou acesse: https://opencode.ai"
  fi

  OPENCODE_DIR="$VAULT_DIR/.opencode"
  if [ ! -d "$OPENCODE_DIR" ]; then
    mkdir -p "$OPENCODE_DIR"
    cat > "$OPENCODE_DIR/config.toml" <<'EOF'
[model]
# Configure o modelo desejado aqui
# Ex: provider = "anthropic", model = "claude-sonnet-4-6"
# Ex: provider = "google", model = "gemini-2.0-flash"

[instructions]
# Aponta para o CLAUDE.md como system prompt
file = "../CLAUDE.md"
EOF
    echo "  ✓ .opencode/config.toml criado"
  fi
fi

# ──── VS Code ───────────────────────────────────────────────────────────────────

echo ""
read -rp "Usa VS Code? (s/n): " uses_vscode

if [[ "$uses_vscode" =~ ^[Ss]$ ]]; then
  VSCODE_DIR="$VAULT_DIR/.vscode"
  if [ ! -d "$VSCODE_DIR" ]; then
    mkdir -p "$VSCODE_DIR"
    cat > "$VSCODE_DIR/extensions.json" <<'EOF'
{
  "recommendations": [
    "anthropic.claude-code"
  ]
}
EOF
    echo "  ✓ .vscode/extensions.json criado com recomendação do Claude Code"
  fi
fi

# ──── Obsidian ──────────────────────────────────────────────────────────────────

echo ""
echo "▶ Vault Obsidian pronto em: $VAULT_DIR"
echo "  Abra o Obsidian → 'Abrir pasta como vault' → selecione a pasta acima."
echo ""

# ──── Próximos passos ───────────────────────────────────────────────────────────

echo "╔══════════════════════════════════════╗"
echo "║           Próximos passos            ║"
echo "╚══════════════════════════════════════╝"
echo ""
echo "  1. Abra o vault no Obsidian"
echo "  2. Abra a pasta vault/ no VS Code (ou terminal)"

if $setup_claude; then
  echo "  3. Rode: claude (no terminal dentro do vault)"
  echo "  4. Digite: /init_newbrain"
elif $setup_gemini; then
  echo "  3. Rode: gemini (no terminal dentro do vault)"
  echo "  4. Peça para seguir as instruções de onboarding em .claude/skills/init_newbrain.md"
fi

echo ""
echo "  Pronto! O onboarding vai personalizar tudo pra você."
echo ""
