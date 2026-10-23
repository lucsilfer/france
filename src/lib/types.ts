export interface Profile {
  id: string;
  username: string;
  display_name: string | null;
  avatar_url: string | null;
  reduce_motion: boolean;
  /** Velocidade das rolagens: instantânea, rápida (padrão) ou normal. */
  roll_speed: RollSpeed;
}

export type RollSpeed = "instant" | "fast" | "normal";

export interface CharacterSummary {
  id: string;
  name: string;
  status: "draft" | "active";
  class_id: string | null;
  origin_id: string | null;
  level: number;
  updated_at: string;
  portrait_path?: string | null;
  portrait_url?: string | null;
  /** A foto exibida é a da forma Lenda (moldura corrompida). */
  lenda?: boolean;
}

export interface CampaignSummary {
  id: string;
  owner_id: string;
  name: string;
  description: string;
  cover_url: string | null;
  invite_code: string | null;
  created_at: string;
  role: "master" | "player";
  member_count: number;
}

export const HOMEBREW_KINDS = [
  { id: "monstro", label: "Monstro", plural: "Monstros" },
  { id: "npc", label: "NPC", plural: "NPCs" },
  { id: "arma", label: "Arma", plural: "Armas" },
  { id: "item", label: "Equipamento", plural: "Equipamentos" },
  { id: "modificador", label: "Modificador", plural: "Modificadores" },
  { id: "item_especial", label: "Item especial", plural: "Itens especiais" },
  { id: "outro", label: "Outro", plural: "Outros conteúdos" },
] as const;

/** Conteúdos que o Mestre pode disponibilizar aos jogadores de uma campanha. */
export const SHAREABLE_KINDS: readonly HomebrewKind[] = ["item", "arma", "modificador", "item_especial", "outro"];

export type HomebrewKind = (typeof HOMEBREW_KINDS)[number]["id"];

export interface HomebrewEntry {
  id: string;
  kind: HomebrewKind;
  name: string;
  description: string;
  data: Record<string, unknown>;
  updated_at: string;
  image_path?: string | null;
  image_url?: string | null;
}

export type ActionResult<T = undefined> =
  | { ok: true; data?: T; message?: string }
  | { ok: false; error: string; fieldErrors?: Record<string, string> };
