"use client";

import { useState, useTransition } from "react";
import { AlertTriangle, Loader2 } from "lucide-react";
import { useToast } from "@/components/ui/Toast";
import { SKILLS } from "@/rules/data/skills.ts";
import { thresholds } from "@/rules/d100.ts";
import type { ComputedSheet } from "@/rules/sheet.ts";
import { updateSkills } from "../actions";
import { EditableSection, NumberCell } from "./EditableSection";
import type { SheetState } from "./Sheet";

type Row = { skill_id: string; points: number; other_bonus: number; temp_bonus: number };
const GROUP_LABEL = { lutar: "Lutar", outros: "Outros" } as const;

export function SkillsSection({ state, sheet, onRoll, rolling }: { state: SheetState; sheet: ComputedSheet; onRoll: (id: string) => void; rolling: string | null }) {
  const toast = useToast();
  const [editing, setEditing] = useState(false);
  const [rows, setRows] = useState<Row[]>([]);
  const [saving, start] = useTransition();

  function beginEdit() {
    setRows(sheet.skills.map((s) => ({ skill_id: s.id, points: s.points, other_bonus: s.other, temp_bonus: s.temporary })));
    setEditing(true);
  }

  function save() {
    start(async () => {
      const res = await updateSkills(state.character.id, rows, state.form.id);
      if (!res.ok) return toast(res.error, "error");
      state.setForm({ skills: rows.map((r) => ({ ...r })) });
      setEditing(false);
      toast(res.message ?? "Perícias salvas.");
    });
  }

  return (
    <EditableSection
      title="Perícias"
      canEdit={state.canEdit}
      editing={editing}
      saving={saving}
      onEdit={beginEdit}
      onCancel={() => setEditing(false)}
      onSave={save}
      hint={`Limite do VALOR TOTAL de cada perícia: ${sheet.skills[0]?.cap ?? 75} (base + pontos + classe + outros; temporário não conta). Valores antigos acima do limite podem ser reduzidos, nunca aumentados.`}
    >
      {editing ? (
        <div className="overflow-x-auto">
          <table className="w-full min-w-[24rem] text-sm">
            <thead>
              <tr className="text-left">
                {["Perícia", "Base", "Pontos", "Classe", "Outros", "Temp.", "Total / limite"].map((h) => (
                  <th key={h} className="label-mono pb-2 font-normal">
                    {h}
                  </th>
                ))}
              </tr>
            </thead>
            <tbody>
              {rows.map((r, i) => {
                const s = sheet.skills.find((x) => x.id === r.skill_id)!;
                const set = (patch: Partial<Row>) => setRows(rows.map((x, j) => (j === i ? { ...x, ...patch } : x)));
                return (
                  <tr key={r.skill_id}>
                    <th scope="row" className="pr-2 text-left font-normal text-fg">
                      {s.name}
                    </th>
                    <td className="p-1 text-center font-mono text-fg-dim">{s.base}</td>
                    <td className="p-1"><NumberCell label={`${s.name} pontos`} min={0} max={200} value={r.points} onChange={(v) => set({ points: v })} /></td>
                    <td className="p-1 text-center font-mono text-cyan">{s.classBonus ? `+${s.classBonus}` : "—"}</td>
                    <td className="p-1"><NumberCell label={`${s.name} outros`} min={-100} max={100} value={r.other_bonus} onChange={(v) => set({ other_bonus: v })} /></td>
                    <td className="p-1"><NumberCell label={`${s.name} temporário`} min={-100} max={100} value={r.temp_bonus} onChange={(v) => set({ temp_bonus: v })} /></td>
                    {(() => {
                      const capTotal = s.permanentBase + r.points + s.classBonus + r.other_bonus;
                      const over = capTotal > s.cap;
                      const room = Math.max(0, s.cap - (s.permanentBase + s.classBonus + r.other_bonus));
                      return (
                        <td className="p-1 text-center font-mono">
                          <span className={over ? "text-alert" : "text-fg"}>{capTotal}</span>
                          <span className="text-fg-muted">/{s.cap}</span>
                          <span className={`block text-[0.6rem] ${over ? "text-alert" : "text-fg-muted"}`}>{over ? "acima do limite" : `até ${room} pts`}</span>
                        </td>
                      );
                    })()}
                  </tr>
                );
              })}
            </tbody>
          </table>
        </div>
      ) : (
        <>
        {sheet.skillCheck.overCap.length > 0 && (
          <p role="alert" className="mb-3 flex items-start gap-2 border border-alert/50 bg-alert/10 px-3 py-2 text-xs text-alert">
            <AlertTriangle className="mt-0.5 h-3.5 w-3.5 shrink-0" aria-hidden />
            <span>
              Distribuição inválida: {sheet.skills.filter((x) => x.overCap).map((x) => `${x.name} (${x.capTotal}/${x.cap})`).join(", ")}. Use o lápis para
              corrigir — os pontos não foram apagados.
            </span>
          </p>
        )}
        <div className="grid gap-4 sm:grid-cols-2">
          {(["lutar", "outros"] as const).map((g) => (
            <div key={g}>
              <h3 className="mb-1 border-b border-primary-deep/60 pb-1 font-display text-xs tracking-[0.25em] text-holo uppercase">{GROUP_LABEL[g]}</h3>
              <ul>
                {SKILLS.filter((s) => s.group === g).map((def) => {
                  const s = sheet.skills.find((x) => x.id === def.id)!;
                  const t = thresholds(s.final);
                  const key = `skill:${s.id}`;
                  return (
                    <li key={s.id}>
                      <button
                        onClick={() => onRoll(s.id)}
                        disabled={!state.canEdit || rolling !== null}
                        aria-label={`${s.name}: ${t.normal} / ${t.good} / ${t.extreme}. ${state.canEdit ? "Rolar teste." : ""}`}
                        className="flex w-full items-center justify-between gap-2 rounded-sm px-2 py-1.5 text-left text-sm transition-colors enabled:hover:bg-primary-deep/15 disabled:cursor-default"
                      >
                        <span className={`flex items-center gap-1.5 ${s.points > 0 || s.classBonus ? "text-fg" : "text-fg-dim"}`}>
                          {rolling === key && <Loader2 className="h-3 w-3 animate-spin text-cyan" aria-hidden />}
                          {s.name}
                          {s.temporary !== 0 && <span className="font-mono text-[0.6rem] text-cyan">({s.temporary > 0 ? "+" : ""}{s.temporary})</span>}
                          {s.overCap && <span className="font-mono text-[0.6rem] text-alert">acima do limite</span>}
                        </span>
                        <span className="font-mono text-fg">
                          {t.normal}
                          <span className="text-fg-muted"> / {t.good} / {t.extreme}</span>
                        </span>
                      </button>
                    </li>
                  );
                })}
              </ul>
            </div>
          ))}
        </div>
        </>
      )}
    </EditableSection>
  );
}
