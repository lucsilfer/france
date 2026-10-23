/**
 * Monstros e NPCs (Homebrew e instâncias em campanha/combate).
 * O Mestre define os valores diretamente: nada de rolagem de criação, fórmula de PV
 * ou limite de 75 nas perícias. Os testes continuam no sistema d100 (normal / bom / extremo).
 */
import { RULES_CONFIG, applyRounding } from "./config.ts";
import { OUTCOME_LABEL, isSuccess, rollTest, thresholds, type D100Test, type Thresholds } from "./d100.ts";
import { ATTRIBUTE_IDS, ATTRIBUTES, type AttributeId } from "./data/attributes.ts";
import { SKILL_BY_ID } from "./data/skills.ts";
import { cryptoRng, isValidDice, rollExpression, type RollResult, type Rng } from "./dice.ts";

export interface CreatureCondition {
  name: string;
  turns: number | null;
}

export interface CreatureAttack {
  id: string;
  name: string;
  description?: string;
  /** "skill:<id>", "attr:<FOR…>" ou "valor" (usa `value`). */
  uses: string;
  value?: number | null;
  damage: string;
  damage_type?: string;
  range?: string;
  effects?: string;
  conditions?: CreatureCondition[];
}

export interface CreatureAbility {
  id: string;
  name: string;
  description?: string;
  type?: string;
  damage?: string;
  heal?: string;
  condition?: CreatureCondition | null;
  area?: string;
  duration?: string;
  pc_cost?: number;
  special?: string;
  /** Teste opcional para usar a habilidade (mesmo formato do ataque). */
  uses?: string;
  value?: number | null;
  /** Efeito configurado à mão: o sistema só registra, o Mestre aplica. */
  manual?: boolean;
}

export interface CreatureSkill {
  /** Perícia oficial (id) ou personalizada ("custom:<nome>"). */
  id: string;
  name?: string;
  value: number;
}

export interface CreatureItem {
  name: string;
  quantity?: number;
  notes?: string;
}

export interface CreatureSheet {
  attributes: Partial<Record<AttributeId, number>>;
  skills: CreatureSkill[];
  pv_max: number | null;
  pc_max: number | null;
  pv_current: number | null;
  pc_current: number | null;
  defense: string;
  resistances: string[];
  vulnerabilities: string[];
  immunities: string[];
  movement: string;
  attacks: CreatureAttack[];
  abilities: CreatureAbility[];
  inventory: CreatureItem[];
  conditions: CreatureCondition[];
}

const str = (v: unknown, max = 2000) => (typeof v === "string" ? v.slice(0, max) : "");
const int = (v: unknown, min = 0, max = 99999): number | null => {
  const n = typeof v === "string" && v.trim() !== "" ? Number(v) : v;
  return typeof n === "number" && Number.isFinite(n) ? Math.max(min, Math.min(max, Math.round(n))) : null;
};
const list = (v: unknown): string[] => (Array.isArray(v) ? v.filter((x): x is string => typeof x === "string" && x.trim() !== "").map((x) => x.trim().slice(0, 120)).slice(0, 30) : []);
const cond = (v: unknown): CreatureCondition | null => {
  if (!v || typeof v !== "object") return null;
  const o = v as Record<string, unknown>;
  const name = str(o.name, 80).trim();
  return name ? { name, turns: int(o.turns, 1, 100) } : null;
};
let seq = 0;
const newId = () => `c${Date.now().toString(36)}${(seq++).toString(36)}`;

