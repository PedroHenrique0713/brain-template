#!/usr/bin/env bash
# SessionStart (matcher "compact"): logo depois de uma compactação, pede o checkpoint do handover.
# O resumo da compactação é raso; o detalhe (ID, número, o "antes") só está na transcrição,
# que continua inteira em disco. Handover escrito sem voltar a ela sai pobre.
exec python3 -c '
import json, sys
try:
    t = json.load(sys.stdin).get("transcript_path") or ""
except Exception:
    t = ""
m = ("A conversa acabou de ser compactada e o resumo acima é raso. Se esta sessão trabalha numa tarefa de "
     "`07 - HANDOVERS/Tarefas/` (ou num repo com HANDOFF.md), faça o checkpoint antes de seguir: reescreva "
     "\"Estado agora\" e \"Próximo passo\" e acrescente uma entrada no log da tarefa, completando IDs, números e "
     "decisões pela transcrição completa")
if t:
    m += f" em {t} (busque com grep; não leia inteira)"
m += ". Sem tarefa em andamento, ignore este aviso."
print(json.dumps({"hookSpecificOutput": {"hookEventName": "SessionStart", "additionalContext": m}}, ensure_ascii=False))
'
