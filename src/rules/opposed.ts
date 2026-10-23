/**
 * Combate por rolagens opostas (Fase 6).
 *
 * 1. Atacante e defensor rolam 1d100.
 * 2. Vence o CONFRONTO quem tirar o MENOR resultado (RULES_CONFIG.opposed.winner = "lower").
 * 3. Empate: jogador × NPC/monstro → o jogador vence; jogador × jogador e NPC × NPC → maior valor na
 *    perícia correspondente (ataque × reação); persistindo o empate → nova rolagem oposta.
 * 4. A QUALIDADE (normal / bom / extremo / crítico) é a classificação normal do d100 do atacante contra a
 *    perícia de ataque (menor é melhor). Só multiplica o dano quando o ataque vence: extremo ×1,5,
 *    resultado 1 ×2 (não acumulam). Demais resultados: dano padrão.
 *
 * Este arquivo é a referência; o banco (public.confront_outcome / public.combat_confront) faz a mesma conta
 * e um teste de paridade compara os dois.
 */
import { RULES_CONFIG, applyRounding } from "./config.ts";
import { OUTCOME_LABEL, classifyD100, type Outcome } from "./d100.ts";
import { cryptoRng, rollExpression, type RollResult, type Rng } from "./dice.ts";
import type { AttackKind } from "./data/equipment.ts";

export type Reaction = "luta" | "reflexo" | string;

export interface ConfrontSide {
  name: string;
  /** Personagem de jogador (vence empates contra NPCs e monstros). */
  isPlayer: boolean;
  /** Perícia usada na qualidade (atacante) e no desempate. */
  skillValue: number;
}

export type TieBreak = "none" | "player" | "skill" | "reroll";

export interface ConfrontOutcome {
  winner: "attacker" | "defender" | "reroll";
  tieBreak: TieBreak;
  /** Qualidade da rolagem do atacante (menor é melhor). */
  quality: Outcome;
  /** Qualidade da rolagem do defensor contra a perícia de reação (informativo). */
  defenderQuality: Outcome;
  multiplier: number;
}

/** Quem vence comparando os dois d100 (sem desempate). */
function compareRolls(a: number, d: number): "attacker" | "defender" | "tie" {
  if (a === d) return "tie";
  const higher = RULES_CONFIG.opposed.winner === "higher";
  return (a > d) === higher ? "attacker" : "defender";
}

/** Resultado de UMA rodada de rolagens opostas (função pura — mesma regra do banco). */
export function confrontOutcome(attackRoll: number, defendRoll: number, attacker: ConfrontSide, defender: ConfrontSide, rollModifier = 0): ConfrontOutcome {
  const quality = classifyD100(attackRoll, attacker.skillValue, rollModifier);
  const defenderQuality = classifyD100(defendRoll, defender.skillValue);
  let winner: ConfrontOutcome["winner"];
  let tieBreak: TieBreak = "none";
  const cmp = compareRolls(attackRoll, defendRoll);
  if (cmp !== "tie") winner = cmp;
  else if (RULES_CONFIG.opposed.tiePlayerWins && attacker.isPlayer !== defender.isPlayer) {
    winner = attacker.isPlayer ? "attacker" : "defender";
    tieBreak = "player";
  } else if (attacker.skillValue !== defender.skillValue) {
    winner = attacker.skillValue > defender.skillValue ? "attacker" : "defender";
    tieBreak = "skill";
  } else {
    winner = "reroll";
    tieBreak = "reroll";
  }
  const multiplier =
    winner !== "attacker" ? 0 : quality === "critical_success" ? RULES_CONFIG.damageMultiplier.critical : quality === "extreme" ? RULES_CONFIG.damageMultiplier.extreme : 1;
  return { winner, tieBreak, quality, defenderQuality, multiplier };
}

export interface ConfrontRound {
  attackRoll: number;
  defendRoll: number;
  outcome: ConfrontOutcome;
}

export interface ConfrontResult {
  attacker: ConfrontSide;
  defender: ConfrontSide;
  rounds: ConfrontRound[];
  final: ConfrontRound;
  hit: boolean;
  qualityLabel: string;
  damageRoll: RollResult | null;
  multiplier: number;
  finalDamage: number;
  /** Dano inteiro aplicado ao PV. */
  appliedDamage: number;
}

/**
 * Executa o confronto completo: rola os dois d100 (repete enquanto o desempate mandar) e, se o ataque vencer,
 * rola o dano (crítico usa `criticalExpr`) e aplica o multiplicador da qualidade.
 */
export function performConfrontation(
  attacker: ConfrontSide,
  defender: ConfrontSide,
  damage: { expr: string; criticalExpr?: string; factor?: number } | null,
  opts: { rollModifier?: number; rng?: Rng } = {},
): ConfrontResult {
  const rng = opts.rng ?? cryptoRng;
  const rounds: ConfrontRound[] = [];
  let round: ConfrontRound;
  do {
    const attackRoll = rng(100);
    const defendRoll = rng(100);
    round = { attackRoll, defendRoll, outcome: confrontOutcome(attackRoll, defendRoll, attacker, defender, opts.rollModifier ?? 0) };
    rounds.push(round);
  } while (round.outcome.winner === "reroll" && rounds.length <= RULES_CONFIG.opposed.maxRerolls);
  // Empate eterno (só com dado viciado): o defensor segura o ataque.
  const hit = round.outcome.winner === "attacker";
  let damageRoll: RollResult | null = null;
  let finalDamage = 0;
  if (hit && damage) {
    const crit = round.outcome.quality === "critical_success";
    damageRoll = rollExpression(crit && damage.criticalExpr ? damage.criticalExpr : damage.expr, rng);
    finalDamage = applyRounding(damageRoll.total * round.outcome.multiplier * (damage.factor ?? 1), RULES_CONFIG.damageRounding);
  }
  return {
    attacker,
    defender,
    rounds,
    final: round,
    hit,
    qualityLabel: OUTCOME_LABEL[round.outcome.quality],
    damageRoll,
    multiplier: hit ? round.outcome.multiplier : 0,
    finalDamage,
    appliedDamage: Math.max(0, applyRounding(finalDamage, RULES_CONFIG.opposed.appliedRounding)),
  };
}

/** Perícia de reação padrão para o tipo de ataque (corpo a corpo → Luta; à distância → Reflexo). */
export function defaultReaction(kind: AttackKind | null | undefined): string {
  return RULES_CONFIG.opposed.defaultReaction[kind ?? "melee"];
}

export const TIE_BREAK_LABEL: Record<TieBreak, string> = {
  none: "",
  player: "empate — o jogador vence",
  skill: "empate — decidido pela perícia",
  reroll: "empate — nova rolagem",
};
