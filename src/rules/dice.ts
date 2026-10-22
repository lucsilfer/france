/**
 * Interpretador seguro de expressões de dados (sem eval).
 * Gramática: expr := termo (('+'|'-') termo)*
 *            termo := [N]dM | inteiro
 * Exemplos: "1d6", "2d8+3", "1d12+1d6", "d100", "3d6-2".
 */

export interface DiceTerm {
  sign: 1 | -1;
  count: number;
  sides: number; // 0 → constante
  value?: number;
}

export interface DiceExpression {
  source: string;
  terms: DiceTerm[];
}

export interface RolledTerm extends DiceTerm {
  rolls: number[];
  subtotal: number;
}

export interface RollResult {
  expression: string;
  terms: RolledTerm[];
  total: number;
}

export type Rng = (sides: number) => number;

export const LIMITS = { maxDice: 100, maxSides: 1000, maxConstant: 10000, maxTerms: 20 };

export class DiceParseError extends Error {
  constructor(message: string) {
    super(message);
    this.name = "DiceParseError";
  }
}

export function parseDice(input: string): DiceExpression {
  if (/[0-9d]\s+[0-9d]/i.test(input)) throw new DiceParseError("Falta operador entre termos.");
  const source = input.replace(/\s+/g, "").toLowerCase();
  if (!source) throw new DiceParseError("Expressão vazia.");
  if (!/^[0-9d+\-]+$/.test(source)) throw new DiceParseError(`Caracteres inválidos em "${input}".`);

  const terms: DiceTerm[] = [];
  const re = /([+-]?)(\d*d\d+|\d+)/gy;
  let pos = 0;
  while (pos < source.length) {
    re.lastIndex = pos;
    const m = re.exec(source);
    if (!m || m.index !== pos) throw new DiceParseError(`Expressão inválida perto de "${source.slice(pos)}".`);
    if (terms.length > 0 && m[1] === "") throw new DiceParseError("Falta operador entre termos.");
    const sign: 1 | -1 = m[1] === "-" ? -1 : 1;
    const body = m[2];
    if (body.includes("d")) {
      const [c, s] = body.split("d");
      const count = c === "" ? 1 : Number(c);
      const sides = Number(s);
      if (count < 1 || count > LIMITS.maxDice) throw new DiceParseError(`Quantidade de dados deve ficar entre 1 e ${LIMITS.maxDice}.`);
      if (sides < 2 || sides > LIMITS.maxSides) throw new DiceParseError(`Faces devem ficar entre 2 e ${LIMITS.maxSides}.`);
      terms.push({ sign, count, sides });
    } else {
      const value = Number(body);
      if (value > LIMITS.maxConstant) throw new DiceParseError("Constante grande demais.");
      terms.push({ sign, count: 0, sides: 0, value });
    }
    pos = re.lastIndex;
    if (terms.length > LIMITS.maxTerms) throw new DiceParseError("Termos demais na expressão.");
  }
  return { source, terms };
}

export function isValidDice(input: string): boolean {
  try {
    parseDice(input);
    return true;
  } catch {
    return false;
  }
}

/** RNG criptográfico com amostragem por rejeição (sem viés de módulo). */
export const cryptoRng: Rng = (sides) => {
  const max = 0x100000000;
  const limit = max - (max % sides);
  const buf = new Uint32Array(1);
  for (;;) {
    globalThis.crypto.getRandomValues(buf);
    if (buf[0] < limit) return (buf[0] % sides) + 1;
  }
};

export function rollExpression(expr: DiceExpression | string, rng: Rng = cryptoRng): RollResult {
  const parsed = typeof expr === "string" ? parseDice(expr) : expr;
  const terms: RolledTerm[] = parsed.terms.map((t) => {
    if (t.sides === 0) return { ...t, rolls: [], subtotal: t.sign * (t.value ?? 0) };
    const rolls = Array.from({ length: t.count }, () => rng(t.sides));
    return { ...t, rolls, subtotal: t.sign * rolls.reduce((a, b) => a + b, 0) };
  });
  return { expression: parsed.source, terms, total: terms.reduce((a, t) => a + t.subtotal, 0) };
}

export function roll(sides: number, rng: Rng = cryptoRng): number {
  return rng(sides);
}

export function diceRange(expr: string): { min: number; max: number } {
  const { terms } = parseDice(expr);
  let min = 0;
  let max = 0;
  for (const t of terms) {
    const lo = t.sides === 0 ? (t.value ?? 0) : t.count;
    const hi = t.sides === 0 ? (t.value ?? 0) : t.count * t.sides;
    if (t.sign === 1) {
      min += lo;
      max += hi;
    } else {
      min -= hi;
      max -= lo;
    }
  }
  return { min, max };
}

/** Soma N dados extras do mesmo tipo do maior dado da expressão: "2d8" + 1 → "3d8". */
export function addDice(expr: string, extra: number, dieOverride?: string): string {
  if (extra <= 0) return expr;
  if (dieOverride) {
    const die = parseDice(dieOverride).terms.find((t) => t.sides > 0);
    if (!die) throw new DiceParseError("Dado extra inválido.");
    return `${expr}+${extra * die.count}d${die.sides}`;
  }
  const parsed = parseDice(expr);
  const diceTerms = parsed.terms.filter((t) => t.sides > 0 && t.sign === 1);
  if (diceTerms.length === 0) return `${expr}+${extra}d6`;
  const biggest = diceTerms.reduce((a, b) => (b.sides > a.sides ? b : a));
  biggest.count += extra;
  return formatDice(parsed.terms);
}

export function formatDice(terms: DiceTerm[]): string {
  return terms
    .map((t, i) => {
      const body = t.sides === 0 ? String(t.value ?? 0) : `${t.count}d${t.sides}`;
      if (i === 0) return t.sign === -1 ? `-${body}` : body;
      return `${t.sign === -1 ? "-" : "+"}${body}`;
    })
    .join("");
}

/** Rolagem de atributo: 3 × (3d6 × 5), maior é destacado. */
export function rollAttributeSet(rng: Rng = cryptoRng, rolls = 3, dice = 3, sides = 6, multiplier = 5) {
  const results = Array.from({ length: rolls }, () => {
    const faces = Array.from({ length: dice }, () => rng(sides));
    return { faces, value: faces.reduce((a, b) => a + b, 0) * multiplier };
  });
  let bestIndex = 0;
  results.forEach((r, i) => {
    if (r.value > results[bestIndex].value) bestIndex = i;
  });
  return { results, bestIndex, best: results[bestIndex].value };
}
