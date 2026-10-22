"use client";

import { useMemo, useState, useTransition } from "react";
import { Crosshair, Power, Square, StepForward, Zap } from "lucide-react";
import { Button } from "@/components/ui/Button";
import { Modal } from "@/components/ui/Modal";
import { useToast } from "@/components/ui/Toast";
import type { EffectRow, ItemRow, PowerRow } from "@/lib/character";
import type { EffectTickPayload, PowerPayload } from "@/lib/rolls";
import { attackOptions, isContinuous, planAttack, type WeaponLike } from "@/rules/combat.ts";
import { WEAPON_MODIFIER_BY_ID } from "@/rules/data/equipment.ts";
import { SKILL_BY_ID } from "@/rules/data/skills.ts";
import { advanceEffect, attackWithItem, endEffect, newRequestId, usePower } from "../../inventory-actions";
import type { SheetState } from "../Sheet";

/** Identificador único por intenção de uso (evita cobrança dupla em cliques repetidos ou reenvio). */
export async function makeRequestId(): Promise<string> {
  try {
    if (typeof crypto !== "undefined" && typeof crypto.randomUUID === "function") return crypto.randomUUID();
  } catch {
    // contexto inseguro (http): cai para o servidor
  }
  return newRequestId();
}

export function weaponOf(item: ItemRow): WeaponLike | null {
  if (!item.attack_kind || !item.effect_dice) return null;
  return {
    name: item.name,
    damage: item.effect_dice,
    attackKind: item.attack_kind,
    tags: item.tags,
    skillOverride: item.skill_override,
    modifiers: item.item_modifiers.map((m) => m.modifier_id),
  };
}

// ============================================================== Ataque

export function AttackButton({ state, item, compact = false }: { state: SheetState; item: ItemRow; compact?: boolean }) {
  const [open, setOpen] = useState(false);
  const weapon = weaponOf(item);
  if (!weapon) return null;
  return (
    <>
      <Button size="sm" variant="primary" onClick={() => setOpen(true)} disabled={!state.canEdit} aria-label={`Atacar com ${item.name}`}>
        <Crosshair className="h-3.5 w-3.5" aria-hidden /> {compact ? "" : "Atacar"}
      </Button>
      {open && <AttackDialog state={state} item={item} weapon={weapon} onClose={() => setOpen(false)} />}
    </>
  );
}

