import type { AttributeId } from "./attributes.ts";

/**
 * Perícias da ficha oficial (ficha lendas, p. 2).
 * Base: valor fixo OU fração de um atributo.
 */
export type SkillBase =
  | { kind: "fixed"; value: number }
  | { kind: "attribute"; attribute: AttributeId; divisor: number | "config:conhecimentoBelico" };

export interface SkillDef {
  id: string;
  name: string;
  group: "lutar" | "outros";
  base: SkillBase;
  /** Texto exatamente como na ficha, para exibição. */
  sheetLabel: string;
}

export const SKILLS: SkillDef[] = [
  { id: "luta", name: "Luta", group: "lutar", base: { kind: "attribute", attribute: "FOR", divisor: 2 }, sheetLabel: "1/2 de FOR" },
  { id: "reflexo", name: "Reflexo", group: "lutar", base: { kind: "attribute", attribute: "DEX", divisor: 2 }, sheetLabel: "1/2 de DEX" },
  {
    id: "conhecimento_belico",
    name: "Conhecimento Bélico",
    group: "lutar",
    base: { kind: "attribute", attribute: "INT", divisor: "config:conhecimentoBelico" },
    sheetLabel: "1/INT (ambíguo — ver configuração)",
  },
  { id: "arma_de_fogo", name: "Arma de Fogo", group: "lutar", base: { kind: "fixed", value: 20 }, sheetLabel: "20" },
  { id: "pontaria", name: "Pontaria", group: "lutar", base: { kind: "attribute", attribute: "DEX", divisor: 2 }, sheetLabel: "1/2 de DEX" },
  { id: "investigacao", name: "Investigação", group: "outros", base: { kind: "fixed", value: 20 }, sheetLabel: "20" },
  { id: "enganacao", name: "Enganação", group: "outros", base: { kind: "fixed", value: 15 }, sheetLabel: "15" },
  { id: "furtividade", name: "Furtividade", group: "outros", base: { kind: "fixed", value: 20 }, sheetLabel: "20" },
  { id: "pilotagem", name: "Pilotagem", group: "outros", base: { kind: "fixed", value: 5 }, sheetLabel: "05" },
  { id: "intuicao", name: "Intuição", group: "outros", base: { kind: "fixed", value: 10 }, sheetLabel: "10" },
];

export type SkillId = (typeof SKILLS)[number]["id"];
export const SKILL_BY_ID: Record<string, SkillDef> = Object.fromEntries(SKILLS.map((s) => [s.id, s]));
