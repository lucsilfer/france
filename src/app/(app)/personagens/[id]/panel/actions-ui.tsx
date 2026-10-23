"use client";

import { useEffect, useMemo, useState } from "react";
import { Crosshair, Power, Square, StepForward, Zap } from "lucide-react";
import { Button } from "@/components/ui/Button";
import { Modal } from "@/components/ui/Modal";
import { useToast } from "@/components/ui/Toast";
import type { EffectRow, ItemRow, PowerRow } from "@/lib/character";
import type { EffectTickPayload, PowerPayload } from "@/lib/rolls";
import { attackOptions, isContinuous, planAttack, type WeaponLike } from "@/rules/combat.ts";
import { techniqueAttackOptions } from "@/rules/techniques.ts";
import { GRENADE_BY_ID, WEAPON_MODIFIER_BY_ID } from "@/rules/data/equipment.ts";
import { SKILL_BY_ID } from "@/rules/data/skills.ts";
import { advanceEffect, attackInCombat, attackWithItem, endEffect, newRequestId, throwGrenade, useItem, usePower } from "../../inventory-actions";
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
    customModifiers: item.custom_modifiers ?? [],
  };
}

/** Itens que podem ser "usados" (consumível, cura/dano/efeito com dados ou usos limitados). */
export function isUsableItem(item: ItemRow): boolean {
  return !item.attack_kind && (Boolean(item.effect_dice) || item.uses_max != null || item.item_type === "consumivel");
}

/** Usa o item: desconta quantidade/uso no banco e aplica a cura na forma ativa; a rolagem aparece na bandeja.
 *  Granadas em combate abrem a escolha dos alvos (confronto por alvo, rolado no banco). */
export function UseItemButton({ state, item }: { state: SheetState; item: ItemRow }) {
  const toast = useToast();
  const [busy, setBusy] = useState(false);
  const [grenadeOpen, setGrenadeOpen] = useState(false);
  const exhausted = item.uses_max != null ? (item.uses_left ?? 0) <= 0 : item.item_type === "consumivel" && item.quantity <= 0;
  const grenade = item.source_ref ? GRENADE_BY_ID[item.source_ref] : undefined;
  if (!state.canEdit || !isUsableItem(item)) return null;
  async function use() {
    if (grenade && state.combat) return setGrenadeOpen(true);
    setBusy(true);
    const token = item.effect_dice ? state.beginRoll(`Usar: ${item.name}`) : null;
    const res = await useItem(state.character.id, item.id, state.form.id);
    setBusy(false);
    if (!res.ok) {
      if (token) state.failRoll(token);
      return toast(res.error, "error");
    }
    const d = res.data!;
    state.setItems((list) => list.map((i) => (i.id === item.id ? { ...i, quantity: d.quantity, uses_left: d.uses_left } : i)));
    if (typeof d.pv === "number") state.patchForm(state.form.id, { pv_current: d.pv });
    if (token && d.entry) state.finishRoll(token, d.entry);
    else if (token) state.failRoll(token);
    if (res.message) toast(res.message);
  }
  return (
    <>
      <Button size="sm" variant="secondary" onClick={use} disabled={busy || exhausted} title={exhausted ? "Sem usos ou quantidade" : grenade ? "Lançar granada" : "Usar item"}>
        {grenade ? "Lançar" : "Usar"}
      </Button>
      {grenadeOpen && grenade && <GrenadeDialog state={state} item={item} onClose={() => setGrenadeOpen(false)} />}
    </>
  );
}

