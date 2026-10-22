import { RULES_CONFIG, applyRounding } from "./config.ts";
import { isSuccess, rollTest, type D100Test } from "./d100.ts";
import type { AttackKind } from "./data/equipment.ts";
import { cryptoRng, rollExpression, type RollResult, type Rng } from "./dice.ts";

export interface AttackInput {
  name: string;
  damage: string;
  attackKind: AttackKind;
  skillValues: Record<string, number>;
  /** Dados de dano adicionais (classe, origem, modificadores), ex.: ["1d4"]. */
  extraDamage?: string[];
  rollModifier?: number;
  advantage?: number;
  rng?: Rng;
}

export interface AttackResult {
  name: string;
  skillId: string;
  test: D100Test;
  hit: boolean;
  damageRoll: RollResult | null;
  rolledDamage: number;
  multiplier: number;
  finalDamage: number;
}

export function attackSkillFor(kind: AttackKind): string {
  return RULES_CONFIG.attackSkill[kind];
}

export function damageMultiplier(test: D100Test): number {
  if (test.outcome === "critical_success") return RULES_CONFIG.damageMultiplier.critical;
  if (test.outcome === "extreme") return RULES_CONFIG.damageMultiplier.extreme;
  return 1;
}

export function resolveAttack(input: AttackInput): AttackResult {
  const rng = input.rng ?? cryptoRng;
  const skillId = attackSkillFor(input.attackKind);
  const value = input.skillValues[skillId] ?? 0;
  const test = rollTest(input.name, value, { rollModifier: input.rollModifier, advantage: input.advantage, rng });
  const hit = isSuccess(test.outcome);
  if (!hit) {
    return { name: input.name, skillId, test, hit, damageRoll: null, rolledDamage: 0, multiplier: 0, finalDamage: 0 };
  }
  const expr = [input.damage, ...(input.extraDamage ?? [])].join("+");
  const damageRoll = rollExpression(expr, rng);
  const multiplier = damageMultiplier(test);
  const finalDamage = applyRounding(damageRoll.total * multiplier, RULES_CONFIG.damageRounding);
  return { name: input.name, skillId, test, hit, damageRoll, rolledDamage: damageRoll.total, multiplier, finalDamage };
}
