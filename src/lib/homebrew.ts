/**
 * Conteúdos Homebrew: validação (Zod) por categoria e conversões para os sistemas
 * da ficha (inventário, armas, modificadores) e do Escudo (monstros/NPCs).
 * Isomórfico: usado nos editores (navegador) e nas ações do servidor.
 */
import { z } from "zod";
import { isValidDice } from "@/rules/dice.ts";
import { ATTRIBUTE_IDS } from "@/rules/data/attributes.ts";
import { SKILL_BY_ID } from "@/rules/data/skills.ts";
import { WEAPON_MODIFIER_BY_ID, type WeaponTag } from "@/rules/data/equipment.ts";
import type { CustomModifier, WeaponLike } from "@/rules/combat.ts";
import { normalizeCreature, type CreatureAbility, type CreatureAttack, type CreatureSheet } from "@/rules/creatures.ts";
import type { HomebrewKind } from "@/lib/types";

export const WEAPON_TAGS: WeaponTag[] = ["corpo_a_corpo", "distancia", "laminas", "perfurantes_projeteis", "pesadas", "contundentes", "foices_correntes", "arma_de_fogo"];

export const ITEM_KINDS = [
  { id: "equipamento", label: "Equipamento" },
  { id: "consumivel", label: "Consumível" },
  { id: "cura", label: "Item de cura" },
  { id: "especial", label: "Item especial" },
  { id: "mistico", label: "Objeto místico" },
  { id: "utilidade", label: "Item de utilidade" },
  { id: "outro", label: "Outro" },
] as const;
export type HomebrewItemKind = (typeof ITEM_KINDS)[number]["id"];

const dice = (msg = "Expressão de dados inválida (ex.: 1d6, 2d8+3, 1d10+1d6).") =>
  z
    .string()
    .trim()
    .max(60)
    .refine((v) => v === "" || isValidDice(v), msg);
const txt = (max: number) => z.string().max(max);
const num = (min: number, max: number) => z.number().int().min(min).max(max);
const strList = z.array(z.string().trim().min(1).max(120)).max(30);
const condition = z.object({ name: z.string().trim().min(1).max(80), turns: num(1, 100).nullable() });
const usesRef = z
  .string()
  .max(60)
  .refine((v) => v === "valor" || /^attr:(FOR|DEX|INT|CON|MIT|PER|CAR|VIG)$/.test(v) || /^skill:[a-z_]{1,40}$/.test(v) || /^skill:custom:.{1,60}$/.test(v), "Teste inválido.");

export const attackSchema = z.object({
  id: z.string().min(1).max(40),
  name: z.string().trim().min(1, "Dê um nome ao ataque.").max(80),
  description: txt(2000).optional(),
  uses: usesRef,
  value: num(0, 999).nullable().optional(),
  damage: z
    .string()
    .trim()
    .min(1, "Informe o dano do ataque.")
    .max(60)
    .refine((v) => isValidDice(v), "Dano inválido (ex.: 2d6+3)."),
  damage_type: txt(40).optional(),
  range: txt(60).optional(),
  effects: txt(2000).optional(),
  conditions: z.array(condition).max(5).optional(),
});

export const abilitySchema = z.object({
  id: z.string().min(1).max(40),
  name: z.string().trim().min(1, "Dê um nome à habilidade.").max(80),
  description: txt(4000).optional(),
  type: txt(40).optional(),
  damage: dice().optional(),
  heal: dice().optional(),
  condition: condition.nullable().optional(),
  area: txt(60).optional(),
  duration: txt(60).optional(),
  pc_cost: num(0, 9999).optional(),
  special: txt(4000).optional(),
  uses: usesRef.optional(),
  value: num(0, 999).nullable().optional(),
  manual: z.boolean().optional(),
});

