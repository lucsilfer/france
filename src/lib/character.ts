import "server-only";
import { notFound } from "next/navigation";
import { requireUser } from "@/lib/supabase/server";
import type { StoredForm } from "@/rules/sheet.ts";
import type { PowerComponent } from "@/rules/powers.ts";
import type { AttackKind, WeaponTag } from "@/rules/data/equipment.ts";
import type { Condition } from "@/lib/campaign-types";

export interface CharacterRow {
  id: string;
  owner_id: string;
  status: "draft" | "active";
  creation_step: number;
  name: string;
  player_name: string;
  origin_id: string | null;
  origin_path_id: string | null;
  class_id: string | null;
  level: number;
  money: number;
  story: string;
  appearance: string;
  extra_info: string;
  personal_notes: string;
  active_form: "base" | "lenda";
  /** Escolhas do equipamento inicial feitas na criação. */
  starting_kit: Record<string, string>;
  updated_at: string;
}

export interface FormRow extends StoredForm {
  id: string;
  name: string;
  description: string;
  special_rules: string;
  setup_complete: boolean;
  /** Condições ativas na forma (aplicadas pelo jogador ou pelo Mestre). */
  conditions: Condition[];
}

export interface AttributeRollRow {
  id: string;
  faces: number[];
  results: number[];
  best: number;
  assigned_attribute: string | null;
  created_at: string;
}

export interface ItemModifierRow {
  id: string;
  modifier_id: string;
  is_temporary: boolean;
}

export interface ItemRow {
  id: string;
  source_kind: "catalog" | "homebrew" | "custom";
  source_ref: string | null;
  /** Vaga do equipamento inicial ("kit:<classe>:<vaga>"), quando veio do kit da classe. */
  kit_ref: string | null;
  name: string;
  description: string;
  item_type: string;
  category: string;
  quantity: number;
  effect_dice: string | null;
  effect_kind: string | null;
  attack_kind: AttackKind | null;
  damage_type: string | null;
  skill_override: string | null;
  tier: string | null;
  range: string;
  special_rules: string;
  tags: WeaponTag[];
  quick_access: boolean;
  created_at: string;
  item_modifiers: ItemModifierRow[];
}

export interface PowerRow {
  id: string;
  name: string;
  description: string;
  ability_type: string;
  target: string;
  range: string;
  duration: string;
  components: PowerComponent[];
  initial_cost: number;
  per_turn_cost: number;
  quick_access: boolean;
  created_at: string;
}

export interface EffectRow {
  id: string;
  form_id: string | null;
  power_id: string | null;
  label: string;
  per_turn_cost: number;
  turns_paid: number;
  turns_total: number;
  active: boolean;
  started_at: string;
}

/** Modelo de item da biblioteca Homebrew do usuário. */
export interface HomebrewItemRow {
  id: string;
  kind: "item" | "arma";
  name: string;
  description: string;
  data: Record<string, unknown>;
}

export interface TechniqueRow {
  id: string;
  technique_id: string;
  learned_level: number;
  created_at: string;
}

export interface TrackerRow {
  scene: number;
  session: number;
  turn: number;
}

export interface TechniqueUseRow {
  id: number;
  technique_id: string;
  scene: number;
  session: number;
  turn: number;
  created_at: string;
}

export interface CharacterBundle {
  character: CharacterRow;
  base: FormRow;
  /** Ficha secundária do Artificial (pode estar em criação). */
  lenda: FormRow | null;
  pendingRoll: AttributeRollRow | null;
  items: ItemRow[];
  powers: PowerRow[];
  effects: EffectRow[];
  /** Técnicas oficiais do Arsenal aprendidas, contadores e usos da sessão atual. */
  techniques: TechniqueRow[];
  tracker: TrackerRow;
  techniqueUses: TechniqueUseRow[];
  isOwner: boolean;
  canEdit: boolean;
}

const CHARACTER_COLUMNS =
  "id, owner_id, status, creation_step, name, player_name, origin_id, origin_path_id, class_id, level, money, story, appearance, extra_info, personal_notes, active_form, starting_kit, updated_at";

const FORM_COLUMNS =
  "id, kind, name, description, special_rules, setup_complete, conditions, pv_current, pc_current, pv_other_bonus, pc_other_bonus, form_attributes(attribute, base_value, other_bonus, temp_bonus), form_skills(skill_id, points, other_bonus, temp_bonus), level_progressions(level, pv_gain, pc_gain)";

