#!/usr/bin/env python3
"""Cria uma tarefa em 07 - HANDOVERS/Tarefas/: o arquivo de estado e o log ao lado.

Uso: nova-tarefa.py "Título" [projeto]

O ID é o maior T0XX entre Tarefas/ e Tarefas/Arquivo/ mais um, calculado sob flock:
duas sessões paralelas numerando à mão acabam repetindo número.
Imprime o caminho do arquivo de estado.
"""
import fcntl
import json
import re
import sys
from datetime import date
from pathlib import Path

VAULT = Path(__file__).resolve().parents[2]
DIR = VAULT / "07 - HANDOVERS" / "Tarefas"
TPL = VAULT / "03 - RESOURCES" / "Templates" / "template-tarefa.md"

LOG_TPL = """---
id: {id}
tipo: log
tarefa: "[[{id} - {titulo}]]"
---

# Log — {id} {titulo}

> Só acréscimo, mais recente embaixo, uma entrada `### YYYY-MM-DD — HH:MM` por sessão (formato no `/handover_chat`).
> Alimenta o `/resumo_do_dia` e o `/semana_s`. O estado vivo da tarefa mora em [[{id} - {titulo}]].
"""


def main() -> None:
    if len(sys.argv) < 2 or not sys.argv[1].strip():
        sys.exit('uso: nova-tarefa.py "Título" [projeto]')
    # fora do nome: separador de caminho e o que quebra link do Obsidian (# ^ [ ] |) ou o YAML
    titulo = re.sub(r"\s+", " ", re.sub(r'[/\\:#^\[\]|"]', "-", sys.argv[1])).strip(" -")
    projeto = sys.argv[2].strip() if len(sys.argv) > 2 else ""
    # o nome do log ("T000 - <título>.log.md") tem de caber nos 255 bytes do sistema de arquivos
    while len(f"T0000 - {titulo}.log.md".encode()) > 250:
        titulo = titulo[:-1].rstrip()
    with open(DIR / ".nova-tarefa.lock", "w") as lock:
        fcntl.flock(lock, fcntl.LOCK_EX)
        nums = [int(m.group(1)) for p in (DIR, DIR / "Arquivo") for f in p.glob("T*.md")
                if (m := re.match(r"T0*(\d+)\b", f.name))]
        tid = f"T{max(nums, default=0) + 1:03d}"
        hoje = date.today().isoformat()
        estado = DIR / f"{tid} - {titulo}.md"
        log = DIR / f"{tid} - {titulo}.log.md"
        corpo = (TPL.read_text()
                 .replace("titulo: {{TITULO}}", f"titulo: {json.dumps(titulo, ensure_ascii=False)}")
                 .replace("projeto: {{PROJETO}}", f"projeto: {json.dumps(projeto, ensure_ascii=False)}")
                 .replace("{{ID}}", tid).replace("{{TITULO}}", titulo).replace("{{DATA}}", hoje))
        with open(estado, "x") as f:
            f.write(corpo)
        try:
            with open(log, "x") as f:
                f.write(LOG_TPL.format(id=tid, titulo=titulo))
        except OSError:
            estado.unlink()  # estado sem log é tarefa pela metade
            raise
    print(estado)


if __name__ == "__main__":
    main()
