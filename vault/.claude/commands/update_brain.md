---
name: update_brain
description: Migra a ESTRUTURA do vault da v1 para a v2 (skills→commands, CLAUDE.md→AGENTS.md) sem perder dados
compatibility: Claude Code, Gemini CLI, opencode, modelos locais
---

# update_brain

Migra um vault criado numa versão antiga do template para a estrutura atual, **sem destruir o conteúdo da pessoa**. É o complemento do `update.sh`:

- `update.sh` (terminal) puxa o **framework** novo (commands, scripts) do GitHub.
- `/update_brain` (aqui) reorganiza a **estrutura** local: move conteúdo do lugar antigo pro novo e ajusta os ponteiros.

Faça em etapas, **confirme antes de cada escrita** e nunca prossiga com dúvida sobre perda de dados.

## Regras de ouro

- **NUNCA** apague ou sobrescreva conteúdo do usuário: `Memória/`, `01 - PROJETOS/` (ou `PROJECTS`), `05 - REUNIÕES/`, `07 - HANDOVERS/`, `00 - INBOX/`, notas soltas.
- **Mover, não recriar** — ao migrar conteúdo, preserve o texto integral; não resuma nem reescreva.
- `AGENTS.md` é o arquivo canônico. `CLAUDE.md`/`GEMINI.md` ficam finos, só apontando pra ele.
- Em caso de conflito (já existe destino), **pergunte** — nunca decida sozinho sobrescrever.
- Use o idioma da pessoa. Mostre um plano antes de aplicar.

## 1. Diagnóstico

Antes de qualquer mudança, leia o vault e detecte o que é v1. Reporte uma tabela do que será feito:

| Sinal de v1 | Detecção | Ação proposta |
|---|---|---|
| Skills antigas | existe `.claude/skills/` | mover para `.claude/commands/` |
| Cérebro no lugar errado | `CLAUDE.md` tem conteúdo de perfil (mais que um ponteiro) e **não** existe `AGENTS.md` | mover conteúdo → `AGENTS.md`, deixar `CLAUDE.md` fino |
| `GEMINI.md` gordo | tem conteúdo próprio em vez de ponteiro | reduzir a ponteiro |
| Pastas faltando | sem `00 - INBOX/`, `07 - HANDOVERS/Arquivo/`, `Tarefas/`, `Tarefas/Arquivo/` | criar + `.gitkeep` |
| Memória sem índice | sem `Memória/INDEX.md` | criar índice base |
| Sem marcador de versão | sem `.claude/.brain-version` | criar ao final |

Se **nada** de v1 for detectado, diga que o vault já está na estrutura atual e sugira rodar `update.sh` pra pegar commands novos. Pare aqui.

## 2. Plano e confirmação

Mostre o plano completo (o que move, o que cria, o que NÃO será tocado) e peça confirmação explícita: "Posso aplicar?". Só prossiga com um "sim".

## 3. Migração (na ordem)

### 3a. Skills → commands
- Para cada arquivo em `.claude/skills/`, se **não** existir equivalente em `.claude/commands/`, mova-o.
- Se já existir nos dois lugares, **pergunte** qual manter (provavelmente o de `commands/`, mais novo).
- Ao fim, se `.claude/skills/` ficar vazia, remova a pasta.

### 3b. CLAUDE.md → AGENTS.md
Só execute se `AGENTS.md` **não** existir e `CLAUDE.md` tiver conteúdo real:
- Crie `AGENTS.md` com **todo** o conteúdo de perfil/projetos/protocolo que estava no `CLAUDE.md` (mover, não resumir).
- Substitua o `CLAUDE.md` pela versão fina:
  ```markdown
  # CLAUDE.md

  Leia primeiro: `AGENTS.md`.

  `AGENTS.md` é o arquivo canônico de contexto deste vault.
  ```
- Se já existe `AGENTS.md`, **não** mexa nele — só garanta que `CLAUDE.md` seja um ponteiro (perguntando antes se ele tiver conteúdo único que possa se perder).

### 3c. GEMINI.md fino
- Se `GEMINI.md` tiver conteúdo próprio, reduza ao mesmo padrão de ponteiro do `CLAUDE.md` (após confirmar que o conteúdo já vive no `AGENTS.md`).

### 3d. Pastas e índice
- Crie as pastas faltantes com `.gitkeep`: `00 - INBOX/`, `07 - HANDOVERS/Arquivo/`, `07 - HANDOVERS/Tarefas/`, `07 - HANDOVERS/Tarefas/Arquivo/`.
- Se não houver `Memória/INDEX.md`, crie um índice base (cabeçalho + seção `## Fatos`), **sem** apagar fatos existentes.

### 3e. Marcador de versão
- Leia a versão atual do template (arquivo `VERSION` na raiz do repo do template, se acessível) e grave em `.claude/.brain-version`. Se não souber, escreva a versão alvo conhecida desta migração.

## 4. Verificação

Depois de aplicar, confira e reporte:
- `.claude/commands/` tem os commands esperados e `.claude/skills/` não existe mais;
- `AGENTS.md` existe e tem o conteúdo migrado; `CLAUDE.md`/`GEMINI.md` são ponteiros;
- nenhuma pasta de conteúdo (`Memória/`, projetos, handovers) foi alterada;
- `.claude/.brain-version` gravado.

## Resposta final

Resumo curto:

- o que foi movido/criado;
- o que foi preservado intacto;
- próximos passos: rode `update.sh` no terminal para sincronizar commands futuros; use `/handover_chat` e `/handon_chat` no dia a dia.
