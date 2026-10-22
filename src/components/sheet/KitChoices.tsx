"use client";

import { Check, Package } from "lucide-react";
import { DAMAGE_TYPE_LABEL } from "@/rules/data/equipment.ts";
import { CATALOG_BY_ID } from "@/rules/catalog.ts";
import { skillOptions, startingKit, weaponOptions, type KitChoices as Choices } from "@/rules/data/startingKits.ts";

/**
 * Equipamento inicial da classe: itens fixos e escolhas (respeitando as restrições da classe).
 * Usado na criação do personagem e no resgate para personagens já criados.
 */
export function KitChoices({
  classId,
  originId,
  choices,
  onChange,
  onlySlots,
  received = [],
  owned = [],
  disabled = false,
}: {
  classId: string;
  originId: string | null;
  choices: Choices;
  onChange: (next: Choices) => void;
  /** Mostrar só estas vagas (resgate). */
  onlySlots?: string[];
  /** Vagas já entregues. */
  received?: string[];
  /** Ids do catálogo que o personagem já tem (itens fixos não são duplicados). */
  owned?: string[];
  disabled?: boolean;
}) {
  const slots = startingKit(classId).filter((s) => !onlySlots || onlySlots.includes(s.id) || received.includes(s.id));
  if (!slots.length) return null;
  return (
    <ul className="space-y-3">
      {slots.map((slot) => {
        const done = received.includes(slot.id);
        return (
          <li key={slot.id} className={`border p-3 ${done ? "border-line/50 opacity-70" : "border-line/80 bg-panel-2/40"}`}>
            <p className="flex items-start gap-2 text-sm text-fg">
              {done ? <Check className="mt-0.5 h-4 w-4 shrink-0 text-ok" aria-label="recebido" /> : <Package className="mt-0.5 h-4 w-4 shrink-0 text-holo" aria-hidden />}
              <span>
                {slot.label}
                {done && <span className="ml-2 font-mono text-[0.6rem] tracking-[0.15em] text-ok uppercase">recebido</span>}
              </span>
            </p>
            {!done && slot.kind === "item" && (
              <p className="mt-1 pl-6 text-xs text-fg-dim">
                {CATALOG_BY_ID[slot.catalogId]?.effectText}
                {slot.quantity && slot.quantity > 1 ? ` · ×${slot.quantity}` : ""}
                {owned.includes(slot.catalogId) && <span className="ml-1 text-cyan-dim">(você já possui — não será duplicado)</span>}
              </p>
            )}
            {!done && slot.kind === "weapon" && (
              <label className="mt-2 block pl-6">
                <span className="sr-only">{slot.label}</span>
                <select className="field-input py-1.5 text-sm" value={choices[slot.id] ?? ""} disabled={disabled} onChange={(e) => onChange({ ...choices, [slot.id]: e.target.value })}>
                  <option value="">Escolha a arma…</option>
                  {weaponOptions(slot, originId).map((w) => (
                    <option key={w.id} value={w.id}>
                      {w.name} — {w.damage} {DAMAGE_TYPE_LABEL[w.damageType].toLowerCase()} · {w.range}
                    </option>
                  ))}
                </select>
              </label>
            )}
            {!done && slot.kind === "skill_item" && (
              <label className="mt-2 block pl-6">
                <span className="sr-only">{slot.label}</span>
                <select className="field-input py-1.5 text-sm" value={choices[slot.id] ?? ""} disabled={disabled} onChange={(e) => onChange({ ...choices, [slot.id]: e.target.value })}>
                  <option value="">Escolha a perícia…</option>
                  {skillOptions(slot).map((s) => (
                    <option key={s.id} value={s.id}>
                      {s.name}
                    </option>
                  ))}
                </select>
              </label>
            )}
          </li>
        );
      })}
    </ul>
  );
}
