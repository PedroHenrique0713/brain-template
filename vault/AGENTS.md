# 🧠 AGENTS.md — Cérebro de [não configurado]

> **Arquivo canônico de contexto.** Vale para qualquer IA — Claude Code, Gemini CLI, opencode, modelos locais.
> `CLAUDE.md` e `GEMINI.md` são finos e apontam pra cá. Não duplique conteúdo neles.
>
> **Para configurar:** rode `/init_newbrain` no Claude Code — onboarding de ~27 perguntas.

---

## Quem sou

_Rode `/init_newbrain` para preencher._

---

## Projetos ativos

_Nenhum projeto cadastrado. Rode `/init_newbrain` ou crie pastas em `01 - PROJECTS/`._

---

## 🧠 Memória viva

Fatos duráveis ficam em `Memória/` — versionados em git, compartilhados entre todas as IAs.

| Tipo | O que é | Onde mora |
|---|---|---|
| **Semântica** | fatos, decisões, preferências estáveis | `Memória/` (1 fato/arquivo) + `Memória/INDEX.md` |
| **Episódica** | o que aconteceu numa sessão | `07 - HANDOVERS/` |
| **Procedural** | como fazer tarefas recorrentes | `.claude/commands/` |

### Como salvar um fato

1. **Cheque duplicata** — leia `Memória/INDEX.md`.
2. **Crie/edite** `Memória/<slug>.md`:
   ```markdown
   ---
   name: <slug-kebab>
   description: <resumo de 1 linha>
   type: project | feedback | user | reference
   updated: <YYYY-MM-DD>
   ---

   <o fato. Para project/feedback: **Why:** e **How to apply:**>
   ```
3. **Atualize** `Memória/INDEX.md` com uma linha: `- [Título](slug.md) — gancho de 1 linha`

**Não salve:** estrutura de código, histórico git, estado momentâneo ("pendente", "atualmente"), conteúdo já em fichas de projeto.

---

## Como trabalhar comigo

_Rode `/init_newbrain` para definir._

---

## Guia de navegação

1. **Geral (já carregado):** este `AGENTS.md` + `Memória/INDEX.md`
2. **Projeto específico:** `01 - PROJECTS/{projeto}/`
3. **Sessão anterior:** `07 - HANDOVERS/` (mais recente = mais relevante)
4. **Tarefas em progresso:** `07 - HANDOVERS/Tarefas/T0XX`
5. **Diário:** `04 - DIARY/`
6. **Reuniões:** `05 - MEETINGS/`

---

## Estrutura de pastas

```
00 - INBOX/         ← captura rápida / triagem
01 - PROJECTS/      ← projetos com objetivo e prazo definidos
02 - AREAS/         ← áreas de responsabilidade contínua
03 - RESOURCES/     ← templates, referências, materiais
  └── Templates/
04 - DIARY/         ← diário pessoal
05 - MEETINGS/      ← resumos de reuniões e calls
06 - KNOWLEDGE/     ← cursos, leituras, estudos
07 - HANDOVERS/     ← snapshots entre sessões
  ├── Tarefas/      ← tarefas longas (T001, T002...)
  └── Arquivo/      ← handovers e tarefas encerradas (> 21 dias)
Memória/            ← 🧠 memória semântica compartilhada
```

---

## Commands disponíveis

| Command | O que faz |
|---|---|
| `/init_newbrain` | Onboarding completo — personaliza todo o vault |
| `/handover_chat` | Salva o progresso da sessão atual |
| `/handon_chat` | Retoma uma tarefa ou lista handovers ativos |
| `/vault_scan` | Varre arquivos novos e cria referências cruzadas |
| `/vault_gc` | Manutenção semanal — arquiva handovers velhos, valida memória |