function GrenadeDialog({ state, item, onClose }: { state: SheetState; item: ItemRow; onClose: () => void }) {
  const toast = useToast();
  const g = GRENADE_BY_ID[item.source_ref ?? ""];
  const targets = state.combat?.targets ?? [];
  const [chosen, setChosen] = useState<string[]>([]);
  const [busy, setBusy] = useState(false);
  const needsTarget = Boolean(g?.damage);
  async function go() {
    setBusy(true);
    const tokens = chosen.map((id) => state.beginRoll(`${item.name} → ${targets.find((t) => t.id === id)?.name ?? "alvo"}`));
    const res = await throwGrenade(state.character.id, item.id, chosen, await makeRequestId());
    setBusy(false);
    if (!res.ok) {
      tokens.forEach((t) => state.failRoll(t));
      return toast(res.error, "error");
    }
    const d = res.data!;
    state.setItems((list) => list.map((i) => (i.id === item.id ? { ...i, quantity: d.quantity } : i)));
    d.entries.forEach((e, i) => (tokens[i] ? state.finishRoll(tokens[i], e) : null));
    tokens.slice(d.entries.length).forEach((t) => state.failRoll(t));
    if (res.message) toast(res.message);
    onClose();
  }
  return (
    <Modal
      open
      onClose={onClose}
      title={`Lançar: ${item.name}`}
      tag={state.combat?.combatName}
      size="md"
      footer={
        <>
          <Button variant="ghost" onClick={onClose}>
            Cancelar
          </Button>
          <Button onClick={go} loading={busy} disabled={needsTarget && chosen.length === 0}>
            Lançar ({item.quantity} restante{item.quantity === 1 ? "" : "s"})
          </Button>
        </>
      }
    >
      <p className="text-sm text-fg-dim">
        {g?.damage ? `${g.damage} de dano · ` : ""}
        {g?.area} · {g?.effect}
      </p>
      {needsTarget ? (
        <fieldset className="mt-3 space-y-1.5">
          <legend className="label-mono mb-1">Alvos na área</legend>
          {targets.map((t) => (
            <label key={t.id} className="flex items-center gap-2 text-sm text-fg">
              <input
                type="checkbox"
                className="accent-[var(--color-holo)]"
                checked={chosen.includes(t.id)}
                onChange={(e) => setChosen(e.target.checked ? [...chosen, t.id] : chosen.filter((x) => x !== t.id))}
              />
              {t.name}
            </label>
          ))}
          {targets.length === 0 && <p className="text-xs text-fg-muted">Nenhum alvo visível no combate.</p>}
        </fieldset>
      ) : (
        <p className="mt-3 text-xs text-fg-muted">Sem alvo: a cobertura é aplicada em você.</p>
      )}
      <p className="mt-3 text-[0.68rem] text-fg-muted">
        Para cada alvo: sua Pontaria × Reflexo do alvo, 1d100 contra 1d100 no servidor; vence o menor. Desconta 1 granada (uma vez por lançamento). O Mestre confirma o dano.
      </p>
    </Modal>
  );
}

/** Dispara o ataque sem esperar: a janela de resultado abre no clique e se preenche quando o servidor responde. */
function fireAttack(state: SheetState, item: ItemRow, options: string[], onError: (msg: string) => void) {
  const token = state.beginRoll(`Ataque: ${item.name}`);
  void attackWithItem(state.character.id, item.id, options, state.form.id).then((res) => {
    if (!res.ok) {
      state.failRoll(token);
      onError(res.error);
      return;
    }
    state.finishRoll(token, res.data!);
  });
}

/** Ataque em combate: confronto de rolagens opostas contra o alvo (rolado no banco). */
function fireConfront(state: SheetState, item: ItemRow, options: string[], target: { id: string; name: string }, reaction: string | null, onError: (msg: string) => void) {
  const token = state.beginRoll(`Confronto: ${item.name} → ${target.name}`);
  void attackInCombat(state.character.id, item.id, options, target.id, reaction, state.form.id).then((res) => {
    if (!res.ok) {
      state.failRoll(token);
      onError(res.error);
      return;
    }
    state.finishRoll(token, res.data!);
  });
}

// ============================================================== Ataque

