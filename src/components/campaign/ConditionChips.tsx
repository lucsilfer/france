"use client";

import { useState } from "react";
import { Plus, X } from "lucide-react";
import type { Condition } from "@/lib/campaign-types";

/** Sugestões (exemplos do livro, tabela de Condições). O nome é livre. */
export const CONDITION_SUGGESTIONS = ["Lentidão", "Vulnerável", "Desvantagem", "Movimento reduzido", "Cego", "Silenciado", "Imobilizado", "Incapaz de atacar", "Atordoado", "Sangrando", "Furtivo"];

export function ConditionChips({
  conditions,
  onAdd,
  onRemove,
  busy = false,
  size = "md",
}: {
  conditions: Condition[];
  onAdd?: (name: string, turns: number | null) => void;
  onRemove?: (id: string) => void;
  busy?: boolean;
  size?: "sm" | "md";
}) {
  const [adding, setAdding] = useState(false);
  const [name, setName] = useState("");
  const [turns, setTurns] = useState("");
  const chip = size === "sm" ? "text-[0.6rem] px-1.5 py-0.5" : "text-[0.66rem] px-2 py-0.5";

  function submit(e: React.FormEvent) {
    e.preventDefault();
    const n = name.trim();
    if (!n || !onAdd) return;
    const t = turns.trim() ? Math.max(1, Math.min(100, Math.floor(Number(turns)) || 1)) : null;
    onAdd(n, t);
    setName("");
    setTurns("");
    setAdding(false);
  }

  return (
    <div className="flex flex-wrap items-center gap-1.5">
      {conditions.length === 0 && !onAdd && <span className="text-xs text-fg-muted">Sem condições</span>}
      {conditions.map((c) => (
        <span key={c.id} className={`inline-flex items-center gap-1 border border-alert/50 bg-alert/10 font-mono tracking-[0.06em] text-alert ${chip}`} title={c.note || undefined}>
          {c.name}
          {c.turns != null && <span className="text-fg-dim">· {c.turns}t</span>}
          {onRemove && (
            <button type="button" onClick={() => onRemove(c.id)} disabled={busy} className="hover:text-fg" aria-label={`Remover ${c.name}`}>
              <X className="h-3 w-3" />
            </button>
          )}
        </span>
      ))}
      {onAdd &&
        (adding ? (
          <form onSubmit={submit} className="flex flex-wrap items-center gap-1">
            <input list="condition-suggestions" autoFocus className="field-input w-36 py-0.5 text-xs" placeholder="Condição" value={name} maxLength={80} onChange={(e) => setName(e.target.value)} aria-label="Nome da condição" />
            <input className="field-input w-16 py-0.5 font-mono text-xs" placeholder="turnos" inputMode="numeric" value={turns} onChange={(e) => setTurns(e.target.value.replace(/\D/g, ""))} aria-label="Duração em turnos (vazio = até remover)" />
            <button type="submit" className="border border-holo/60 px-2 py-0.5 font-mono text-[0.6rem] text-cyan uppercase hover:bg-primary/10" disabled={busy}>
              Ok
            </button>
            <button type="button" onClick={() => setAdding(false)} className="px-1 text-fg-muted hover:text-fg" aria-label="Cancelar">
              <X className="h-3.5 w-3.5" />
            </button>
            <datalist id="condition-suggestions">
              {CONDITION_SUGGESTIONS.map((s) => (
                <option key={s} value={s} />
              ))}
            </datalist>
          </form>
        ) : (
          <button type="button" onClick={() => setAdding(true)} className={`inline-flex items-center gap-1 border border-dashed border-line font-mono text-fg-muted uppercase hover:border-holo hover:text-cyan ${chip}`} disabled={busy}>
            <Plus className="h-3 w-3" /> Condição
          </button>
        ))}
    </div>
  );
}
