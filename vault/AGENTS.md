# 🧠 AGENTS.md — Cérebro de [não configurado]

> **Arquivo canônico de contexto.** Vale para qualquer IA — Claude Code, Codex, Gemini CLI, opencode, modelos locais.
> `CLAUDE.md` e `GEMINI.md` são finos e apontam pra cá. Não duplique conteúdo neles.
> **Como trabalhar** (raciocínio → código → verificação): [GUARDRAILS.md](GUARDRAILS.md).
>
> **Para configurar:** rode `/init_newbrain` no Claude Code — onboarding de ~27 perguntas.
>
> **Leia primeiro:** este arquivo + `Memória/INDEX.md` + `07 - HANDOVERS/ATIVAS.md` se for continuar um trabalho. Depois navegue sob demanda (economia de tokens).

---

## Quem sou

_Rode `/init_newbrain` para preencher._

---

## Projetos ativos

_Nenhum projeto cadastrado. Rode `/init_newbrain` ou crie pastas em `01 - PROJECTS/`._

---

## 🧠 Memória viva

O vault é a memória persistente entre sessões **e entre ferramentas**. Toda IA lê e escreve no **mesmo** padrão.

| Tipo | O que é | Onde mora |
|---|---|---|
| **Semântica** | fatos, decisões, preferências estáveis | `Memória/` (1 fato/arquivo) + `Memória/INDEX.md` |
| **Episódica** | o que aconteceu numa sessão | `07 - HANDOVERS/` (tarefas e snapshots) |
| **Procedural** | como fazer tarefas recorrentes | `.claude/commands/` |

### Como salvar um fato

1. **Cheque duplicata** — leia `Memória/INDEX.md`. Já existe fato do tema? **Edite** o arquivo dele.
2. **Crie/edite** `Memória/<slug>.md`:
   ```markdown
   ---
   name: <slug-kebab>
   description: <resumo de 1 linha — usado no recall>
   type: project | feedback | user | reference
   scope: <projeto | global | feedback>
   updated: <YYYY-MM-DD>
   ---

   <o fato. Para project/feedback: **Why:** e **How to apply:**>
   ```
3. **Atualize o índice** com **uma linha**, que é **gancho, não resumo** (teto de ~320 caracteres): `- [Título](slug.md) — \`scope\` — gancho`. O INDEX é carregado inteiro em toda sessão: causa, medição e data moram no arquivo do fato, nunca aqui.
4. **Gancho buscável:** a `description` e a linha do INDEX levam as palavras que uma busca futura usaria — sintoma, apelido, mensagem de erro, ID.
5. **Não salve** estrutura de código, histórico git, conteúdo de fichas, nem estado momentâneo ("pendente", "atualmente", "por enquanto") — isso é handoff. Fato com prazo leva `review: YYYY-MM-DD`.
6. **Fato que muda = invalidação explícita:** registre no corpo "⚠️ até YYYY-MM-DD valia X; substituído por Y (motivo)" e mantenha por um ciclo do `/vault_gc`. Edição silenciosa deixa cópia velha virando anti-fato em outro lugar.
7. **Sem tempo?** Uma linha em `Memória/STAGING.md` com data e escopo; o `/vault_gc` tritura.
8. **Quando o INDEX engordar:** lição técnica genérica e fatos de um projeto só podem sair do INDEX para uma **skill** (`~/.claude/skills/<nome>/SKILL.md`), que carrega quando o trabalho toca o tema. O arquivo do fato continua em `Memória/`; só a linha de gancho muda de lugar, e o INDEX ganha uma linha apontando a skill.

---

## 🔄 Continuidade entre IAs e sessões (handoff)

Começar um esforço numa IA e continuar em outra, ou dias depois, sem perder o que foi feito e decidido. O estado vivo mora em **arquivo**, nunca só no chat.

