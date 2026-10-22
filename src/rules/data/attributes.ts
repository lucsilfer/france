export const ATTRIBUTES = [
  { id: "FOR", name: "Força" },
  { id: "DEX", name: "Destreza" },
  { id: "INT", name: "Inteligência" },
  { id: "CON", name: "Constituição" },
  { id: "MIT", name: "Misticismo" },
  { id: "PER", name: "Percepção" },
  { id: "CAR", name: "Carisma" },
  { id: "VIG", name: "Vigor" },
] as const;

export type AttributeId = (typeof ATTRIBUTES)[number]["id"];
export const ATTRIBUTE_IDS: AttributeId[] = ATTRIBUTES.map((a) => a.id);

export type AttributeMap = Record<AttributeId, number>;

export function emptyAttributeMap(value = 0): AttributeMap {
  return { FOR: value, DEX: value, INT: value, CON: value, MIT: value, PER: value, CAR: value, VIG: value };
}
