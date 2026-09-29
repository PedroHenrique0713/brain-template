---
description: Retoma o contexto de uma tarefa específica (ex: /handon T001) ou lista as tarefas vivas
---

Retome o contexto carregando a tarefa pedida.

- ARGS = o que o usuário passou (ex: "T001", "site", "migração")
- Uma tarefa são dois arquivos em `07 - HANDOVERS/Tarefas/`: o **estado** `T0XX - nome.md` e o **log** `T0XX - nome.log.md`. Nas buscas, ignore os `.log.md`.

## Modo A — com argumento

1. Procure em `07 - HANDOVERS/Tarefas/*.md` (sem os `.log.md`) o arquivo cujo nome contém ARGS (sem diferenciar maiúsculas, parcial vale). Não achou? Procure em `Tarefas/Arquivo/`; se for retomada de tarefa encerrada, mova os dois arquivos de volta e reabra como `ativa`.
2. Leia o **estado** inteiro. Se passar de ~20 KB (formato antigo), leia o frontmatter e as seções de Objetivo, Estado, Próximo passo, Decisões e Armadilhas, e avise que a tarefa será reorganizada no próximo `/handover_chat`.
3. Do **log**, leia só as **2 últimas entradas** (`grep -n "^### "` e leitura a partir da penúltima).
4. Apresente:

```markdown
## Tarefa retomada — {ID} | {TÍTULO}

**Projeto:** {projeto} | **Status:** {status}
{se aguardando: "**Esperando:** {bloqueio}"}

### Objetivo
### Estado agora
### Próximo passo
### Última sessão
### Contexto técnico (condensado)

---
*Tarefa {ID} carregada. Pode começar pelo "Próximo passo".*
```

## Modo B — sem argumento

1. Rode `python3 "03 - RESOURCES/Scripts/gerar-ativas.py"` e leia `07 - HANDOVERS/ATIVAS.md`.
2. Mostre a tabela (ativas não paradas primeiro) e pergunte: **"Qual tarefa iniciar?"**
3. Com o ID escolhido, execute o Modo A.

Depois de carregar, mantenha o contexto para o resto da sessão sem repeti-lo a cada resposta.
