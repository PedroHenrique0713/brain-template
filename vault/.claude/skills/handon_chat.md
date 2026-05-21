# /handon_chat

Retoma o contexto de uma sessão anterior ou lista todas as sessões salvas.

---

## Uso

- `/handon_chat` — lista todas as sessões em `07 - HANDOVERS/` ordenadas por data (mais recente primeiro)
- `/handon_chat {data ou parte do nome}` — carrega o handover mais próximo que corresponde ao argumento

---

## Execução — sem argumento (listar)

1. Liste todos os arquivos `.md` em `07 - HANDOVERS/` que não estejam marcados como `status: finalizado`.
2. Para cada um, mostre: `{data hora} — {primeira linha de "Contexto"}`.
3. Pergunte: "Qual sessão quer retomar?"

## Execução — com argumento (retomar)

1. Encontre o arquivo de handover correspondente ao argumento.
2. Leia o arquivo inteiro.
3. Apresente um resumo:
   - O que foi feito
   - Próximos passos pendentes
   - Arquivos modificados
4. Diga: "Contexto carregado. Pode continuar de onde parou."
5. Opcional: se houver próximos passos marcados com `[ ]`, pergunte se quer começar pelo primeiro.
