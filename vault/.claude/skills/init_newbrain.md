# /init_newbrain

Onboarding interativo para personalizar este vault. Faça as perguntas em blocos, espere as respostas, depois gere os arquivos.

---

## Regras gerais

- Faça um bloco por vez. Não despeje todas as perguntas de uma vez.
- Após cada bloco, confirme o que entendeu antes de continuar.
- No final, gere os arquivos automaticamente sem pedir confirmação extra.
- Use o idioma que a pessoa responder nas perguntas.
- Se a pessoa pular uma pergunta, use um placeholder sensato.

---

## BLOCO 1 — Identidade (faça estas 5 perguntas juntas)

> "Vamos começar com o básico. Responde as 5 perguntas abaixo:"

1. Como devo te chamar? (nome ou apelido)
2. O que você faz? (profissão, função, área de atuação)
3. Qual o seu principal objetivo com este sistema? _(ex: organizar trabalho, aprender mais rápido, ter um segundo cérebro pessoal, tudo junto)_
4. Em que idioma prefere que eu responda? (Português / English / Español / outro)
5. Em uma escala de 1 a 5, quão confortável você é com tecnologia? _(1 = uso básico, 5 = developer/técnico)_

Salve internamente: `name`, `profession`, `goal`, `language`, `tech_level`.

---

## BLOCO 2 — Trabalho (faça estas 6 perguntas juntas)

> "Agora sobre seu trabalho:"

6. Você trabalha para uma empresa, é freelancer ou autônomo?
7. Se empresa: qual o nome e o que ela faz em uma linha? Se freelancer: que tipo de projeto você costuma pegar?
8. Qual é o seu papel principal no dia a dia?
9. Quais ferramentas você usa todo dia? _(liste as 3-5 principais: ex: Notion, Slack, VS Code, Figma...)_
10. Tem projetos ativos agora? Me dá até 3 nomes com uma linha de contexto cada.
11. Tem rotinas recorrentes? _(reuniões fixas, entregas semanais, rituais de trabalho)_

Salve internamente: `work_type`, `employer`, `role`, `tools[]`, `projects[]`, `routines[]`.

---

## BLOCO 3 — Vida pessoal (faça estas 5 perguntas juntas)

> "Agora além do trabalho:"

12. Quais áreas da sua vida você quer acompanhar aqui? _(marque quantas quiser: saúde, finanças, estudos, relacionamentos, hobbies, espiritualidade, outros)_
13. Você estuda ou faz cursos atualmente? O quê?
14. Tem projetos pessoais fora do trabalho? Me dá até 2.
15. Quer um espaço de diário/journaling aqui?
16. Tem alguma coisa que você explicitamente **não** quer que eu traga à tona ou acompanhe?

Salve internamente: `life_areas[]`, `studying`, `personal_projects[]`, `wants_diary`, `off_limits`.

---

## BLOCO 4 — Estilo de colaboração com IA (faça estas 7 perguntas juntas)

> "Agora vou entender como você prefere trabalhar comigo:"

17. Prefere respostas curtas e diretas ou detalhadas e bem explicadas?
18. Tom: formal, casual ou tanto faz?
19. Quer que eu seja proativo (sugira coisas sem ser pedido) ou reativo (só quando você pedir)?
20. No final de cada sessão, quer um resumo do que foi feito?
21. Quer que eu lembre contexto pessoal entre sessões (memórias automáticas)?
22. Prefere bullet lists ou texto corrido?
23. Tem algum assunto sensível que prefere não discutir comigo?

Salve internamente: `verbosity`, `tone`, `proactivity`, `session_summary`, `auto_memory`, `format_preference`, `sensitive_topics`.

---

## BLOCO 5 — Setup técnico (faça estas 4 perguntas juntas)

> "Últimas perguntas, sobre o setup:"

