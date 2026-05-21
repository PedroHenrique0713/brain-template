# /handover_chat

Salva o progresso da sessão atual como um snapshot em `07 - HANDOVERS/`.

---

## Execução

1. Determine a data e hora atual (formato `YYYY-MM-DD HHmm`).
2. Identifique a tarefa ativa da sessão (pelo contexto da conversa ou pelo título da tarefa em andamento).
3. Crie o arquivo `07 - HANDOVERS/{data} {hora} - Handover.md` com este template:

```markdown
---
data: {data}
hora: {hora}
status: em_andamento
---

# Handover — {data} {hora}

## Contexto

{Descreva em 2-3 frases o que estava sendo feito nesta sessão.}

## O que foi feito

- {item 1}
- {item 2}
- ...

## Próximos passos

- [ ] {próximo passo 1}
- [ ] {próximo passo 2}
- ...

## Arquivos modificados / criados

- {arquivo 1}
- {arquivo 2}

## Decisões tomadas

{Decisões relevantes que precisam ser lembradas na próxima sessão.}

## Observações

{Qualquer contexto extra que pode ser útil.}
```

4. Confirme ao usuário: `"Handover salvo em 07 - HANDOVERS/{data} {hora} - Handover.md"`
