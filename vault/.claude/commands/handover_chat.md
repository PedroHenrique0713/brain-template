---
description: Salva o progresso da sessão no estado e no log da tarefa (ou cria a tarefa, ou um snapshot geral) e regenera o ATIVAS.md
---

Salve um snapshot completo do que foi feito nesta sessão.

**Definições:**
- TODAY = data de hoje em `YYYY-MM-DD`
- HHMM / HH:MM = hora atual 24h (`1430` / `14:30`)
- Uma tarefa são **dois arquivos** lado a lado em `07 - HANDOVERS/Tarefas/`: o **estado** `T0XX - nome.md` (curto, reescrito a cada handover) e o **log** `T0XX - nome.log.md` (só acréscimo).

## Voz e tom

Escreva como se **o usuário tivesse escrito**, não uma IA: 1ª pessoa do passado ("fiz", "testei", "descobri"), sem voz passiva, sem gerúndio substantivado ("realização de"), sem narração de IA ("Procedeu-se a"). Tom direto, como quem conta pro time o que aconteceu.

---

## Passo 1 — Identificar o modo

Leia `07 - HANDOVERS/ATIVAS.md` (a lista das tarefas vivas com o próximo passo de cada uma).

- **Modo Tarefa:** a sessão começou com `/handon`, ou o que foi feito cabe numa tarefa viva. Sessão que tocou mais de uma tarefa escreve em cada uma. Em dúvida entre duas, pergunte.
- **Tarefa nova:** o trabalho vai continuar em outra sessão e não tem tarefa. Crie com o script, **nunca numerando à mão** (sessões paralelas repetem número):
  ```bash
  python3 "03 - RESOURCES/Scripts/nova-tarefa.py" "Título curto" "Projeto"
  ```
  Depois siga o Modo Tarefa.
- **Modo Geral:** só para sessão sem continuidade (planejamento, pergunta avulsa, exploração). Trabalho de um tema que tem tarefa **não** vira snapshot solto — senão o estado do tema fica espalhado e ninguém acha depois.

---

## Modo Tarefa

1. **Tarefa no formato antigo?** (sem o `.log.md` ao lado, ou com `## Log de sessões` dentro do estado) → migre antes: o `## Log de sessões` e tudo depois dele vão para o `.log.md`; seção datada solta vira entrada do log com a mesma data. **Mover, nunca apagar.**
2. **Estado** (`T0XX - nome.md`), reescrevendo em vez de acrescentar:
   - frontmatter: `atualizado:` → TODAY; `status:` ∈ `ativa` | `aguardando` (com `bloqueio:`) | `pausada` | `concluida` | `cancelada`;
   - `## 📍 Estado agora` e `## 🔜 Próximo passo` → substitua inteiros;
   - `## ✅ Feito (não refazer)` → uma linha por entrega; passando de ~15, condense (o detalhe está no log);
   - `## 🧭 Decisões técnicas` → acrescente, datadas e com o porquê;
   - `## ⚠️ Armadilhas` → acrescente as novas, tire as que deixaram de valer.
   Nada de seção nova datada no estado; alvo de até ~80 linhas. Próximo passo velho esquecido no meio do arquivo vira informação falsa.
3. **Log** (`T0XX - nome.log.md`): acrescente ao **final**:

```markdown
### {TODAY} — {HH:MM}

**Resumo:** <uma frase: o que foi feito — 1ª pessoa, sem jargão>

- <o que foi feito, específico: IDs, endpoints, valores, arquivos>
- <descobertas, erros, decisões>
- <o que ficou pendente>

**Status:** ativa | aguardando | pausada | concluida | cancelada
**Próximo:** <primeiro passo concreto da próxima sessão>
**Por:** Claude | Codex | Gemini | opencode
```

4. **Status virou `concluida` ou `cancelada`:** promova para `Memória/` o conhecimento durável que ainda não está lá e mova (`git mv`) os **dois** arquivos para `07 - HANDOVERS/Tarefas/Arquivo/`.
5. Regenere a lista: `python3 "03 - RESOURCES/Scripts/gerar-ativas.py"`.
6. Confirme com link markdown clicável para os arquivos.

### Checkpoint no meio da sessão

Em sessão longa, rode o handover **ao fechar cada frente ou antes de trocar de assunto**, não só no fim. Depois de uma compactação o detalhe (ID, número, o que estava errado antes) só existe na transcrição; o hook `SessionStart` "compact" deste vault lembra de fazer o checkpoint e aponta a transcrição completa.

---

## Modo Geral — snapshot

`07 - HANDOVERS/{TODAY} {HHMM} - Handover.md`, com as mesmas seções do estado de tarefa:

```markdown
---
date: {TODAY}
time: "{HH:MM}"
tags: [handover]
---

# Handover — {TODAY} {HH:MM}

## 🎯 Objetivo
## 📍 Estado agora
## ✅ Feito
## 🔜 Próximos passos
## 🧭 Decisões
## ⚠️ Armadilhas
## Arquivos/recursos relevantes
```

Depois, regenere o `ATIVAS.md` e confirme com link para o arquivo.

---

**Importante:** seja específico. "Configurar webhook" é ruim; "Configurar o webhook `X` apontando para `https://.../webhook/abc`" é bom. O handover só vale se a próxima sessão continuar sem reler o chat.
