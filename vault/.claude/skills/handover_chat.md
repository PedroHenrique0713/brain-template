---
name: handover_chat
description: Salva o progresso da sessão atual como um snapshot em 07 - HANDOVERS/ para retomar depois
compatibility: Claude Code, Gemini CLI, opencode, modelos locais
---

# handover_chat

Salva tudo que foi feito nesta sessão em um arquivo de handover. Use ao final de qualquer sessão de trabalho ou quando precisar pausar no meio de uma tarefa.

---

## O que este skill faz

Cria um arquivo `.md` em `07 - HANDOVERS/` com:
- O que foi feito nesta sessão
- Próximos passos pendentes
- Arquivos criados ou modificados
- Decisões importantes tomadas

---

## Passo a passo

### Passo 1 — Descobrir a data e hora atual

Execute este comando no terminal:

```bash
date '+%Y-%m-%d %H%M'
```

A saída será algo como: `2026-05-20 1430`

Se não tiver acesso ao terminal, peça para o usuário informar data e hora, ou estime com base no contexto.

### Passo 2 — Identificar o contexto da sessão

Analise o histórico da conversa atual e identifique:

- **Qual era a tarefa principal?** (o que a pessoa estava tentando fazer)
- **O que foi concluído?** (liste tudo que foi finalizado)
- **O que ficou pendente?** (o que ainda precisa ser feito)
- **Quais arquivos foram criados ou modificados?** (liste os caminhos)
- **Houve alguma decisão importante?** (algo que precisa ser lembrado)

### Passo 3 — Criar o arquivo de handover

Crie o arquivo em: `07 - HANDOVERS/{data} {hora} - Handover.md`

Exemplo de caminho: `07 - HANDOVERS/2026-05-20 1430 - Handover.md`

Use este template:

```markdown
---
data: {YYYY-MM-DD}
hora: {HHmm}
status: em_andamento
---

# Handover — {data} {hora}

## Contexto da sessão

{2-3 frases descrevendo o que estava sendo feito. Seja específico o suficiente para uma IA conseguir retomar sem precisar de mais contexto.}

## O que foi feito

- {Item concluído 1}
- {Item concluído 2}
- {Adicione quantos forem necessários}

## Próximos passos

- [ ] {Próximo passo 1 — seja específico}
- [ ] {Próximo passo 2}
- [ ] {Adicione quantos forem necessários}

## Arquivos criados ou modificados

- `{caminho/do/arquivo.md}` — {o que foi feito nele}
- `{caminho/do/outro.md}` — {o que foi feito nele}

## Decisões tomadas

{Liste decisões que precisam ser lembradas na próxima sessão. Se não houver, escreva "Nenhuma decisão relevante."}

## Observações

{Contexto extra: bloqueios encontrados, dúvidas em aberto, links úteis, etc. Se não tiver, pode deixar vazio.}
```

### Passo 4 — Confirmar para o usuário

Após criar o arquivo, diga:

```
Handover salvo em: 07 - HANDOVERS/{data} {hora} - Handover.md

Para retomar nesta sessão: /handon_chat
```

---

## Exemplo de uso

**Usuário diz:** `/handover_chat`

**Você faz:**
1. Roda `date '+%Y-%m-%d %H%M'` → obtém `2026-05-20 1430`
2. Analisa a conversa: estava configurando um fluxo n8n, criou 3 nodes, faltam 2
3. Cria `07 - HANDOVERS/2026-05-20 1430 - Handover.md` com o resumo
4. Diz: "Handover salvo em 07 - HANDOVERS/2026-05-20 1430 - Handover.md"

---

## Notas para modelos com capacidades limitadas

Se você não conseguir executar comandos bash, use a data informada pelo usuário ou peça para ele informar. O arquivo DEVE ser criado mesmo sem a data exata — use `YYYY-MM-DD` como placeholder.

Se você não conseguir escrever arquivos diretamente, mostre o conteúdo formatado para o usuário copiar e colar.
