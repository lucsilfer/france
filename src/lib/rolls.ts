/** Formato dos registros de rolagem (roll_log.result) exibidos na ficha. */
import type { D100Test, Outcome } from "@/rules/d100.ts";

export type TestPayload = D100Test & { kind?: "test"; outcomeLabel: string };

export interface DiceDetail {
  expression: string;
  rolls: number[];
  total: number;
}

export interface AttackPayload {
  kind: "attack";
  weapon: string;
  skillName: string;
  natural: number;
  rolls: number[];
  effective: number;
  rollModifier: number;
  thresholds: { normal: number; good: number; extreme: number };
  outcome: Outcome;
  outcomeLabel: string;
  hit: boolean;
  damage: DiceDetail | null;
  multiplier: number;
  finalDamage: number;
  applied: string[];
  conditions: string[];
  note: string | null;
}

export interface PowerPayload {
  kind: "power";
  power: string;
  cost: number;
  pcAfter: number;
  effects: (DiceDetail & { label: string; effect: string })[];
  notes: string[];
  continuous: { effectId: string; perTurn: number; turns: number } | null;
}

export interface EffectTickPayload {
  kind: "effect";
  label: string;
  cost: number;
  pcAfter: number;
  turnsPaid: number;
  turnsTotal: number;
  active: boolean;
  effects: (DiceDetail & { label: string; effect: string })[];
}

/** Confronto por rolagens opostas (Fase 6): os dois d100, vencedor, qualidade e dano. */
export interface ConfrontPayload {
  kind: "confront";
  id: string;
  label: string;
  attacker: string;
  defender: string;
  attackSkill: string | null;
  attackValue: number;
  reactionSkill: string | null;
  defenseValue: number;
  attackRoll: number;
  defendRoll: number;
  rounds: { attack: number; defend: number; winner: string; tie_break: string }[];
  winner: "attacker" | "defender";
  tieBreak: "none" | "player" | "skill" | "reroll";
  quality: Outcome;
  defenderQuality: Outcome;
  multiplier: number;
  damage: DiceDetail | null;
  finalDamage: number;
  appliedDamage: number;
  applied: boolean;
  byPlayer: boolean;
  conditions: { name: string; turns: number | null; dot?: string }[];
}

export type RollPayload = TestPayload | AttackPayload | PowerPayload | EffectTickPayload | ConfrontPayload;

/** Linha de combat_confrontations (banco) → payload exibido. */
export function confrontFromRow(r: Record<string, unknown>): ConfrontPayload {
  const dmg = r.damage as { expression: string; terms: { rolls?: number[] }[]; total: number } | null;
  return {
    kind: "confront",
    id: String(r.id),
    label: String(r.label ?? ""),
    attacker: String(r.attacker_name ?? ""),
    defender: String(r.defender_name ?? ""),
    attackSkill: (r.attack_skill as string) ?? null,
    attackValue: Number(r.attack_value ?? 0),
    reactionSkill: (r.reaction_skill as string) ?? null,
    defenseValue: Number(r.defense_value ?? 0),
    attackRoll: Number(r.attack_roll),
    defendRoll: Number(r.defend_roll),
    rounds: (r.rounds as ConfrontPayload["rounds"]) ?? [],
    winner: r.winner as ConfrontPayload["winner"],
    tieBreak: (r.tie_break as ConfrontPayload["tieBreak"]) ?? "none",
    quality: r.quality as Outcome,
    defenderQuality: r.defender_quality as Outcome,
    multiplier: Number(r.multiplier ?? 0),
    damage: dmg ? { expression: dmg.expression, rolls: (dmg.terms ?? []).flatMap((t) => t.rolls ?? []), total: Number(dmg.total) } : null,
    finalDamage: Number(r.final_damage ?? 0),
    appliedDamage: Number(r.applied_damage ?? 0),
    applied: Boolean(r.applied),
    byPlayer: Boolean(r.by_player),
    conditions: (r.conditions as ConfrontPayload["conditions"]) ?? [],
  };
}

export interface RollEntry {
  id: string;
  label: string;
  created_at: string;
  result: RollPayload;
}

export function payloadKind(p: RollPayload): "test" | "attack" | "power" | "effect" | "confront" {
  return (p as { kind?: string }).kind === undefined ? "test" : ((p as { kind: string }).kind as "test" | "attack" | "power" | "effect" | "confront");
}
