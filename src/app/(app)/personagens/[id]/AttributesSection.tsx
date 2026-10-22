"use client";

import { useState, useTransition } from "react";
import { Loader2 } from "lucide-react";
import { useToast } from "@/components/ui/Toast";
import { ATTRIBUTES } from "@/rules/data/attributes.ts";
import { thresholds } from "@/rules/d100.ts";
import { StatReadout } from "@/components/hud/StatReadout";
import type { ComputedSheet } from "@/rules/sheet.ts";
import { updateAttributes } from "../actions";
import { EditableSection, NumberCell } from "./EditableSection";
import type { SheetState } from "./Sheet";

type Row = { attribute: string; base_value: number; other_bonus: number; temp_bonus: number };

export function AttributesSection({ state, sheet, onRoll, rolling }: { state: SheetState; sheet: ComputedSheet; onRoll: (id: string) => void; rolling: string | null }) {
  const toast = useToast();
  const [editing, setEditing] = useState(false);
  const [rows, setRows] = useState<Row[]>([]);
  const [saving, start] = useTransition();

  function beginEdit() {
    setRows(
      ATTRIBUTES.map((a) => {
        const v = sheet.attributes[a.id];
        return { attribute: a.id, base_value: v.base, other_bonus: v.other, temp_bonus: v.temporary };
      }),
    );
    setEditing(true);
  }

  function save() {
    start(async () => {
      const res = await updateAttributes(state.character.id, rows, state.form.id);
      if (!res.ok) return toast(res.error, "error");
      state.setForm({ attributes: rows.map((r) => ({ ...r })) });
      setEditing(false);
      toast(res.message ?? "Atributos salvos.");
    });
  }

  return (
    <EditableSection
      title="Atributos"
      canEdit={state.canEdit}
      editing={editing}
      saving={saving}
      onEdit={beginEdit}
      onCancel={() => setEditing(false)}
      onSave={save}
      hint="Base = valor rolado. Outros = bônus permanentes. Temporário = efeitos passageiros (não altera a base). O bônus de classe é aplicado sozinho."
    >
      {editing ? (
        <div className="overflow-x-auto">
          <table className="w-full min-w-[22rem] text-sm">
            <thead>
              <tr className="text-left">
                {["", "Base", "Classe", "Outros", "Temp.", "Final"].map((h) => (
                  <th key={h} className="label-mono pb-2 font-normal">
                    {h}
                  </th>
                ))}
              </tr>
            </thead>
            <tbody>
              {rows.map((r, i) => {
                const classBonus = sheet.attributes[r.attribute as keyof typeof sheet.attributes].classBonus;
                const set = (patch: Partial<Row>) => setRows(rows.map((x, j) => (j === i ? { ...x, ...patch } : x)));
                return (
                  <tr key={r.attribute}>
                    <th scope="row" className="pr-2 text-left font-display text-holo">
                      {r.attribute}
                    </th>
                    <td className="p-1"><NumberCell label={`${r.attribute} base`} min={0} max={200} value={r.base_value} onChange={(v) => set({ base_value: v })} /></td>
                    <td className="p-1 text-center font-mono text-cyan">{classBonus ? `+${classBonus}` : "—"}</td>
                    <td className="p-1"><NumberCell label={`${r.attribute} outros`} min={-100} max={100} value={r.other_bonus} onChange={(v) => set({ other_bonus: v })} /></td>
                    <td className="p-1"><NumberCell label={`${r.attribute} temporário`} min={-100} max={100} value={r.temp_bonus} onChange={(v) => set({ temp_bonus: v })} /></td>
                    <td className="p-1 text-center font-mono text-fg">{r.base_value + classBonus + r.other_bonus + r.temp_bonus}</td>
                  </tr>
                );
              })}
            </tbody>
          </table>
        </div>
      ) : (
        <ul className="grid grid-cols-2 gap-2 sm:grid-cols-4">
          {ATTRIBUTES.map((a) => {
            const v = sheet.attributes[a.id];
            const t = thresholds(v.final);
            const key = `attribute:${a.id}`;
            const mods = v.classBonus + v.other + v.temporary;
            return (
              <li key={a.id}>
                <button
                  onClick={() => onRoll(a.id)}
                  disabled={!state.canEdit || rolling !== null}
                  title={state.canEdit ? `Rolar teste de ${a.name}` : a.name}
                  aria-label={`${a.name}: ${t.normal} / ${t.good} / ${t.extreme}. ${state.canEdit ? "Rolar teste." : ""}`}
                  className="group relative flex w-full border border-line bg-panel-3/70 px-2.5 pt-2.5 pb-2 transition-[border-color,box-shadow,background] enabled:hover:border-holo enabled:hover:bg-primary/10 enabled:hover:shadow-[var(--shadow-glow)] disabled:cursor-default"
                >
                  <StatReadout code={a.id} name={a.name} value={v.final} />
                  {mods !== 0 && (
                    <span className="absolute top-2.5 right-5 font-mono text-[0.6rem] text-cyan" title={`Base ${v.base}`}>
                      {mods > 0 ? "+" : ""}
                      {mods}
                    </span>
                  )}
                  {v.temporary !== 0 && (
                    <span className="absolute bottom-9 left-2.5 font-mono text-[0.5rem] tracking-[0.15em] text-cyan uppercase">
                      temp {v.temporary > 0 ? "+" : ""}
                      {v.temporary}
                    </span>
                  )}
                  {rolling === key && <Loader2 className="absolute top-2.5 right-1 h-3 w-3 animate-spin text-cyan" aria-hidden />}
                </button>
              </li>
            );
          })}
        </ul>
      )}
    </EditableSection>
  );
}