/** Lê dados de monstro/NPC (incluindo o formato antigo da Fase 4: ataques com `skill` numérico). */
export function normalizeCreature(raw: unknown): CreatureSheet {
  const d = (raw && typeof raw === "object" ? raw : {}) as Record<string, unknown>;
  const attrsIn = (d.attributes && typeof d.attributes === "object" ? d.attributes : {}) as Record<string, unknown>;
  const attributes: Partial<Record<AttributeId, number>> = {};
  for (const id of ATTRIBUTE_IDS) {
    const v = int(attrsIn[id], 0, 999);
    if (v !== null) attributes[id] = v;
  }
  const skills: CreatureSkill[] = (Array.isArray(d.skills) ? d.skills : [])
    .map((s) => s as Record<string, unknown>)
    .filter((s) => typeof s.id === "string" && int(s.value, 0, 999) !== null)
    .map((s) => ({ id: str(s.id, 80), name: str(s.name, 80) || undefined, value: int(s.value, 0, 999)! }))
    .slice(0, 60);
  const attacks: CreatureAttack[] = (Array.isArray(d.attacks) ? d.attacks : [])
    .map((a) => a as Record<string, unknown>)
    .filter((a) => str(a.name).trim() && isValidDice(str(a.damage, 60).trim() || "x"))
    .map((a) => {
      const legacy = typeof a.skill === "number" && !a.uses;
      return {
        id: str(a.id, 40) || newId(),
        name: str(a.name, 80).trim(),
        description: str(a.description) || undefined,
        uses: legacy ? "valor" : str(a.uses, 40) || "valor",
        value: legacy ? int(a.skill, 0, 999) : int(a.value, 0, 999),
        damage: str(a.damage, 60).trim(),
        damage_type: str(a.damage_type, 40) || undefined,
        range: str(a.range, 60) || undefined,
        effects: str(a.effects) || undefined,
        conditions: (Array.isArray(a.conditions) ? a.conditions : []).map(cond).filter((c): c is CreatureCondition => !!c).slice(0, 5),
      };
    })
    .slice(0, 20);
  const abilities: CreatureAbility[] = (Array.isArray(d.abilities) ? d.abilities : [])
    .map((a) => a as Record<string, unknown>)
    .filter((a) => str(a.name).trim())
    .map((a) => ({
      id: str(a.id, 40) || newId(),
      name: str(a.name, 80).trim(),
      description: str(a.description) || undefined,
      type: str(a.type, 40) || undefined,
      damage: isValidDice(str(a.damage, 60).trim()) ? str(a.damage, 60).trim() : undefined,
      heal: isValidDice(str(a.heal, 60).trim()) ? str(a.heal, 60).trim() : undefined,
      condition: cond(a.condition),
      area: str(a.area, 60) || undefined,
      duration: str(a.duration, 60) || undefined,
      pc_cost: int(a.pc_cost, 0, 9999) ?? 0,
      special: str(a.special) || undefined,
      uses: str(a.uses, 40) || undefined,
      value: int(a.value, 0, 999),
      manual: Boolean(a.manual),
    }))
    .slice(0, 30);
  // Fase 4: habilidades eram um texto livre.
  if (abilities.length === 0 && typeof d.abilities === "string" && d.abilities.trim()) {
    abilities.push({ id: "legado", name: "Habilidades", description: d.abilities.slice(0, 2000), manual: true, pc_cost: 0 });
  }
  const inventory: CreatureItem[] = (Array.isArray(d.inventory) ? d.inventory : [])
    .map((i) => i as Record<string, unknown>)
    .filter((i) => str(i.name).trim())
    .map((i) => ({ name: str(i.name, 120).trim(), quantity: int(i.quantity, 0, 9999) ?? 1, notes: str(i.notes, 500) || undefined }))
    .slice(0, 60);
  return {
    attributes,
    skills,
    pv_max: int(d.pv_max) ?? int(d.pv),
    pc_max: int(d.pc_max) ?? int(d.pc),
    pv_current: int(d.pv_current),
    pc_current: int(d.pc_current),
    defense: str(d.defense, 60),
    resistances: list(d.resistances),
    vulnerabilities: list(d.vulnerabilities),
    immunities: list(d.immunities),
    movement: str(d.movement, 60),
    attacks,
    abilities,
    inventory,
    conditions: (Array.isArray(d.conditions) ? d.conditions : []).map(cond).filter((c): c is CreatureCondition => !!c).slice(0, 20),
  };
}

/** Nome legível de "skill:luta" / "attr:FOR" / "valor". */
export function usesLabel(uses: string | undefined, sheet?: CreatureSheet): string {
  if (!uses || uses === "valor") return "Valor fixo";
  const [k, ...rest] = uses.split(":");
  const id = rest.join(":");
  if (k === "attr") return ATTRIBUTES.find((a) => a.id === id)?.name ?? id;
  if (k === "skill") return SKILL_BY_ID[id]?.name ?? sheet?.skills.find((s) => s.id === id)?.name ?? id.replace(/^custom:/, "");
  return uses;
}