export function AttackButton({ state, item, compact = false }: { state: SheetState; item: ItemRow; compact?: boolean }) {
  const toast = useToast();
  const [open, setOpen] = useState(false);
  const weapon = weaponOf(item);
  const c = state.character;
  const classId = state.form.kind === "base" ? c.class_id : null;
  const hasOptions = useMemo(
    () =>
      weapon
        ? attackOptions(weapon, { classId, originId: c.origin_id, pathId: c.origin_path_id }).length > 0 ||
          techniqueAttackOptions(state.techniques, c.level, state.techniqueUses, state.tracker).length > 0
        : false,
    [weapon, classId, c.origin_id, c.origin_path_id, c.level, state.techniques, state.techniqueUses, state.tracker],
  );
  if (!weapon) return null;
  // Sem situações a marcar e fora de combate, o ataque é rolado direto (um clique). Em combate, escolhe o alvo.
  const onClick = () => (hasOptions || state.combat ? setOpen(true) : fireAttack(state, item, [], (m) => toast(m, "error")));
  return (
    <>
      <Button size="sm" variant="primary" onClick={onClick} disabled={!state.canEdit} aria-label={`Atacar com ${item.name}`} title={hasOptions ? "Escolher situação e atacar" : "Rolar ataque"}>
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
  const [combat, setCombat] = useState(state.combat);
  const [target, setTarget] = useState<string>(state.combat?.targets[0]?.id ?? "");
  const [reaction, setReaction] = useState<string>("");
  useEffect(() => {
    // Atualiza os alvos ao abrir (alguém pode ter entrado ou saído do combate).
    void state.refreshCombat().then((ctx) => {
      setCombat(ctx);
      setTarget((t) => (ctx && (t === "" || ctx.targets.some((x) => x.id === t)) ? t || ctx.targets[0]?.id || "" : ""));
    });
    // eslint-disable-next-line react-hooks/exhaustive-deps
  }, []);
  const classId = form.kind === "base" ? c.class_id : null;
  const tecOptions = useMemo(
    () => techniqueAttackOptions(state.techniques, c.level, state.techniqueUses, state.tracker),
    [state.techniques, c.level, state.techniqueUses, state.tracker],
  );
  const options = useMemo(
    () => [
      ...attackOptions(weapon, { classId, originId: c.origin_id, pathId: c.origin_path_id }),
      ...tecOptions.map((t) => ({ key: t.key, label: t.consumes ? `${t.label} — usa a técnica nesta cena` : t.label, source: t.source })),
    ],
    [weapon, classId, c.origin_id, c.origin_path_id, tecOptions],
  );
  const skillValues = useMemo(() => Object.fromEntries(sheet.skills.map((s) => [s.id, s.final])), [sheet.skills]);
  const plan = useMemo(
    () =>
      planAttack(weapon, {
        classId,
        originId: c.origin_id,
        pathId: c.origin_path_id,
        level: c.level,
        skillValues,
        options: chosen,
        allowedTechniques: tecOptions.map((t) => t.def.id),
      }),
    [weapon, classId, c.origin_id, c.origin_path_id, c.level, skillValues, chosen, tecOptions],
  );
  const conditions = item.item_modifiers.map((m) => WEAPON_MODIFIER_BY_ID[m.modifier_id]).filter((m) => m?.condition);

  function attack() {
    const t = combat?.targets.find((x) => x.id === target);
    if (t) fireConfront(state, item, chosen, t, reaction || null, (m) => toast(m, "error"));
    else fireAttack(state, item, chosen, (m) => toast(m, "error"));
    // Técnicas que consomem uso: registra localmente (o servidor registrou de verdade).
    const consumed = tecOptions.filter((t) => t.consumes && chosen.includes(t.key));
    if (consumed.length)
      state.setTechniqueUses((list) => [
        ...consumed.map((t, i) => ({ id: Date.now() + i, technique_id: t.def.id, ...state.tracker, created_at: new Date().toISOString() })),
        ...list,
      ]);
    onClose();
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
          <Button onClick={attack}>
            <Crosshair className="h-3.5 w-3.5" aria-hidden /> {combat && target ? "Rolar confronto" : "Rolar ataque"}
          </Button>
        </>
      }
    >
      {combat && (
        <div className="mb-4 space-y-2 border border-holo/50 bg-holo/5 p-3">
          <p className="label-mono text-holo">Combate: {combat.combatName}</p>
          <div className="grid gap-2 sm:grid-cols-2">
            <label className="text-xs text-fg-dim">
              Alvo
              <select className="field-input mt-1 text-sm" value={target} onChange={(e) => setTarget(e.target.value)}>
                <option value="">Sem alvo (teste fora do confronto)</option>
                {combat.targets.map((t) => (
                  <option key={t.id} value={t.id}>
                    {t.name}
                  </option>
                ))}
              </select>
            </label>
            <label className="text-xs text-fg-dim">
              Reação do alvo
              <select className="field-input mt-1 text-sm" value={reaction} onChange={(e) => setReaction(e.target.value)} disabled={!target}>
                <option value="">Automática ({item.attack_kind === "melee" ? "Luta" : "Reflexo"})</option>
                <option value="luta">Bloquear (Luta)</option>
                <option value="reflexo">Esquivar (Reflexo)</option>
              </select>
            </label>
          </div>
          <p className="text-[0.68rem] text-fg-muted">
            Rolagens opostas: você e o alvo rolam 1d100 no servidor; vence o menor. A sua perícia define a qualidade do acerto. O Mestre confirma o dano.
          </p>
        </div>
      )}
      <dl className="grid grid-cols-2 gap-3 text-sm">
        <div>
          <dt className="label-mono">Perícia</dt>
          <dd className="text-fg">
            {SKILL_BY_ID[plan.skillId]?.name ?? plan.skillId} <span className="font-mono text-cyan">{plan.skillValue}</span>
          </dd>
        </div>
        <div>
          <dt className="label-mono">Dano</dt>
          <dd className="font-mono break-words text-fg">
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
        {combat && target ? "Se você vencer o confronto: extremo ×1,5 e resultado 1 ×2 (não acumulam)." : "Fora de combate: falha não causa dano. Acerto extremo ×1,5 e 1 natural ×2 (não acumulam)."} A rolagem acontece no servidor.
      </p>
    </Modal>
  );
}

