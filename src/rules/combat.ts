/**
 * Ataques com armas e uso de poderes — monta o "plano" (perícia, modificadores,
 * expressões de dano) e executa as rolagens. Sem interface, sem banco.
 */
import { RULES_CONFIG, applyRounding } from "./config.ts";
import { OUTCOME_EFFECT, isSuccess, rollTest, type D100Test } from "./d100.ts";
import { TECHNIQUE_BY_ID, WEAPON_MODIFIER_BY_ID, type AttackKind, type RollEffect, type WeaponTag } from "./data/equipment.ts";
import { prodigioExtraWeaponDice } from "./data/origins.ts";
import { addDice, cryptoRng, formatDice, parseDice, rollExpression, type RollResult, type Rng } from "./dice.ts";
import { componentCost, computePowerCost, type PowerComponent } from "./powers.ts";

// ------------------------------------------------------------------ Armas

export interface WeaponLike {
  name: string;
  damage: string;
  attackKind: AttackKind;
  tags: WeaponTag[];
  /** Perícia definida no item (arma personalizada / decisão do Mestre). */
  skillOverride?: string | null;
  modifiers: string[];
  /** Modificadores personalizados (Homebrew), copiados para a arma. */
  customModifiers?: CustomModifier[];
}

/** Modificador criado no Homebrew. `requires: "qualquer"` serve para qualquer arma. */
export interface CustomModifier {
  id: string;
  name: string;
  requires: WeaponTag | "qualquer";
  text?: string;
  always?: RollEffect;
  onCritical?: RollEffect;
  condition?: string;
  requirements?: string;
  /** Regra especial: não ocupa vaga do limite de modificadores. */
  ignoreLimit?: boolean;
}

export function customModifierCompatible(m: Pick<CustomModifier, "requires">, tags: readonly string[]): boolean {
  return m.requires === "qualquer" || tags.includes(m.requires);
}

/** Vagas de modificação ocupadas (oficiais permanentes + personalizados que contam no limite). */
export function modifierSlotsUsed(officialPermanent: number, custom: readonly Pick<CustomModifier, "ignoreLimit">[]): number {
  return officialPermanent + custom.filter((m) => !m.ignoreLimit).length;
}

export interface AttackContext {
  classId: string | null;
  originId: string | null;
  pathId: string | null;
  level: number;
  skillValues: Record<string, number>;
  /** Opções situacionais marcadas: "mod:<modificador>:<opção>", "ctx:<id>" ou "tec:<técnica>". */
  options?: string[];
  /** Técnicas do Arsenal que podem entrar neste ataque (aprendidas, não suspensas e disponíveis). */
  allowedTechniques?: string[];
}

export interface AttackOption {
  key: string;
  label: string;
  source: string;
}

/** Ajusta a quantidade do dado principal da arma (+n ou −n; nunca abaixo de 1 dado). */
export function adjustWeaponDice(expr: string, n: number): string {
  if (n === 0) return expr;
  if (n > 0) return addDice(expr, n);
  const parsed = parseDice(expr);
  const dice = parsed.terms.filter((t) => t.sides > 0 && t.sign === 1);
  if (dice.length === 0) return expr;
  const biggest = dice.reduce((a, b) => (b.sides > a.sides ? b : a));
  biggest.count = Math.max(1, biggest.count + n);
  return formatDice(parsed.terms);
}

/** Opções situacionais disponíveis para esta arma e este personagem. */
/** Prévia dos efeitos de uma arma (sem bônus de classe/origem): usada pelos criadores do Homebrew. */
export function weaponPreview(weapon: WeaponLike): { attackBonus: number; damage: string; critical: string; applied: string[]; conditions: string[] } {
  const p = planAttack(weapon, { classId: null, originId: null, pathId: null, level: 1, skillValues: {} });
  return { attackBonus: -p.rollModifier, damage: p.damageExpr, critical: p.criticalExpr, applied: p.applied, conditions: p.conditions };
}

export function attackOptions(weapon: WeaponLike, ctx: Pick<AttackContext, "classId" | "originId" | "pathId">): AttackOption[] {
  const out: AttackOption[] = [];
  for (const id of weapon.modifiers) {
    const m = WEAPON_MODIFIER_BY_ID[id];
    for (const o of m?.options ?? []) out.push({ key: `mod:${id}:${o.id}`, label: o.label, source: m!.name });
  }
  if (ctx.classId === "esoterico") out.push({ key: "ctx:alvo_lenda", label: "Alvo é uma lenda (+1d6)", source: "Esotérico" });
  if (ctx.classId === "rato") out.push({ key: "ctx:furtivo", label: "Furtivo com a roupa de furtividade (dano ×2)", source: "Rato" });
  if (ctx.classId === "atirador" && weapon.attackKind === "firearm") out.push({ key: "ctx:mira", label: "Gastou a ação mirando com a mira (2 vantagens)", source: "Atirador" });
  return out;
}

