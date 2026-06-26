---
name: handon_chat
description: Retoma uma tarefa T0XX ou lista handovers ativos
compatibility: Claude Code, Gemini CLI, opencode, modelos locais
---

# handon_chat

Use para carregar contexto salvo antes de continuar trabalho.

## Sem argumento

Liste candidatos ativos:

```bash
find "07 - HANDOVERS" -name "*.md" -not -path "*/Arquivo/*" | sort -r
```

Leia frontmatter e primeiras seções. Ignore `status: finalizado`.

Mostre:

```text
Handovers ativos:
1. T016 — Nome — último estado
2. 2026-05-20 1430 — assunto
```

## Com argumento

- `/handon_chat T003`: abra `07 - HANDOVERS/Tarefas/T003*`
- `/handon_chat ultima`: abra o handover mais recente não arquivado
- `/handon_chat YYYY-MM-DD`: abra o handover mais recente dessa data

Depois de ler, responda com:

- objetivo atual;
- estado agora;
- feito que não deve ser repetido;
- próximos passos abertos;
- decisões e armadilhas relevantes.

## Encerramento

Se o usuário pedir para fechar uma tarefa/sessão:

1. marque `status: finalizado`;
2. preserve o conteúdo;
3. se houver conhecimento durável, crie/atualize arquivo em `Memória/` e `Memória/INDEX.md`;
4. não mova para `Arquivo/` manualmente, a menos que o usuário peça. O `/vault_gc` faz isso.