- **Tarefa** = dois arquivos em `07 - HANDOVERS/Tarefas/`: o **estado** `T0XX - nome.md` (curto, reescrito a cada handover) e o **log** `T0XX - nome.log.md` (só acréscimo, uma entrada por sessão). Estado e log no mesmo arquivo viram diário de centenas de KB, com "próximo passo" velho esquecido no meio.
- **Tarefa nova:** `python3 "03 - RESOURCES/Scripts/nova-tarefa.py" "Título" "Projeto"` — o ID sai sob trava, e duas sessões paralelas não repetem número.
- **`status:`** ∈ `ativa` | `aguardando` (com `bloqueio:`) | `pausada` | `concluida` | `cancelada`.
- **Porta de entrada:** `07 - HANDOVERS/ATIVAS.md`, gerado por `gerar-ativas.py` — toda tarefa viva com status, última atualização e próximo passo; ⚠️ marca a viva parada há mais de 21 dias.
- **Snapshot geral** `07 - HANDOVERS/{data} {HHMM} - Handover.md`: só para sessão sem continuidade. Trabalho de um tema que tem tarefa escreve na tarefa.
- **Repo de código:** `HANDOFF.md` na raiz (template em `03 - RESOURCES/Templates/HANDOFF.template.md`).

**Estrutura** (a mesma no estado da tarefa, no snapshot e no `HANDOFF.md`): 🎯 Objetivo · 📍 Estado agora · 🔜 Próximo passo · ✅ Feito (não refazer) · 🧭 Decisões técnicas (só acréscimo, datadas, **com o porquê**) · ⚠️ Armadilhas.

**Protocolo:**
1. **Ao iniciar** num esforço em andamento: leia o estado da tarefa (`/handon_chat`) antes de agir.
2. **Ao decidir** algo relevante: registre na hora em Decisões técnicas.
3. **Ao fechar uma frente, ao terminar ou antes de trocar de IA:** `/handover_chat` — reescreve o estado, acrescenta a entrada no log (`**Por:** Claude | Codex | …`) e regenera o `ATIVAS.md`. Sessão longa faz checkpoint no meio: handover escrito depois de uma compactação sai do resumo, que é raso. O hook `SessionStart` "compact" deste vault lembra disso.
4. **Esforço concluído:** o durável sobe para `Memória/`; os dois arquivos vão para `Tarefas/Arquivo/` (arquivar é mover, nunca apagar).

---

## Como trabalhar comigo

_Rode `/init_newbrain` para definir._

---

## Guia de navegação

1. **Geral (já carregado):** este `AGENTS.md` + `GUARDRAILS.md` + `Memória/INDEX.md`
2. **Trabalho em andamento:** `07 - HANDOVERS/ATIVAS.md` → o estado da tarefa
3. **Projeto específico:** `01 - PROJECTS/{projeto}/`
4. **Diário:** `04 - DIARY/`
5. **Reuniões:** `05 - MEETINGS/`

---

## Estrutura de pastas

```
00 - INBOX/         ← captura rápida / triagem
01 - PROJECTS/      ← projetos com objetivo e prazo definidos
02 - AREAS/         ← áreas de responsabilidade contínua
03 - RESOURCES/     ← templates, scripts, referências
  ├── Templates/
  └── Scripts/      ← nova-tarefa.py, gerar-ativas.py
04 - DIARY/         ← diário pessoal
05 - MEETINGS/      ← resumos de reuniões e calls
06 - KNOWLEDGE/     ← cursos, leituras, estudos
07 - HANDOVERS/     ← ATIVAS.md (gerado) e snapshots entre sessões
  ├── Tarefas/      ← T0XX estado + T0XX .log.md
  └── Arquivo/      ← handovers e tarefas encerradas
Memória/            ← 🧠 memória semântica (fatos + INDEX.md + STAGING.md)
```

---

## Commands disponíveis

| Command | O que faz |
|---|---|
| `/init_newbrain` | Onboarding completo — personaliza todo o vault |
| `/handover_chat` | Salva o progresso: estado e log da tarefa (ou cria a tarefa, ou um snapshot) |
| `/handon_chat` | Retoma uma tarefa ou lista as vivas pelo `ATIVAS.md` |
| `/vault_scan` | Varre arquivos novos e cria referências cruzadas |
| `/vault_gc` | Manutenção semanal — tritura o STAGING, arquiva, lista tarefas paradas, valida a memória |
| `/update_brain` | Migra um vault de versão anterior para a estrutura atual |
