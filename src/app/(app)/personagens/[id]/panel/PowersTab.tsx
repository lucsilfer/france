"use client";

import { useEffect, useMemo, useRef, useState, useTransition } from "react";
import { AlertTriangle, ChevronDown, Cog, Gem, Pencil, Plus, Star, Swords, Trash2, X, Zap } from "lucide-react";
import { Button } from "@/components/ui/Button";
import { ConfirmDialog } from "@/components/ui/ConfirmDialog";
import { Field } from "@/components/ui/Field";
import { Modal } from "@/components/ui/Modal";
import { useToast } from "@/components/ui/Toast";
import type { PowerRow } from "@/lib/character";
import { isContinuous } from "@/rules/combat.ts";
import {
  BUFFS,
  CONDITIONS,
  DAMAGE_AREA,
  DAMAGE_AREA_SIZES,
  DAMAGE_SINGLE,
  HEAL_AREA_MODIFIER,
  HEAL_CONTINUOUS,
  HEAL_SINGLE,
  SHIELD,
  SHIELD_DURATION,
} from "@/rules/data/powerTables.ts";
import { computePowerCost, type AreaChoice, type PowerComponent } from "@/rules/powers.ts";
import { TechniquesPanel } from "./TechniquesPanel";
import { deletePower, savePower, setQuickAccess, type PowerInput } from "../../inventory-actions";
import type { SheetState } from "../Sheet";
import { ActiveEffects, UsePowerButton } from "./actions-ui";

const THEME_ICON = { default: Zap, arsenal: Swords, engrenagem: Cog, pacto: Gem } as const;

export function PowersTab({ state }: { state: SheetState }) {
  const [creating, setCreating] = useState(false);
  const { abilities: ab, powersTab: info } = state;
  const Icon = THEME_ICON[info.theme];
  // Pedido externo (ex.: "Abrir criador" no bloqueio de evolução).
  const lastRequest = useRef(state.creatorRequest);
  useEffect(() => {
    if (state.creatorRequest !== lastRequest.current) {
      lastRequest.current = state.creatorRequest;
      if (state.canEdit && ab.canCreate) setCreating(true);
    }
  }, [state.creatorRequest, state.canEdit, ab.canCreate]);

  return (
    <div className="space-y-4" data-powers-theme={info.theme}>
      <ActiveEffects state={state} />
      <header className="flex flex-wrap items-start justify-between gap-3">
        <div className="min-w-0">
          <h2 className="flex items-center gap-2 text-lg tracking-[0.08em] text-holo uppercase">
            <Icon className="h-4 w-4" aria-hidden /> {info.label}
          </h2>
          <p className="mt-1 max-w-md text-xs text-fg-dim">{info.description}</p>
        </div>
        {state.canEdit && (
          <Button size="sm" onClick={() => setCreating(true)} disabled={!ab.canCreate} title={ab.canCreate ? undefined : "Sem vagas disponíveis neste nível"}>
            <Plus className="h-3.5 w-3.5" aria-hidden /> {info.newLabel}
          </Button>
        )}
      </header>
      <AbilityMeter state={state} />
      {info.theme === "arsenal" && <TechniquesPanel state={state} />}
      {info.theme === "arsenal" && (
        <p className="label-mono pt-2">
          Técnicas personalizadas (criadas com o Mestre) <span className="text-fg">({state.powers.length})</span>
        </p>
      )}
      {state.powers.length === 0 ? (
        <p className="border border-dashed border-line p-6 text-center text-sm text-fg-muted">Nada criado ainda. {info.description}</p>
      ) : (
        <ul className="space-y-2">
          {state.powers.map((p) => (
            <PowerCard key={p.id} state={state} power={p} />
          ))}
        </ul>
      )}
      {state.isLenda && <p className="text-xs text-fg-muted">Os poderes são compartilhados entre as formas; o PC gasto é o da forma ativa.</p>}
      {creating && <PowerCreator state={state} onClose={() => setCreating(false)} />}
    </div>
  );
}

