/** Catálogo oficial de itens do Livro do Jogador, no formato usado pelo inventário. */
import { DAMAGE_TYPE_LABEL, GEAR, GRENADES, WEAPONS, compatibleModifiers, type AttackKind, type WeaponTag } from "./data/equipment.ts";

export type ItemType = "arma" | "armadura" | "equipamento" | "consumivel" | "outro";
export type EffectKind = "dano" | "cura" | "condicao" | "utilidade" | "personalizado";

export const ITEM_TYPE_LABEL: Record<ItemType, string> = {
  arma: "Arma",
  armadura: "Armadura",
  equipamento: "Equipamento",
  consumivel: "Consumível",
  outro: "Outro",
};

export const EFFECT_KIND_LABEL: Record<EffectKind, string> = {
  dano: "Dano",
  cura: "Cura",
  condicao: "Condição",
  utilidade: "Utilidade",
  personalizado: "Personalizado",
};

export const ATTACK_KIND_LABEL: Record<AttackKind, string> = {
  melee: "Corpo a corpo",
  ranged: "Distância",
  firearm: "Arma de fogo",
};

export interface CatalogItem {
  id: string;
  name: string;
  type: ItemType;
  category: string;
  description: string;
  effectKind: EffectKind | null;
  effectDice: string | null;
  effectText: string;
  range: string;
  damageType: string | null;
  attackKind: AttackKind | null;
  tags: WeaponTag[];
  tier: string | null;
  modifiers: string[];
  note?: string;
}

export const CATALOG: CatalogItem[] = [
  ...WEAPONS.map<CatalogItem>((w) => ({
    id: w.id,
    name: w.name,
    type: "arma",
    category: w.tier === "simples" ? "Arma simples" : "Arma refinada",
    description: `${w.tier === "simples" ? "Arma simples" : "Arma refinada"} · ${DAMAGE_TYPE_LABEL[w.damageType]}`,
    effectKind: "dano",
    effectDice: w.damage,
    effectText: `${w.damage} ${DAMAGE_TYPE_LABEL[w.damageType].toLowerCase()}`,
    range: w.range,
    damageType: w.damageType,
    attackKind: w.attackKind,
    tags: w.tags,
    tier: w.tier,
    modifiers: compatibleModifiers(w.tags).map((m) => m.id),
    note: w.note,
  })),
  ...GEAR.map<CatalogItem>((g) => ({
    id: g.id,
    name: g.name,
    type: g.type,
    category: g.type === "armadura" ? "Armadura" : g.type === "consumivel" ? "Consumível" : "Equipamento",
    description: g.description,
    effectKind: g.type === "armadura" ? "utilidade" : "personalizado",
    effectDice: null,
    effectText: g.effect,
    range: "",
    damageType: null,
    attackKind: null,
    tags: [],
    tier: null,
    modifiers: [],
  })),
  ...GRENADES.map<CatalogItem>((g) => ({
    id: g.id,
    name: g.name,
    type: "consumivel",
    category: g.rare ? "Granada (rara)" : "Granada",
    description: `${g.area}. ${g.effect}`,
    effectKind: g.damage ? "dano" : "utilidade",
    effectDice: g.damage,
    effectText: [g.damage ? `${g.damage} de dano` : "Sem dano", g.effect].join(" · "),
    range: "Arremesso",
    damageType: null,
    attackKind: null,
    tags: [],
    tier: null,
    modifiers: [],
    note: g.condition ? `Condição: ${g.condition.name} (${g.condition.turns} turno${g.condition.turns > 1 ? "s" : ""}${g.condition.dot ? `, ${g.condition.dot} por turno` : ""})${g.condition.automatic ? "" : " — o Mestre decide"}` : undefined,
  })),
];

export const CATALOG_BY_ID: Record<string, CatalogItem> = Object.fromEntries(CATALOG.map((c) => [c.id, c]));
