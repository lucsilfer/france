/**
 * Equipamento inicial das classes (Livro do Jogador, cap. IV) em formato estruturado.
 * Cada "vaga" vira um item real no inventário, identificado por `kit:<classe>:<vaga>`
 * (o banco impede duplicar a mesma vaga).
 */
import { CATALOG_BY_ID, type CatalogItem } from "../catalog.ts";
import { SKILLS, SKILL_BY_ID } from "./skills.ts";
import { WEAPONS, type AttackKind, type WeaponDef } from "./equipment.ts";

export type KitSlot =
  | { id: string; kind: "item"; label: string; catalogId: string; quantity?: number }
  | {
      id: string;
      kind: "weapon";
      label: string;
      tier?: WeaponDef["tier"];
      attackKinds?: AttackKind[];
      /** Restrição que o Prodígio ignora (ex.: Demolidor: "que não seja de fogo (exceto para Prodígios)"). */
      prodigioAlsoAllows?: AttackKind[];
    }
  | { id: string; kind: "skill_item"; label: string; excludeGroups: ("lutar" | "outros")[] };

const NOT_FIREARM: AttackKind[] = ["melee", "ranged"];

export const STARTING_KITS: Record<string, KitSlot[]> = {
  brawler: [
    { id: "arma_refinada", kind: "weapon", label: "Uma arma corpo a corpo refinada", tier: "refinada", attackKinds: ["melee"] },
    { id: "arma_simples", kind: "weapon", label: "Uma arma simples", tier: "simples" },
    { id: "armadura", kind: "item", label: "Armadura simples (redução de 5 de dano físico)", catalogId: "armadura_simples" },
  ],
  demolidor: [
    { id: "granadas", kind: "item", label: "Cinco granadas à escolha do jogador", catalogId: "granada", quantity: 5 },
    {
      id: "arma_distancia",
      kind: "weapon",
      label: "Uma arma de longa distância que não seja de fogo (exceto para Prodígios)",
      attackKinds: ["ranged"],
      prodigioAlsoAllows: ["firearm"],
    },
  ],
  detalhista: [
    { id: "arma_refinada", kind: "weapon", label: "Uma arma refinada que não seja de fogo", tier: "refinada", attackKinds: NOT_FIREARM },
    { id: "item_pericia", kind: "skill_item", label: "Um item de perícia (vantagem na perícia escolhida — nenhuma da seção Lutar)", excludeGroups: ["lutar"] },
  ],
  esoterico: [
    { id: "arma_refinada", kind: "weapon", label: "Uma arma refinada que não seja de fogo", tier: "refinada", attackKinds: NOT_FIREARM },
    { id: "talisma", kind: "item", label: "Talismã de energia", catalogId: "talisma_energia" },
  ],
  atirador: [
    { id: "arma_fogo", kind: "weapon", label: "Uma arma de fogo", attackKinds: ["firearm"] },
    { id: "mira", kind: "item", label: "Mira para a arma de fogo", catalogId: "mira" },
  ],
  rato: [
    // O livro diz "arma leve" sem definir; interpretado como arma simples [decisão do site].
    { id: "arma_leve", kind: "weapon", label: "Uma arma leve (arma simples)", tier: "simples" },
    { id: "roupa", kind: "item", label: "Roupa de furtividade", catalogId: "roupa_furtividade" },
  ],
  healer: [
    { id: "arma_simples", kind: "weapon", label: "Uma arma simples", tier: "simples" },
    { id: "kit_medicina", kind: "item", label: "Kit de medicina", catalogId: "kit_medicina" },
  ],
  tank: [
    { id: "arma_refinada", kind: "weapon", label: "Uma arma refinada que não seja de fogo", tier: "refinada", attackKinds: NOT_FIREARM },
    { id: "armadura", kind: "item", label: "Armadura (+7 de defesa)", catalogId: "armadura_7" },
  ],
  lider: [
    { id: "arma_refinada", kind: "weapon", label: "Uma arma refinada que não seja de fogo", tier: "refinada", attackKinds: NOT_FIREARM },
    { id: "armadura", kind: "item", label: "Armadura (+2 de defesa)", catalogId: "armadura_2" },
  ],
};

export function startingKit(classId: string | null | undefined): KitSlot[] {
  return (classId && STARTING_KITS[classId]) || [];
}

export function kitRef(classId: string, slotId: string): string {
  return `kit:${classId}:${slotId}`;
}

/** Vagas que exigem escolha do jogador. */
export function kitChoiceSlots(classId: string | null | undefined): KitSlot[] {
  return startingKit(classId).filter((s) => s.kind !== "item");
}

export function weaponOptions(slot: Extract<KitSlot, { kind: "weapon" }>, originId: string | null): WeaponDef[] {
  const kinds = [...(slot.attackKinds ?? []), ...(originId === "prodigio" ? (slot.prodigioAlsoAllows ?? []) : [])];
  return WEAPONS.filter((w) => (!slot.tier || w.tier === slot.tier) && (kinds.length === 0 || kinds.includes(w.attackKind)));
}

export function skillOptions(slot: Extract<KitSlot, { kind: "skill_item" }>) {
  return SKILLS.filter((s) => !slot.excludeGroups.includes(s.group));
}

export type KitChoices = Record<string, string>;

/** Confere as escolhas (todas as vagas de escolha precisam de uma opção permitida). */
export function validateKitChoices(classId: string | null, originId: string | null, choices: KitChoices, onlySlots?: string[]): string[] {
  const errors: string[] = [];
  for (const slot of kitChoiceSlots(classId)) {
    if (onlySlots && !onlySlots.includes(slot.id)) continue;
    const v = choices[slot.id];
    if (!v) {
      errors.push(`Escolha: ${slot.label}.`);
      continue;
    }
    const ok = slot.kind === "weapon" ? weaponOptions(slot, originId).some((w) => w.id === v) : slot.kind === "skill_item" ? skillOptions(slot).some((s) => s.id === v) : true;
    if (!ok) errors.push(`Opção não permitida para “${slot.label}”.`);
  }
  return errors;
}

/** Item concreto que cada vaga entrega (mesmo formato dos itens do catálogo). */
export interface KitGrant {
  slotId: string;
  kitRef: string;
  item: CatalogItem;
  quantity: number;
}

export function kitGrants(classId: string | null, originId: string | null, choices: KitChoices, onlySlots?: string[]): KitGrant[] {
  if (!classId) return [];
  const out: KitGrant[] = [];
  for (const slot of startingKit(classId)) {
    if (onlySlots && !onlySlots.includes(slot.id)) continue;
    let item: CatalogItem | undefined;
    if (slot.kind === "item") item = CATALOG_BY_ID[slot.catalogId];
    else if (slot.kind === "weapon") item = weaponOptions(slot, originId).some((w) => w.id === choices[slot.id]) ? CATALOG_BY_ID[choices[slot.id]] : undefined;
    else {
      const skill = skillOptions(slot).find((s) => s.id === choices[slot.id]);
      if (skill) {
        const base = CATALOG_BY_ID.item_pericia;
        item = { ...base, id: base.id, name: `Item de perícia (${SKILL_BY_ID[skill.id].name})`, effectText: `Vantagem nos testes de ${SKILL_BY_ID[skill.id].name}` };
      }
    }
    if (!item) continue;
    out.push({ slotId: slot.id, kitRef: kitRef(classId, slot.id), item, quantity: slot.kind === "item" ? (slot.quantity ?? 1) : 1 });
  }
  return out;
}
