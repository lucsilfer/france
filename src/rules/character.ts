import { RULES_CONFIG, applyRounding } from "./config.ts";
import { ATTRIBUTE_IDS, type AttributeId, type AttributeMap, emptyAttributeMap } from "./data/attributes.ts";
import { CLASS_BY_ID, type ClassDef } from "./data/classes.ts";
import { SKILLS, type SkillDef } from "./data/skills.ts";

export interface AttributeBreakdown {
  base: number;
  classBonus: number;
  other: number;
  temporary: number;
  final: number;
}

export type AttributeSheet = Record<AttributeId, AttributeBreakdown>;

export interface CharacterInput {
  baseAttributes: Partial<AttributeMap>;
  classId?: string | null;
  attributeOther?: Partial<AttributeMap>;
  attributeTemporary?: Partial<AttributeMap>;
  skillPoints?: Record<string, number>;
  skillOther?: Record<string, number>;
  skillTemporary?: Record<string, number>;
  /** Para a forma "lenda" do Artificial, a classe não se aplica (decisão do site). */
  applyClass?: boolean;
}

export function getClass(classId?: string | null): ClassDef | null {
  return classId ? (CLASS_BY_ID[classId] ?? null) : null;
}

export function computeAttributes(input: CharacterInput): AttributeSheet {
  const cls = input.applyClass === false ? null : getClass(input.classId);
  const out = {} as AttributeSheet;
  for (const id of ATTRIBUTE_IDS) {
    const base = input.baseAttributes[id] ?? 0;
    const classBonus = cls?.attributeBonus[id] ?? 0;
    const other = input.attributeOther?.[id] ?? 0;
    const temporary = input.attributeTemporary?.[id] ?? 0;
    out[id] = { base, classBonus, other, temporary, final: base + classBonus + other + temporary };
  }
  return out;
}

export function finalAttributes(sheet: AttributeSheet): AttributeMap {
  const map = emptyAttributeMap();
  for (const id of ATTRIBUTE_IDS) map[id] = sheet[id].final;
  return map;
}

/** PV e PC base (antes de progressão de nível). */
export function baseResources(attrs: AttributeMap, classId?: string | null, applyClass = true) {
  const r = RULES_CONFIG.resourceRounding;
  const pvFromAttrs =
    RULES_CONFIG.pvFormula === "for_plus_con_div3"
      ? attrs.FOR + applyRounding(attrs.CON / 3, r)
      : applyRounding((attrs.FOR + attrs.CON) / 3, r);
  const pcFromAttrs = applyRounding(attrs.VIG / 3, r);
  const cls = applyClass ? getClass(classId) : null;
  const classPv = cls?.pvBonusAtLevel1 ?? 0;
  return { pv: pvFromAttrs + classPv, pc: pcFromAttrs, breakdown: { pvFromAttrs, classPv, pcFromAttrs } };
}

export interface SkillBreakdown {
  id: string;
  name: string;
  group: SkillDef["group"];
  /** Base calculada com os atributos atuais (inclui efeitos temporários de atributo). */
  base: number;
  points: number;
  classBonus: number;
  other: number;
  temporary: number;
  final: number;
  /** Base calculada só com valores permanentes de atributo (usada no limite). */
  permanentBase: number;
  /** Valor que conta para o limite: base permanente + pontos + classe + outros. */
  capTotal: number;
  /** Limite total da perícia (75; Detalhista 95). */
  cap: number;
  /** Quantos pontos, no total, esta perícia pode receber. */
  maxPoints: number;
  overCap: boolean;
}

export function skillBase(skill: SkillDef, attrs: AttributeMap): number {
  if (skill.base.kind === "fixed") return skill.base.value;
  const divisor = skill.base.divisor === "config:conhecimentoBelico" ? RULES_CONFIG.conhecimentoBelicoDivisor : skill.base.divisor;
  return Math.floor(attrs[skill.base.attribute] / divisor);
}

function permanentAttributes(input: CharacterInput): AttributeMap {
  const sheet = computeAttributes({ ...input, attributeTemporary: {} });
  return finalAttributes(sheet);
}

export function computeSkills(input: CharacterInput, attrs?: AttributeMap): SkillBreakdown[] {
  const a = attrs ?? finalAttributes(computeAttributes(input));
  const perm = permanentAttributes(input);
  const applyClass = input.applyClass !== false;
  const cls = applyClass ? getClass(input.classId) : null;
  const cap = skillBudget(input.classId, applyClass).maxSkillTotal;
  return SKILLS.map((s) => {
    const base = skillBase(s, a);
    const permanentBase = skillBase(s, perm);
    const points = input.skillPoints?.[s.id] ?? 0;
    const classBonus = cls?.skillBonus[s.id] ?? 0;
    const other = input.skillOther?.[s.id] ?? 0;
    const temporary = input.skillTemporary?.[s.id] ?? 0;
    const fixed = permanentBase + classBonus + other;
    const capTotal = fixed + points;
    return {
      id: s.id,
      name: s.name,
      group: s.group,
      base,
      points,
      classBonus,
      other,
      temporary,
      final: base + points + classBonus + other + temporary,
      permanentBase,
      capTotal,
      cap,
      maxPoints: Math.max(0, cap - fixed),
      overCap: capTotal > cap,
    };
  });
}

