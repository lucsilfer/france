/**
 * Monta a ficha calculada a partir dos valores ARMAZENADOS (base, bônus, pontos, ganhos de nível).
 * Nenhum valor derivado é guardado no banco: tudo é recalculado aqui.
 */
import { RULES_CONFIG } from "./config.ts";
import {
  baseResources,
  computeAttributes,
  computeSkills,
  finalAttributes,
  validateComputedSkills,
  type DistributionCheck,
  type AttributeSheet,
  type SkillBreakdown,
} from "./character.ts";
import { ATTRIBUTE_IDS, type AttributeId, type AttributeMap } from "./data/attributes.ts";
import { CLASS_BY_ID } from "./data/classes.ts";
import { ORIGIN_BY_ID, type OriginTrait } from "./data/origins.ts";
import { activeGains } from "./progression.ts";

export interface StoredAttribute {
  attribute: string;
  base_value: number | null;
  other_bonus: number;
  temp_bonus: number;
}

export interface StoredSkill {
  skill_id: string;
  points: number;
  other_bonus: number;
  temp_bonus: number;
}

export interface StoredProgression {
  level: number;
  pv_gain: number;
  pc_gain: number;
}

export interface StoredForm {
  kind: "base" | "lenda";
  pv_current: number;
  pc_current: number;
  pv_other_bonus: number;
  pc_other_bonus: number;
  attributes: StoredAttribute[];
  skills: StoredSkill[];
  progressions: StoredProgression[];
}

export interface SheetInput {
  classId: string | null;
  originId: string | null;
  level: number;
  form: StoredForm;
}

export interface ComputedSheet {
  attributes: AttributeSheet;
  finalAttributes: AttributeMap;
  missingAttributes: AttributeId[];
  skills: SkillBreakdown[];
  /** Situação da distribuição de perícias (limite total, pontos gastos). */
  skillCheck: DistributionCheck;
  resources: {
    pvMax: number;
    pcMax: number;
    pvCurrent: number;
    pcCurrent: number;
    breakdown: { pvFromAttrs: number; classPv: number; pcFromAttrs: number; levelPv: number; levelPc: number; otherPv: number; otherPc: number };
  };
}

function toMap<T>(rows: T[], key: (r: T) => string, value: (r: T) => number): Record<string, number> {
  const out: Record<string, number> = {};
  for (const r of rows) out[key(r)] = value(r);
  return out;
}

export function buildSheet(input: SheetInput): ComputedSheet {
  const { form } = input;
  const applyClass = form.kind === "base";
  const attrsById = new Map(form.attributes.map((a) => [a.attribute, a]));
  const baseAttributes: Partial<AttributeMap> = {};
  const missingAttributes: AttributeId[] = [];
  for (const id of ATTRIBUTE_IDS) {
    const row = attrsById.get(id);
    if (row?.base_value == null) missingAttributes.push(id);
    baseAttributes[id] = row?.base_value ?? 0;
  }
  const attributes = computeAttributes({
    baseAttributes,
    classId: input.classId,
    applyClass,
    attributeOther: toMap(form.attributes, (a) => a.attribute, (a) => a.other_bonus) as Partial<AttributeMap>,
    attributeTemporary: toMap(form.attributes, (a) => a.attribute, (a) => a.temp_bonus) as Partial<AttributeMap>,
  });
  const finals = finalAttributes(attributes);
  const skills = computeSkills(
    {
      baseAttributes,
      classId: input.classId,
      applyClass,
      skillPoints: toMap(form.skills, (s) => s.skill_id, (s) => s.points),
      skillOther: toMap(form.skills, (s) => s.skill_id, (s) => s.other_bonus),
      skillTemporary: toMap(form.skills, (s) => s.skill_id, (s) => s.temp_bonus),
    },
    finals,
  );
  const skillCheck = validateComputedSkills(skills, input.classId, applyClass);
  const base = baseResources(finals, input.classId, applyClass);
  const gains = activeGains(
    form.progressions.map((p) => ({ level: p.level, pvGain: p.pv_gain, pcGain: p.pc_gain })),
    input.level,
  );
  const pvMax = Math.max(0, base.pv + gains.pv + form.pv_other_bonus);
  const pcMax = Math.max(0, base.pc + gains.pc + form.pc_other_bonus);
  return {
    attributes,
    finalAttributes: finals,
    missingAttributes,
    skills,
    skillCheck,
    resources: {
      pvMax,
      pcMax,
      pvCurrent: form.pv_current,
      pcCurrent: form.pc_current,
      breakdown: {
        ...base.breakdown,
        levelPv: gains.pv,
        levelPc: gains.pc,
        otherPv: form.pv_other_bonus,
        otherPc: form.pc_other_bonus,
      },
    },
  };
}

// ---------------------------------------------------------------- Criação

export const CREATION_STEPS = [
  { step: 1, id: "atributos", label: "Atributos" },
  { step: 2, id: "origem", label: "Origem" },
  { step: 3, id: "classe", label: "Classe" },
  { step: 4, id: "pericias", label: "Perícias" },
  { step: 5, id: "identidade", label: "Identidade" },
  { step: 6, id: "revisao", label: "Revisão" },
] as const;

