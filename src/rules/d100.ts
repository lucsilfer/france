import { RULES_CONFIG, applyRounding } from "./config.ts";
import { cryptoRng, type Rng } from "./dice.ts";

export interface Thresholds {
  normal: number;
  good: number;
  extreme: number;
}

export type Outcome = "critical_success" | "critical_failure" | "extreme" | "good" | "normal" | "failure";

export const OUTCOME_LABEL: Record<Outcome, string> = {
  critical_success: "Acerto crítico",
  critical_failure: "Falha crítica",
  extreme: "Acerto extremo",
  good: "Acerto bom",
  normal: "Acerto normal",
  failure: "Falha",
};

/** Efeitos do livro (p. 5). */
export const OUTCOME_EFFECT: Record<Outcome, string> = {
  critical_failure: "Recebe 1,5× de dano no próximo turno",
  failure: "A ação não acontece",
  normal: "Efeito padrão da ação",
  good: "Acerto sólido, mais difícil de evitar",
  extreme: "1,5× de dano",
  critical_success: "Dano dobrado",
};

export function isSuccess(o: Outcome): boolean {
  return o === "critical_success" || o === "extreme" || o === "good" || o === "normal";
}

export function thresholds(value: number): Thresholds {
  const { goodDivisor, extremeDivisor, rounding } = RULES_CONFIG.thresholds;
  const v = Math.max(0, Math.floor(value));
  return {
    normal: v,
    good: applyRounding(v / goodDivisor, rounding),
    extreme: applyRounding(v / extremeDivisor, rounding),
  };
}

export function formatThresholds(value: number): string {
  const t = thresholds(value);
  return `${t.normal} / ${t.good} / ${t.extreme}`;
}

/**
 * Classifica um d100 (menor é melhor).
 * Prioridade: crítico (1) > falha crítica (100) > extremo > bom > normal > falha.
 * `rollModifier` soma ao resultado (negativo ajuda: "−15 como vantagem").
 * Os críticos usam sempre o valor natural do dado.
 */
export function classifyD100(natural: number, value: number, rollModifier = 0): Outcome {
  if (!Number.isInteger(natural) || natural < 1 || natural > 100) {
    throw new RangeError("O resultado do d100 deve ser um inteiro entre 1 e 100.");
  }
  if (natural === 1) return "critical_success";
  if (natural === 100) return "critical_failure";
  const effective = natural + rollModifier;
  const t = thresholds(value);
  if (effective <= t.extreme) return "extreme";
  if (effective <= t.good) return "good";
  if (effective <= t.normal) return "normal";
  return "failure";
}

export interface D100Test {
  label: string;
  value: number;
  thresholds: Thresholds;
  natural: number;
  rolls: number[];
  rollModifier: number;
  effective: number;
  outcome: Outcome;
  advantage: number;
}

/**
 * Executa um teste. `advantage` > 0 rola dados extras e mantém o menor
 * (modo configurável); < 0 (desvantagem) mantém o maior.
 */
export function rollTest(label: string, value: number, opts: { rollModifier?: number; advantage?: number; rng?: Rng } = {}): D100Test {
  const rng = opts.rng ?? cryptoRng;
  const rollModifier = opts.rollModifier ?? 0;
  const advantage = opts.advantage ?? 0;
  let rolls: number[];
  let natural: number;
  let extraMod = 0;
  if (advantage !== 0 && RULES_CONFIG.advantageMode === "roll_twice_keep_lowest") {
    rolls = Array.from({ length: 1 + Math.abs(advantage) }, () => rng(100));
    natural = advantage > 0 ? Math.min(...rolls) : Math.max(...rolls);
  } else {
    rolls = [rng(100)];
    natural = rolls[0];
    extraMod = advantage * -15;
  }
  const totalMod = rollModifier + extraMod;
  return {
    label,
    value,
    thresholds: thresholds(value),
    natural,
    rolls,
    rollModifier: totalMod,
    effective: natural + totalMod,
    outcome: classifyD100(natural, value, totalMod),
    advantage,
  };
}
