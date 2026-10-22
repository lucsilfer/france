"use client";

import { useEffect, useState } from "react";
import { BookOpen, Feather, LockOpen, Sparkles } from "lucide-react";
import { Field } from "@/components/ui/Field";
import { SaveIndicator } from "@/components/SaveIndicator";
import { combineStatus, useAutosave } from "@/components/useAutosave";
import { ClassDetails } from "@/components/sheet/ClassDetails";
import { TraitList } from "@/components/sheet/TraitList";
import { CLASS_BY_ID } from "@/rules/data/classes.ts";
import { originTraitsWithStatus } from "@/rules/sheet.ts";
import { levelUnlocks } from "@/rules/unlocks.ts";
import { saveFormIdentity, saveText } from "../actions";
import type { SheetState } from "./Sheet";
import { QuickTab } from "./panel/QuickTab";
import { InventoryTab } from "./panel/InventoryTab";
import { PowersTab } from "./panel/PowersTab";

export type Tab = "rapido" | "inventario" | "habilidades" | "poderes" | "descricao";

const TAB_IDS: Tab[] = ["rapido", "inventario", "habilidades", "poderes", "descricao"];
const TAB_KEY = "france:sheet-tab";

export function RightPanel({ state }: { state: SheetState }) {
  const { tab, setTab: setTabState, abilities, powersTab } = state;
  const TABS: { id: Tab; label: string }[] = [
    { id: "rapido", label: "Inventário Rápido" },
    { id: "inventario", label: "Inventário" },
    { id: "habilidades", label: "Habilidades de Classe" },
    { id: "poderes", label: powersTab.label },
    { id: "descricao", label: "Descrição" },
  ];
  // Abas já abertas continuam montadas (escondidas): voltar a elas é instantâneo e não perde o que estava aberto.
  const [visited, setVisited] = useState<ReadonlySet<Tab>>(() => new Set([tab]));
  useEffect(() => {
    setVisited((v) => (v.has(tab) ? v : new Set(v).add(tab)));
  }, [tab]);
  // Lembra a última aba (conveniência por navegador; lido após montar para não divergir do servidor).
  useEffect(() => {
    try {
      const saved = window.localStorage.getItem(TAB_KEY) as Tab | null;
      if (saved && TAB_IDS.includes(saved)) setTabState(saved);
    } catch {
      // armazenamento indisponível
    }
    // eslint-disable-next-line react-hooks/exhaustive-deps
  }, []);
  function setTab(t: Tab) {
    setTabState(t);
    try {
      window.localStorage.setItem(TAB_KEY, t);
    } catch {
      // armazenamento indisponível: só não lembra a aba
    }
  }

  function onKey(e: React.KeyboardEvent) {
    if (e.key !== "ArrowRight" && e.key !== "ArrowLeft") return;
    e.preventDefault();
    const i = TAB_IDS.indexOf(tab);
    const next = TAB_IDS[(i + (e.key === "ArrowRight" ? 1 : TAB_IDS.length - 1)) % TAB_IDS.length];
    setTab(next);
    document.getElementById(`sheet-tab-${next}`)?.focus();
  }

  const pending = abilities.mode === "standard" ? abilities.available : 0;

  return (
    <div className="hud-panel">
      {pending > 0 && (
        <button
          onClick={() => setTab("poderes")}
          className="flex w-full items-center justify-between gap-3 border-b border-holo/50 bg-primary/10 px-5 py-2.5 text-left hover:bg-primary/15"
        >
          <span className="flex items-center gap-2 font-mono text-[0.68rem] tracking-[0.2em] text-cyan uppercase">
            <Sparkles className="h-3.5 w-3.5" aria-hidden />
            {pending} {pending === 1 ? `${powersTab.singular} disponível` : `${powersTab.plural} disponíveis`}
          </span>
          <span className="font-mono text-[0.6rem] tracking-[0.15em] text-fg-dim uppercase">Abrir →</span>
        </button>
      )}
      <div role="tablist" aria-label="Painel da ficha" className="flex overflow-x-auto border-b border-line">
        {TABS.map((t) => {
          const active = tab === t.id;
          return (
            <button
              key={t.id}
              id={`sheet-tab-${t.id}`}
              role="tab"
              aria-selected={active}
              aria-controls={`sheet-panel-${t.id}`}
              tabIndex={active ? 0 : -1}
              onClick={() => setTab(t.id)}
              onKeyDown={onKey}
              className={`relative flex shrink-0 items-center gap-1.5 px-4 py-3 font-mono text-[0.65rem] tracking-[0.15em] uppercase transition-colors ${active ? "text-fg" : "text-fg-muted hover:text-fg-dim"}`}
            >
              {t.label}
              {t.id === "poderes" && pending > 0 && (
                <span className="rounded-full bg-primary px-1.5 font-mono text-[0.58rem] text-fg" aria-label={`${pending} disponíveis`}>
                  {pending}
                </span>
              )}
              {active && <span className="absolute inset-x-2 -bottom-px h-0.5 bg-cyan shadow-[0_0_8px_var(--color-cyan)]" />}
            </button>
          );
        })}
      </div>
      {TAB_IDS.filter((id) => visited.has(id) || id === tab).map((id) => (
        <div key={id} id={`sheet-panel-${id}`} role="tabpanel" aria-labelledby={`sheet-tab-${id}`} hidden={id !== tab} className="p-5">
          {id === "rapido" && <QuickTab state={state} goTo={setTab} />}
          {id === "inventario" && <InventoryTab state={state} />}
          {id === "habilidades" && <AbilitiesTab state={state} />}
          {id === "poderes" && <PowersTab state={state} />}
          {id === "descricao" && <DescriptionTab state={state} />}
        </div>
      ))}
    </div>
  );
}