export interface CreationState {
  classId: string | null;
  originId: string | null;
  originPathId: string | null;
  name: string;
  playerName: string;
  form: StoredForm;
}

export interface StepCheck {
  step: number;
  complete: boolean;
  errors: string[];
}

/** Verifica cada etapa. O servidor usa o mesmo código para finalizar. */
export function checkCreation(state: CreationState): StepCheck[] {
  const sheet = buildSheet({ classId: state.classId, originId: state.originId, level: 1, form: state.form });
  const s1: string[] = sheet.missingAttributes.length ? [`Faltam ${sheet.missingAttributes.length} atributo(s): ${sheet.missingAttributes.join(", ")}.`] : [];

  const s2: string[] = [];
  const origin = state.originId ? ORIGIN_BY_ID[state.originId] : undefined;
  if (!origin) s2.push("Escolha uma origem.");
  else if (origin.paths?.length && !origin.paths.some((p) => p.id === state.originPathId)) s2.push(`Escolha o Caminho do ${origin.name}.`);
  else if (!origin.paths?.length && state.originPathId) s2.push("Esta origem não tem Caminho.");

  const s3: string[] = state.classId && CLASS_BY_ID[state.classId] ? [] : ["Escolha uma classe."];

  const s4 = skillStepErrors(sheet.skillCheck);

  const s5: string[] = [];
  if (!state.name.trim()) s5.push("Dê um nome ao personagem.");
  if (!state.playerName.trim()) s5.push("Informe o nome do jogador.");

  const steps: StepCheck[] = [
    { step: 1, complete: s1.length === 0, errors: s1 },
    { step: 2, complete: s2.length === 0, errors: s2 },
    { step: 3, complete: s3.length === 0, errors: s3 },
    { step: 4, complete: s4.length === 0, errors: s4 },
    { step: 5, complete: s5.length === 0, errors: s5 },
  ];
  const all = steps.every((s) => s.complete);
  steps.push({ step: 6, complete: all, errors: all ? [] : ["Complete as etapas anteriores."] });
  return steps;
}

function skillStepErrors(dist: DistributionCheck): string[] {
  const out = [...dist.errors];
  if (dist.valid && !dist.canFinalize) {
    if (dist.chosen.length !== dist.budget.skillsToChoose) out.push(`Escolha exatamente ${dist.budget.skillsToChoose} perícias (atual: ${dist.chosen.length}).`);
    if (dist.remaining !== 0) out.push(`Distribua todos os pontos (restam ${dist.remaining}).`);
  }
  return out;
}

// ---------------------------------------------------------------- Forma Lenda (Artificial)

export const LENDA_STEPS = [
  { step: 1, id: "atributos", label: "Atributos" },
  { step: 2, id: "pericias", label: "Perícias" },
  { step: 3, id: "identidade", label: "Identidade" },
  { step: 4, id: "revisao", label: "Revisão" },
] as const;

/** Criação da ficha da Lenda: sem origem e sem classe (a classe não se aplica à forma Lenda). */
export function checkLendaCreation(state: { name: string; form: StoredForm; level: number }): StepCheck[] {
  const sheet = buildSheet({ classId: null, originId: "artificial", level: state.level, form: { ...state.form, kind: "lenda" } });
  const s1 = sheet.missingAttributes.length ? [`Faltam ${sheet.missingAttributes.length} atributo(s): ${sheet.missingAttributes.join(", ")}.`] : [];
  const s2 = skillStepErrors(sheet.skillCheck);
  const s3 = state.name.trim() ? [] : ["Dê um nome à Lenda."];
  const steps: StepCheck[] = [
    { step: 1, complete: s1.length === 0, errors: s1 },
    { step: 2, complete: s2.length === 0, errors: s2 },
    { step: 3, complete: s3.length === 0, errors: s3 },
  ];
  const all = steps.every((x) => x.complete);
  steps.push({ step: 4, complete: all, errors: all ? [] : ["Complete as etapas anteriores."] });
  return steps;
}

/** Etapa mais avançada que o jogador pode abrir (as anteriores precisam estar completas). */
export function maxReachableStep(checks: StepCheck[]): number {
  let reach = 1;
  const last = checks[checks.length - 1]?.step ?? 6;
  for (const c of checks) {
    if (c.step >= last) break;
    if (!c.complete) break;
    reach = c.step + 1;
  }
  return reach;
}

/** Traços de origem com indicação de liberação pelo nível. */
export function originTraitsWithStatus(originId: string | null, pathId: string | null, level: number) {
  const origin = originId ? ORIGIN_BY_ID[originId] : undefined;
  if (!origin) return { origin: undefined, path: undefined, traits: [] as (OriginTrait & { unlocked: boolean })[] };
  const path = origin.paths?.find((p) => p.id === pathId);
  const traits = [...origin.traits, ...(path?.traits ?? [])].map((t) => ({ ...t, unlocked: (t.minLevel ?? 1) <= level }));
  return { origin, path, traits };
}

export const SHEET_LIMITS = {
  attributeMax: 200,
  bonusRange: [-100, 100] as const,
  skillPointsMax: 200,
  resourceMax: 9999,
  levels: RULES_CONFIG.levels,
};
