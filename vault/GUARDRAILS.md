# ⚙️ GUARDRAILS.md — Protocolo de engenharia (todas as IAs)

> **O que é:** *como trabalhar* — raciocínio, construção de código, verificação e economia de contexto. O `AGENTS.md` diz **o que saber**; este arquivo diz **como agir**.
>
> **Como é carregado:** o `CLAUDE.md` do vault importa este arquivo (`@GUARDRAILS.md`). Para valer em todos os seus projetos no Claude Code, importe-o também no `~/.claude/CLAUDE.md` com o caminho absoluto. Outras IAs (Codex, Gemini, opencode): aponte a configuração delas para cá.
>
> Edite **aqui**, não duplique nas configs das ferramentas. Regra nova entra quando custou caro uma vez, com o caso que a motivou.

---

## 1. Reconhecimento antes de opinião

- Nunca afirme como um repo, fluxo ou API funciona sem ter **lido nesta sessão**. Memória de treino não é fonte; o código é.
- Antes de citar função, rota, campo ou config: `grep`/leia e confirme que existe. Cite evidência como `arquivo:linha`.
- Se a documentação divergir do código real, **explicite a divergência** em vez de escolher um lado em silêncio.
- Docs do próprio repo (README, docs/) vêm antes de suposição.

## 2. Plano antes de implementar

- Tarefa não-trivial (3+ arquivos, decisão de arquitetura, mexe em produção): escreva um plano curto **antes** do primeiro edit — objetivo, arquivos, critério de aceite, riscos. Tarefa pequena e óbvia: faça.
- O plano define o **escopo**. Achou problema fora dele? Anote e reporte; não conserte de carona sem avisar.
- Decisão técnica relevante → registre na hora no estado da tarefa (`## 🧭 Decisões técnicas`), com data e **porquê**.

## 3. Execução cirúrgica

- Menor mudança **completa** que resolve — nem gambiarra, nem refactor que ninguém pediu.
- Imite o código vizinho: estilo, nomes, idioma, densidade de comentários.
- Comentário só para restrição que o código não mostra.
- Edite o trecho; não reescreva o arquivo inteiro quando um edit resolve.
- Não deixe estado intermediário quebrado entre passos.

## 4. Verificação com evidência

- "Pronto" exige **prova**: exercitar o fluxo afetado de ponta a ponta. Typecheck/lint passar **não** é prova de funcionamento.
- Reporte falha com o output real. Teste falhou? Diga que falhou e mostre.
- Não deu pra verificar? Diga **exatamente o que não foi verificado** e como verificar.

## 5. Economia de contexto

- Busque antes de ler (`grep`/glob → `read` no trecho certo). Arquivo grande: offset/limit.
- Não releia o que já está no contexto.
- Chamadas independentes → em **paralelo**.
- Output longo → salve em arquivo e traga só o resumo + caminho.
- Fato que só importa a um projeto não precisa carregar em toda sessão: ele pode morar numa skill do projeto, que carrega pelo tema (ver `AGENTS.md` → Memória viva).

## 6. Autonomia calibrada

- Ação **óbvia, reversível e dentro do escopo** → faça e relate.
- Pare e pergunte em: ação irreversível ou destrutiva, efeito externo (push, deploy, mensagem, gasto) ou trade-off real que muda o produto.
- Aprovação em um contexto não vale para o próximo.
- **Pergunta de informação é falha de busca.** Antes de perguntar número, ID, caminho, "onde fica" ou "isso já foi feito?", procure: `Memória/INDEX.md` → `grep` em `Memória/` → `07 - HANDOVERS/ATIVAS.md` e a tarefa → o próprio código/`git log`. Só pergunte se voltar vazio, dizendo onde procurou.
- Pergunte só o que apenas o usuário sabe: prioridade, trade-off de produto, autorização, e qual de duas leituras do pedido vale quando levam a trabalhos diferentes.

## 7. Anti-deriva

- **2 falhas na mesma abordagem → pare de variar às cegas.** Releia o erro inteiro, re-diagnostique e tente algo diferente, ou reporte o bloqueio com o erro exato.
- Ferramenta negada pelo usuário = decisão, não falha técnica.

## 8. Comunicação

- **Resultado primeiro**, detalhe depois.
- Frases completas, termos técnicos no original. Datas absolutas (`2026-07-08`), nunca relativas.

## 9. Estado persistente

- O estado vivo mora em **arquivo**, nunca só no chat: tarefa em `07 - HANDOVERS/Tarefas/` (estado + log) ou `HANDOFF.md` no repo de código. Protocolo no `AGENTS.md` → Continuidade.
- Sessão longa faz **checkpoint** ao fechar cada frente: handover escrito depois de uma compactação sai do resumo, que é raso.
- Conhecimento durável (decisão, causa raiz, gotcha) sobe para `Memória/` ao fim do esforço.
