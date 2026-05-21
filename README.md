# brain-template

Vault Obsidian pronto para uso com IA. Funciona com **Claude Code**, **Gemini CLI**, **opencode** e modelos locais.

Depois de instalar, rode `/init_newbrain` — ele faz ~27 perguntas e configura tudo: perfil, pastas, CLAUDE.md e memória inicial.

---

## Instalação

### 1. Pré-requisitos

- [Obsidian](https://obsidian.md/download) — baixe e instale
- Git — verifique se já tem: abra o terminal e digite `git --version`
  - Linux: `sudo apt install git`
  - Mac: já vem instalado (ou instale com `xcode-select --install`)
  - Windows: baixe em [git-scm.com](https://git-scm.com/download/win)

### 2. Clonar e instalar

Abra o terminal e cole este comando:

```bash
git clone https://github.com/PedroHenrique0713/brain-template && cd brain-template && bash setup.sh
```

O script vai:
- Baixar os plugins do Obsidian automaticamente
- Perguntar qual ferramenta de IA você vai usar
- Verificar se as ferramentas estão instaladas
- Mostrar os próximos passos

### 3. Abrir no Obsidian

1. Abra o Obsidian
2. Clique em **"Abrir pasta como vault"**
3. Selecione a pasta `brain-template/vault/`
4. Quando perguntar sobre plugins: clique em **"Confiar no autor e habilitar plugins"**

### 4. Rodar o onboarding

Com Claude Code:
```bash
cd brain-template/vault
claude
```
Depois: `/init_newbrain`

Com Gemini CLI:
```bash
cd brain-template/vault
gemini
```
Depois: *"Leia o arquivo .claude/skills/init_newbrain.md e siga as instruções"*

---

## O que está incluído

### Plugins Obsidian (instalados automaticamente)

| Plugin | O que faz |
|---|---|
| **Dataview** | Transforma suas notas em banco de dados — crie listas e tabelas dinâmicas |
| **Templater** | Templates com variáveis — cria notas de projetos, reuniões e diário com um clique |
| **Calendar** | Calendário visual na barra lateral — clique em qualquer dia para abrir/criar o diário |
| **Periodic Notes** | Integra o calendário com seus diários diários e semanais |
| **Obsidian Git** | Backup automático do vault para o GitHub — nunca perca uma nota |

### Skills de IA

| Skill | O que faz |
|---|---|
| `/init_newbrain` | Onboarding completo — faz ~27 perguntas e personaliza o vault para você |
| `/handover_chat` | Salva o progresso da sessão atual para retomar depois |
| `/handon_chat` | Lista sessões salvas ou retoma uma sessão específica |
| `/vault_scan` | Varre notas novas e cria links entre notas relacionadas automaticamente |

### Estrutura de pastas

```
vault/
├── 01 - PROJECTS/     ← projetos com objetivo e prazo definidos
├── 02 - AREAS/        ← áreas de vida (saúde, finanças, estudos...)
├── 03 - RESOURCES/    ← templates e materiais de apoio
│   └── Templates/     ← diário, projeto (usados pelo Templater)
├── 04 - DIARY/        ← diário pessoal / journaling
├── 05 - MEETINGS/     ← resumos de reuniões e calls
├── 06 - KNOWLEDGE/    ← cursos, leituras, anotações de estudo
├── 07 - HANDOVERS/    ← snapshots de sessões IA (para continuidade)
├── CLAUDE.md          ← contexto para Claude Code (gerado pelo /init_newbrain)
└── GEMINI.md          ← contexto para Gemini CLI
```

---

## Compatibilidade

| Ferramenta | Skills | Contexto automático |
|---|---|---|
| **Claude Code** | `/init_newbrain` e mais via slash command | `CLAUDE.md` carregado automaticamente |
| **Gemini CLI** | Via prompt manual (sem slash commands) | `GEMINI.md` carregado automaticamente |
| **opencode** | Via `.opencode/config.toml` | `CLAUDE.md` como system prompt |
| **Modelos locais** | Skills são texto puro — funciona com qualquer modelo | Cole o CLAUDE.md como contexto |

---

## Como fazer backup do vault com o Obsidian Git

1. Crie um repositório **privado** no GitHub para seu vault pessoal
2. No terminal, dentro da pasta `vault/`:
   ```bash
   git init
   git remote add origin https://github.com/SEU_USUARIO/meu-vault.git
   git add . && git commit -m "primeiro backup"
   git push -u origin main
   ```
3. No Obsidian: **Settings → Obsidian Git** → configure o intervalo de backup automático

---

## Dúvidas frequentes

**Preciso saber programar para usar isso?**
Não. O único comando técnico é o da instalação. Depois, tudo é feito pelo Obsidian e pela IA.

**Funciona no celular?**
O vault Obsidian funciona no celular via Obsidian Mobile. As skills de IA requerem o app no computador.

**Posso usar com ChatGPT ou outro modelo?**
Sim. Cole o conteúdo do `CLAUDE.md` como system prompt em qualquer modelo. As skills também são texto puro — cole o conteúdo da skill desejada como instrução.

**Como atualizo meu perfil depois do onboarding?**
Rode `/init_newbrain` de novo ou edite o `CLAUDE.md` diretamente.