export interface AttackPlan {
  name: string;
  skillId: string;
  skillValue: number;
  rollModifier: number;
  advantage: number;
  baseDamage: string;
  damageExpr: string;
  criticalExpr: string;
  damageFactor: number;
  applied: string[];
  conditions: string[];
}

function mergeEffect(e: RollEffect | undefined, acc: { attack: number; dice: number; extra: string[]; adv: number }) {
  if (!e) return;
  acc.attack += e.attackBonus ?? 0;
  acc.dice += e.extraWeaponDice ?? 0;
  if (e.extraDamage) acc.extra.push(e.extraDamage);
  acc.adv += e.advantage ?? 0;
}

export function planAttack(weapon: WeaponLike, ctx: AttackContext): AttackPlan {
  parseDice(weapon.damage);
  const skillId = weapon.skillOverride || RULES_CONFIG.attackSkill[weapon.attackKind];
  const opts = new Set(ctx.options ?? []);
  const acc = { attack: 0, dice: 0, extra: [] as string[], adv: 0 };
  const crit = { attack: 0, dice: 0, extra: [] as string[], adv: 0 };
  const applied: string[] = [];
  const conditions: string[] = [];

  for (const id of weapon.modifiers) {
    const m = WEAPON_MODIFIER_BY_ID[id];
    if (!m || !weapon.tags.includes(m.requires)) continue; // incompatível: ignorado
    if (m.always) {
      mergeEffect(m.always, acc);
      applied.push(m.name);
    }
    if (m.onCritical) mergeEffect(m.onCritical, crit);
    for (const o of m.options ?? []) {
      if (opts.has(`mod:${id}:${o.id}`)) {
        mergeEffect(o, acc);
        applied.push(`${m.name}: ${o.label}`);
      }
    }
    if (m.condition) conditions.push(`${m.name} — ${m.condition}`);
  }
  for (const m of weapon.customModifiers ?? []) {
    if (!customModifierCompatible(m, weapon.tags)) continue;
    if (m.always) {
      mergeEffect(m.always, acc);
      applied.push(m.name);
    }
    if (m.onCritical) mergeEffect(m.onCritical, crit);
    if (m.condition) conditions.push(`${m.name} — ${m.condition}`);
  }

  // Origem e classe
  const prodigio = ctx.originId === "prodigio";
  if (prodigio) {
    const n = prodigioExtraWeaponDice(ctx.level);
    acc.dice += n;
    applied.push(`Combatente de Guerra (+${n} dado${n > 1 ? "s" : ""})`);
    if (ctx.pathId === "engrenagem") {
      acc.attack += 15;
      applied.push("Ferramenta Autoral (−15 no dado)");
    }
  }
  if (ctx.classId === "brawler" && weapon.attackKind !== "firearm") {
    if (prodigio) applied.push("Porrada forte não acumula com o Prodígio");
    else {
      acc.extra.push("1d4");
      applied.push("Porrada forte (+1d4)");
    }
  }
  if (opts.has("ctx:alvo_lenda") && ctx.classId === "esoterico") {
    acc.extra.push("1d6");
    applied.push("Ligação oculta (+1d6 contra lenda)");
  }
  for (const tid of ctx.allowedTechniques ?? []) {
    const t = TECHNIQUE_BY_ID[tid];
    if (!t?.attack || !opts.has(`tec:${tid}`)) continue;
    acc.dice += t.attack.extraWeaponDice ?? 0;
    if (t.attack.extraDamage) acc.extra.push(t.attack.extraDamage);
    applied.push(`${t.name}${t.attack.extraWeaponDice ? ` (+${t.attack.extraWeaponDice} dado)` : t.attack.extraDamage ? ` (+${t.attack.extraDamage})` : ""}`);
  }
  let damageFactor = 1;
  if (opts.has("ctx:furtivo") && ctx.classId === "rato") {
    damageFactor = 2;
    applied.push("Roupa de furtividade (dano ×2)");
  }
  if (opts.has("ctx:mira") && ctx.classId === "atirador" && weapon.attackKind === "firearm") {
    acc.adv += 2;
    applied.push("Mira (2 vantagens)");
  }

  const withDice = adjustWeaponDice(weapon.damage, acc.dice);
  const damageExpr = [withDice, ...acc.extra].join("+");
  const criticalExpr = [adjustWeaponDice(withDice, crit.dice), ...acc.extra, ...crit.extra].join("+");
  return {
    name: weapon.name,
    skillId,
    skillValue: ctx.skillValues[skillId] ?? 0,
    rollModifier: -acc.attack,
    advantage: acc.adv,
    baseDamage: weapon.damage,
    damageExpr,
    criticalExpr,
    damageFactor,
    applied,
    conditions,
  };
}

