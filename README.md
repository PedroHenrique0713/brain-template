# brain-template

Vault Obsidian + IA pronto para uso. Funciona com **Claude Code**, **Gemini CLI** e **opencode**.

Depois de instalar, rode `/init_newbrain` — ele faz ~30 perguntas e personaliza tudo automaticamente: `CLAUDE.md`, estrutura de pastas, memória inicial.

---

## Instalação rápida

```bash
git clone https://github.com/SEU_USUARIO/brain-template
cd brain-template
bash setup.sh
```

O script detecta quais ferramentas de IA você tem instaladas e configura tudo.

---

## O que está incluído

```
vault/
├── 01 - PROJECTS/       ← projetos ativos
├── 02 - AREAS/          ← saúde, finanças, estudos, hobbies...
├── 03 - RESOURCES/
│   └── Templates/       ← templates de projeto e diário
├── 04 - DIARY/          ← journaling diário
├── 05 - MEETINGS/       ← resumos de reuniões
├── 06 - KNOWLEDGE/      ← cursos, anotações de estudo
├── 07 - HANDOVERS/      ← snapshots de sessões IA
├── CLAUDE.md            ← contexto para Claude Code (gerado pelo /init_newbrain)
├── GEMINI.md            ← contexto para Gemini CLI (gerado pelo /init_newbrain)
└── .claude/
    └── skills/
        ├── init_newbrain.md    ← onboarding (~30 perguntas)
        ├── handover_chat.md    ← salva sessão atual
        ├── handon_chat.md      ← retoma sessão anterior
        └── vault_scan.md       ← cria referências cruzadas entre notas
```

---

## Skills disponíveis

| Skill | O que faz |
|---|---|
| `/init_newbrain` | Onboarding completo — personaliza vault, CLAUDE.md e memória |
| `/handover_chat` | Salva o progresso da sessão atual em `07 - HANDOVERS/` |
| `/handon_chat` | Lista sessões salvas ou retoma uma específica |
| `/vault_scan` | Varre arquivos novos e cria links entre notas relacionadas |

---

## Compatibilidade por ferramenta

| Ferramenta | Skills nativas | Contexto automático | Setup |
|---|---|---|---|
| **Claude Code** | `/init_newbrain` e outras via slash command | `CLAUDE.md` + memória `.claude/` | `claude` no terminal |
| **Gemini CLI** | Não tem slash commands — lê skills como prompt | `GEMINI.md` | `gemini` no terminal |
| **opencode** | Depende do provider configurado | `CLAUDE.md` via `.opencode/config.toml` | `opencode` no terminal |

---

## Requisitos

- [Obsidian](https://obsidian.md) — para visualizar o vault
- VS Code (recomendado) — para abrir o vault com IA integrada
- Uma das ferramentas de IA:
  - [Claude Code](https://claude.ai/code): `npm i -g @anthropic-ai/claude-code`
  - [Gemini CLI](https://ai.google.dev/gemini-api/docs/gemini-cli): `npm i -g @google/generative-ai-cli`
  - [opencode](https://opencode.ai): `npm i -g opencode-ai`

---

## Primeiro uso

1. `git clone` + `bash setup.sh`
2. Abra a pasta `vault/` no Obsidian como vault
3. Abra a pasta `vault/` no VS Code
4. Terminal: `claude` (ou `gemini`)
5. Digite `/init_newbrain` — siga o onboarding
6. Em ~5 minutos o vault estará configurado pro seu perfil
