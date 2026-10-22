import { RULES_CONFIG, applyRounding } from "./config.ts";
import {
  BUFFS,
  CONDITIONS,
  DAMAGE_AREA,
  DAMAGE_AREA_SIZES,
  DAMAGE_SINGLE,
  EXTRA_DIE_COST,
  HEAL_AREA_MODIFIER,
  HEAL_CONTINUOUS,
  HEAL_EXTRA_DIE,
  HEAL_SINGLE,
  SHIELD,
  SHIELD_DURATION,
  SHIELD_EXTRA_DIE,
  type AreaSize,
} from "./data/powerTables.ts";
import { addDice, parseDice } from "./dice.ts";
import { powerLimits } from "./progression.ts";

export type AreaChoice = "alvo" | AreaSize["id"];

export type PowerComponent =
  | { type: "damage"; tier: number; extraDice: number; area: AreaChoice }
  | { type: "heal"; tier: number; extraDice: number; area: AreaChoice }
  | { type: "heal_continuous"; tier: number }
  | { type: "shield"; tier: number; extraDice: number; duration: string }
  | { type: "condition"; intensity: string }
  | { type: "buff"; buff: string };

export interface ComponentCost {
  type: PowerComponent["type"];
  label: string;
  initial: number;
  perTurn: number;
  dice: string | null;
  extraDice: number;
  details: string[];
}

export interface PowerCost {
  components: ComponentCost[];
  fullInitial: number;
  initial: number;
  perTurn: number;
  extraDice: number;
  limits: { maxPc: number; maxExtraDice: number };
  /** Sem limites de PC e dados extras (Prodígio). */
  unlimited: boolean;
  /** Dano bônus do Amaldiçoado: +1d6 a cada 2 dados de dano. */
  bonusDamageDice: string | null;
  valid: boolean;
  errors: string[];
}

function tierAt<T>(table: T[], i: number, what: string): T {
  const row = table[i];
  if (!row) throw new RangeError(`Faixa inválida para ${what}.`);
  return row;
}

function nonNegInt(n: number, what: string) {
  if (!Number.isInteger(n) || n < 0) throw new RangeError(`${what} deve ser um inteiro ≥ 0.`);
}

export function componentCost(c: PowerComponent): ComponentCost {
  switch (c.type) {
    case "damage": {
      nonNegInt(c.extraDice, "Dados extras");
      const single = c.area === "alvo";
      const t = tierAt(single ? DAMAGE_SINGLE : DAMAGE_AREA, c.tier, "dano");
      const size = single ? null : DAMAGE_AREA_SIZES.find((s) => s.id === c.area);
      if (!single && !size) throw new RangeError("Área inválida.");
      const initial = t.cost + c.extraDice * EXTRA_DIE_COST + (size?.damageCost ?? 0);
      const details = [`${single ? "Dano contra 1 alvo" : "Dano em área"}: ${t.dice} (${t.cost} PC)`];
      if (c.extraDice) details.push(`+${c.extraDice} dado(s) extra(s): +${c.extraDice * EXTRA_DIE_COST} PC`);
      if (size) details.push(`${size.name} (${size.radiusM} m): ${size.damageCost ? `+${size.damageCost} PC` : "custo normal"}`);
      return { type: "damage", label: "Dano", initial, perTurn: 0, dice: addDice(t.dice, c.extraDice), extraDice: c.extraDice, details };
    }
    case "heal": {
      nonNegInt(c.extraDice, "Dados extras");
      const t = tierAt(HEAL_SINGLE, c.tier, "cura");
      const areaCost = HEAL_AREA_MODIFIER[c.area];
      if (areaCost === undefined) throw new RangeError("Área inválida.");
      const initial = t.cost + c.extraDice * EXTRA_DIE_COST + areaCost;
      const details = [`Cura: ${t.dice} (${t.cost} PC)`];
      if (c.extraDice) details.push(`+${c.extraDice}d6: +${c.extraDice * EXTRA_DIE_COST} PC`);
      if (c.area !== "alvo") {
        const size = DAMAGE_AREA_SIZES.find((s) => s.id === c.area)!;
        details.push(`Cura em área ${size.radiusM} m: +${areaCost} PC`);
      }
      return { type: "heal", label: "Cura", initial, perTurn: 0, dice: addDice(t.dice, c.extraDice, HEAL_EXTRA_DIE), extraDice: c.extraDice, details };
    }
    case "heal_continuous": {
      const t = tierAt(HEAL_CONTINUOUS, c.tier, "cura contínua");
      return { type: "heal_continuous", label: "Cura contínua", initial: 0, perTurn: t.perTurn, dice: t.dice, extraDice: 0, details: [`${t.dice} PV/turno: ${t.perTurn} PC/turno`] };
    }
    case "shield": {
      nonNegInt(c.extraDice, "Dados extras");
      const t = tierAt(SHIELD, c.tier, "escudo");
      const d = SHIELD_DURATION.find((x) => x.id === c.duration);
      if (!d) throw new RangeError("Duração de escudo inválida.");
      const initial = t.cost + c.extraDice * EXTRA_DIE_COST + d.cost;
      const details = [`Escudo: ${t.dice} (${t.cost} PC)`, `Duração ${d.name}: ${d.cost ? `+${d.cost} PC` : "normal"}`];
      if (c.extraDice) details.push(`+${c.extraDice}d8: +${c.extraDice * EXTRA_DIE_COST} PC`);
      return { type: "shield", label: "Escudo", initial, perTurn: 0, dice: addDice(t.dice, c.extraDice, SHIELD_EXTRA_DIE), extraDice: c.extraDice, details };
    }
    case "condition": {
      const t = CONDITIONS.find((x) => x.id === c.intensity);
      if (!t) throw new RangeError("Intensidade de condição inválida.");
      return { type: "condition", label: `Condição ${t.name}`, initial: t.initial, perTurn: t.perTurn, dice: null, extraDice: 0, details: [`${t.name} (${t.examples}): ${t.initial} PC + ${t.perTurn} PC/turno`] };
    }
    case "buff": {
      const t = BUFFS.find((x) => x.id === c.buff);
      if (!t) throw new RangeError("Melhoria inválida.");
      return { type: "buff", label: t.name, initial: t.initial, perTurn: t.perTurn, dice: null, extraDice: 0, details: [`${t.name}: ${t.initial} PC + ${t.perTurn} PC/turno`] };
    }
  }
}