// ============================================================== Poder

function needsPowerDialog(state: SheetState, power: PowerRow) {
  const classId = state.form.kind === "base" ? state.character.class_id : null;
  return isContinuous(power.components) || (classId === "esoterico" && power.components.some((x) => x.type === "damage"));
}

/** Usa o poder: abre a janela de resultado na hora; PC (quando houver) é descontado pelo banco uma única vez. */
async function firePower(state: SheetState, power: PowerRow, opts: { turns: number; options: string[] }, requestId: string, onError: (m: string) => void) {
  const formId = state.form.id;
  const token = state.beginRoll(`Poder: ${power.name}`);
  const res = await usePower(state.character.id, power.id, requestId, { turns: opts.turns, options: opts.options, formId });
  if (!res.ok) {
    state.failRoll(token);
    onError(res.error);
    return false;
  }
  const p = res.data!.result as PowerPayload;
  state.patchForm(formId, { pc_current: p.pcAfter });
  if (p.continuous) {
    const eff: EffectRow = {
      id: p.continuous.effectId,
      form_id: formId,
      power_id: power.id,
      label: power.name,
      per_turn_cost: p.continuous.perTurn,
      turns_paid: 0,
      turns_total: p.continuous.turns,
      active: true,
      started_at: new Date().toISOString(),
    };
    state.setEffects((list) => [...list.filter((e) => e.id !== eff.id), eff]);
  }
  state.finishRoll(token, res.data!);
  return true;
}

