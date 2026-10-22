import { RULES_CONFIG } from "./config.ts";
import { CLASS_BY_ID } from "./data/classes.ts";
import { ORIGIN_BY_ID } from "./data/origins.ts";
import { LEVEL_POWER_TABLE } from "./data/powerTables.ts";
import { cryptoRng, rollExpression, type RollResult, type Rng } from "./dice.ts";

export interface LevelDice {
  pv: string;
  pc: string | null;
  source: string;
}

/** Dados de evolução. A origem Prodígio tem prioridade sobre a classe (regra do site). */
export function levelDice(classId?: string | null, originId?: string | null): LevelDice {
  const origin = originId ? ORIGIN_BY_ID[originId] : undefined;
  if (origin?.overridesProgression && origin.id === "prodigio") {
    return { pv: RULES_CONFIG.prodigioProgression.pv, pc: RULES_CONFIG.prodigioProgression.pc, source: "Origem: Prodígio" };
  }
  const cls = classId ? CLASS_BY_ID[classId] : undefined;
  if (!cls) throw new Error("Classe não definida: não é possível rolar a evolução.");
  return { pv: cls.progression.pv, pc: cls.progression.pc, source: `Classe: ${cls.name}` };
}

export interface LevelGain {
  level: number;
  pvGain: number;
  pcGain: number;
  pvRoll: RollResult;
  pcRoll: RollResult | null;
}

export function assertLevel(level: number) {
  const { min, max } = RULES_CONFIG.levels;
  if (!Number.isInteger(level) || level < min || level > max) throw new RangeError(`Nível deve ser entre ${min} e ${max}.`);
}

/** Níveis que ainda precisam de rolagem para chegar ao alvo (nunca rola um nível já registrado). */
export function missingLevels(recorded: Iterable<number>, targetLevel: number): number[] {
  assertLevel(targetLevel);
  const have = new Set(recorded);
  const out: number[] = [];
  for (let l = 2; l <= targetLevel; l++) if (!have.has(l)) out.push(l);
  return out;
}

export function rollLevelGain(level: number, dice: LevelDice, rng: Rng = cryptoRng): LevelGain {
  const pvRoll = rollExpression(dice.pv, rng);
  const pcRoll = dice.pc ? rollExpression(dice.pc, rng) : null;
  return { level, pvGain: pvRoll.total, pcGain: pcRoll?.total ?? 0, pvRoll, pcRoll };
}

/** Soma dos ganhos ativos: apenas níveis 2..nível atual. Registros acima ficam guardados, mas inativos. */
export function activeGains(recorded: { level: number; pvGain: number; pcGain: number }[], currentLevel: number) {
  let pv = 0;
  let pc = 0;
  for (const g of recorded) {
    if (g.level >= 2 && g.level <= currentLevel) {
      pv += g.pvGain;
      pc += g.pcGain;
    }
  }
  return { pv, pc };
}

export function clampCurrent(current: number, max: number): number {
  return Math.min(current, max);
}

/** Limite de PC por habilidade e dados extras por nível (p. 18). */
export function powerLimits(level: number): { maxPc: number; maxExtraDice: number } {
  assertLevel(level);
  let row = LEVEL_POWER_TABLE[0];
  for (const r of LEVEL_POWER_TABLE) if (r.level <= level) row = r;
  const maxPc = RULES_CONFIG.powerLimitMode === "linear" ? 15 + 3 * (level - 1) : row.maxPc;
  return { maxPc, maxExtraDice: row.maxExtraDice };
}