const creatureBase = {
  attributes: z.record(z.string(), num(0, 999)).refine((r) => Object.keys(r).every((k) => (ATTRIBUTE_IDS as string[]).includes(k)), "Atributo desconhecido."),
  skills: z
    .array(z.object({ id: z.string().min(1).max(70), name: txt(80).optional(), value: num(0, 999) }))
    .max(60)
    .refine((l) => l.every((s) => s.id.startsWith("custom:") || SKILL_BY_ID[s.id]), "Perícia desconhecida."),
  pv_max: num(0, 99999).nullable(),
  pc_max: num(0, 99999).nullable(),
  pv_current: num(0, 99999).nullable(),
  pc_current: num(0, 99999).nullable(),
  defense: txt(60),
  resistances: strList,
  vulnerabilities: strList,
  immunities: strList,
  movement: txt(60),
  attacks: z.array(attackSchema).max(20),
  abilities: z.array(abilitySchema).max(30),
  inventory: z.array(z.object({ name: z.string().trim().min(1).max(120), quantity: num(0, 9999).optional(), notes: txt(500).optional() })).max(60),
  conditions: z.array(condition).max(20),
};

export type AttackValue = CreatureAttack;
export type AbilityValue = CreatureAbility;
export interface CreatureFormValue extends Omit<CreatureSheet, "attributes"> {
  attributes: Record<string, number>;
}
export interface MonsterFormValue extends CreatureFormValue {
  category: string;
  level: string;
  story: string;
  master_notes: string;
}
export interface NpcFormValue extends CreatureFormValue {
  mode: "simples" | "completa";
  age: string;
  appearance: string;
  personality: string;
  story: string;
  relation: string;
  equipment: string;
  master_notes: string;
}
export interface CustomModifierRef {
  source_id: string;
  name: string;
  text: string;
  data: ModifierFormValue;
}
export interface ModifierFormValue {
  requires: string;
  attack_bonus: number;
  extra_damage: string;
  extra_weapon_dice: number;
  crit_extra_damage: string;
  crit_extra_weapon_dice: number;
  penalties: string;
  condition: string;
  requirements: string;
  ignore_limit: boolean;
}
export interface WeaponFormValue {
  category: string;
  attack_kind: "melee" | "ranged" | "firearm";
  tags: WeaponTag[];
  effect_dice: string;
  damage_type: "cort" | "cont" | "perf" | "bal" | "var" | null;
  range: string;
  skill_override: string | null;
  modifiers: string[];
  custom_modifiers: CustomModifierRef[];
  special_rules: string;
}
export interface ItemFormValue {
  item_type: HomebrewItemKind;
  category: string;
  quantity: number;
  effect_kind: "dano" | "cura" | "condicao" | "utilidade" | "personalizado" | null;
  effect_dice: string;
  special_rules: string;
  uses_max: number | null;
  range: string;
  ability: { name: string; description: string } | null;
}
export interface OtherFormValue {
  category: string;
  content: string;
  effect_dice: string;
}

const creatureRefine = <T extends { pv_max: number | null; pv_current: number | null; pc_max: number | null; pc_current: number | null }>(d: T) =>
  (d.pv_current == null || d.pv_max == null || d.pv_current <= d.pv_max) && (d.pc_current == null || d.pc_max == null || d.pc_current <= d.pc_max);

export const monsterData = z
  .object({
    ...creatureBase,
    category: txt(60),
    level: txt(40),
    story: txt(20000),
    master_notes: txt(20000),
  })
  .refine(creatureRefine, "O valor atual não pode passar do máximo.");

export const npcData = z
  .object({
    ...creatureBase,
    mode: z.enum(["simples", "completa"]),
    age: txt(40),
    appearance: txt(10000),
    personality: txt(10000),
    story: txt(20000),
    relation: txt(5000),
    equipment: txt(5000),
    master_notes: txt(20000),
  })
  .refine(creatureRefine, "O valor atual não pode passar do máximo.");

/** NPC/monstro de uma campanha (instância): ficha de criatura + textos; segredos ficam em master_notes. */
export const campaignNpcData = z
  .object({
    ...creatureBase,
    description: txt(10000),
    appearance: txt(10000),
    personality: txt(10000),
    story: txt(20000),
    master_notes: txt(20000),
    category: txt(60),
    level: txt(40),
  })
  .refine(creatureRefine, "O valor atual não pode passar do máximo.");

export interface CampaignNpcFormValue extends CreatureFormValue {
  description: string;
  appearance: string;
  personality: string;
  story: string;
  master_notes: string;
  category: string;
  level: string;
}

