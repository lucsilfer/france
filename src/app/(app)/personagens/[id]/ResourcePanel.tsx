"use client";

import { useState, useTransition } from "react";
import { Minus, Plus } from "lucide-react";
import { useToast } from "@/components/ui/Toast";
import { ResourceBar } from "@/components/hud/ResourceBar";
import type { ComputedSheet } from "@/rules/sheet.ts";
import { adjustResource, updateResources } from "../actions";
import { EditableSection, NumberCell } from "./EditableSection";
import type { SheetState } from "./Sheet";
import { LevelControl } from "./LevelControl";

export function ResourcePanel({ state, sheet }: { state: SheetState; sheet: ComputedSheet }) {
  const toast = useToast();
  const { character: c, form } = state;
  const r = sheet.resources;
  const [editing, setEditing] = useState(false);
  const [draft, setDraft] = useState({ pv_current: form.pv_current, pc_current: form.pc_current, pv_other_bonus: form.pv_other_bonus, pc_other_bonus: form.pc_other_bonus });
  const [saving, start] = useTransition();
  const [busy, setBusy] = useState<string | null>(null);

  async function nudge(resource: "pv" | "pc", delta: number) {
    if (busy) return;
    const max = resource === "pv" ? r.pvMax : r.pcMax;
    const cur = resource === "pv" ? form.pv_current : form.pc_current;
    const optimistic = Math.max(0, Math.min(max, cur + delta));
    state.setForm(resource === "pv" ? { pv_current: optimistic } : { pc_current: optimistic });
    setBusy(resource);
    const res = await adjustResource(c.id, resource, delta, form.id);
    setBusy(null);
    if (!res.ok) {
      state.setForm(resource === "pv" ? { pv_current: cur } : { pc_current: cur });
      return toast(res.error, "error");
    }
    state.setForm(resource === "pv" ? { pv_current: res.data!.value } : { pc_current: res.data!.value });
  }

  function save() {
    start(async () => {
      const res = await updateResources(c.id, draft, form.id);
      if (!res.ok) return toast(res.error, "error");
      state.refresh();
      state.setForm({ ...draft });
      setEditing(false);
      toast(res.message ?? "Salvo.");
    });
  }

  const b = r.breakdown;

  return (
    <EditableSection
      title="Recursos"
      canEdit={state.canEdit}
      editing={editing}
      saving={saving}
      onEdit={() => {
        setDraft({ pv_current: form.pv_current, pc_current: form.pc_current, pv_other_bonus: form.pv_other_bonus, pc_other_bonus: form.pc_other_bonus });
        setEditing(true);
      }}
      onCancel={() => setEditing(false)}
      onSave={save}
      hint="PV/PC atuais ficam limitados ao máximo. “Bônus no máximo” soma ao valor calculado pelas regras."
    >
      <LevelControl state={state} />

      {editing ? (
        <div className="grid grid-cols-2 gap-4">
          {(["pv", "pc"] as const).map((k) => (
            <fieldset key={k} className="space-y-2">
              <legend className="label-mono mb-1 text-holo">{k.toUpperCase()}</legend>
              <label className="block text-xs text-fg-dim">
                Atual
                <NumberCell label={`${k.toUpperCase()} atual`} min={0} max={9999} value={draft[`${k}_current`]} onChange={(v) => setDraft({ ...draft, [`${k}_current`]: v })} />
              </label>
              <label className="block text-xs text-fg-dim">
                Bônus no máximo
                <NumberCell label={`Bônus no ${k.toUpperCase()} máximo`} min={-9999} max={9999} value={draft[`${k}_other_bonus`]} onChange={(v) => setDraft({ ...draft, [`${k}_other_bonus`]: v })} />
              </label>
            </fieldset>
          ))}
        </div>
      ) : (
        <div className="space-y-4">
          {(["pv", "pc"] as const).map((k) => (
            <div key={k} className="flex items-end gap-2">
              <div className="flex-1">
                <ResourceBar short={k.toUpperCase()} label={k === "pv" ? "Pontos de Vida" : "Pontos de Consumo"} current={k === "pv" ? r.pvCurrent : r.pcCurrent} max={k === "pv" ? r.pvMax : r.pcMax} tone={k} />
              </div>
              {state.canEdit && (
                <div className="flex gap-1">
                  <button
                    onClick={() => nudge(k, -1)}
                    disabled={busy !== null}
                    aria-label={`Diminuir ${k.toUpperCase()} em 1`}
                    className="rounded-sm border border-line p-1.5 text-fg-dim hover:border-alert hover:text-alert disabled:opacity-40"
                  >
                    <Minus className="h-3.5 w-3.5" />
                  </button>
                  <button
                    onClick={() => nudge(k, 1)}
                    disabled={busy !== null}
                    aria-label={`Aumentar ${k.toUpperCase()} em 1`}
                    className="rounded-sm border border-line p-1.5 text-fg-dim hover:border-cyan hover:text-cyan disabled:opacity-40"
                  >
                    <Plus className="h-3.5 w-3.5" />
                  </button>
                </div>
              )}
            </div>
          ))}
          <details className="text-xs text-fg-muted">
            <summary className="cursor-pointer hover:text-fg-dim">Como o máximo é calculado</summary>
            <p className="mt-2 font-mono">
              PV {r.pvMax} = {b.pvFromAttrs} (FOR + CON÷3){b.classPv ? ` + ${b.classPv} (classe)` : ""}
              {b.levelPv ? ` + ${b.levelPv} (níveis)` : ""}
              {b.otherPv ? ` ${b.otherPv > 0 ? "+" : "−"} ${Math.abs(b.otherPv)} (bônus)` : ""}
            </p>
            <p className="font-mono">
              PC {r.pcMax} = {b.pcFromAttrs} (VIG÷3){b.levelPc ? ` + ${b.levelPc} (níveis)` : ""}
              {b.otherPc ? ` ${b.otherPc > 0 ? "+" : "−"} ${Math.abs(b.otherPc)} (bônus)` : ""}
            </p>
          </details>
        </div>
      )}
    </EditableSection>
  );
}
