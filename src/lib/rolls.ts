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

export type RollPayload = TestPayload | AttackPayload | PowerPayload | EffectTickPayload;

export interface RollEntry {
  id: string;
  label: string;
  created_at: string;
  result: RollPayload;
}

export function payloadKind(p: RollPayload): "test" | "attack" | "power" | "effect" {
  return (p as { kind?: string }).kind === undefined ? "test" : ((p as { kind: string }).kind as "test" | "attack" | "power" | "effect");
}
