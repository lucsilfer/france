/** Tipos de campanha/Escudo do Mestre (usados no servidor e no navegador). */
import type { StoredAttribute, StoredProgression, StoredSkill } from "@/rules/sheet.ts";

export interface Condition {
  id: string;
  name: string;
  turns: number | null;
  note?: string;
}

export interface CampaignSettings {
  players_see_party?: boolean;
}

export interface CampaignRow {
  id: string;
  owner_id: string;
  name: string;
  description: string;
  cover_url: string | null;
  settings: CampaignSettings;
  created_at: string;
}

export interface MemberRow {
  user_id: string;
  username: string | null;
  display_name: string | null;
  role: "master" | "player";
}

export interface PartyRow {
  character_id: string;
  name: string;
  class_id: string | null;
  origin_id: string | null;
  origin_path_id: string | null;
  level: number;
  owner_id: string;
  owner_username: string | null;
  status: "pending" | "accepted";
  is_mine: boolean;
  active_form: "base" | "lenda";
  /** Foto da forma ativa (v6). */
  portrait_path?: string | null;
}

export interface CombatRow {
  id: string;
  name: string;
  status: "active" | "paused" | "ended";
  round: number;
  turn_index: number;
  version: number;
  initiative_mode: "manual" | "reflexo" | "d20";
  started_at: string | null;
  ended_at: string | null;
  created_at: string;
}

export interface CombatantRow {
  id: string;
  combat_id: string;
  character_id: string | null;
  npc_id: string | null;
  kind: "character" | "npc" | "monstro" | "other";
  form_id: string | null;
  name: string;
  initiative: number | null;
  sort_order: number;
  pv_current: number | null;
  pv_max: number | null;
  pc_current: number | null;
  pc_max: number | null;
  conditions: Condition[];
  hidden: boolean;
  hide_stats: boolean;
  notes: string;
  /** Fase 5: ficha copiada da criatura (ataques, habilidades, atributos…) — independente do modelo. */
  data?: Record<string, unknown>;
  image_path?: string | null;
  homebrew_id?: string | null;
}

export type PublicCombatant = Omit<CombatantRow, "hide_stats" | "notes" | "data" | "homebrew_id">;

export interface CombatLogRow {
  id: number;
  combat_id: string;
  round: number;
  turn_index: number;
  kind: string;
  message: string;
  public: boolean;
  created_at: string;
}

/** Ficha de criatura (ver normalizeCreature) + textos. Aceita o formato antigo da Fase 4. */
export type NpcData = Record<string, unknown> & { description?: string; appearance?: string; master_notes?: string };

export interface NpcRow {
  id: string;
  kind: "npc" | "monstro";
  name: string;
  data: NpcData;
  pv_current: number | null;
  pv_max: number | null;
  pc_current: number | null;
  pc_max: number | null;
  conditions: Condition[];
  visible_to_players: boolean;
  source_homebrew_id: string | null;
  image_path?: string | null;
  created_at: string;
}

export interface InvestigationRow {
  id: string;
  title: string;
  description: string;
  location: string;
  status: "aberta" | "em_andamento" | "resolvida" | "arquivada";
  characters: string[];
  visible_to_players: boolean;
  created_at: string;
  secret?: string;
}

export interface ClueRow {
  id: string;
  investigation_id: string;
  title: string;
  content: string;
  location: string;
  characters: string[];
  image_url: string | null;
  attachments: string[];
  revealed: boolean;
  revealed_at: string | null;
  board_x: number | null;
  board_y: number | null;
  created_at: string;
}

export interface RevealedClue {
  id: string;
  investigation_id: string;
  investigation_title: string;
  title: string;
  content: string;
  location: string;
  image_url: string | null;
  attachments: string[];
  revealed_at: string | null;
}

export interface NodeRow {
  id: string;
  investigation_id: string;
  kind: "place" | "character" | "note";
  label: string;
  x: number;
  y: number;
}

export interface LinkRow {
  id: string;
  investigation_id: string;
  from_id: string;
  to_id: string;
  label: string;
}

export interface ReportRow {
  id: string;
  title: string;
  report_date: string;
  description: string;
  participants: string[];
  events: string[];
  conclusions: string;
  attachments: string[];
  is_private: boolean;
  created_at: string;
}

export interface NoteRow {
  id: string;
  title: string;
  category: string;
  content: string;
  is_private: boolean;
  updated_at: string;
}

export interface RollRow {
  id: string;
  user_id: string;
  character_id: string | null;
  label: string;
  expression: string;
  result: Record<string, unknown>;
  visibility: "public" | "master" | "self";
  created_at: string;
}

export interface AgentForm {
  id: string;
  kind: "base" | "lenda";
  name: string;
  setup_complete: boolean;
  pv_current: number;
  pc_current: number;
  pv_other_bonus: number;
  pc_other_bonus: number;
  conditions: Condition[];
  portrait_path?: string | null;
  form_attributes: StoredAttribute[];
  form_skills: StoredSkill[];
  level_progressions: StoredProgression[];
}

export interface AgentRow {
  character: {
    id: string;
    name: string;
    player_name: string;
    class_id: string | null;
    origin_id: string | null;
    origin_path_id: string | null;
    level: number;
    owner_id: string;
    active_form: "base" | "lenda";
  };
  masterCanEdit: boolean;
  forms: AgentForm[];
  /** Armas da ficha (para o Mestre conduzir um confronto pelo agente). */
  weapons?: { id: string; name: string; effect_dice: string | null; attack_kind: string | null; quantity: number; source_ref: string | null }[];
}

export interface ShieldHomebrew {
  id: string;
  kind: "npc" | "monstro" | "item" | "arma" | "item_especial" | "modificador" | "outro";
  name: string;
  description: string;
  data: Record<string, unknown>;
  image_path?: string | null;
}

export interface CampaignHub {
  campaign: CampaignRow;
  role: "master" | "player";
  userId: string;
  members: MemberRow[];
  party: PartyRow[];
  invite: { code: string; active: boolean } | null;
  myCharacters: { id: string; name: string; class_id: string | null; origin_id: string | null; level: number }[];
  combat: CombatRow | null;
  combatants: PublicCombatant[];
  clues: RevealedClue[];
  reports: ReportRow[];
  notes: NoteRow[];
  rolls: RollRow[];
  /** Vínculos dos MEUS personagens com a campanha (status e permissão de edição do Mestre). */
  myLinks: { character_id: string; status: "pending" | "accepted"; master_can_edit: boolean }[];
}

export interface ShieldData {
  campaign: CampaignRow;
  userId: string;
  members: MemberRow[];
  party: PartyRow[];
  agents: AgentRow[];
  npcs: NpcRow[];
  combats: CombatRow[];
  combatants: CombatantRow[];
  combatLog: CombatLogRow[];
  investigations: InvestigationRow[];
  clues: ClueRow[];
  nodes: NodeRow[];
  links: LinkRow[];
  reports: ReportRow[];
  notes: NoteRow[];
  rolls: RollRow[];
  homebrew: ShieldHomebrew[];
  /** Links assinados das imagens (fotos dos agentes, NPCs, combatentes, modelos). */
  media: Record<string, string>;
}