export interface AttackOutcome {
  plan: AttackPlan;
  test: D100Test;
  hit: boolean;
  damageRoll: RollResult | null;
  rolledDamage: number;
  multiplier: number;
  finalDamage: number;
  note: string | null;
}

/** Executa: 1d100 → classificação → dano (somente se acertar) → multiplicador (extremo OU crítico). */
export function performAttack(plan: AttackPlan, rng: Rng = cryptoRng): AttackOutcome {
  const test = rollTest(plan.name, plan.skillValue, { rollModifier: plan.rollModifier, advantage: plan.advantage, rng });
  const hit = isSuccess(test.outcome);
  if (!hit) {
    return {
      plan,
      test,
      hit,
      damageRoll: null,
      rolledDamage: 0,
      multiplier: 0,
      finalDamage: 0,
      note: test.outcome === "critical_failure" ? `Falha crítica: ${OUTCOME_EFFECT.critical_failure.toLowerCase()}.` : "O ataque não acertou.",
    };
  }
  const crit = test.outcome === "critical_success";
  const damageRoll = rollExpression(crit ? plan.criticalExpr : plan.damageExpr, rng);
  // Extremo (×1,5) e crítico (×2) não se acumulam.
  const multiplier = crit ? RULES_CONFIG.damageMultiplier.critical : test.outcome === "extreme" ? RULES_CONFIG.damageMultiplier.extreme : 1;
  const finalDamage = applyRounding(damageRoll.total * multiplier * plan.damageFactor, RULES_CONFIG.damageRounding);
  return { plan, test, hit, damageRoll, rolledDamage: damageRoll.total, multiplier, finalDamage, note: null };
}

// ------------------------------------------------------------------ Poderes

export interface PowerUseContext {
  classId: string | null;
  originId: string | null;
  /** Opções: "alvo_lenda" (Esotérico). */
  options?: string[];
}

export interface PowerEffectRoll {
  label: string;
  kind: "dano" | "cura" | "escudo" | "cura_continua";
  expression: string;
  roll: RollResult;
}

export interface PowerUsePlan {
  effects: { label: string; kind: PowerEffectRoll["kind"]; expression: string }[];
  notes: string[];
}

/** Quais dados rolar ao usar o poder (sem teste de acerto). */
export function planPowerUse(components: PowerComponent[], ctx: PowerUseContext): PowerUsePlan {
  const effects: PowerUsePlan["effects"] = [];
  const notes: string[] = [];
  const cost = computePowerCost(components, 1, ctx.originId);
  const opts = new Set(ctx.options ?? []);
  for (const c of components) {
    const cc = componentCost(c);
    if (c.type === "damage" && cc.dice) {
      const extra: string[] = [];
      if (ctx.originId === "amaldicoado" && cost.bonusDamageDice) extra.push(cost.bonusDamageDice);
      if (ctx.classId === "esoterico" && opts.has("alvo_lenda")) extra.push("1d6");
      effects.push({ label: cc.label, kind: "dano", expression: [cc.dice, ...extra].join("+") });
    } else if ((c.type === "heal" || c.type === "heal_continuous") && cc.dice) {
      const extra = ctx.classId === "healer" ? ["1d6"] : [];
      effects.push({ label: cc.label, kind: c.type === "heal" ? "cura" : "cura_continua", expression: [cc.dice, ...extra].join("+") });
    } else if (c.type === "shield" && cc.dice) {
      effects.push({ label: cc.label, kind: "escudo", expression: cc.dice });
    } else {
      notes.push(cc.details[0]);
    }
  }
  if (ctx.originId === "amaldicoado" && cost.bonusDamageDice) notes.push(`A dívida a pagar: +${cost.bonusDamageDice} de dano.`);
  if (ctx.classId === "healer" && effects.some((e) => e.kind === "cura" || e.kind === "cura_continua")) notes.push("Heróis não morrem: +1d6 de cura.");
  return { effects, notes };
}

export function rollPowerEffects(plan: PowerUsePlan, rng: Rng = cryptoRng): PowerEffectRoll[] {
  return plan.effects.map((e) => ({ ...e, roll: rollExpression(e.expression, rng) }));
}

/** Componentes com custo/efeito por turno (ativação contínua). */
export function isContinuous(components: PowerComponent[]): boolean {
  return components.some((c) => c.type === "heal_continuous" || c.type === "condition" || c.type === "buff");
}
