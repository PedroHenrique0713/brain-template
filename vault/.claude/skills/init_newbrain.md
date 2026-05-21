---
name: init_newbrain
description: Onboarding interativo de ~27 perguntas que personaliza o vault inteiro — gera CLAUDE.md, GEMINI.md, estrutura de pastas e memória inicial
compatibility: Claude Code, Gemini CLI, opencode, modelos locais
---

# init_newbrain

Configura este vault para uma pessoa específica. Faz perguntas em blocos, depois gera os arquivos automaticamente.

---

## O que este skill faz

1. Faz ~27 perguntas organizadas em 5 blocos
2. Gera um `CLAUDE.md` e `GEMINI.md` personalizados na raiz do vault
3. Cria pastas de projetos e áreas com base nas respostas
4. Cria um arquivo de memória de perfil em `.claude/projects/*/memory/user_profile.md`
5. Confirma tudo ao final

---

## Regras importantes (leia antes de começar)

- **Faça um bloco por vez.** Não despeje todas as perguntas de uma vez.
- **Espere as respostas** antes de continuar para o próximo bloco.
- **Confirme o que entendeu** após cada bloco com um breve resumo.
- **Se a pessoa pular uma pergunta**, use um placeholder sensato (ex: "a definir").
- **Use o idioma que a pessoa responder.** Se ela responder em português, continue em português.
- **No final, gere os arquivos sem pedir confirmação extra** — só mostre o que foi criado.

---

## BLOCO 1 — Identidade

> Diga isso para a pessoa: *"Vamos começar. Responde estas 5 perguntas:"*

**Pergunta 1.** Como devo te chamar? (nome ou apelido)
**Pergunta 2.** O que você faz? (profissão, função ou área de atuação — pode ser curto)
**Pergunta 3.** Qual o seu principal objetivo com este sistema? Escolha o que mais se encaixa:
  - (A) Organizar meu trabalho e projetos
  - (B) Aprender e guardar conhecimento
  - (C) Ter um diário / espaço pessoal
  - (D) Tudo junto / outro

**Pergunta 4.** Em que idioma prefere que eu responda? (Português / English / Español / outro)

**Pergunta 5.** De 1 a 5, quão confortável você é com tecnologia?
  - 1 = uso básico (WhatsApp, Google)
  - 3 = uso bem o computador mas não programo
  - 5 = developer / técnico

> Após receber as respostas, confirme: *"Entendido — você é [nome], [profissão], objetivo: [objetivo]. Vamos continuar."*

**Salve internamente:** `name`, `profession`, `goal`, `language`, `tech_level`

---

## BLOCO 2 — Trabalho

> Diga: *"Agora sobre seu trabalho ou projetos:"*

**Pergunta 6.** Você trabalha para uma empresa, é freelancer ou as duas coisas?

**Pergunta 7.** Se empresa: qual o nome e o que ela faz em uma linha?
  Se freelancer: que tipo de trabalho você costuma fazer?
  Se nenhum dos dois: pode pular.

**Pergunta 8.** Qual é o seu papel principal no dia a dia? (ex: designer, gerente de projeto, estudante, dona de casa, etc.)

**Pergunta 9.** Quais ferramentas ou apps você usa todo dia no trabalho? Liste até 5.
  (ex: Notion, WhatsApp, Instagram, Canva, Google Sheets...)

**Pergunta 10.** Tem projetos ativos agora que quer acompanhar aqui?
  Se sim, me dá até **3 nomes** e uma frase de contexto para cada.
  Se não, tudo bem — pode pular.

**Pergunta 11.** Tem rotinas recorrentes? (ex: reunião toda segunda, relatório toda sexta, aula toda terça)
  Se não tiver, pode pular.

> Confirme: *"Certo, trabalho em [empresa/freelance], papel: [papel], projetos ativos: [lista]."*

**Salve internamente:** `work_type`, `employer`, `role`, `tools[]`, `projects[]`, `routines[]`

---

## BLOCO 3 — Vida pessoal

> Diga: *"Agora além do trabalho:"*

**Pergunta 12.** Quais áreas da sua vida você quer acompanhar aqui? Pode marcar várias:
  - Saúde e corpo
  - Finanças pessoais
  - Estudos e cursos
  - Relacionamentos
  - Hobbies
  - Espiritualidade / bem-estar
  - Nenhuma (só quero usar para trabalho)

**Pergunta 13.** Você estuda ou faz algum curso atualmente? Se sim, o quê?

**Pergunta 14.** Tem projetos pessoais fora do trabalho? (ex: blog, canal, hobby, empreendimento pessoal)
  Me dá até 2 com uma linha de contexto.

**Pergunta 15.** Quer ter um espaço de diário / journaling aqui? (Sim / Não / Talvez)

