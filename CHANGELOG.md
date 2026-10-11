# Changelog — Vault Brain

Notas de versão do template. O `update.sh` mostra automaticamente tudo o que mudou
entre a sua versão e a mais recente. Formato baseado em [Keep a Changelog](https://keepachangelog.com/pt-BR/).

## [3.0.1] - 2026-10-10

Os scripts de tarefa funcionam no Windows.

### Corrigido
- `nova-tarefa.py` e `gerar-ativas.py` liam e gravavam sem `encoding`, e no Windows o Python usa cp1252: o `gerar-ativas.py` quebrava no ⚠️ do cabeçalho (`UnicodeEncodeError: 'charmap' codec`) e o `nova-tarefa.py` gravava a tarefa em cp1252, com os acentos inválidos para o Obsidian. Agora tudo é UTF-8. Achado num vault real em Windows 11.

## [3.0.0] - 2026-09-29

Handover que aguenta meses de uso, com várias sessões e várias IAs ao mesmo tempo. Tudo o que entra aqui saiu de problema medido num vault real, com 190 sessões num mês.

### Mudou
- **Tarefa = dois arquivos:** o estado `T0XX - nome.md` (curto, reescrito a cada `/handover_chat`) e o log `T0XX - nome.log.md` (só acréscimo). Estado e log juntos viravam diários de centenas de KB, com "próximo passo" velho esquecido no meio.
- **`status:` com 5 valores:** `ativa`, `aguardando` (com `bloqueio:`), `pausada`, `concluida`, `cancelada`. Eram 18 grafias diferentes e o `/vault_gc` só reconhecia algumas.
- **`CLAUDE.md` importa** `AGENTS.md`, `GUARDRAILS.md` e `Memória/INDEX.md` com `@`. Antes ele só dizia "leia o AGENTS.md", e o carregamento dependia do modelo lembrar.
- `/handover_chat`, `/handon_chat` e `/vault_gc` reescritos para o esquema novo, com a mesma estrutura de seções no estado, no snapshot e no `HANDOFF.md`.

### Adicionado
- **`GUARDRAILS.md`** — protocolo de trabalho para qualquer IA: reconhecimento antes de opinião, plano, verificação com evidência, economia de contexto, autonomia calibrada.
- **`07 - HANDOVERS/ATIVAS.md`**, gerado por `03 - RESOURCES/Scripts/gerar-ativas.py`: toda tarefa viva com status, última atualização e próximo passo; ⚠️ marca a viva parada há mais de 21 dias.
- **`03 - RESOURCES/Scripts/nova-tarefa.py`**: cria estado + log com o próximo ID sob trava (sessões paralelas numerando à mão repetiam número).
- **Hook `SessionStart` "compact"** (`.claude/hooks/pos-compactacao.sh`, registrado em `.claude/settings.json`): depois de cada compactação, pede o checkpoint da tarefa e aponta a transcrição completa. Handover escrito depois de uma compactação saía do resumo, que é raso.
- **`Memória/STAGING.md`** e o protocolo de memória completo no `AGENTS.md`: teto de ~320 caracteres por linha do INDEX, gancho buscável, invalidação explícita, e fatos de projeto ou lições técnicas podendo sair do INDEX para uma skill que carrega pelo tema.
- **`/vault_gc`** lista as tarefas paradas para você decidir, e tritura o STAGING.

### Como atualizar um vault existente
- `update.sh` / `update.mjs` agora sincronizam também `.claude/hooks/` e `03 - RESOURCES/Scripts/`, e criam `GUARDRAILS.md`, `Memória/STAGING.md` e os templates de tarefa **só se faltarem** (nunca sobrescrevem o que você editou).
- À mão: troque o `CLAUDE.md` pelo do template (imports com `@`) e acrescente ao seu `.claude/settings.json` o bloco `hooks.SessionStart` do template. As tarefas antigas migram sozinhas: o `/handover_chat` separa o log na primeira vez que tocar cada uma.

## [2.2.0] - 2026-06-28

Atualizar agora funciona no Windows "pelado" também.

### Adicionado
- **`update.mjs`** — versão do atualizador em Node.js, cross-platform (Windows/Mac/Linux), zero dependências. Para quem não tem Git Bash/WSL mas tem Node. Mesmas funções do `update.sh` (banner, release notes, `--dry-run`, `--prune`, marcador de versão).

### Notas
- Windows: rode `update.mjs` com Node, ou `update.sh` no Git Bash. PowerShell/CMD puros não rodam o `.sh`.

## [2.1.0] - 2026-06-28

Atualização sem dor: agora dá pra puxar novidades do template num vault que já existe.

### Adicionado
- **`update.sh`** — sincroniza o framework (commands, scripts) do GitHub sem tocar nos seus dados. Roda com um comando só (`curl -sL .../update.sh | bash`), mostra o banner e as release notes, e tem `--dry-run` e `--prune`. Grava a versão em `.claude/.brain-version`.
- Command **`/update_brain`** — migra a estrutura de um vault da v1 para a v2 (skills→commands, conteúdo do `CLAUDE.md`→`AGENTS.md`), de forma interativa e preservando o conteúdo.
- `CHANGELOG.md` e `VERSION` — base das release notes mostradas pelo `update.sh`.

## [2.0.0] - 2026-06-26

Reorganização grande: o template passou a usar um **cérebro neutro multi-IA**.

### Mudou
- **Cérebro canônico em `AGENTS.md`** — `CLAUDE.md` e `GEMINI.md` viraram ponteiros finos que só apontam pra lá. Vale pra Claude Code, Gemini CLI, opencode e modelos locais.
- **Skills viraram slash-commands** — de `.claude/skills/*.md` para `.claude/commands/*.md`.

### Adicionado
- Command `/vault_gc` — manutenção semanal (arquiva handovers/tarefas, valida Memória ↔ INDEX, triagem do INBOX).
- Estrutura base com `.gitkeep` em `00 - INBOX/`, `07 - HANDOVERS/Arquivo/`, `07 - HANDOVERS/Tarefas/` e `Tarefas/Arquivo/`.
- `setup.sh` com auto-download dos plugins do Obsidian e escolha de ferramenta de IA.

### Removido
- Pasta antiga `.claude/skills/` (substituída por `.claude/commands/`).

## [1.0.0] - 2026-06-24

### Adicionado
- Estrutura inicial do vault (PROJETOS, ÁREAS, RECURSOS, REUNIÕES, HANDOVERS, Memória).
- Plugins do Obsidian e primeira versão das skills de onboarding/handover.