/** Vagas: adquiridas no nível, criadas e disponíveis (regra geral, Caminho do Prodígio, Elo e Muto). */
function AbilityMeter({ state }: { state: SheetState }) {
  const { abilities: ab, powersTab: info, character: c } = state;
  if (ab.mode === "free")
    return <p className="border border-line/60 px-3 py-2 text-xs text-fg-dim">Elo: cria {info.plural} quando quiser — sem limite de vagas e sem bloqueio de evolução.</p>;
  if (ab.mode === "none")
    return (
      <p className="border border-line/60 px-3 py-2 text-xs text-fg-dim">
        Muto não usa o sistema convencional de {info.plural}: a progressão segue a Mutação Adaptativa. Registros aqui não ocupam vagas nem bloqueiam a evolução.
      </p>
    );
  return (
    <div className="flex flex-wrap items-center gap-x-5 gap-y-1 border border-line/60 px-3 py-2 font-mono text-[0.64rem] tracking-[0.12em] text-fg-dim uppercase">
      <span>
        Adquiridas (nível {c.level}): <span className="text-fg">{ab.granted}</span>
      </span>
      <span>
        Criadas: <span className="text-fg">{ab.created}</span>
      </span>
      <span>
        Disponíveis: <span className={ab.available > 0 ? "text-cyan" : "text-fg"}>{ab.available}</span>
      </span>
      {ab.rule.source !== "Regra geral" && <span className="text-fg-muted normal-case tracking-normal">({ab.rule.source})</span>}
    </div>
  );
}

function PowerCard({ state, power }: { state: SheetState; power: PowerRow }) {
  const toast = useToast();
  const [open, setOpen] = useState(false);
  const [editing, setEditing] = useState(false);
  const [confirm, setConfirm] = useState(false);
  const [pending, start] = useTransition();
  const cid = state.character.id;
  // O custo exibido é sempre recalculado pelo nível atual (o banco também recalcula ao salvar).
  const cost = useMemo(() => computePowerCost(power.components, state.character.level, state.character.origin_id), [power.components, state.character.level, state.character.origin_id]);

  function quick(v: boolean) {
    const patch = (value: boolean) => state.setPowers((list) => list.map((p) => (p.id === power.id ? { ...p, quick_access: value } : p)));
    patch(v);
    void setQuickAccess(cid, "power", power.id, v).then((res) => {
      if (!res.ok) {
        patch(!v);
        toast(res.error, "error");
      }
    });
  }

  return (
    <li className={`border bg-panel-2/40 ${open ? "border-holo/60" : "border-line/70"}`}>
      <div className="flex items-center gap-2 px-3 py-2">
        {state.canEdit && (
          <label className="flex shrink-0 cursor-pointer items-center" title="Inventário Rápido">
            <input type="checkbox" className="sr-only" checked={power.quick_access} onChange={(e) => quick(e.target.checked)} aria-label={`${power.name} no Inventário Rápido`} />
            <Star className={`h-4 w-4 ${power.quick_access ? "fill-cyan text-cyan" : "text-fg-muted hover:text-fg-dim"}`} aria-hidden />
          </label>
        )}
        <button onClick={() => setOpen((o) => !o)} aria-expanded={open} className="flex min-w-0 flex-1 items-center gap-2 text-left">
          <span className="truncate text-sm text-fg">{power.name}</span>
          {!state.noPc && <span className="shrink-0 font-mono text-[0.65rem] text-cyan">{power.initial_cost} PC</span>}
          {power.per_turn_cost > 0 && <span className="shrink-0 font-mono text-[0.62rem] text-holo">+{power.per_turn_cost}/T</span>}
          {!cost.valid && <AlertTriangle className="h-3.5 w-3.5 shrink-0 text-alert" aria-label="Acima do limite atual" />}
          <ChevronDown className={`ml-auto h-4 w-4 shrink-0 text-fg-muted transition-transform ${open ? "rotate-180" : ""}`} aria-hidden />
        </button>
        <UsePowerButton state={state} power={power} />
      </div>
      {open && (
        <div className="space-y-2 border-t border-line/60 px-3 py-3 text-sm">
          {power.description && <p className="whitespace-pre-line text-fg-dim">{power.description}</p>}
          <dl className="grid grid-cols-2 gap-2 text-xs sm:grid-cols-4">
            {power.ability_type && <Info label="Tipo" value={power.ability_type} />}
            {power.target && <Info label="Alvo" value={power.target} />}
            {power.range && <Info label="Alcance" value={power.range} />}
            {power.duration && <Info label="Duração" value={power.duration} />}
          </dl>
          <ul className="space-y-1 text-xs text-fg-dim">
            {cost.components.map((c, i) => (
              <li key={i}>
                <span className="text-fg">{c.label}</span>
                {c.dice && <span className="ml-1 font-mono text-cyan">{c.dice}</span>} — {c.details.join(" · ")}
              </li>
            ))}
          </ul>
          {cost.bonusDamageDice && <p className="text-xs text-cyan-dim">Amaldiçoado: +{cost.bonusDamageDice} de dano.</p>}
          {!cost.valid && <p className="text-xs text-alert">{cost.errors.join(" ")}</p>}
          {state.canEdit && (
            <div className="flex justify-end gap-2 pt-2">
              <Button size="sm" variant="secondary" onClick={() => setEditing(true)}>
                <Pencil className="h-3.5 w-3.5" aria-hidden /> Editar
              </Button>
              <Button size="sm" variant="danger" onClick={() => setConfirm(true)}>
                <Trash2 className="h-3.5 w-3.5" aria-hidden /> Excluir
              </Button>
            </div>
          )}
        </div>
      )}
      {editing && <PowerCreator state={state} power={power} onClose={() => setEditing(false)} />}
      <ConfirmDialog
        open={confirm}
        title={`Excluir ${state.powersTab.singular}`}
        description={`Excluir “${power.name}”? A vaga volta a ficar disponível e efeitos contínuos ativos dele deixam de ser cobrados.`}
        confirmLabel="Excluir"
        loading={pending}
        onCancel={() => setConfirm(false)}
        onConfirm={() =>
          start(async () => {
            const res = await deletePower(cid, power.id);
            if (!res.ok) return toast(res.error, "error");
            toast(res.message ?? "Excluído.");
            setConfirm(false);
            // A vaga volta a ficar disponível (a contagem vem da lista de poderes).
            state.setPowers((list) => list.filter((p) => p.id !== power.id));
            state.setEffects((list) => list.filter((e) => e.power_id !== power.id));
          })
        }
      />
    </li>
  );
}