24. Qual(is) ferramenta(s) de IA vai usar com este vault? _(Claude Code / Gemini CLI / opencode / ainda não sei)_
25. Usa VS Code como editor principal?
26. Quais plugins do Obsidian você já usa ou quer usar? _(Dataview, Calendar, Templater, Tasks, nenhum, não sei...)_
27. Com que frequência você abre o vault? _(diariamente / algumas vezes por semana / quando preciso)_

Salve internamente: `ai_tools[]`, `uses_vscode`, `obsidian_plugins[]`, `vault_frequency`.

---

## GERAÇÃO DOS ARQUIVOS

Após coletar todos os blocos, execute **todos** os passos abaixo:

### 1. Sobrescrever `CLAUDE.md`

Gere um novo `CLAUDE.md` na raiz do vault com este formato (adapte ao perfil coletado):

```markdown
# Brain — {name}

## Quem sou

{profession}. {employer_context}. {goal_context}.
Nível técnico: {tech_level}/5.

---

## Projetos ativos

{para cada projeto em projects[]:}
| **{nome}** | {contexto} |

---

## Áreas de vida

{para cada área em life_areas[]:}
- {área}

---

## Como trabalhar comigo

- Idioma: {language}
- Tom: {tone}
- Verbosidade: {verbosity}
- Formato preferido: {format_preference}
- Proatividade: {proactivity}
- Resumo de sessão: {session_summary}
- Memória automática: {auto_memory}
{se sensitive_topics: - Evitar: {sensitive_topics}}

---

## Ferramentas do dia a dia

{tools[]}

---

## Plugins Obsidian

{obsidian_plugins[]}

---

## Skills disponíveis

| Skill | Uso |
|---|---|
| `/init_newbrain` | Refazer onboarding / atualizar perfil |
| `/handover_chat` | Salvar progresso da sessão |
| `/handon_chat` | Retomar tarefa ou listar sessões ativas |
| `/vault_scan` | Varrer arquivos novos e criar referências cruzadas |

---

## Guia de contexto

Sempre que precisar de contexto, siga esta ordem:
1. `CLAUDE.md` — identidade e projetos
2. `.claude/projects/.../memory/MEMORY.md` — memórias persistidas
3. `01 - PROJECTS/{projeto}.md` — detalhes de cada projeto
4. `07 - HANDOVERS/` — última sessão
5. `04 - DIARY/` — contexto do dia
```

### 2. Sobrescrever `GEMINI.md`

Mesmo conteúdo do CLAUDE.md, substituindo referências a `.claude/` por `.gemini/` e removendo a seção de skills (Gemini CLI não tem slash commands nativos).

### 3. Criar estrutura de pastas

- Para cada projeto em `projects[]`: criar `01 - PROJECTS/{nome}/` com um `{nome}.md` de contexto inicial.
- Para cada área em `life_areas[]`: criar `02 - AREAS/{área}/` com `.gitkeep`.
- Se `wants_diary == true`: criar `04 - DIARY/template-diario.md` com template de journaling.
- Se `studying != ""`: criar `06 - KNOWLEDGE/{curso ou tema}/` com nota inicial.

### 4. Criar memória inicial

Criar o arquivo de memória de perfil em `.claude/projects/{path_hash}/memory/` se possível, ou orientar o usuário a onde isso fica.

Crie um arquivo `user_profile.md` com:
```markdown
---
name: user-profile
description: Perfil do usuário — quem é, o que faz, como prefere colaborar
metadata:
  type: user
---

{name} — {profession} {employer_context}.
Nível técnico: {tech_level}/5. Idioma: {language}.
Tom preferido: {tone}. Verbosidade: {verbosity}.
Proatividade: {proactivity}. Formato: {format_preference}.
```

### 5. Confirmação final

Ao terminar, mostre um resumo do que foi criado/modificado e diga:
> "Vault configurado. Pode começar a usar. Se quiser ajustar algo, rode `/init_newbrain` de novo ou edite o `CLAUDE.md` diretamente."