export function campaignNpcDefaults(raw?: Record<string, unknown>): CampaignNpcFormValue {
  const d = raw ?? {};
  const s = (k: string, def = "") => (typeof d[k] === "string" ? (d[k] as string) : def);
  return {
    ...emptyCreature(),
    ...normalizeCreature(d),
    description: s("description"),
    appearance: s("appearance"),
    personality: s("personality"),
    story: s("story"),
    master_notes: s("master_notes", s("notes")),
    category: s("category"),
    level: s("level"),
  } as CampaignNpcFormValue;
}

export const customModifierData = z.object({
  requires: z.enum(["qualquer", ...WEAPON_TAGS] as [string, ...string[]]),
  attack_bonus: num(-100, 100),
  extra_damage: dice(),
  extra_weapon_dice: num(-5, 5),
  crit_extra_damage: dice(),
  crit_extra_weapon_dice: num(0, 5),
  penalties: txt(2000),
  condition: txt(500),
  requirements: txt(1000),
  ignore_limit: z.boolean(),
});

export const weaponData = z.object({
  category: txt(60),
  attack_kind: z.enum(["melee", "ranged", "firearm"]),
  tags: z.array(z.enum(WEAPON_TAGS as [WeaponTag, ...WeaponTag[]])).max(8),
  effect_dice: z
    .string()
    .trim()
    .min(1, "Informe o dado de dano.")
    .max(60)
    .refine((v) => isValidDice(v), "Dano inválido (ex.: 1d8+2)."),
  damage_type: z.enum(["cort", "cont", "perf", "bal", "var"]).nullable(),
  range: txt(60),
  skill_override: z
    .string()
    .nullable()
    .refine((v) => !v || SKILL_BY_ID[v], "Perícia inválida."),
  modifiers: z
    .array(z.string())
    .max(2)
    .refine((l) => l.every((m) => WEAPON_MODIFIER_BY_ID[m]), "Modificador oficial inválido."),
  custom_modifiers: z.array(z.object({ source_id: z.string().max(40), name: z.string().min(1).max(120), data: customModifierData, text: txt(2000) })).max(4),
  special_rules: txt(5000),
});

export const itemData = z.object({
  item_type: z.enum(ITEM_KINDS.map((k) => k.id) as [HomebrewItemKind, ...HomebrewItemKind[]]),
  category: txt(60),
  quantity: num(0, 9999),
  effect_kind: z.enum(["dano", "cura", "condicao", "utilidade", "personalizado"]).nullable(),
  effect_dice: dice(),
  special_rules: txt(5000),
  uses_max: num(1, 9999).nullable(),
  range: txt(60),
  ability: z.object({ name: txt(120), description: txt(4000) }).nullable(),
});

export const otherData = z.object({
  category: txt(60),
  content: txt(30000),
  effect_dice: dice(),
});

export const entryBase = z.object({
  name: z.string().trim().min(1, "Dê um nome.").max(120, "Máximo de 120 caracteres."),
  description: z.string().trim().max(10000, "Texto longo demais."),
  image_path: z.string().max(200).nullable(),
});

export const DATA_SCHEMAS = {
  monstro: monsterData,
  npc: npcData,
  arma: weaponData,
  item: itemData,
  item_especial: itemData,
  modificador: customModifierData,
  outro: otherData,
} as const;

export type MonsterData = MonsterFormValue;
export type NpcFormData = NpcFormValue;
export type WeaponData = WeaponFormValue;
export type ItemData = ItemFormValue;
export type ModifierData = ModifierFormValue;
export type OtherData = OtherFormValue;

// ------------------------------------------------------------------ valores iniciais dos editores

export function emptyCreature(): Omit<CreatureSheet, "attributes"> & { attributes: Record<string, number> } {
  return {
    attributes: {},
    skills: [],
    pv_max: null,
    pc_max: null,
    pv_current: null,
    pc_current: null,
    defense: "",
    resistances: [],
    vulnerabilities: [],
    immunities: [],
    movement: "",
    attacks: [],
    abilities: [],
    inventory: [],
    conditions: [],
  };
}