**Pergunta 16.** Tem alguma coisa que você **não** quer que eu traga à tona ou acompanhe?
  (ex: "não me lembre de finanças", "não quero falar sobre trabalho aos fins de semana")

> Confirme: *"Anotado — áreas de vida: [lista], diário: [sim/não]."*

**Salve internamente:** `life_areas[]`, `studying`, `personal_projects[]`, `wants_diary`, `off_limits`

---

## BLOCO 4 — Como prefere trabalhar comigo

> Diga: *"Agora vou entender como você gosta de trabalhar com IA:"*

**Pergunta 17.** Prefere respostas:
  - (A) Curtas e diretas — só o essencial
  - (B) Balanceadas — explico quando necessário
  - (C) Detalhadas — gosto de entender o porquê de tudo

**Pergunta 18.** Tom preferido:
  - (A) Formal e profissional
  - (B) Casual e amigável
  - (C) Tanto faz

**Pergunta 19.** Quero que eu seja:
  - (A) Proativo — sugiro coisas mesmo sem você pedir
  - (B) Reativo — só respondo quando você pedir
  - (C) Equilibrado

**Pergunta 20.** No final de cada sessão de trabalho, quer um resumo do que foi feito? (Sim / Não)

**Pergunta 21.** Quer que eu lembre contexto pessoal entre conversas?
  Por exemplo: se você me contar que está passando por algo difícil hoje, quero levar em conta da próxima vez. (Sim / Não)

**Pergunta 22.** Tem algum assunto sensível que prefere não discutir comigo? (opcional — pode pular)

> Confirme: *"Entendido — tom [tom], verbosidade [verbosidade], proatividade [proatividade]."*

**Salve internamente:** `verbosity`, `tone`, `proactivity`, `session_summary`, `auto_memory`, `sensitive_topics`

---

## BLOCO 5 — Setup técnico

> Diga: *"Últimas perguntas — sobre as ferramentas:"*

**Pergunta 23.** Qual ferramenta de IA você vai usar com este vault?
  - (A) Claude Code (Anthropic)
  - (B) Gemini CLI (Google)
  - (C) opencode ou outro modelo local
  - (D) Não sei ainda / quero usar mais de uma

**Pergunta 24.** Você usa VS Code como editor de código/texto?

**Pergunta 25.** Quais plugins do Obsidian você já usa ou quer usar?
  Os que já vêm instalados neste vault são: **Dataview, Templater, Calendar, Periodic Notes, Obsidian Git**.
  Tem algum outro que você usa?

**Pergunta 26.** Com que frequência você abre este vault?
  - (A) Todo dia
  - (B) Algumas vezes por semana
  - (C) Quando preciso / sem rotina

**Pergunta 27.** Mais alguma coisa que você quer que eu saiba sobre você ou sobre como você quer usar este sistema?

> Confirme: *"Perfeito! Agora vou configurar tudo."*

**Salve internamente:** `ai_tools[]`, `uses_vscode`, `extra_plugins`, `vault_frequency`, `extra_notes`

---

## GERAÇÃO DOS ARQUIVOS

Após coletar todos os 5 blocos, execute os passos abaixo em ordem.

### Passo 1 — Sobrescrever `CLAUDE.md`

Escreva um novo arquivo em `CLAUDE.md` na raiz do vault. Use o template abaixo, preenchendo com os dados coletados. Adapte o texto para soar natural — não copie os placeholders literalmente.

```
# Cérebro — {name}

## Quem sou

{profession}. {Se tiver employer: "Trabalho na/para {employer}."} {goal em forma de frase natural.}
Nível técnico: {tech_level}/5.

---

## Projetos ativos

{Se tiver projects[]:}
| Projeto | Contexto |
|---|---|
{Para cada projeto: | **{nome}** | {contexto} |}

{Se não tiver projetos: "_Nenhum cadastrado. Adicione projetos em `01 - PROJECTS/`._"}

---

## Áreas de vida

{Se tiver life_areas[]:}
{Para cada área: "- {área}"}

{Se não tiver: "_Só uso profissional._"}

---

## Como trabalhar comigo

- **Idioma:** {language}
- **Tom:** {tone}
- **Verbosidade:** {verbosity}
- **Proatividade:** {proactivity}
- **Resumo de sessão:** {session_summary}
- **Memória entre conversas:** {auto_memory}
{Se tiver off_limits: "- **Evitar:** {off_limits}"}
{Se tiver sensitive_topics: "- **Não discutir:** {sensitive_topics}"}

---

## Ferramentas do dia a dia

{tools[] em formato de lista}

---

## Skills disponíveis

| Skill | O que faz |
|---|---|
| `/init_newbrain` | Refazer o onboarding / atualizar este perfil |
| `/handover_chat` | Salvar o progresso da sessão atual |
| `/handon_chat` | Retomar uma sessão anterior |
| `/vault_scan` | Varrer arquivos novos e criar referências cruzadas |

---

## Guia de contexto (para a IA)

Ao iniciar uma sessão, leia na ordem:
1. `CLAUDE.md` — este arquivo
2. `.claude/projects/.../memory/MEMORY.md` — memórias persistidas
3. `01 - PROJECTS/{projeto}/` — detalhes de cada projeto ativo
4. `07 - HANDOVERS/` — última sessão salva (mais recente primeiro)
5. `04 - DIARY/` — contexto do dia atual
```

