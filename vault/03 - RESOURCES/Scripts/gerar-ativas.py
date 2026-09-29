#!/usr/bin/env python3
"""Gera 07 - HANDOVERS/ATIVAS.md: o painel de retomada das tarefas vivas.

Uma linha por tarefa de Tarefas/ (sem descer em Arquivo/, sem os .log.md), com status,
última atualização e o próximo passo; tarefa viva sem toque há mais de PARADA_DIAS
ganha ⚠️ e sai do D do /resumo_do_dia. Rodado pelo /handover_chat e pelo /vault_gc.
Idempotente. O arquivo gerado não se edita à mão.
"""
import re
from datetime import date
from pathlib import Path

VAULT = Path(__file__).resolve().parents[2]
HO = VAULT / "07 - HANDOVERS"
DIR = HO / "Tarefas"
OUT = HO / "ATIVAS.md"
PARADA_DIAS = 21
ORDEM = {"ativa": 0, "aguardando": 1, "pausada": 2}
# status antigos, antes do enum de 2026-09-29
LEGADO = {
    "em-progresso": "ativa", "em-andamento": "ativa", "em_andamento": "ativa", "em_progresso": "ativa",
    "aberta": "ativa", "planejamento": "ativa", "bloqueado": "aguardando",
    "finalizada": "concluida", "finalizado": "concluida", "concluido": "concluida", "concluída": "concluida",
    "encerrada": "concluida", "cancelado": "cancelada",
    "aguardando-review": "aguardando", "aguardando-go-live": "aguardando", "bloqueada": "aguardando",
    "parado-pelo-cliente": "aguardando", "pausado": "pausada", "congelado": "pausada",
}


def frontmatter(texto: str) -> dict:
    m = re.match(r"---\n(.*?)\n---", texto, re.S)
    campos = {}
    for linha in (m.group(1).splitlines() if m else []):
        if ":" in linha and not linha.startswith((" ", "-")):
            k, v = linha.split(":", 1)
            campos[k.strip()] = v.strip().strip('"')
    return campos


def proximo_passo(texto: str) -> str:
    # só títulos que COMEÇAM por "Próximo..." ou "A fila" (depois de um emoji, se houver);
    # a seção vai até o próximo "##", atravessando subtítulos, e a marcada como histórico é pulada
    for m in re.finditer(r"^#{2,3} [^\w\n]*(Próxim|A fila)[^\n]*\n(.*?)(?=^#{1,2} |\Z)", texto, re.S | re.M | re.I):
        if "histórico" in m.group(0).split("\n", 1)[0].lower():
            continue
        for linha in m.group(2).splitlines():
            if re.match(r"\s*([-*]|\d+[.)])?\s*\[[xX]\]", linha):
                continue  # item já feito não é próximo passo
            linha = re.sub(r"^[\s>*-]*(\d+[.)]\s*)?(\[ \]\s*)?", "", linha).replace("**", "").strip()
            if linha and not linha.startswith(("<", "~~", "|", "```", "#")):
                return (linha[:157] + "...") if len(linha) > 160 else linha
    return ""


def main() -> None:
    hoje = date.today()
    linhas = []
    for f in sorted(DIR.glob("T*.md")):
        if f.name.endswith(".log.md"):
            continue
        texto = f.read_text(errors="ignore")
        fm = frontmatter(texto)
        status = fm.get("status", "?").lower()
        status = LEGADO.get(status, status)
        if status in ("concluida", "cancelada"):
            continue
        atual = fm.get("atualizado") or fm.get("updated") or fm.get("date") or ""
        try:
            idade = (hoje - date.fromisoformat(atual[:10])).days
        except ValueError:
            idade = 999
        parada = status in ("ativa", "aguardando") and idade > PARADA_DIAS
        tid = f.name.split(" - ")[0]
        nome = f.stem.split(" - ", 1)[1] if " - " in f.stem else f.stem
        bloqueio = fm.get("bloqueio", "")
        prox = proximo_passo(texto) or "(sem próximo passo no arquivo)"
        if bloqueio and status == "aguardando":
            prox = f"espera: {bloqueio} · {prox}"
        linhas.append((ORDEM.get(status, 3), atual, tid, nome, status, parada, prox.replace("|", "/")))
    # por status, as paradas no fim de cada grupo, a mais recente primeiro
    linhas.sort(key=lambda x: x[1], reverse=True)
    linhas.sort(key=lambda x: (x[0], x[5]))
    recentes = sorted((p for p in HO.glob("20*.md")), reverse=True)[:8]
    with open(OUT, "w") as w:
        w.write("<!-- GERADO por 03 - RESOURCES/Scripts/gerar-ativas.py. Não editar: mude a tarefa e rode o script. -->\n")
        w.write(f"# Tarefas vivas ({hoje.isoformat()})\n\n")
        w.write(f"> Ponto de partida para retomar trabalho ou dividir frentes entre sessões. ⚠️ = viva, mas sem toque há mais de {PARADA_DIAS} dias: não entra no D do dia, e o `/vault_gc` pergunta se pausa ou encerra.\n\n")
        w.write("| ID | Tarefa | Status | Atualizada | Próximo passo |\n|---|---|---|---|---|\n")
        for _, atual, tid, nome, status, parada, prox in linhas:
            w.write(f"| {tid} | [[{tid} - {nome}\\|{nome[:70]}]] | {'⚠️ ' if parada else ''}{status} | {atual or '?'} | {prox} |\n")
        w.write("\n## Handovers gerais mais recentes\n\n")
        for p in recentes:
            w.write(f"- [[{p.stem}]]\n")
    print(f"{OUT} ({len(linhas)} tarefas vivas, {sum(1 for l in linhas if l[5])} paradas)")


if __name__ == "__main__":
    main()