function AttackDialog({ state, item, weapon, onClose }: { state: SheetState; item: ItemRow; weapon: WeaponLike; onClose: () => void }) {
  const toast = useToast();
  const { character: c, form, sheet } = state;
  const [chosen, setChosen] = useState<string[]>([]);
  const [pending, start] = useTransition();
  const classId = form.kind === "base" ? c.class_id : null;
  const options = useMemo(() => attackOptions(weapon, { classId, originId: c.origin_id, pathId: c.origin_path_id }), [weapon, classId, c.origin_id, c.origin_path_id]);
  const skillValues = useMemo(() => Object.fromEntries(sheet.skills.map((s) => [s.id, s.final])), [sheet.skills]);
  const plan = useMemo(
    () => planAttack(weapon, { classId, originId: c.origin_id, pathId: c.origin_path_id, level: c.level, skillValues, options: chosen }),
    [weapon, classId, c.origin_id, c.origin_path_id, c.level, skillValues, chosen],
  );
  const conditions = item.item_modifiers.map((m) => WEAPON_MODIFIER_BY_ID[m.modifier_id]).filter((m) => m?.condition);

  function attack() {
    state.showResult(null, true);
    start(async () => {
      const res = await attackWithItem(c.id, item.id, chosen, form.id);
      if (!res.ok) {
        state.showResult(null, false);
        return toast(res.error, "error");
      }
      state.showResult(res.data!, false);
      onClose();
    });
  }

  return (
    <Modal
      open
      onClose={onClose}
      title={item.name}
      tag="Ataque"
      size="md"
      footer={
        <>
          <Button variant="ghost" onClick={onClose}>
            Cancelar
          </Button>
          <Button onClick={attack} loading={pending}>
            <Crosshair className="h-3.5 w-3.5" aria-hidden /> Rolar ataque
          </Button>
        </>
      }
    >
      <dl className="grid grid-cols-2 gap-3 text-sm">
        <div>
          <dt className="label-mono">Perícia</dt>
          <dd className="text-fg">
            {SKILL_BY_ID[plan.skillId]?.name ?? plan.skillId} <span className="font-mono text-cyan">{plan.skillValue}</span>
          </dd>
        </div>
        <div>
          <dt className="label-mono">Dano</dt>
          <dd className="font-mono text-fg">
            {plan.damageExpr}
            {plan.damageFactor !== 1 && <span className="text-cyan"> ×{plan.damageFactor}</span>}
          </dd>
        </div>
        <div>
          <dt className="label-mono">Modificador no d100</dt>
          <dd className="font-mono text-fg">{plan.rollModifier === 0 ? "—" : `${plan.rollModifier > 0 ? "+" : ""}${plan.rollModifier}`}</dd>
        </div>
        <div>
          <dt className="label-mono">Vantagens</dt>
          <dd className="font-mono text-fg">{plan.advantage || "—"}</dd>
        </div>
      </dl>
      {plan.applied.length > 0 && (
        <p className="mt-3 text-xs text-fg-dim">
          <span className="label-mono mr-1">Aplicado automaticamente:</span>
          {plan.applied.join(" · ")}
        </p>
      )}
      {options.length > 0 && (
        <fieldset className="mt-4 space-y-2">
          <legend className="label-mono mb-2 text-holo">Situação do ataque</legend>
          {options.map((o) => (
            <label key={o.key} className="flex cursor-pointer items-start gap-2 text-sm text-fg-dim hover:text-fg">
              <input
                type="checkbox"
                className="mt-1 accent-[var(--color-holo)]"
                checked={chosen.includes(o.key)}
                onChange={(e) => setChosen((cur) => (e.target.checked ? [...cur, o.key] : cur.filter((k) => k !== o.key)))}
              />
              <span>
                {o.label} <span className="text-xs text-fg-muted">({o.source})</span>
              </span>
            </label>
          ))}
        </fieldset>
      )}
      {conditions.length > 0 && (
        <div className="mt-4 border-t border-line/60 pt-3">
          <p className="label-mono mb-1">Condições (o Mestre aplica)</p>
          <ul className="space-y-1 text-xs text-cyan-dim">
            {conditions.map((m) => (
              <li key={m!.id}>
                <span className="text-fg-dim">{m!.name}:</span> {m!.condition}
              </li>
            ))}
          </ul>
        </div>
      )}
      <p className="mt-4 text-xs text-fg-muted">
        Falha não causa dano. Acerto extremo ×1,5 e 1 natural ×2 (não acumulam). A rolagem acontece no servidor.
      </p>
    </Modal>
  );
}

// ============================================================== Poder

export function UsePowerButton({ state, power }: { state: SheetState; power: PowerRow }) {
  const [open, setOpen] = useState(false);
  const enough = state.form.pc_current >= power.initial_cost;
  return (
    <>
      <Button
        size="sm"
        variant="primary"
        onClick={() => setOpen(true)}
        disabled={!state.canEdit || !enough}
        title={enough ? undefined : `PC insuficiente (precisa de ${power.initial_cost})`}
        aria-label={`Usar ${power.name}`}
      >
        <Zap className="h-3.5 w-3.5" aria-hidden /> Usar
      </Button>
      {open && <UsePowerDialog state={state} power={power} onClose={() => setOpen(false)} />}
    </>
  );
}

