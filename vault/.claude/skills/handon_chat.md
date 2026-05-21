---
name: handon_chat
description: Lista sessões salvas em 07 - HANDOVERS/ ou carrega uma sessão específica para retomar o trabalho
compatibility: Claude Code, Gemini CLI, opencode, modelos locais
---

# handon_chat

Retoma o contexto de uma sessão anterior a partir dos arquivos salvos em `07 - HANDOVERS/`.

---

## Formas de usar

- **`/handon_chat`** — lista todas as sessões salvas (mais recente primeiro)
- **`/handon_chat 2026-05-20`** — carrega a sessão mais próxima dessa data
- **`/handon_chat ultima`** — carrega o handover mais recente automaticamente

---

## MODO 1 — Listar sessões (sem argumento)

### Passo 1 — Encontrar os arquivos de handover

Execute:
```bash
find "07 - HANDOVERS" -name "*.md" -not -name ".gitkeep" | sort -r
```

Se não tiver acesso ao terminal, peça ao usuário para listar os arquivos em `07 - HANDOVERS/`.

### Passo 2 — Filtrar sessões ativas

Leia cada arquivo encontrado e verifique o frontmatter. Ignore arquivos com `status: finalizado`.

### Passo 3 — Mostrar a lista

Mostre assim:

```
Sessões salvas (mais recente primeiro):

1. 2026-05-20 1430 — Configurando fluxo n8n para cliente X
2. 2026-05-19 0930 — Revisão de documentação do projeto Y
3. 2026-05-18 1600 — Setup inicial do vault

Qual quer retomar? (diga o número ou a data)
```

Use a primeira linha da seção "## Contexto da sessão" como descrição resumida.

---

## MODO 2 — Carregar sessão específica

### Passo 1 — Encontrar o arquivo correto

Se o argumento for uma data (ex: `2026-05-20`), encontre o arquivo mais recente daquela data:
```bash
find "07 - HANDOVERS" -name "2026-05-20*.md" | sort -r | head -1
```

Se o argumento for `ultima`, encontre o arquivo mais recente de todos:
```bash
find "07 - HANDOVERS" -name "*.md" -not -name ".gitkeep" | sort -r | head -1
```

### Passo 2 — Ler o arquivo inteiro

Leia o conteúdo completo do arquivo de handover encontrado.

### Passo 3 — Apresentar o contexto

Mostre este resumo para o usuário:

```
Sessão retomada: {data} {hora}

CONTEXTO
{Conteúdo da seção "Contexto da sessão"}

O QUE JÁ FOI FEITO
{Lista da seção "O que foi feito"}

PRÓXIMOS PASSOS PENDENTES
{Lista da seção "Próximos passos" — destacando os que têm [ ] (não concluídos)}

ARQUIVOS RELACIONADOS
{Lista da seção "Arquivos criados ou modificados"}
```

### Passo 4 — Oferecer continuação

Após o resumo, diga:

```
Contexto carregado. Podemos continuar de onde parou.

Sugestão: começar pelo próximo passo "{primeiro [ ] da lista}".
Quer continuar por aí ou por outro passo?
```

---

## MODO 3 — Marcar sessão como finalizada

Se o usuário disser "fechar sessão", "marcar como finalizado" ou similar:

1. Encontre o arquivo de handover atual
2. Edite o frontmatter, trocando `status: em_andamento` por `status: finalizado`
3. Confirme: "Sessão marcada como finalizada."

---

## Notas para modelos com capacidades limitadas

Se você não conseguir executar comandos bash, peça ao usuário para listar os arquivos em `07 - HANDOVERS/` e dizer qual quer abrir. Depois leia o arquivo e siga os passos do Modo 2 a partir do Passo 2.

Se você não conseguir ler arquivos, peça ao usuário para colar o conteúdo do handover na conversa.
