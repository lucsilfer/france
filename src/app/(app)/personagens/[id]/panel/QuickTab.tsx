"use client";

import { Star, Zap } from "lucide-react";
import { ATTACK_KIND_LABEL } from "@/rules/catalog.ts";
import { planAttack } from "@/rules/combat.ts";
import { SKILL_BY_ID } from "@/rules/data/skills.ts";
import type { SheetState } from "../Sheet";
import { ActiveEffects, AttackButton, UsePowerButton, weaponOf } from "./actions-ui";

/** Itens e poderes marcados com ★, prontos para usar em combate. */
export function QuickTab({ state, goTo }: { state: SheetState; goTo: (tab: "inventario" | "poderes") => void }) {
  const { character: c, form, sheet } = state;
  const items = state.items.filter((i) => i.quick_access);
  const powers = state.powers.filter((p) => p.quick_access);
  const skillValues = Object.fromEntries(sheet.skills.map((s) => [s.id, s.final]));
  const classId = form.kind === "base" ? c.class_id : null;

  return (
    <div className="space-y-5">
      <ActiveEffects state={state} />
      <section>
        <p className="label-mono mb-2">Armas e itens</p>
        {items.length === 0 ? (
          <Empty text="Nenhum item no Inventário Rápido." action="Marque ★ no Inventário" onClick={() => goTo("inventario")} />
        ) : (
          <ul className="space-y-2">
            {items.map((i) => {
              const w = weaponOf(i);
              const plan = w ? planAttack(w, { classId, originId: c.origin_id, pathId: c.origin_path_id, level: c.level, skillValues }) : null;
              return (
                <li key={i.id} className="flex items-center gap-3 border border-line/70 bg-panel-2/40 px-3 py-2">
                  <div className="min-w-0 flex-1">
                    <p className="truncate text-sm text-fg">
                      {i.name}
                      {i.quantity !== 1 && <span className="ml-1 font-mono text-[0.65rem] text-fg-dim">×{i.quantity}</span>}
                    </p>
                    {plan ? (
                      <p className="font-mono text-[0.62rem] text-fg-dim">
                        {i.attack_kind && ATTACK_KIND_LABEL[i.attack_kind].toUpperCase()} · {SKILL_BY_ID[plan.skillId]?.name.toUpperCase()} {plan.skillValue} · DANO <span className="text-cyan">{plan.damageExpr}</span>
                      </p>
                    ) : (
                      <p className="truncate text-xs text-fg-dim">{i.special_rules || i.description || i.effect_dice || "—"}</p>
                    )}
                  </div>
                  {w && <AttackButton state={state} item={i} />}
                </li>
              );
            })}
          </ul>
        )}
      </section>
      <section>
        <p className="label-mono mb-2">
          Poderes · PC <span className="text-cyan">{form.pc_current}</span>
        </p>
        {powers.length === 0 ? (
          <Empty text="Nenhum poder no Inventário Rápido." action="Marque ★ em Poderes Próprios" onClick={() => goTo("poderes")} />
        ) : (
          <ul className="space-y-2">
            {powers.map((p) => (
              <li key={p.id} className="flex items-center gap-3 border border-line/70 bg-panel-2/40 px-3 py-2">
                <Zap className="h-4 w-4 shrink-0 text-holo" aria-hidden />
                <div className="min-w-0 flex-1">
                  <p className="truncate text-sm text-fg">{p.name}</p>
                  <p className="font-mono text-[0.62rem] text-fg-dim">
                    {p.initial_cost} PC{p.per_turn_cost > 0 && ` + ${p.per_turn_cost}/TURNO`}
                  </p>
                </div>
                <UsePowerButton state={state} power={p} />
              </li>
            ))}
          </ul>
        )}
      </section>
    </div>
  );
}

function Empty({ text, action, onClick }: { text: string; action: string; onClick: () => void }) {
  return (
    <p className="border border-dashed border-line p-4 text-center text-sm text-fg-muted">
      {text}{" "}
      <button onClick={onClick} className="inline-flex items-center gap-1 text-cyan hover:underline">
        <Star className="h-3.5 w-3.5" aria-hidden /> {action}
      </button>
    </p>
  );
}
