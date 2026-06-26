---
name: vault_gc
description: Manutenção semanal do vault: arquiva handovers antigos, valida Memória/INDEX.md e triage do INBOX
compatibility: Claude Code, Gemini CLI, opencode, modelos locais
---

# vault_gc

Use semanalmente ou quando o vault estiver acumulando lixo operacional.

## Escopo

- `07 - HANDOVERS/`: mover handovers finalizados ou antigos para `07 - HANDOVERS/Arquivo/`.
- `07 - HANDOVERS/Tarefas/`: mover tarefas finalizadas para `07 - HANDOVERS/Tarefas/Arquivo/`.
- `Memória/`: validar que todo arquivo tem entrada em `Memória/INDEX.md` e que links do índice existem.
- `00 - INBOX/`: listar itens pendentes de triagem.

## Regras

- Arquivar é mover, nunca apagar.
- Não condensar handovers; eles são timeline.
- Não criar memória a partir de estado momentâneo.
- Antes de mover muitos arquivos, mostre plano curto e execute.

## Checklist

1. Criar pastas de arquivo se faltarem:
   ```bash
   mkdir -p "07 - HANDOVERS/Arquivo" "07 - HANDOVERS/Tarefas/Arquivo"
   ```
2. Listar handovers candidatos:
   ```bash
   find "07 - HANDOVERS" -maxdepth 1 -name "*.md" | sort
   find "07 - HANDOVERS/Tarefas" -maxdepth 1 -name "*.md" | sort
   ```
3. Ler frontmatter antes de mover.
4. Validar `Memória/INDEX.md` contra `Memória/*.md`.
5. Listar `00 - INBOX/` e sugerir destino para cada item.

## Relatório

Informe:

- arquivos arquivados;
- inconsistências de memória corrigidas;
- itens de inbox pendentes;
- qualquer coisa que exigiu decisão do usuário.