function Info({ label, value }: { label: string; value: string }) {
  return (
    <div>
      <dt className="label-mono">{label}</dt>
      <dd className="text-fg">{value}</dd>
    </div>
  );
}

// ============================================================== Criador de poderes

const AREAS: { id: AreaChoice; label: string }[] = [{ id: "alvo", label: "1 alvo" }, ...DAMAGE_AREA_SIZES.map((s) => ({ id: s.id as AreaChoice, label: `${s.name} (${s.radiusM} m)` }))];

const NEW_COMPONENT: Record<PowerComponent["type"], PowerComponent> = {
  damage: { type: "damage", tier: 0, extraDice: 0, area: "alvo" },
  heal: { type: "heal", tier: 0, extraDice: 0, area: "alvo" },
  heal_continuous: { type: "heal_continuous", tier: 0 },
  shield: { type: "shield", tier: 0, extraDice: 0, duration: "1t" },
  condition: { type: "condition", intensity: "leve" },
  buff: { type: "buff", buff: "teste_1" },
};

const COMPONENT_LABEL: Record<PowerComponent["type"], string> = {
  damage: "Dano",
  heal: "Cura",
  heal_continuous: "Cura contínua",
  shield: "Escudo",
  condition: "Condição",
  buff: "Melhoria",
};

