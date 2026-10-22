"use client";

import { Minus, Plus } from "lucide-react";
import { SKILLS } from "@/rules/data/skills.ts";
import { CLASS_BY_ID } from "@/rules/data/classes.ts";
import { formatThresholds } from "@/rules/d100.ts";
import { buildSheet, type StoredForm } from "@/rules/sheet.ts";

interface Props {
  classId: string | null;
  form: StoredForm;
  onChange: (points: Record<string, number>) => void;
}

const GROUP_LABEL = { lutar: "Lutar", outros: "Outros" } as const;

export function StepSkills({ classId, form, onChange }: Props) {
  const points: Record<string, number> = Object.fromEntries(SKILLS.map((s) => [s.id, form.skills.find((x) => x.skill_id === s.id)?.points ?? 0]));
  // A ficha calculada já traz, por perícia: base permanente, bônus de classe, limite total e pontos máximos.
  const sheet = buildSheet({ classId, originId: null, level: 1, form });
  const check = sheet.skillCheck;
  const { budget } = check;
  const applyClass = form.kind === "base";
  const cls = applyClass && classId ? CLASS_BY_ID[classId] : undefined;
  const rowOf = (id: string) => sheet.skills.find((x) => x.id === id)!;

  function set(id: string, raw: number) {
    const v = Math.max(0, Math.min(rowOf(id).maxPoints, Number.isFinite(raw) ? Math.trunc(raw) : 0));
    onChange({ ...points, [id]: v });
  }

  const chosenCount = check.chosen.length;
  const canChooseMore = chosenCount < budget.skillsToChoose;

  return (
    <div className="space-y-6">
      <div>
        <h2 className="text-2xl text-fg">Perícias</h2>
        <p className="mt-1 max-w-2xl text-sm text-fg-dim">
          Escolha {budget.skillsToChoose} perícias e distribua {budget.totalPoints} pontos. O valor TOTAL de cada perícia (base + pontos +
          bônus{applyClass ? " de classe" : ""}) não pode passar de {budget.maxSkillTotal}. Bônus de classe não gastam pontos, mas contam para o limite.
        </p>
      </div>

      <div className="hud-panel sticky top-20 z-10 bg-panel/95 grid grid-cols-3 gap-2 px-4 py-4 text-center sm:px-6" aria-live="polite">
        <div>
          <span className="label-mono block">Pontos restantes</span>
          <span className={`font-display text-2xl ${check.remaining < 0 ? "text-alert" : check.remaining === 0 ? "text-ok" : "text-cyan"}`}>
            {check.remaining}
          </span>
          <span className="font-mono text-xs text-fg-muted"> / {budget.totalPoints}</span>
        </div>
        <div>
          <span className="label-mono block">Perícias</span>
          <span className={`font-display text-2xl ${chosenCount > budget.skillsToChoose ? "text-alert" : "text-fg"}`}>{chosenCount}</span>
          <span className="font-mono text-xs text-fg-muted"> / {budget.skillsToChoose}</span>
        </div>
        <div>
          <span className="label-mono block">Total máx. da perícia</span>
          <span className="font-display text-2xl text-fg">{budget.maxSkillTotal}</span>
        </div>
        <div className="col-span-3 mt-1">
          <div
            className="relative h-2 overflow-hidden border border-line bg-panel-3"
            role="meter"
            aria-label="Pontos distribuídos"
            aria-valuemin={0}
            aria-valuemax={budget.totalPoints}
            aria-valuenow={check.spent}
          >
            <div
              className={`h-full transition-[width] duration-300 ${check.spent > budget.totalPoints ? "bg-alert" : "bg-gradient-to-r from-primary to-cyan shadow-[0_0_10px_var(--color-holo)]"}`}
              style={{ width: `${Math.min(100, (check.spent / budget.totalPoints) * 100)}%` }}
            />
          </div>
          <p className="mt-1 text-right font-mono text-[0.6rem] tracking-[0.2em] text-fg-muted uppercase">
            {check.spent} / {budget.totalPoints} distribuídos
          </p>
        </div>
      </div>

      {check.errors.length > 0 && (
        <ul role="alert" className="space-y-1 rounded-sm border border-alert/50 bg-alert/10 px-4 py-3 text-sm text-alert">
          {check.errors.map((e) => (
            <li key={e}>{e}</li>
          ))}
        </ul>
      )}
      {cls && Object.keys(cls.skillBonus).length > 0 && (
        <p className="text-sm text-fg-dim">
          {cls.name}: {cls.benefit.text} — o bônus aparece na coluna “Classe” e não ocupa uma das {budget.skillsToChoose} escolhas.
        </p>
      )}

      {(["lutar", "outros"] as const).map((group) => (
        <div key={group} className="hud-panel overflow-hidden">
          <h3 className="border-b border-line bg-panel-3/60 px-5 py-3 font-display text-sm tracking-[0.2em] text-holo uppercase">{GROUP_LABEL[group]}</h3>
          <div className="hidden grid-cols-[1fr_3.5rem_9rem_3.5rem_7rem_6rem] gap-3 px-5 pt-3 sm:grid">
            {["Perícia", "Base", "Pontos", "Classe", "Total", "Espaço"].map((h) => (
              <span key={h} className="label-mono">
                {h}
              </span>
            ))}
          </div>
          <ul className="divide-y divide-line">
            {SKILLS.filter((s) => s.group === group).map((s) => {
              const row = rowOf(s.id);
              const p = points[s.id];
              const room = row.maxPoints - p;
              const locked = p === 0 && !canChooseMore;
              return (
                <li key={s.id} className={`grid grid-cols-2 items-center gap-3 px-5 py-3 sm:grid-cols-[1fr_3.5rem_9rem_3.5rem_7rem_6rem] ${p > 0 ? "bg-primary-deep/10" : ""}`}>
                  <div className="col-span-2 sm:col-span-1">
                    <span className="text-fg">{s.name}</span>
                    <span className="ml-2 font-mono text-xs text-fg-muted">({s.sheetLabel})</span>
                  </div>
                  <span className="font-mono text-fg-dim">
                    <span className="label-mono mr-1 sm:hidden">Base</span>
                    {row.base}
                  </span>
                  <div className="flex items-center gap-1">
                    <button
                      type="button"
                      onClick={() => set(s.id, p - 5)}
                      disabled={p === 0}
                      aria-label={`Tirar 5 pontos de ${s.name}`}
                      className="rounded-sm border border-line p-1.5 text-fg-dim hover:border-cyan hover:text-cyan disabled:opacity-30"
                    >
                      <Minus className="h-3 w-3" />
                    </button>
                    <input
                      type="number"
                      inputMode="numeric"
                      min={0}
                      max={row.maxPoints}
                      step={1}
                      value={p}
                      disabled={locked}
                      onChange={(e) => set(s.id, Number(e.target.value))}
                      aria-label={`Pontos em ${s.name}`}
                      className="field-input w-16 px-2 py-1 text-center font-mono disabled:opacity-40"
                    />
                    <button
                      type="button"
                      onClick={() => set(s.id, p + 5)}
                      disabled={locked || p >= row.maxPoints}
                      aria-label={`Adicionar 5 pontos em ${s.name}`}
                      className="rounded-sm border border-line p-1.5 text-fg-dim hover:border-cyan hover:text-cyan disabled:opacity-30"
                    >
                      <Plus className="h-3 w-3" />
                    </button>
                  </div>
                  <span className={`font-mono ${row.classBonus ? "text-cyan" : "text-fg-muted"}`}>
                    <span className="label-mono mr-1 sm:hidden">Classe</span>
                    {row.classBonus ? `+${row.classBonus}` : "—"}
                  </span>
                  <span className={`font-mono sm:col-span-1 ${row.overCap ? "text-alert" : "text-fg"}`}>
                    <span className="label-mono mr-1 sm:hidden">Total</span>
                    {row.capTotal}
                    <span className="text-fg-muted">/{row.cap}</span>
                    <span className="block text-[0.6rem] text-fg-muted">{formatThresholds(row.final)}</span>
                  </span>
                  <span className={`font-mono text-xs ${row.overCap ? "text-alert" : room === 0 ? "text-ok" : "text-fg-dim"}`}>
                    <span className="label-mono mr-1 sm:hidden">Espaço</span>
                    {row.overCap ? "acima do limite" : `+${room} pts`}
                  </span>
                </li>
              );
            })}
          </ul>
        </div>
      ))}
      <p className="text-xs text-fg-muted">
        Conhecimento Bélico usa metade de INT (a ficha traz “1/INT”, notação ambígua — regra configurável no motor). As alterações são salvas
        automaticamente.
      </p>
    </div>
  );
}
