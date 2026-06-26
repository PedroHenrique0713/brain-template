---
name: handover_chat
description: Salva o progresso da sessão atual em 07 - HANDOVERS/ ou em uma tarefa T0XX ativa
compatibility: Claude Code, Gemini CLI, opencode, modelos locais
---

# handover_chat

Use ao fim de uma sessão ou antes de trocar de IA. O objetivo é permitir continuidade sem depender do chat.

## Onde salvar

- Sessão solta: `07 - HANDOVERS/YYYY-MM-DD HHMM - Handover.md`
- Tarefa longa: `07 - HANDOVERS/Tarefas/T0XX - Nome da tarefa.md`

Se a conversa já tem uma tarefa T0XX, atualize esse arquivo em vez de criar outro handover solto.

## Template

```markdown
---
date: YYYY-MM-DD
time: "HH:MM"
status: em_andamento
tags:
  - handover
---

# Handover — YYYY-MM-DD HH:MM

## Objetivo atual

O que a sessão estava tentando resolver.

## Estado agora

Onde parou exatamente. Cite arquivos, comandos, links e bloqueios.

## Feito (não refazer)

- Itens concluídos.

## Próximos passos

- [ ] Próximo passo específico.

## Decisões técnicas

- YYYY-MM-DD — Decisão tomada e por quê.

## Armadilhas

- Contexto que a próxima IA provavelmente perderia.

— atualizado por <Claude|Codex|Gemini|opencode> em YYYY-MM-DD
```

## Regras

- Seja factual e específico.
- Não apague histórico; handover é timeline.
- Decisões relevantes entram em "Decisões técnicas" com data e motivo.
- Conhecimento durável vai também para `Memória/` ao final do esforço.
