---
description: Manutenção semanal do vault — tritura o STAGING, digere a semana na Memória, arquiva tarefas encerradas, lista as paradas, valida a Memória e faz triagem do INBOX. Rodar ~1x por semana.
---

Execute na ordem. Cada passo é independente — sem nada a fazer, siga. No fim, apresente o relatório do Passo 5.

> ⚠️ **Arquivar = mover de pasta, nunca condensar ou apagar.** Handovers e logs de tarefa são a linha do tempo do trabalho.

- TODAY = data de hoje
- Status encerrados: `concluida`, `cancelada` (e os legados `finalizada`, `finalizado`, `concluido`, `cancelado`)
- Uma tarefa são dois arquivos (estado e `.log.md`); andam sempre juntos

## Passo 1 — Arquivar tarefas encerradas

Para cada `07 - HANDOVERS/Tarefas/*.md` (sem os `.log.md`, sem descer em `Arquivo/`) com status encerrado: promova para `Memória/` o conhecimento durável que ainda não está lá (protocolo do `AGENTS.md`) e mova os dois arquivos para `Tarefas/Arquivo/`.

## Passo 1b — Tarefas paradas (decisão do usuário)

Rode `python3 "03 - RESOURCES/Scripts/gerar-ativas.py"` e leia `07 - HANDOVERS/ATIVAS.md`. Tarefa com ⚠️ (viva, sem toque há mais de 21 dias) e `pausada` há mais de 60 dias vão para o relatório com uma sugestão curta (pausar, encerrar, ou "segue viva porque X"). **Não mude status sozinho.**

## Passo 2 — Arquivar handovers antigos

Mova para `07 - HANDOVERS/Arquivo/` todo `07 - HANDOVERS/*.md` com data no nome anterior a TODAY − 21 dias. O mais recente fica sempre. `ATIVAS.md` nunca sai.

## Passo 3 — Validar a Memória

1. **STAGING:** cada linha de `Memória/STAGING.md` → durável vira fato (ou complementa um existente); efêmero ou já registrado sai. Zere a lista. Ambíguo vai pro relatório.
2. **Digestão da semana:** leia os handovers e logs de tarefa novos desde o último gc e (a) atualize os fatos que mudaram, com invalidação explícita; (b) liste contradições entre fato e handover mais novo; (c) capture no STAGING o durável que ninguém anotou.
3. **Sincronia:** todo `Memória/*.md` (exceto INDEX e STAGING) tem **exatamente uma** linha de gancho — no `INDEX.md` ou numa skill de `~/.claude/skills/`. Nenhum nos dois, nenhum sem.
4. **Teto do INDEX:** linhas acima de 320 caracteres (`awk '/^- \[/ {if (length > 320) print NR": "length}' "Memória/INDEX.md"`) viram gancho puro; causa e medição vão para o arquivo do fato.
5. **Perecíveis:** "no momento", "atualmente", "pendente", "aguardando", "por enquanto" nos fatos e no INDEX → move para a tarefa ou remove.
6. **Datas relativas** ("segunda", "semana que vem", "amanhã") → data absoluta, ou remove se já passou.
7. **Fatos-dossiê:** fato com mais de ~4 KB provavelmente é documentação; sugira migrar o corpo para a pasta do projeto (só listar).
8. **`review:` vencido:** confira se ainda vale.
9. **Fusão de feedbacks** que se sobrepõem: poucas regras fortes > muitas fracas.

## Passo 4 — INBOX

Arquivo de `00 - INBOX/` já processado vai para a pasta definitiva; o não processado entra no relatório (não processe sozinho).

## Passo 5 — Relatório

```markdown
## 🧹 vault_gc — {TODAY}

**Tarefas arquivadas:** T0XX | nenhuma
**Paradas para decidir:** T0XX (sugestão) | nenhuma
**Handovers arquivados:** N | nenhum
**Memória:** INDEX ok | corrigido: ... · perecíveis: ... · staging: N promovidos / N descartados · contradições: ...
**INBOX:** N movidos · pendentes: ...
```