### Passo 2 — Sobrescrever `GEMINI.md`

Escreva um novo arquivo em `GEMINI.md` com o mesmo conteúdo do CLAUDE.md, mas:
- Substitua referências a `.claude/` por `.gemini/`
- Remova a seção "Skills disponíveis" (Gemini CLI não tem slash commands nativos)
- Adicione ao final:

```
## Nota para o Gemini CLI

Este vault não tem slash commands nativos. Para usar as skills:
- Leia o arquivo `.claude/skills/{nome-da-skill}.md`
- Siga as instruções descritas lá

Skills disponíveis:
- `.claude/skills/handover_chat.md` — salvar sessão
- `.claude/skills/handon_chat.md` — retomar sessão
- `.claude/skills/vault_scan.md` — varrer arquivos novos
- `.claude/skills/init_newbrain.md` — refazer onboarding
```

### Passo 3 — Criar estrutura de pastas

Execute os comandos abaixo conforme os dados coletados:

**Para cada projeto em `projects[]`:**
```bash
mkdir -p "01 - PROJECTS/{nome-do-projeto}"
```
Depois crie `01 - PROJECTS/{nome-do-projeto}/{nome-do-projeto}.md` com o template de projeto (está em `03 - RESOURCES/Templates/projeto-template.md`). Preencha o "Contexto" com a frase que a pessoa deu.

**Para cada área em `life_areas[]`:**
```bash
mkdir -p "02 - AREAS/{nome-da-area}"
```

**Se `wants_diary == true` ou `wants_diary == "Sim"`:**
Copie o template `03 - RESOURCES/Templates/diario-template.md` para `04 - DIARY/diario-template.md`.

**Se `studying != ""` e não estiver vazio:**
```bash
mkdir -p "06 - KNOWLEDGE/{tema-do-estudo}"
```
Crie `06 - KNOWLEDGE/{tema-do-estudo}/index.md` com uma nota inicial simples.

**Se tiver projetos pessoais em `personal_projects[]`:**
```bash
mkdir -p "01 - PROJECTS/{nome-projeto-pessoal}"
```

### Passo 4 — Criar memória de perfil

Tente criar o arquivo de memória em:
`.claude/projects/{nome-hash-do-caminho}/memory/user_profile.md`

Se não souber o path hash exato, crie em:
`.claude/memory/user_profile.md`

Conteúdo do arquivo:

```markdown
---
name: user-profile
description: Perfil do usuário — identidade, trabalho, estilo de colaboração
metadata:
  type: user
---

**Nome:** {name}
**Profissão:** {profession}
**Empresa/contexto:** {employer ou "independente"}
**Objetivo principal:** {goal}
**Nível técnico:** {tech_level}/5
**Idioma preferido:** {language}

**Estilo de colaboração:**
- Tom: {tone}
- Verbosidade: {verbosity}
- Proatividade: {proactivity}
- Resumo de sessão: {session_summary}
- Memória automática: {auto_memory}

**Ferramentas do dia a dia:** {tools[]}
**Frequência de uso do vault:** {vault_frequency}

{Se tiver off_limits: "**Evitar trazer à tona:** {off_limits}"}
{Se tiver extra_notes: "**Notas adicionais:** {extra_notes}"}
```

Também crie ou atualize o arquivo de índice `.claude/memory/MEMORY.md` com:

```markdown
# Memory Index

- [Perfil do usuário](user_profile.md) — {name}, {profession}, estilo de colaboração
```

### Passo 5 — Mensagem final

Após criar tudo, mostre este resumo:

```
Vault configurado para {name}.

Arquivos gerados:
✓ CLAUDE.md — perfil personalizado
✓ GEMINI.md — equivalente para Gemini CLI
✓ {n} pastas criadas em 01 - PROJECTS/
✓ {n} pastas criadas em 02 - AREAS/
✓ .claude/memory/user_profile.md — memória de perfil

Próximos passos sugeridos:
→ Abra o vault no Obsidian e explore as pastas
→ Crie sua primeira nota em 04 - DIARY/ com /nova_nota ou abrindo o calendário
→ Quando terminar uma sessão de trabalho, use /handover_chat para salvar o contexto

Para atualizar seu perfil, rode /init_newbrain novamente.
```