export function UsePowerButton({ state, power }: { state: SheetState; power: PowerRow }) {
  const toast = useToast();
  const [open, setOpen] = useState(false);
  const [busy, setBusy] = useState(false);
  const enough = state.noPc || state.form.pc_current >= power.initial_cost;

  async function onClick() {
    if (needsPowerDialog(state, power)) return setOpen(true);
    setBusy(true);
    await firePower(state, power, { turns: 0, options: [] }, await makeRequestId(), (m) => toast(m, "error"));
    setBusy(false);
  }

  return (
    <>
      <Button
        size="sm"
        variant="primary"
        onClick={onClick}
        loading={busy}
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
  const { character: c, form, noPc } = state;
  const continuous = isContinuous(power.components);
  const [turns, setTurns] = useState(continuous ? 1 : 0);
  const [lenda, setLenda] = useState(false);
  const [busy, setBusy] = useState(false);
  // Um id por abertura do diálogo: cliques repetidos não cobram duas vezes.
  const [reqId, setReqId] = useState<string | null>(null);
  const classId = form.kind === "base" ? c.class_id : null;
  const enough = noPc || form.pc_current >= power.initial_cost;

  async function use() {
    if (busy) return;
    setBusy(true);
    const id = reqId ?? (await makeRequestId());
    setReqId(id);
    const ok = await firePower(state, power, { turns: continuous ? turns : 0, options: lenda ? ["alvo_lenda"] : [] }, id, (m) => toast(m, "error"));
    setBusy(false);
    if (ok) onClose();
  }

  return (
    <Modal
      open
      onClose={onClose}
      title={power.name}
      tag={`Usar ${state.powersTab.singular}`}
      size="md"
      footer={
        <>
          <Button variant="ghost" onClick={onClose}>
            Cancelar
          </Button>
          <Button onClick={use} loading={busy} disabled={!enough}>
            <Zap className="h-3.5 w-3.5" aria-hidden /> {noPc || power.initial_cost === 0 ? "Usar" : `Gastar ${power.initial_cost} PC e usar`}
          </Button>
        </>
      }
    >
      {!noPc && (
        <p className="font-mono text-sm text-fg-dim">
          PC ATUAL <span className="text-fg">{form.pc_current}</span> · CUSTO <span className="text-cyan">{power.initial_cost}</span>
          {power.per_turn_cost > 0 && <> · +{power.per_turn_cost}/turno</>}
        </p>
      )}
      {!enough && <p className="mt-2 text-sm text-alert">PC insuficiente para ativar este poder.</p>}
      {power.description && <p className="mt-3 text-sm leading-relaxed text-fg-dim">{power.description}</p>}
      {continuous && (
        <label className="mt-4 block text-sm text-fg-dim">
          <span className="label-mono mb-1 block text-holo">Turnos de manutenção</span>
          <input type="number" min={1} max={100} value={turns} onChange={(e) => setTurns(Math.max(1, Math.min(100, Number(e.target.value) || 1)))} className="field-input w-28 font-mono" />
          <span className="mt-1 block text-xs text-fg-muted">
            {power.per_turn_cost > 0
              ? `O custo inicial é cobrado agora. Cada turno de manutenção cobra ${power.per_turn_cost} PC quando você clicar em “Próximo turno”; você pode encerrar antes.`
              : "O efeito fica ativo pelos turnos escolhidos; avance com “Próximo turno” ou encerre antes."}
          </span>
        </label>
      )}
      {classId === "esoterico" && power.components.some((x) => x.type === "damage") && (
        <label className="mt-4 flex items-center gap-2 text-sm text-fg-dim">
          <input type="checkbox" className="accent-[var(--color-holo)]" checked={lenda} onChange={(e) => setLenda(e.target.checked)} />
          Alvo é uma lenda (+1d6 — Esotérico)
        </label>
      )}
      <p className="mt-4 text-xs text-fg-muted">Sem teste de acerto: só os dados de efeito são rolados, no servidor.</p>
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
    const token = state.beginRoll(`Turno: ${e.label}`);
    const res = await advanceEffect(state.character.id, e.id, await makeRequestId());
    setBusy(null);
    if (!res.ok) {
      state.failRoll(token);
      return toast(res.error, "error");
    }
    const p = res.data!.result as EffectTickPayload;
    if (e.form_id) state.patchForm(e.form_id, { pc_current: p.pcAfter });
    state.setEffects((list) => list.map((x) => (x.id === e.id ? { ...x, turns_paid: p.turnsPaid, active: p.active } : x)).filter((x) => x.active));
    state.finishRoll(token, res.data!);
  }

  async function end(e: EffectRow) {
    setBusy(e.id);
    // Otimista: some da lista na hora; volta se o banco recusar.
    state.setEffects((list) => list.filter((x) => x.id !== e.id));
    const res = await endEffect(state.character.id, e.id);
    setBusy(null);
    if (!res.ok) {
      state.setEffects((list) => [...list, e]);
      return toast(res.error, "error");
    }
    toast(res.message ?? "Encerrado.");
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
              <div className="min-w-0">
                <p className="text-sm break-words text-fg">{e.label}</p>
                <p className="font-mono text-[0.62rem] text-fg-dim">
                  {e.per_turn_cost > 0 ? `${e.per_turn_cost} PC/TURNO · ` : ""}TURNO {e.turns_paid}
                  {e.turns_total ? `/${e.turns_total}` : ""}
                  {remaining !== null && ` · ${remaining} RESTANTE(S)`}
                </p>
              </div>
              {state.canEdit && (
                <div className="flex gap-2">
                  <Button size="sm" variant="secondary" onClick={() => advance(e)} loading={busy === e.id} disabled={!state.noPc && state.form.pc_current < e.per_turn_cost}>
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