function PowerCreator({ state, power, onClose }: { state: SheetState; power?: PowerRow; onClose: () => void }) {
  const toast = useToast();
  const { character: c } = state;
  const [pending, start] = useTransition();
  const [meta, setMeta] = useState({
    name: power?.name ?? "",
    description: power?.description ?? "",
    ability_type: power?.ability_type ?? "",
    target: power?.target ?? "",
    range: power?.range ?? "",
    duration: power?.duration ?? "",
  });
  const noPc = state.noPc;
  const info = state.powersTab;
  const [components, setComponents] = useState<PowerComponent[]>(power?.components ?? (noPc ? [] : [NEW_COMPONENT.damage]));
  const cost = useMemo(() => computePowerCost(components, c.level, c.origin_id), [components, c.level, c.origin_id]);
  const continuous = isContinuous(components);
  const overPc = cost.errors.some((e) => e.includes("PC por habilidade"));
  const overDice = !cost.unlimited && cost.extraDice > cost.limits.maxExtraDice;

  function patch(i: number, p: Partial<PowerComponent>) {
    setComponents((list) => list.map((x, k) => (k === i ? ({ ...x, ...p } as PowerComponent) : x)));
  }

  function save() {
    if (!meta.name.trim()) return toast("Dê um nome.", "error");
    if (!cost.valid) return toast(cost.errors[0], "error");
    const input: PowerInput = { ...meta, name: meta.name.trim(), components };
    start(async () => {
      const res = await savePower(c.id, input, power?.id);
      if (!res.ok) return toast(res.error, "error");
      toast(res.message ?? "Salvo.");
      const row = res.data;
      if (row) state.setPowers((list) => (power ? list.map((p) => (p.id === row.id ? row : p)) : [...list, row]));
      onClose();
    });
  }

  return (
    <Modal
      open
      onClose={onClose}
      title={power ? `Editar: ${power.name}` : info.newLabel}
      tag={info.label}
      size="xl"
      header={
        noPc ? (
          <div className="flex flex-wrap items-end justify-between gap-3" aria-live="polite">
            <p className="font-display text-2xl tracking-[0.08em] text-cyan text-glow">SEM CUSTO DE PC</p>
            <p className="max-w-sm text-right text-xs text-fg-dim">Prodígio: sem limite de PC por habilidade e sem limite de dados extras. Escolha livremente os efeitos — ou nenhum, para registrar só o texto.</p>
            {!cost.valid && (
              <ul className="w-full space-y-0.5 text-xs text-alert">
                {cost.errors.map((e) => (
                  <li key={e} className="flex items-center gap-1.5">
                    <AlertTriangle className="h-3.5 w-3.5" aria-hidden /> {e}
                  </li>
                ))}
              </ul>
            )}
          </div>
        ) : (
        <div className={`flex flex-wrap items-end justify-between gap-3 ${cost.valid ? "" : "text-alert"}`} aria-live="polite">
          <div>
            <p className={`font-display text-3xl tracking-[0.08em] tabular-nums ${cost.valid ? "text-cyan text-glow" : "text-alert"}`}>
              CUSTO: {cost.initial} PC{cost.perTurn > 0 && <span className="text-xl"> + {cost.perTurn} PC/TURNO</span>}
            </p>
            {cost.initial !== cost.fullInitial && <p className="font-mono text-[0.62rem] text-fg-dim">Custo cheio {cost.fullInitial} PC · Amaldiçoado paga metade (arredondado para cima)</p>}
          </div>
          <dl className="grid grid-cols-2 gap-x-4 text-right font-mono text-[0.62rem] text-fg-muted">
            <dt>MÁX. PC (NÍVEL {c.level})</dt>
            <dt>DADOS EXTRAS</dt>
            <dd className={`text-base tabular-nums ${overPc ? "text-alert" : "text-fg"}`}>{cost.limits.maxPc}</dd>
            <dd className={`text-base tabular-nums ${overDice ? "text-alert" : "text-fg"}`}>
              {cost.extraDice}/{cost.limits.maxExtraDice}
            </dd>
          </dl>
          {!cost.valid && (
            <ul className="w-full space-y-0.5 text-xs">
              {cost.errors.map((e) => (
                <li key={e} className="flex items-center gap-1.5">
                  <AlertTriangle className="h-3.5 w-3.5" aria-hidden /> {e}
                </li>
              ))}
            </ul>
          )}
        </div>
        )
      }
      footer={
        <>
          <Button variant="ghost" onClick={onClose}>
            Cancelar
          </Button>
          <Button onClick={save} loading={pending} disabled={!cost.valid}>
            <Zap className="h-3.5 w-3.5" aria-hidden /> {power ? "Salvar" : info.newLabel}
          </Button>
        </>
      }
    >
      <div className="grid gap-4 sm:grid-cols-2">
        <Field label="Nome">
          <input className="field-input" maxLength={120} value={meta.name} onChange={(e) => setMeta({ ...meta, name: e.target.value })} />
        </Field>
        <Field label={info.theme === "default" ? "Tipo de habilidade" : "Tipo"}>
          <input className="field-input" maxLength={60} placeholder="Ofensiva, suporte…" value={meta.ability_type} onChange={(e) => setMeta({ ...meta, ability_type: e.target.value })} />
        </Field>
        <Field label="Alvo">
          <input className="field-input" maxLength={120} value={meta.target} onChange={(e) => setMeta({ ...meta, target: e.target.value })} />
        </Field>
        <div className="grid grid-cols-2 gap-4">
          <Field label="Alcance">
            <input className="field-input" maxLength={60} value={meta.range} onChange={(e) => setMeta({ ...meta, range: e.target.value })} />
          </Field>
          <Field label="Duração">
            <input className="field-input" maxLength={60} placeholder={continuous ? "Contínua" : "Instantânea"} value={meta.duration} onChange={(e) => setMeta({ ...meta, duration: e.target.value })} />
          </Field>
        </div>
      </div>
      <div className="mt-4">
        <Field label="Descrição">
          <textarea rows={3} className="field-input resize-y" maxLength={5000} value={meta.description} onChange={(e) => setMeta({ ...meta, description: e.target.value })} />
        </Field>
      </div>

      <section className="mt-6">
        <p className="label-mono mb-3 text-holo">Efeitos (Capítulo V do livro){noPc ? " — opcionais" : ""}</p>
        <ol className="space-y-3">
          {components.map((comp, i) => {
            const cc = cost.components[i];
            return (
              <li key={i} className="border border-line/70 bg-panel-2/40 p-3">
                <div className="mb-3 flex flex-wrap items-center gap-2">
                  <select
                    className="field-input w-44 py-1"
                    value={comp.type}
                    onChange={(e) => setComponents((list) => list.map((x, k) => (k === i ? NEW_COMPONENT[e.target.value as PowerComponent["type"]] : x)))}
                    aria-label="Tipo de efeito"
                  >
                    {(Object.keys(COMPONENT_LABEL) as PowerComponent["type"][]).map((t) => (
                      <option key={t} value={t}>
                        {COMPONENT_LABEL[t]}
                      </option>
                    ))}
                  </select>
                  {cc && (
                    <span className="font-mono text-xs text-cyan">
                      {!noPc && (
                        <>
                          {cc.initial} PC{cc.perTurn > 0 && ` + ${cc.perTurn}/turno`}
                        </>
                      )}
                      {cc.dice && <span className="ml-2 text-fg">{cc.dice}</span>}
                    </span>
                  )}
                  {(components.length > 1 || noPc) && (
                    <button onClick={() => setComponents((list) => list.filter((_, k) => k !== i))} className="ml-auto p-1 text-fg-muted hover:text-alert" aria-label="Remover efeito">
                      <X className="h-4 w-4" />
                    </button>
                  )}
                </div>
                <ComponentEditor comp={comp} onChange={(p) => patch(i, p)} />
                {cc && !noPc && <p className="mt-2 text-xs text-fg-muted">{cc.details.join(" · ")}</p>}
              </li>
            );
          })}
        </ol>
        {components.length < 10 && (
          <Button size="sm" variant="secondary" className="mt-3" onClick={() => setComponents((l) => [...l, NEW_COMPONENT.damage])}>
            <Plus className="h-3.5 w-3.5" aria-hidden /> Adicionar efeito
          </Button>
        )}
        {cost.bonusDamageDice && <p className="mt-3 text-xs text-cyan-dim">Amaldiçoado — a dívida a pagar: +{cost.bonusDamageDice} de dano ao usar.</p>}
        {continuous && (
          <p className="mt-2 text-xs text-fg-muted">
            {noPc ? "Efeito contínuo: ao usar, fica ativo pelos turnos escolhidos." : "Este poder tem custo por turno: ao usar, ele fica ativo e cada turno de manutenção cobra o PC indicado."}
          </p>
        )}
      </section>
    </Modal>
  );
}