function AbilitiesTab({ state }: { state: SheetState }) {
  const { character: c } = state;
  const cls = c.class_id ? CLASS_BY_ID[c.class_id] : undefined;
  const { origin, path, traits } = originTraitsWithStatus(c.origin_id, c.origin_path_id, c.level);
  const unlocks = levelUnlocks(c.origin_id, c.origin_path_id, c.level);
  return (
    <div className="space-y-8">
      {unlocks.length > 0 && (
        <section className="border border-holo/40 bg-primary/5 p-4">
          <p className="label-mono mb-2 flex items-center gap-1.5 text-cyan">
            <LockOpen className="h-3.5 w-3.5" aria-hidden /> Desbloqueios no nível {c.level}
          </p>
          <ul className="space-y-2">
            {unlocks.map((u) => (
              <li key={u.label} className="text-sm">
                <span className="text-fg">{u.label}:</span> <span className="text-cyan">{u.value}</span>
                <span className="block text-xs text-fg-muted">{u.basis}</span>
              </li>
            ))}
          </ul>
        </section>
      )}
      {state.isLenda && <p className="text-xs text-fg-muted">A forma Lenda não recebe os bônus de classe; as habilidades abaixo valem para a forma humana.</p>}
      {cls && (
        <section>
          <p className="label-mono">Classe</p>
          <h2 className="mb-3 flex items-center gap-2 text-xl text-holo">
            <BookOpen className="h-4 w-4" aria-hidden /> {cls.name}
          </h2>
          <ClassDetails cls={cls} />
        </section>
      )}
      {origin && (
        <section>
          <p className="label-mono">Origem</p>
          <h2 className="mb-3 flex items-center gap-2 text-xl text-holo">
            <Feather className="h-4 w-4" aria-hidden /> {origin.name}
            {path && <span className="text-base text-cyan-dim">· {path.name}</span>}
          </h2>
          {origin.description.map((p, i) => (
            <p key={i} className="mb-3 text-sm leading-relaxed text-fg-dim">
              {p}
            </p>
          ))}
          <TraitList traits={traits} level={c.level} />
        </section>
      )}
    </div>
  );
}

const TEXT_FIELDS = [
  { id: "story", label: "História", rows: 8 },
  { id: "appearance", label: "Descrição física", rows: 5 },
  { id: "extra_info", label: "Informações adicionais", rows: 4 },
  { id: "personal_notes", label: "Anotações pessoais", rows: 6 },
] as const;

function DescriptionTab({ state }: { state: SheetState }) {
  const { character: c, lenda } = state;
  const hasLenda = Boolean(lenda?.setup_complete);
  // Estado próprio: o texto em edição não é sobrescrito por atualizações de outras seções.
  const [values, setValues] = useState(() => ({ story: c.story, appearance: c.appearance, extra_info: c.extra_info, personal_notes: c.personal_notes }));
  const [lendaValues, setLendaValues] = useState(() => ({ description: lenda?.description ?? "", special_rules: lenda?.special_rules ?? "" }));
  const savers = {
    story: useAutosave((v: string) => saveText(c.id, "story", v), 900),
    appearance: useAutosave((v: string) => saveText(c.id, "appearance", v), 900),
    extra_info: useAutosave((v: string) => saveText(c.id, "extra_info", v), 900),
    personal_notes: useAutosave((v: string) => saveText(c.id, "personal_notes", v), 900),
  };
  const lendaSavers = {
    description: useAutosave((v: string) => (lenda ? saveFormIdentity(c.id, lenda.id, { description: v }) : Promise.resolve({ ok: true as const })), 900),
    special_rules: useAutosave((v: string) => (lenda ? saveFormIdentity(c.id, lenda.id, { special_rules: v }) : Promise.resolve({ ok: true as const })), 900),
  };
  const all = [...Object.values(savers), ...Object.values(lendaSavers)];
  const status = combineStatus(...all.map((s) => s.status));
  const error = all.find((s) => s.error)?.error;

  const textarea = (value: string, rows: number, onChange: (v: string) => void, max = 20000) => (
    <textarea rows={rows} readOnly={!state.canEdit} maxLength={max} value={value} onChange={(e) => onChange(e.target.value)} className="field-input resize-y leading-relaxed" />
  );

  return (
    <div className="space-y-5">
      <div className="flex justify-end">
        <SaveIndicator status={status} error={error} />
      </div>
      {TEXT_FIELDS.map((f) => (
        <Field key={f.id} label={f.id === "appearance" && hasLenda ? "Descrição física — forma humana" : f.label}>
          {textarea(values[f.id], f.rows, (v) => {
            setValues((all) => ({ ...all, [f.id]: v }));
            savers[f.id].schedule(v);
          })}
        </Field>
      ))}
      {hasLenda && lenda && (
        <section className="space-y-5 border-t border-holo/40 pt-5">
          <p className="label-mono text-cyan">Forma Lenda{lenda.name ? ` — ${lenda.name}` : ""}</p>
          <Field label="Descrição física — Lenda">
            {textarea(lendaValues.description, 5, (v) => {
              setLendaValues((all) => ({ ...all, description: v }));
              lendaSavers.description.schedule(v);
            }, 10000)}
          </Field>
          <Field label="Informações da Lenda">
            {textarea(lendaValues.special_rules, 4, (v) => {
              setLendaValues((all) => ({ ...all, special_rules: v }));
              lendaSavers.special_rules.schedule(v);
            }, 10000)}
          </Field>
        </section>
      )}
    </div>
  );
}
