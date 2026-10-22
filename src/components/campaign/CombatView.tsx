"use client";

import { Skull, Swords } from "lucide-react";
import type { CombatRow, PublicCombatant } from "@/lib/campaign-types";
import { ConditionChips } from "./ConditionChips";

function Bar({ cur, max, tone }: { cur: number | null; max: number | null; tone: "pv" | "pc" }) {
  if (cur == null || max == null || max <= 0) return null;
  const pct = Math.max(0, Math.min(100, (cur / max) * 100));
  return (
    <span className="flex items-center gap-2">
      <span className="relative h-1.5 w-24 overflow-hidden border border-line bg-panel-3" aria-hidden>
        <span className={`absolute inset-y-0 left-0 ${tone === "pv" ? "bg-gradient-to-r from-primary to-cyan" : "bg-holo/70"}`} style={{ width: `${pct}%` }} />
      </span>
      <span className="font-mono text-[0.62rem] text-fg-dim tabular-nums">
        {tone.toUpperCase()} {cur}/{max}
      </span>
    </span>
  );
}

/** Visão do combate para os jogadores (e prévia do Mestre). */
export function CombatView({ combat, combatants }: { combat: CombatRow | null; combatants: PublicCombatant[] }) {
  if (!combat) return <p className="border border-dashed border-line p-6 text-center text-sm text-fg-muted">Nenhum combate em andamento.</p>;
  const order = [...combatants].sort((a, b) => a.sort_order - b.sort_order || (b.initiative ?? -1e9) - (a.initiative ?? -1e9));
  const current = combat.status === "active" ? order[Math.min(combat.turn_index, order.length - 1)] : undefined;
  return (
    <div className="space-y-3">
      <div className="flex flex-wrap items-center justify-between gap-2">
        <h3 className="flex items-center gap-2 text-lg tracking-[0.08em] text-holo uppercase">
          <Swords className="h-4 w-4" aria-hidden /> {combat.name}
        </h3>
        <p className="font-mono text-xs tracking-[0.2em] text-fg-dim uppercase">
          {combat.status === "paused" ? "Em preparação" : <>Rodada <span className="text-cyan">{combat.round}</span></>}
        </p>
      </div>
      {current && (
        <p className="border border-cyan/50 bg-cyan/10 px-3 py-2 font-mono text-xs tracking-[0.15em] text-cyan uppercase" role="status">
          Agindo agora: {current.name}
        </p>
      )}
      <ol className="space-y-1.5">
        {order.map((c, i) => {
          const active = current?.id === c.id;
          const down = c.pv_current === 0;
          return (
            <li
              key={c.id}
              className={`flex flex-wrap items-center gap-x-4 gap-y-1 border px-3 py-2 ${active ? "border-cyan bg-cyan/10 shadow-[0_0_24px_-10px_var(--color-cyan)]" : "border-line/60 bg-panel-2/40"}`}
              aria-current={active ? "true" : undefined}
            >
              <span className="w-6 font-mono text-xs text-fg-muted tabular-nums">{String(i + 1).padStart(2, "0")}</span>
              <span className={`min-w-0 flex-1 truncate text-sm ${down ? "text-fg-muted line-through" : "text-fg"}`}>
                {down && <Skull className="mr-1 inline h-3.5 w-3.5 text-alert" aria-label="caído" />}
                {c.name}
              </span>
              {c.initiative != null && <span className="font-mono text-[0.6rem] text-fg-muted">INI {c.initiative}</span>}
              <Bar cur={c.pv_current} max={c.pv_max} tone="pv" />
              <Bar cur={c.pc_current} max={c.pc_max} tone="pc" />
              {c.conditions?.length > 0 && (
                <span className="basis-full">
                  <ConditionChips conditions={c.conditions} size="sm" />
                </span>
              )}
            </li>
          );
        })}
      </ol>
    </div>
  );
}