function TierSelect({ value, rows, onChange, label }: { value: number; rows: { dice: string; cost?: number; perTurn?: number }[]; onChange: (n: number) => void; label: string }) {
  return (
    <label className="text-xs text-fg-dim">
      <span className="label-mono mb-1 block">{label}</span>
      <select className="field-input py-1" value={value} onChange={(e) => onChange(Number(e.target.value))}>
        {rows.map((r, k) => (
          <option key={k} value={k}>
            {r.dice} — {r.cost !== undefined ? `${r.cost} PC` : `${r.perTurn} PC/turno`}
          </option>
        ))}
      </select>
    </label>
  );
}

function ExtraDice({ value, onChange, die }: { value: number; onChange: (n: number) => void; die: string }) {
  return (
    <label className="text-xs text-fg-dim">
      <span className="label-mono mb-1 block">Dados extras (+{die}, 3 PC cada)</span>
      <input type="number" min={0} max={20} className="field-input w-24 py-1 font-mono" value={value} onChange={(e) => onChange(Math.max(0, Math.min(20, Math.floor(Number(e.target.value) || 0))))} />
    </label>
  );
}

function ComponentEditor({ comp, onChange }: { comp: PowerComponent; onChange: (p: Partial<PowerComponent>) => void }) {
  switch (comp.type) {
    case "damage":
      return (
        <div className="grid gap-3 sm:grid-cols-3">
          <label className="text-xs text-fg-dim">
            <span className="label-mono mb-1 block">Área</span>
            <select className="field-input py-1" value={comp.area} onChange={(e) => onChange({ area: e.target.value as AreaChoice })}>
              {AREAS.map((a) => (
                <option key={a.id} value={a.id}>
                  {a.label}
                  {a.id !== "alvo" ? ` (+${DAMAGE_AREA_SIZES.find((s) => s.id === a.id)!.damageCost} PC)` : ""}
                </option>
              ))}
            </select>
          </label>
          <TierSelect label="Dano" value={comp.tier} rows={comp.area === "alvo" ? DAMAGE_SINGLE : DAMAGE_AREA} onChange={(tier) => onChange({ tier })} />
          <ExtraDice value={comp.extraDice} onChange={(extraDice) => onChange({ extraDice })} die="1 dado" />
        </div>
      );
    case "heal":
      return (
        <div className="grid gap-3 sm:grid-cols-3">
          <label className="text-xs text-fg-dim">
            <span className="label-mono mb-1 block">Área</span>
            <select className="field-input py-1" value={comp.area} onChange={(e) => onChange({ area: e.target.value as AreaChoice })}>
              {AREAS.map((a) => (
                <option key={a.id} value={a.id}>
                  {a.label}
                  {HEAL_AREA_MODIFIER[a.id] ? ` (+${HEAL_AREA_MODIFIER[a.id]} PC)` : ""}
                </option>
              ))}
            </select>
          </label>
          <TierSelect label="Cura" value={comp.tier} rows={HEAL_SINGLE} onChange={(tier) => onChange({ tier })} />
          <ExtraDice value={comp.extraDice} onChange={(extraDice) => onChange({ extraDice })} die="1d6" />
        </div>
      );
    case "heal_continuous":
      return <TierSelect label="Cura por turno" value={comp.tier} rows={HEAL_CONTINUOUS} onChange={(tier) => onChange({ tier })} />;
    case "shield":
      return (
        <div className="grid gap-3 sm:grid-cols-3">
          <TierSelect label="Escudo" value={comp.tier} rows={SHIELD} onChange={(tier) => onChange({ tier })} />
          <label className="text-xs text-fg-dim">
            <span className="label-mono mb-1 block">Duração</span>
            <select className="field-input py-1" value={comp.duration} onChange={(e) => onChange({ duration: e.target.value })}>
              {SHIELD_DURATION.map((d) => (
                <option key={d.id} value={d.id}>
                  {d.name}
                  {d.cost ? ` (+${d.cost} PC)` : ""}
                </option>
              ))}
            </select>
          </label>
          <ExtraDice value={comp.extraDice} onChange={(extraDice) => onChange({ extraDice })} die="1d8" />
        </div>
      );
    case "condition":
      return (
        <label className="text-xs text-fg-dim">
          <span className="label-mono mb-1 block">Intensidade</span>
          <select className="field-input py-1" value={comp.intensity} onChange={(e) => onChange({ intensity: e.target.value })}>
            {CONDITIONS.map((t) => (
              <option key={t.id} value={t.id}>
                {t.name} — {t.initial} PC + {t.perTurn}/turno ({t.examples})
              </option>
            ))}
          </select>
        </label>
      );
    case "buff":
      return (
        <label className="text-xs text-fg-dim">
          <span className="label-mono mb-1 block">Melhoria</span>
          <select className="field-input py-1" value={comp.buff} onChange={(e) => onChange({ buff: e.target.value })}>
            {BUFFS.map((t) => (
              <option key={t.id} value={t.id}>
                {t.name} — {t.initial} PC + {t.perTurn}/turno
              </option>
            ))}
          </select>
        </label>
      );
  }
}
