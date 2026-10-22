/** Capítulo V — Criação de habilidade (Livro do Jogador, pp. 18–20). */

export interface CostTier {
  cost: number;
  dice: string;
}

/** Dano contra 1 alvo. "+3 PC = +1 dado". */
export const DAMAGE_SINGLE: CostTier[] = [
  { cost: 3, dice: "1d6" },
  { cost: 6, dice: "2d6" },
  { cost: 9, dice: "2d8" },
  { cost: 12, dice: "2d10" },
  { cost: 15, dice: "2d12" },
];

/** Dano em área. "+3 PC = +1 dado". */
export const DAMAGE_AREA: CostTier[] = [
  { cost: 6, dice: "1d6" },
  { cost: 9, dice: "2d6" },
  { cost: 12, dice: "2d8" },
  { cost: 15, dice: "2d10" },
  { cost: 18, dice: "2d12" },
];

export const EXTRA_DIE_COST = 3;

export interface AreaSize {
  id: "pequena" | "media" | "grande" | "enorme";
  name: string;
  radiusM: number;
  damageCost: number;
}

export const DAMAGE_AREA_SIZES: AreaSize[] = [
  { id: "pequena", name: "Área pequena", radiusM: 2, damageCost: 0 },
  { id: "media", name: "Área média", radiusM: 4, damageCost: 3 },
  { id: "grande", name: "Área grande", radiusM: 8, damageCost: 6 },
  { id: "enorme", name: "Área enorme", radiusM: 16, damageCost: 9 },
];

/** Cura — 1 alvo. "+3 PC = +1d6". */
export const HEAL_SINGLE: CostTier[] = [
  { cost: 3, dice: "1d4" },
  { cost: 6, dice: "1d6+2" },
  { cost: 9, dice: "2d6+2" },
  { cost: 12, dice: "2d8+3" },
  { cost: 15, dice: "2d10+4" },
];
export const HEAL_EXTRA_DIE = "1d6";

/** Cura em área: modificador somado ao custo da cura (tabela própria, diferente da de dano). */
export const HEAL_AREA_MODIFIER: Record<"alvo" | AreaSize["id"], number> = {
  alvo: 0,
  pequena: 6, // 2 m
  media: 9, // 4 m
  grande: 12, // 8 m
  enorme: 15, // 16 m
};

/** Cura contínua: o livro só define custo por turno. */
export const HEAL_CONTINUOUS: { dice: string; perTurn: number }[] = [
  { dice: "1d4", perTurn: 2 },
  { dice: "1d6", perTurn: 3 },
  { dice: "1d8", perTurn: 4 },
  { dice: "1d10", perTurn: 5 },
  { dice: "1d12", perTurn: 6 },
];

/** Escudo. "+3 PC = +1d8". */
export const SHIELD: CostTier[] = [
  { cost: 3, dice: "1d6+2" },
  { cost: 6, dice: "2d6+2" },
  { cost: 9, dice: "2d8+4" },
  { cost: 12, dice: "2d10+5" },
  { cost: 15, dice: "2d12+6" },
];
export const SHIELD_EXTRA_DIE = "1d8";

export const SHIELD_DURATION: { id: string; name: string; turns: number | "cena"; cost: number }[] = [
  { id: "1t", name: "1 turno", turns: 1, cost: 0 },
  { id: "2t", name: "2 turnos", turns: 2, cost: 2 },
  { id: "3t", name: "3 turnos", turns: 3, cost: 4 },
  { id: "cena", name: "Até o fim da cena", turns: "cena", cost: 6 },
];

export interface UpkeepTier {
  id: string;
  name: string;
  examples: string;
  initial: number;
  perTurn: number;
}

export const CONDITIONS: UpkeepTier[] = [
  { id: "leve", name: "Leve", examples: "−1 dado, lentidão, vulnerabilidade pequena", initial: 3, perTurn: 1 },
  { id: "moderada", name: "Moderada", examples: "−2 dados, redução de movimento, desvantagem", initial: 6, perTurn: 2 },
  { id: "forte", name: "Forte", examples: "Cegueira, silêncio, impedir reação", initial: 9, perTurn: 3 },
  { id: "severa", name: "Severa", examples: "Imobilizado, incapaz de atacar", initial: 12, perTurn: 4 },
  { id: "extrema", name: "Extrema", examples: "Atordoado, controle intenso", initial: 15, perTurn: 5 },
];

export const BUFFS: UpkeepTier[] = [
  { id: "teste_1", name: "+1 dado em testes", examples: "", initial: 3, perTurn: 1 },
  { id: "teste_2", name: "+2 dados em testes", examples: "", initial: 6, perTurn: 2 },
  { id: "dano_1", name: "+1 dado de dano", examples: "", initial: 6, perTurn: 2 },
  { id: "dano_2", name: "+2 dados de dano", examples: "", initial: 9, perTurn: 3 },
  { id: "acao", name: "+1 ação/reação especial", examples: "", initial: 12, perTurn: 4 },
  { id: "grande", name: "Grande melhoria física/sobrenatural", examples: "", initial: 15, perTurn: 5 },
];

/** Progressão por nível (p. 18): PC máximo por habilidade e dados extras máximos. */
export const LEVEL_POWER_TABLE: { level: number; maxPc: number; maxExtraDice: number }[] = [
  { level: 1, maxPc: 15, maxExtraDice: 1 },
  { level: 2, maxPc: 18, maxExtraDice: 1 },
  { level: 4, maxPc: 24, maxExtraDice: 2 },
  { level: 6, maxPc: 30, maxExtraDice: 3 },
  { level: 8, maxPc: 36, maxExtraDice: 4 },
  { level: 10, maxPc: 42, maxExtraDice: 5 },
  { level: 15, maxPc: 57, maxExtraDice: 7 },
  { level: 20, maxPc: 72, maxExtraDice: 10 },
];