function UsePowerDialog({ state, power, onClose }: { state: SheetState; power: PowerRow; onClose: () => void }) {
  const toast = useToast();
  const { character: c, form } = state;
  const continuous = isContinuous(power.components) && power.per_turn_cost > 0;
  const [turns, setTurns] = useState(continuous ? 1 : 0);
  const [lenda, setLenda] = useState(false);
  const [pending, start] = useTransition();
  // Um id por abertura do diálogo: cliques repetidos não cobram duas vezes.
  const [reqId, setReqId] = useState<string | null>(null);
  const classId = form.kind === "base" ? c.class_id : null;
  const enough = form.pc_current >= power.initial_cost;

  function use() {
    state.showResult(null, true);
    start(async () => {
      const id = reqId ?? (await makeRequestId());
      setReqId(id);
      const res = await usePower(c.id, power.id, id, { turns: continuous ? turns : 0, options: lenda ? ["alvo_lenda"] : [], formId: form.id });
      if (!res.ok) {
        state.showResult(null, false);
        return toast(res.error, "error");
      }
      const p = res.data!.result as PowerPayload;
      state.setForm({ pc_current: p.pcAfter });
      state.showResult(res.data!, false);
      state.refresh();
      onClose();
    });
  }

  return (
    <Modal
      open
      onClose={onClose}
      title={power.name}
      tag="Usar poder"
      size="md"
      footer={
        <>
          <Button variant="ghost" onClick={onClose}>
            Cancelar
          </Button>
          <Button onClick={use} loading={pending} disabled={!enough}>
            <Zap className="h-3.5 w-3.5" aria-hidden /> Gastar {power.initial_cost} PC e usar
          </Button>
        </>
      }
    >
      <p className="font-mono text-sm text-fg-dim">
        PC ATUAL <span className="text-fg">{form.pc_current}</span> · CUSTO <span className="text-cyan">{power.initial_cost}</span>
        {power.per_turn_cost > 0 && <> · +{power.per_turn_cost}/turno</>}
      </p>
      {!enough && <p className="mt-2 text-sm text-alert">PC insuficiente para ativar este poder.</p>}
      {power.description && <p className="mt-3 text-sm leading-relaxed text-fg-dim">{power.description}</p>}
      {continuous && (
        <label className="mt-4 block text-sm text-fg-dim">
          <span className="label-mono mb-1 block text-holo">Turnos de manutenção</span>
          <input type="number" min={1} max={100} value={turns} onChange={(e) => setTurns(Math.max(1, Math.min(100, Number(e.target.value) || 1)))} className="field-input w-28 font-mono" />
          <span className="mt-1 block text-xs text-fg-muted">
            O custo inicial é cobrado agora. Cada turno de manutenção cobra {power.per_turn_cost} PC quando você clicar em “Próximo turno”; você pode encerrar antes.
          </span>
        </label>
      )}
      {classId === "esoterico" && power.components.some((x) => x.type === "damage") && (
        <label className="mt-4 flex items-center gap-2 text-sm text-fg-dim">
          <input type="checkbox" className="accent-[var(--color-holo)]" checked={lenda} onChange={(e) => setLenda(e.target.checked)} />
          Alvo é uma lenda (+1d6 — Esotérico)
        </label>
      )}
      <p className="mt-4 text-xs text-fg-muted">Poderes não fazem teste de acerto: só os dados de efeito são rolados, no servidor.</p>
    </Modal>
  );
}

// ============================================================== Efeitos contínuos

export function ActiveEffects({ state }: { state: SheetState }) {
  const toast = useToast();
  const [busy, setBusy] = useState<string | null>(null);
  const effects = state.effects.filter((e) => e.active && (!e.form_id || e.form_id === state.form.id));
  if (effects.length === 0) return null;

  async function advance(e: EffectRow) {
    setBusy(e.id);
    state.showResult(null, true);
    const res = await advanceEffect(state.character.id, e.id, await makeRequestId());
    setBusy(null);
    if (!res.ok) {
      state.showResult(null, false);
      return toast(res.error, "error");
    }
    state.setForm({ pc_current: (res.data!.result as EffectTickPayload).pcAfter });
    state.showResult(res.data!, false);
    state.refresh();
  }

  async function end(e: EffectRow) {
    setBusy(e.id);
    const res = await endEffect(state.character.id, e.id);
    setBusy(null);
    if (!res.ok) return toast(res.error, "error");
    toast(res.message ?? "Encerrado.");
    state.refresh();
  }

  return (
    <section className="mb-5 border border-holo/50 bg-primary/5 p-3" aria-label="Efeitos ativos">
      <p className="label-mono mb-2 flex items-center gap-1.5 text-cyan">
        <Power className="h-3.5 w-3.5" aria-hidden /> Efeitos contínuos ativos
      </p>
      <ul className="space-y-2">
        {effects.map((e) => {
          const remaining = e.turns_total ? Math.max(0, e.turns_total - e.turns_paid) : null;
          return (
            <li key={e.id} className="flex flex-wrap items-center justify-between gap-2 border-b border-line/50 pb-2">
              <div>
                <p className="text-sm text-fg">{e.label}</p>
                <p className="font-mono text-[0.62rem] text-fg-dim">
                  {e.per_turn_cost} PC/TURNO · TURNO {e.turns_paid}
                  {e.turns_total ? `/${e.turns_total}` : ""}
                  {remaining !== null && ` · ${remaining} RESTANTE(S)`}
                </p>
              </div>
              {state.canEdit && (
                <div className="flex gap-2">
                  <Button size="sm" variant="secondary" onClick={() => advance(e)} loading={busy === e.id} disabled={state.form.pc_current < e.per_turn_cost}>
                    <StepForward className="h-3.5 w-3.5" aria-hidden /> Próximo turno
                  </Button>
                  <Button size="sm" variant="danger" onClick={() => end(e)} disabled={busy === e.id}>
                    <Square className="h-3 w-3" aria-hidden /> Encerrar
                  </Button>
                </div>
              )}
            </li>
          );
        })}
      </ul>
    </section>
  );
}
