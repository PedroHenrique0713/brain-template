# /vault_scan

Varre arquivos novos ou modificados no vault e cria referências cruzadas entre notas relacionadas.

---

## Execução

### 1. Descobrir arquivos novos

Liste todos os arquivos `.md` no vault, excluindo:
- `07 - HANDOVERS/`
- `CLAUDE.md`, `GEMINI.md`
- Arquivos dentro de `.claude/`, `.gemini/`, `.obsidian/`

Identifique os que foram criados ou modificados recentemente (use data de modificação via `ls -lt` ou `find -newer`).

### 2. Para cada arquivo novo/modificado

- Leia o conteúdo.
- Identifique entidades mencionadas: projetos, pessoas, ferramentas, conceitos.
- Verifique se existe outra nota no vault sobre essas entidades.
- Se sim, adicione um link `[[nome-da-nota]]` na seção `## Referências` ao final da nota (crie a seção se não existir).

### 3. Atualizar índices

- Se existe um `MOC.md` ou `index.md` na pasta do arquivo, adicione o novo arquivo à lista.
- Se não existe, não crie automaticamente — apenas informe ao usuário.

### 4. Relatório final

Mostre:
```
Vault scan concluído.
Arquivos analisados: {n}
Referências cruzadas criadas: {n}
Arquivos sem referências encontradas: {lista}
```

Se nenhum arquivo novo for encontrado, diga: "Nenhum arquivo novo desde a última análise."