export interface SkillBudget {
  skillsToChoose: number;
  totalPoints: number;
  /** Limite do valor TOTAL de cada perícia. */
  maxSkillTotal: number;
  freeSkills: string[];
}

/** Orçamento de perícias. A forma Lenda do Artificial não recebe benefícios de classe. */
export function skillBudget(classId?: string | null, applyClass = true): SkillBudget {
  const d = RULES_CONFIG.skillDistribution;
  const cls = applyClass ? getClass(classId) : null;
  return {
    skillsToChoose: d.skillsToChoose,
    totalPoints: d.totalPoints + (cls?.skillPointsBonus ?? 0),
    maxSkillTotal: cls?.maxPerSkillOverride ?? d.maxSkillTotal,
    freeSkills: cls?.freeSkills ?? [],
  };
}

/** Pontos máximos que uma perícia pode receber dado o que ela já tem de base e bônus. */
export function maxPointsFor(fixedPart: number, budget: SkillBudget): number {
  return Math.max(0, budget.maxSkillTotal - fixedPart);
}

export interface DistributionCheck {
  valid: boolean;
  canFinalize: boolean;
  spent: number;
  remaining: number;
  chosen: string[];
  errors: string[];
  /** Perícias cujo valor total passa do limite. */
  overCap: string[];
  budget: SkillBudget;
}

/**
 * Valida a distribuição de pontos.
 * `fixed[skill]` = base permanente + bônus de classe + outros bônus da perícia.
 * O limite vale para o TOTAL (fixed + pontos).
 */
export function validateSkillDistribution(
  points: Record<string, number>,
  classId?: string | null,
  fixed: Record<string, number> = {},
  applyClass = true,
): DistributionCheck {
  const budget = skillBudget(classId, applyClass);
  const errors: string[] = [];
  const overCap: string[] = [];
  const known = new Set(SKILLS.map((s) => s.id));
  let spent = 0;
  const chosen: string[] = [];
  for (const [id, raw] of Object.entries(points)) {
    if (!known.has(id)) {
      errors.push(`Perícia desconhecida: ${id}.`);
      continue;
    }
    if (!Number.isInteger(raw) || raw < 0) {
      errors.push(`Pontos inválidos em ${id}.`);
      continue;
    }
    if (raw === 0) continue;
    const total = (fixed[id] ?? 0) + raw;
    if (total > budget.maxSkillTotal) {
      overCap.push(id);
      const name = SKILLS.find((s) => s.id === id)!.name;
      errors.push(
        `${name}: total ${total} passa do limite de ${budget.maxSkillTotal} (pode receber até ${maxPointsFor(fixed[id] ?? 0, budget)} pontos).`,
      );
    }
    spent += raw;
    chosen.push(id);
  }
  if (chosen.length > budget.skillsToChoose) errors.push(`Escolha no máximo ${budget.skillsToChoose} perícias.`);
  if (spent > budget.totalPoints) errors.push(`Você distribuiu ${spent} de ${budget.totalPoints} pontos.`);
  const valid = errors.length === 0;
  const canFinalize = valid && chosen.length === budget.skillsToChoose && spent === budget.totalPoints;
  return { valid, canFinalize, spent, remaining: budget.totalPoints - spent, chosen, errors, overCap, budget };
}

/** Atalho: valida a partir das perícias já calculadas (usa base, classe e outros de cada uma). */
export function validateComputedSkills(skills: SkillBreakdown[], classId?: string | null, applyClass = true): DistributionCheck {
  const points: Record<string, number> = {};
  const fixed: Record<string, number> = {};
  for (const s of skills) {
    points[s.id] = s.points;
    fixed[s.id] = s.permanentBase + s.classBonus + s.other;
  }
  return validateSkillDistribution(points, classId, fixed, applyClass);
}

/** Na edição da ficha: a nova configuração não pode aumentar uma perícia acima do limite.
 *  Reduzir uma perícia que já estava acima (dados antigos) é permitido. */
export function checkSkillEdit(before: SkillBreakdown[], after: SkillBreakdown[]): string[] {
  const errors: string[] = [];
  for (const a of after) {
    const b = before.find((x) => x.id === a.id);
    if (a.overCap && (!b || a.capTotal > b.capTotal)) {
      errors.push(`${a.name}: total ${a.capTotal} passa do limite de ${a.cap}.`);
    }
  }
  return errors;
}

/**
 * Validação da atribuição de atributos: cada rolagem só pode ir para um atributo
 * e cada atributo recebe uma rolagem.
 */
export function validateAttributeAssignment(assignments: { rollId: string; attribute: AttributeId }[]) {
  const errors: string[] = [];
  const rolls = new Set<string>();
  const attrs = new Set<AttributeId>();
  for (const a of assignments) {
    if (rolls.has(a.rollId)) errors.push("Uma rolagem não pode ser usada em dois atributos.");
    if (attrs.has(a.attribute)) errors.push(`${a.attribute} já recebeu um valor.`);
    rolls.add(a.rollId);
    attrs.add(a.attribute);
  }
  return { valid: errors.length === 0, complete: attrs.size === ATTRIBUTE_IDS.length && errors.length === 0, errors };
}
