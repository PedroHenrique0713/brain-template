---
name: vault_scan
description: Varre arquivos novos ou modificados no vault e cria referências cruzadas entre notas relacionadas
compatibility: Claude Code, Gemini CLI, opencode, modelos locais
---

# vault_scan

Encontra arquivos criados ou modificados recentemente no vault, identifica relações entre eles e adiciona links do tipo `[[nome-da-nota]]` para conectar notas relacionadas.

---

## O que este skill faz

1. Lista arquivos `.md` novos ou modificados recentemente
2. Lê o conteúdo de cada um
3. Identifica menções a projetos, pessoas, ferramentas, conceitos e temas
4. Verifica se existe outra nota no vault sobre essas entidades
5. Adiciona seção `## Referências` com links `[[nome-da-nota]]` nas notas relevantes
6. Relata o que foi feito

---

## Passo a passo

### Passo 1 — Encontrar arquivos recentes

Execute para ver arquivos modificados nos últimos 7 dias:

```bash
find . -name "*.md" \
  -not -path "./.obsidian/*" \
  -not -path "./.claude/*" \
  -not -path "./.gemini/*" \
  -not -path "./.opencode/*" \
  -not -path "./07 - HANDOVERS/*" \
  -not -name "CLAUDE.md" \
  -not -name "GEMINI.md" \
  -newer "07 - HANDOVERS/.gitkeep" \
  -type f | sort
```

Se quiser verificar todos os arquivos (não só os recentes), remova o `-newer` do comando.

Se não tiver acesso ao terminal, liste manualmente os arquivos relevantes que foram criados ou modificados.

### Passo 2 — Para cada arquivo encontrado, extraia as entidades

Leia o arquivo e identifique:

- **Nomes de projetos** mencionados (ex: "Projeto X", "App Y", nomes próprios de iniciativas)
- **Nomes de pessoas** (ex: "João me pediu", "falar com Maria")
- **Ferramentas e tecnologias** (ex: n8n, Supabase, Figma, React)
- **Temas ou conceitos** (ex: "marketing de conteúdo", "gestão financeira")
- **Empresas ou clientes** mencionados

### Passo 3 — Verificar se existe nota correspondente

Para cada entidade identificada, verifique se existe um arquivo `.md` no vault com nome parecido:

```bash
find . -name "*.md" | grep -i "{nome-da-entidade}"
```

**Exemplos de match:**
- Arquivo menciona "fluxo de vendas" → existe `01 - PROJECTS/Empresa X/fluxo-de-vendas.md`? → link!
- Arquivo menciona "João" → existe `Pessoas/Joao.md`? → link!
- Arquivo menciona "n8n" → existe `02 - AREAS/Ferramentas/n8n.md`? → link!

Ignore correspondências óbvias ou irrelevantes (ex: não adicione link para "o", "a", "de").

### Passo 4 — Adicionar seção de referências

Para cada arquivo que tem correspondências:

1. Verifique se o arquivo já tem uma seção `## Referências` no final
2. Se **não tiver**: adicione ao final do arquivo:

```markdown

---

## Referências

- [[nome-da-nota-encontrada]]
- [[outra-nota-encontrada]]
```

3. Se **já tiver**: adicione os novos links que ainda não estão listados, sem duplicar.

4. Não adicione um link se a nota já referencia a outra diretamente no texto com `[[...]]`.

### Passo 5 — Relatório final

Após processar todos os arquivos, mostre:

```
Vault scan concluído.

Arquivos analisados: {n}
Referências cruzadas adicionadas: {n}
  - {arquivo1.md} → links adicionados: [[nota1]], [[nota2]]
  - {arquivo2.md} → links adicionados: [[nota3]]

Arquivos sem novas referências: {n}
  (nenhuma nota relacionada encontrada no vault)
```

Se nenhum arquivo novo for encontrado:
```
Nenhum arquivo novo ou modificado encontrado desde a última análise.
O vault está atualizado.
```

---

## Notas para modelos com capacidades limitadas

Se você não conseguir executar comandos bash:
1. Peça ao usuário para listar os arquivos novos
2. Peça para colar o conteúdo de cada arquivo na conversa
3. Faça a análise de entidades manualmente
4. Mostre ao usuário exatamente o texto que precisa ser adicionado em cada arquivo

Se o vault for muito grande (mais de 100 arquivos), processe uma pasta por vez. Comece por `01 - PROJECTS/` que costuma ter as notas mais interconectadas.

---

## Exemplo

**Usuário diz:** `/vault_scan`

**Você encontra:** `01 - PROJECTS/App de Vendas/reuniao-kickoff.md` — arquivo novo

**Conteúdo menciona:** "João vai cuidar do backend", "usaremos Supabase", "prazo: julho"

**Você verifica:** existe `Pessoas/Joao.md`? Sim. Existe `02 - AREAS/Ferramentas/Supabase.md`? Sim.

**Você adiciona** ao final de `reuniao-kickoff.md`:
```markdown
## Referências

- [[Joao]]
- [[Supabase]]
```

**Você reporta:** "1 arquivo analisado, 2 referências adicionadas."