export function defaultData(kind: HomebrewKind, raw?: Record<string, unknown>): Record<string, unknown> {
  const d = raw ?? {};
  const s = (k: string, def = "") => (typeof d[k] === "string" ? (d[k] as string) : def);
  switch (kind) {
    case "monstro": {
      const c = normalizeCreature(d);
      return { ...emptyCreature(), ...c, category: s("category"), level: s("level"), story: s("story"), master_notes: s("master_notes") };
    }
    case "npc": {
      const c = normalizeCreature(d);
      return {
        ...emptyCreature(),
        ...c,
        mode: d.mode === "completa" ? "completa" : "simples",
        age: s("age"),
        appearance: s("appearance"),
        personality: s("personality"),
        story: s("story"),
        relation: s("relation"),
        equipment: s("equipment"),
        master_notes: s("master_notes", s("notes")),
      };
    }
    case "arma":
      return {
        category: s("category"),
        attack_kind: ["melee", "ranged", "firearm"].includes(d.attack_kind as string) ? d.attack_kind : "melee",
        tags: Array.isArray(d.tags) ? d.tags : [],
        effect_dice: s("effect_dice"),
        damage_type: (d.damage_type as string) || null,
        range: s("range"),
        skill_override: (d.skill_override as string) || null,
        modifiers: Array.isArray(d.modifiers) ? d.modifiers : [],
        custom_modifiers: Array.isArray(d.custom_modifiers) ? d.custom_modifiers : [],
        special_rules: s("special_rules"),
      };
    case "item":
    case "item_especial": {
      const legacyType = s("item_type");
      const type = ITEM_KINDS.some((k) => k.id === legacyType) ? legacyType : legacyType === "armadura" ? "equipamento" : kind === "item_especial" ? "especial" : "equipamento";
      const ek = d.effect_kind === "outro" ? "personalizado" : (d.effect_kind as string) || null;
      return {
        item_type: type,
        category: s("category"),
        quantity: typeof d.quantity === "number" ? d.quantity : 1,
        effect_kind: ek,
        effect_dice: s("effect_dice"),
        special_rules: s("special_rules"),
        uses_max: typeof d.uses_max === "number" ? d.uses_max : null,
        range: s("range"),
        ability: d.ability && typeof d.ability === "object" ? d.ability : null,
      };
    }
    case "modificador":
      return {
        requires: typeof d.requires === "string" ? d.requires : "qualquer",
        attack_bonus: typeof d.attack_bonus === "number" ? d.attack_bonus : 0,
        extra_damage: s("extra_damage"),
        extra_weapon_dice: typeof d.extra_weapon_dice === "number" ? d.extra_weapon_dice : 0,
        crit_extra_damage: s("crit_extra_damage"),
        crit_extra_weapon_dice: typeof d.crit_extra_weapon_dice === "number" ? d.crit_extra_weapon_dice : 0,
        penalties: s("penalties"),
        condition: s("condition"),
        requirements: s("requirements"),
        ignore_limit: Boolean(d.ignore_limit),
      };
    default:
      return { category: s("category"), content: s("content", s("special_rules")), effect_dice: s("effect_dice") };
  }
}

// ------------------------------------------------------------------ conversões para o motor

/** Modificador do Homebrew → formato do motor de ataques. */
export function toCustomModifier(id: string, name: string, d: ModifierData, text = ""): CustomModifier {
  const always = { attackBonus: d.attack_bonus || undefined, extraDamage: d.extra_damage || undefined, extraWeaponDice: d.extra_weapon_dice || undefined };
  const onCritical = { extraDamage: d.crit_extra_damage || undefined, extraWeaponDice: d.crit_extra_weapon_dice || undefined };
  const has = (o: object) => Object.values(o).some((v) => v !== undefined);
  return {
    id: `hb:${id}`,
    name,
    requires: d.requires as CustomModifier["requires"],
    text: [text, d.penalties && `Penalidades: ${d.penalties}`].filter(Boolean).join("\n") || undefined,
    always: has(always) ? always : undefined,
    onCritical: has(onCritical) ? onCritical : undefined,
    condition: d.condition || undefined,
    requirements: d.requirements || undefined,
    ignoreLimit: d.ignore_limit || undefined,
  };
}

/** Arma do Homebrew → arma do motor (prévia e inventário). */
export function weaponFromData(name: string, d: WeaponData): WeaponLike {
  return {
    name,
    damage: d.effect_dice,
    attackKind: d.attack_kind,
    tags: d.tags,
    skillOverride: d.skill_override,
    modifiers: d.modifiers,
    customModifiers: d.custom_modifiers.map((m) => toCustomModifier(m.source_id, m.name, m.data, m.text)),
  };
}

