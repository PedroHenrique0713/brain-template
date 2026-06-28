# Changelog — Vault Brain

Notas de versão do template. O `update.sh` mostra automaticamente tudo o que mudou
entre a sua versão e a mais recente. Formato baseado em [Keep a Changelog](https://keepachangelog.com/pt-BR/).

## [2.1.0] - 2026-06-28

Atualização sem dor: agora dá pra puxar novidades do template num vault que já existe.

### Adicionado
- **`update.sh`** — sincroniza o framework (commands, scripts) do GitHub sem tocar nos seus dados. Roda com um comando só (`curl -sL .../update.sh | bash`), mostra o banner e as release notes, e tem `--dry-run` e `--prune`. Grava a versão em `.claude/.brain-version`.
- Command **`/update_brain`** — migra a estrutura de um vault da v1 para a v2 (skills→commands, conteúdo do `CLAUDE.md`→`AGENTS.md`), de forma interativa e preservando o conteúdo.
- `CHANGELOG.md` e `VERSION` — base das release notes mostradas pelo `update.sh`.

## [2.0.0] - 2026-06-26

Reorganização grande: o template passou a usar um **cérebro neutro multi-IA**.

### Mudou
- **Cérebro canônico em `AGENTS.md`** — `CLAUDE.md` e `GEMINI.md` viraram ponteiros finos que só apontam pra lá. Vale pra Claude Code, Gemini CLI, opencode e modelos locais.
- **Skills viraram slash-commands** — de `.claude/skills/*.md` para `.claude/commands/*.md`.

### Adicionado
- Command `/vault_gc` — manutenção semanal (arquiva handovers/tarefas, valida Memória ↔ INDEX, triagem do INBOX).
- Estrutura base com `.gitkeep` em `00 - INBOX/`, `07 - HANDOVERS/Arquivo/`, `07 - HANDOVERS/Tarefas/` e `Tarefas/Arquivo/`.
- `setup.sh` com auto-download dos plugins do Obsidian e escolha de ferramenta de IA.

### Removido
- Pasta antiga `.claude/skills/` (substituída por `.claude/commands/`).

## [1.0.0] - 2026-06-24

### Adicionado
- Estrutura inicial do vault (PROJETOS, ÁREAS, RECURSOS, REUNIÕES, HANDOVERS, Memória).
- Plugins do Obsidian e primeira versão das skills de onboarding/handover.