function countDice(expr: string): number {
  return parseDice(expr).terms.reduce((a, t) => a + (t.sides > 0 ? t.count : 0), 0);
}

export function computePowerCost(components: PowerComponent[], level: number, originId?: string | null): PowerCost {
  const errors: string[] = [];
  const parts: ComponentCost[] = [];
  for (const c of components) {
    try {
      parts.push(componentCost(c));
    } catch (e) {
      errors.push((e as Error).message);
    }
  }
  const prodigio = originId === "prodigio";
  const pp = RULES_CONFIG.prodigioPowers;
  if (components.length === 0 && !(prodigio && pp.allowNoEffects)) errors.push("Adicione pelo menos um efeito.");
  if (components.length > 10) errors.push("Efeitos demais.");

  const fullInitial = parts.reduce((a, p) => a + p.initial, 0);
  const perTurn = parts.reduce((a, p) => a + p.perTurn, 0);
  const extraDice = parts.reduce((a, p) => a + p.extraDice, 0);
  const limits = powerLimits(level);
  const cursed = originId === "amaldicoado";
  let initial = cursed ? applyRounding(fullInitial / 2, RULES_CONFIG.amaldicoadoCostRounding) : fullInitial;
  let perTurnFinal = cursed ? applyRounding(perTurn / 2, RULES_CONFIG.amaldicoadoCostRounding) : perTurn;
  // Prodígio não usa PC: nada é cobrado (o custo cheio fica só como referência).
  if (prodigio && pp.noPcCost) {
    initial = 0;
    perTurnFinal = 0;
  }

  const costForLimit =
    (cursed && !RULES_CONFIG.amaldicoadoLimitUsesFullCost ? initial : fullInitial) +
    (RULES_CONFIG.perTurnCostCountsTowardLimit ? perTurn : 0);
  const limited = !(prodigio && pp.noLimits);
  if (limited && costForLimit > limits.maxPc) errors.push(`Custo de ${costForLimit} PC acima do limite de ${limits.maxPc} PC por habilidade no nível ${level}.`);
  if (limited && extraDice > limits.maxExtraDice) errors.push(`${extraDice} dados extras acima do máximo de +${limits.maxExtraDice} no nível ${level}.`);

  let bonusDamageDice: string | null = null;
  if (cursed) {
    const dmgDice = parts.filter((p) => p.type === "damage" && p.dice).reduce((a, p) => a + countDice(p.dice!), 0);
    const bonus = Math.floor(dmgDice / 2);
    if (bonus > 0) bonusDamageDice = `${bonus}d6`;
  }

  return { components: parts, fullInitial, initial, perTurn: perTurnFinal, extraDice, limits, unlimited: !limited, bonusDamageDice, valid: errors.length === 0, errors };
}

/** Verificação de gasto de PC (a operação atômica real acontece no banco). */
export function canSpend(currentPc: number, cost: number): boolean {
  return Number.isInteger(cost) && cost >= 0 && currentPc >= cost;
}