/** Linha de `items` (cópia independente) a partir de um conteúdo de equipamento/arma/item especial. */
export function inventoryRowFrom(kind: HomebrewKind, name: string, description: string, raw: Record<string, unknown>) {
  if (kind === "arma") {
    const d = weaponData.parse(defaultData("arma", raw)) as WeaponData;
    return {
      row: {
        name,
        description,
        item_type: "arma",
        category: d.category,
        quantity: 1,
        range: d.range,
        effect_kind: "dano",
        effect_dice: d.effect_dice,
        special_rules: d.special_rules,
        attack_kind: d.attack_kind,
        damage_type: d.damage_type,
        skill_override: d.skill_override,
        tags: d.tags,
        custom_modifiers: d.custom_modifiers.map((m) => toCustomModifier(m.source_id, m.name, m.data, m.text)),
        uses_max: null,
        uses_left: null,
      },
      officialModifiers: d.modifiers,
    };
  }
  if (kind === "item" || kind === "item_especial") {
    const d = itemData.parse(defaultData(kind, raw)) as ItemData;
    const t = d.item_type;
    const itemType = t === "consumivel" || t === "cura" ? "consumivel" : t === "outro" ? "outro" : "equipamento";
    const label = ITEM_KINDS.find((k) => k.id === t)?.label ?? "";
    const rules = [d.special_rules, d.ability?.name ? `Concede: ${d.ability.name}${d.ability.description ? ` — ${d.ability.description}` : ""}` : ""].filter(Boolean).join("\n");
    return {
      row: {
        name,
        description,
        item_type: itemType,
        category: d.category || label,
        quantity: Math.max(1, d.quantity),
        range: d.range,
        effect_kind: d.effect_kind ?? (t === "cura" ? "cura" : null),
        effect_dice: d.effect_dice || null,
        special_rules: rules,
        attack_kind: null,
        damage_type: null,
        skill_override: null,
        tags: [] as WeaponTag[],
        custom_modifiers: [] as CustomModifier[],
        uses_max: d.uses_max,
        uses_left: d.uses_max,
      },
      officialModifiers: [] as string[],
    };
  }
  if (kind === "outro") {
    const d = otherData.parse(defaultData("outro", raw)) as OtherData;
    return {
      row: {
        name,
        description: [description, d.content].filter(Boolean).join("\n\n").slice(0, 5000),
        item_type: "outro",
        category: d.category,
        quantity: 1,
        range: "",
        effect_kind: d.effect_dice ? "personalizado" : null,
        effect_dice: d.effect_dice || null,
        special_rules: "",
        attack_kind: null,
        damage_type: null,
        skill_override: null,
        tags: [] as WeaponTag[],
        custom_modifiers: [] as CustomModifier[],
        uses_max: null,
        uses_left: null,
      },
      officialModifiers: [] as string[],
    };
  }
  return null;
}

/** Resumo curto para os cartões da biblioteca. */
export function entrySummary(kind: HomebrewKind, raw: Record<string, unknown>): string {
  try {
    if (kind === "monstro" || kind === "npc") {
      const c = normalizeCreature(raw);
      const bits = [raw.category, raw.level ? `Nível ${raw.level}` : "", c.pv_max != null ? `PV ${c.pv_max}` : "", c.pc_max != null ? `PC ${c.pc_max}` : "", c.attacks.length ? `${c.attacks.length} ataque(s)` : ""];
      return bits.filter(Boolean).join(" · ");
    }
    if (kind === "arma") return [raw.effect_dice, raw.range, raw.category].filter(Boolean).join(" · ");
    if (kind === "modificador") {
      const d = defaultData("modificador", raw) as unknown as ModifierData;
      return [d.requires === "qualquer" ? "Qualquer arma" : d.requires, d.attack_bonus ? `${d.attack_bonus > 0 ? "+" : ""}${d.attack_bonus} no ataque` : "", d.extra_damage ? `+${d.extra_damage}` : ""].filter(Boolean).join(" · ");
    }
    if (kind === "item" || kind === "item_especial") {
      const d = defaultData(kind, raw) as unknown as ItemData;
      return [ITEM_KINDS.find((k) => k.id === d.item_type)?.label, d.effect_dice, d.uses_max ? `${d.uses_max} uso(s)` : ""].filter(Boolean).join(" · ");
    }
    return String(raw.category ?? "");
  } catch {
    return "";
  }
}
