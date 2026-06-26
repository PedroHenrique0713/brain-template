---
name: init_newbrain
description: Onboarding interativo que personaliza AGENTS.md, Memória/ e a estrutura inicial do vault
compatibility: Claude Code, Gemini CLI, opencode, modelos locais
---

# init_newbrain

Configura este vault para uma pessoa específica. Faça perguntas em blocos, espere as respostas, confirme o entendimento e só então gere os arquivos.

## Regras

- Use o idioma da pessoa.
- Faça um bloco por vez.
- Se a pessoa pular algo, use "a definir".
- Não escreva em `.claude/projects/.../memory/`; a memória canônica fica em `Memória/`.
- `AGENTS.md` é o arquivo canônico. `CLAUDE.md` e `GEMINI.md` devem continuar finos, apontando para `AGENTS.md`.

## Blocos de perguntas

### 1. Identidade

Pergunte:

1. Como devo te chamar?
2. O que você faz?
3. Qual é seu objetivo principal com este vault?
4. Em que idioma prefere que eu responda?
5. De 1 a 5, quão confortável você é com tecnologia?

### 2. Trabalho e projetos

Pergunte:

1. Você trabalha para empresa, é freelancer, estuda, ou combina mais de uma coisa?
2. Qual empresa/contexto principal e o que ela faz?
3. Qual é seu papel no dia a dia?
4. Quais ferramentas usa todo dia?
5. Quais projetos ativos quer acompanhar? Peça até 5 nomes com uma linha de contexto.
6. Existem rotinas recorrentes importantes?

### 3. Vida e conhecimento

Pergunte:

1. Quais áreas da vida quer acompanhar aqui?
2. Estuda algo atualmente?
3. Tem projetos pessoais?
4. Quer usar diário/journaling?
5. Existe algum assunto que não quer que a IA acompanhe?

### 4. Estilo de colaboração

Pergunte:

1. Prefere respostas curtas, balanceadas ou detalhadas?
2. Tom formal, casual ou direto?
3. Quer uma IA proativa, reativa ou equilibrada?
4. Quer resumo ao fim de cada sessão?
5. Quer memória entre conversas?
6. Algum tema sensível a evitar?

### 5. Setup técnico

Pergunte:

1. Vai usar Claude Code, Gemini CLI, opencode, ChatGPT/outro, ou várias ferramentas?
2. Usa VS Code?
3. Quais plugins Obsidian quer manter ou adicionar?
4. Com que frequência pretende abrir o vault?
5. Mais alguma coisa que a IA deve saber?

## Geração

Depois dos 5 blocos, faça:

1. Atualize `AGENTS.md` com:
   - quem é a pessoa;
   - projetos ativos;
   - áreas de vida;
   - estilo de colaboração;
   - ferramentas;
   - protocolo de memória e handoff preservado.
2. Garanta `CLAUDE.md` e `GEMINI.md` finos:
   ```markdown
   # CLAUDE.md

   Leia primeiro: `AGENTS.md`.

   `AGENTS.md` é o arquivo canônico de contexto deste vault.
   ```
3. Crie/atualize `Memória/user-profile.md`:
   ```markdown
   ---
   name: user-profile
   description: Perfil do usuário, trabalho e estilo de colaboração
   type: user
   scope: global
   updated: YYYY-MM-DD
   ---

   **Nome:** ...
   **Profissão/contexto:** ...
   **Objetivo do vault:** ...
   **Idioma:** ...
   **Nível técnico:** ...

   **Como colaborar:**
   - Tom: ...
   - Verbosidade: ...
   - Proatividade: ...
   - Resumo de sessão: ...
   - Memória entre conversas: ...
   ```
4. Atualize `Memória/INDEX.md`:
   ```markdown
   - [Perfil do usuário](user-profile.md) — `global` — identidade, trabalho e estilo de colaboração
   ```
5. Crie pastas de projetos em `01 - PROJECTS/`, áreas em `02 - AREAS/` e estudos em `06 - KNOWLEDGE/`, conforme respostas.
6. Crie notas iniciais de projeto usando `03 - RESOURCES/Templates/projeto-template.md` quando fizer sentido.

## Resposta final

Informe de forma curta:

- arquivos atualizados;
- pastas criadas;
- memória inicial criada;
- próximo uso sugerido: `/handover_chat` ao fim da sessão e `/handon_chat` para retomar.
