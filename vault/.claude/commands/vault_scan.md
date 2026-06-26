---
name: vault_scan
description: Varre notas novas/modificadas e adiciona referências cruzadas úteis
compatibility: Claude Code, Gemini CLI, opencode, modelos locais
---

# vault_scan

Use quando o vault ganhou notas novas e precisa de links entre projetos, pessoas, empresas, áreas e conceitos.

## Passos

1. Liste arquivos `.md` recentes, ignorando pastas técnicas:
   ```bash
   find . -name "*.md" \
     -not -path "./.obsidian/*" \
     -not -path "./.claude/*" \
     -not -path "./.opencode/*" \
     -not -path "./.git/*" \
     -not -path "./07 - HANDOVERS/Arquivo/*" \
     -type f | sort
   ```
2. Leia apenas os arquivos relevantes para a tarefa.
3. Extraia entidades: projetos, pessoas, empresas, ferramentas, clientes, temas.
4. Procure notas correspondentes com `rg --files | rg -i "<termo>"`.
5. Adicione `[[wikilinks]]` onde fizer sentido.

## Regras

- Não crie links decorativos.
- Não duplique links já existentes.
- Não altere transcrições literais sem pedido explícito.
- Não mexa em handovers arquivados.
- Se criar fato durável, use `Memória/<slug>.md` e atualize `Memória/INDEX.md`.

## Relatório

Ao fim, diga:

- arquivos analisados;
- links adicionados;
- arquivos ignorados e por quê.