/** Valor do teste d100 de um ataque/habilidade da criatura. */
export function testValue(sheet: CreatureSheet, uses: string | undefined, value?: number | null): number {
  if (!uses || uses === "valor") return value ?? 0;
  const [k, ...rest] = uses.split(":");
  const id = rest.join(":");
  if (k === "attr") return sheet.attributes[id as AttributeId] ?? 0;
  if (k === "skill") return sheet.skills.find((s) => s.id === id)?.value ?? value ?? 0;
  return value ?? 0;
}

export function creatureThresholds(v: number): Thresholds {
  return thresholds(v);
}

export interface CreatureAttackResult {
  name: string;
  value: number;
  test: D100Test;
  outcomeLabel: string;
  hit: boolean;
  damage: RollResult | null;
  multiplier: number;
  finalDamage: number;
  conditions: CreatureCondition[];
}

/** d100 contra o valor; se acertar, rola o dano (extremo ×1,5, crítico ×2 — como nos personagens). */
export function rollCreatureAttack(sheet: CreatureSheet, attack: CreatureAttack, rng: Rng = cryptoRng): CreatureAttackResult {
  const value = testValue(sheet, attack.uses, attack.value);
  const test = rollTest(attack.name, value, { rng });
  const hit = isSuccess(test.outcome);
  if (!hit) return { name: attack.name, value, test, outcomeLabel: OUTCOME_LABEL[test.outcome], hit, damage: null, multiplier: 0, finalDamage: 0, conditions: [] };
  const damage = rollExpression(attack.damage, rng);
  const multiplier = test.outcome === "critical_success" ? RULES_CONFIG.damageMultiplier.critical : test.outcome === "extreme" ? RULES_CONFIG.damageMultiplier.extreme : 1;
  return {
    name: attack.name,
    value,
    test,
    outcomeLabel: OUTCOME_LABEL[test.outcome],
    hit,
    damage,
    multiplier,
    finalDamage: applyRounding(damage.total * multiplier, RULES_CONFIG.damageRounding),
    conditions: attack.conditions ?? [],
  };
}

export interface CreatureAbilityResult {
  name: string;
  pcCost: number;
  test: D100Test | null;
  outcomeLabel: string | null;
  success: boolean;
  damage: RollResult | null;
  heal: RollResult | null;
  condition: CreatureCondition | null;
  manual: boolean;
}

/** Usa a habilidade: teste opcional, dano/cura rolados, condição sugerida. O custo de PC é cobrado à parte (no banco). */
export function rollCreatureAbility(sheet: CreatureSheet, ability: CreatureAbility, rng: Rng = cryptoRng): CreatureAbilityResult {
  const test = ability.uses ? rollTest(ability.name, testValue(sheet, ability.uses, ability.value), { rng }) : null;
  const success = test ? isSuccess(test.outcome) : true;
  return {
    name: ability.name,
    pcCost: ability.pc_cost ?? 0,
    test,
    outcomeLabel: test ? OUTCOME_LABEL[test.outcome] : null,
    success,
    damage: success && ability.damage && !ability.manual ? rollExpression(ability.damage, rng) : null,
    heal: success && ability.heal && !ability.manual ? rollExpression(ability.heal, rng) : null,
    condition: success ? (ability.condition ?? null) : null,
    manual: Boolean(ability.manual),
  };
}

/** Uma linha de resumo (cartões, lista de combatentes). */
export function creatureSummary(sheet: CreatureSheet): string {
  const bits: string[] = [];
  if (sheet.pv_max != null) bits.push(`PV ${sheet.pv_max}`);
  if (sheet.pc_max != null) bits.push(`PC ${sheet.pc_max}`);
  if (sheet.defense) bits.push(`Def ${sheet.defense}`);
  if (sheet.attacks.length) bits.push(`${sheet.attacks.length} ataque${sheet.attacks.length > 1 ? "s" : ""}`);
  if (sheet.abilities.length) bits.push(`${sheet.abilities.length} habilidade${sheet.abilities.length > 1 ? "s" : ""}`);
  return bits.join(" · ");
}
