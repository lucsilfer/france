export interface Profile {
  id: string;
  username: string;
  display_name: string | null;
  avatar_url: string | null;
  reduce_motion: boolean;
}

export interface CharacterSummary {
  id: string;
  name: string;
  status: "draft" | "active";
  class_id: string | null;
  origin_id: string | null;
  level: number;
  updated_at: string;
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
  { id: "item", label: "Item" },
  { id: "arma", label: "Arma" },
  { id: "modificador", label: "Modificador" },
  { id: "monstro", label: "Monstro" },
  { id: "npc", label: "NPC" },
  { id: "outro", label: "Outro" },
] as const;

export type HomebrewKind = (typeof HOMEBREW_KINDS)[number]["id"];

export interface HomebrewEntry {
  id: string;
  kind: HomebrewKind;
  name: string;
  description: string;
  data: Record<string, unknown>;
  updated_at: string;
}

export type ActionResult<T = undefined> =
  | { ok: true; data?: T; message?: string }
  | { ok: false; error: string; fieldErrors?: Record<string, string> };