export const ITEM_COLUMNS =
  "id, source_kind, source_ref, kit_ref, name, description, item_type, category, quantity, effect_dice, effect_kind, attack_kind, damage_type, skill_override, tier, range, special_rules, tags, quick_access, created_at, item_modifiers(id, modifier_id, is_temporary)";

export const POWER_COLUMNS = "id, name, description, ability_type, target, range, duration, components, initial_cost, per_turn_cost, quick_access, created_at";

type RawForm = Omit<FormRow, "attributes" | "skills" | "progressions"> & {
  form_attributes: FormRow["attributes"];
  form_skills: FormRow["skills"];
  level_progressions: FormRow["progressions"];
};

function toForm(raw: RawForm): FormRow {
  const { form_attributes, form_skills, level_progressions, ...rest } = raw;
  return { ...rest, conditions: rest.conditions ?? [], attributes: form_attributes ?? [], skills: form_skills ?? [], progressions: level_progressions ?? [] };
}

export async function loadCharacter(id: string): Promise<CharacterBundle> {
  if (!/^[0-9a-f-]{36}$/i.test(id)) notFound();
  const { supabase, user } = await requireUser();

  const { data: character } = await supabase.from("characters").select(CHARACTER_COLUMNS).eq("id", id).maybeSingle();
  if (!character) notFound();

  // Tudo em paralelo: uma ida ao banco por tabela, sem esperas em sequência.
  const [{ data: forms, error: formErr }, { data: canEdit }, items, powers, effects, { data: pending }, techniques, tracker, uses] = await Promise.all([
    supabase.from("character_forms").select(FORM_COLUMNS).eq("character_id", id),
    supabase.rpc("can_edit_character", { p_character: id }),
    supabase.from("items").select(ITEM_COLUMNS).eq("character_id", id).order("created_at", { ascending: true }),
    supabase.from("powers").select(POWER_COLUMNS).eq("character_id", id).order("created_at", { ascending: true }),
    supabase
      .from("active_effects")
      .select("id, form_id, power_id, label, per_turn_cost, turns_paid, turns_total, active, started_at")
      .eq("character_id", id)
      .eq("active", true)
      .order("started_at", { ascending: true }),
    supabase
      .from("attribute_rolls")
      .select("id, faces, results, best, assigned_attribute, created_at, character_forms!inner(character_id, kind)")
      .eq("character_forms.character_id", id)
      .eq("character_forms.kind", "base")
      .is("assigned_attribute", null)
      .maybeSingle(),
    supabase.from("character_techniques").select("id, technique_id, learned_level, created_at").eq("character_id", id).order("created_at"),
    supabase.from("character_trackers").select("scene, session, turn").eq("character_id", id).maybeSingle(),
    supabase.from("technique_uses").select("id, technique_id, scene, session, turn, created_at").eq("character_id", id).order("id", { ascending: false }).limit(200),
  ]);
  if (formErr) throw new Error("Falha ao carregar a ficha.");
  const all = (forms as RawForm[] | null) ?? [];
  const baseRaw = all.find((f) => f.kind === "base");
  if (!baseRaw) throw new Error("Ficha sem forma base.");
  const base = toForm(baseRaw);
  const lendaRaw = all.find((f) => f.kind === "lenda");

  const row = character as CharacterRow;
  return {
    character: { ...row, money: Number(row.money ?? 0), starting_kit: (row.starting_kit ?? {}) as Record<string, string> },
    base,
    lenda: lendaRaw ? toForm(lendaRaw) : null,
    pendingRoll: pending ? (({ character_forms: _f, ...r }) => r as AttributeRollRow)(pending as AttributeRollRow & { character_forms: unknown }) : null,
    items: ((items.data ?? []) as ItemRow[]).map((i) => ({ ...i, tags: i.tags ?? [], item_modifiers: i.item_modifiers ?? [] })),
    powers: (powers.data ?? []) as PowerRow[],
    effects: (effects.data ?? []) as EffectRow[],
    techniques: (techniques.data ?? []) as TechniqueRow[],
    tracker: (tracker.data as TrackerRow | null) ?? { scene: 1, session: 1, turn: 1 },
    techniqueUses: (uses.data ?? []) as TechniqueUseRow[],
    isOwner: row.owner_id === user.id,
    canEdit: Boolean(canEdit),
  };
}

/** Forma pedida (base ou Lenda pronta). */
export function pickForm(bundle: CharacterBundle, formId?: string | null): FormRow | null {
  if (!formId || formId === bundle.base.id) return bundle.base;
  if (bundle.lenda && bundle.lenda.id === formId) return bundle.lenda;
  return null;
}
