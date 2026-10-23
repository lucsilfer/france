import "server-only";
import { signMedia } from "@/lib/media";
import { notFound, redirect } from "next/navigation";
import { requireUser } from "@/lib/supabase/server";
import type {
  AgentRow,
  CampaignHub,
  CampaignRow,
  ClueRow,
  CombatantRow,
  CombatLogRow,
  CombatRow,
  InvestigationRow,
  LinkRow,
  MemberRow,
  NodeRow,
  NoteRow,
  NpcRow,
  PartyRow,
  PublicCombatant,
  RevealedClue,
  ReportRow,
  RollRow,
  ShieldData,
  ShieldHomebrew,
} from "@/lib/campaign-types";

const uuidRe = /^[0-9a-f-]{36}$/i;

const ROLL_COLUMNS = "id, user_id, character_id, label, expression, result, visibility, created_at";
const COMBAT_COLUMNS = "id, name, status, round, turn_index, version, initiative_mode, started_at, ended_at, created_at";

async function base(id: string) {
  if (!uuidRe.test(id)) notFound();
  const { supabase, user } = await requireUser();
  const [{ data: camp }, { data: member }] = await Promise.all([
    supabase.from("campaigns").select("id, owner_id, name, description, cover_url, settings, created_at").eq("id", id).maybeSingle(),
    supabase.from("campaign_members").select("role").eq("campaign_id", id).eq("user_id", user.id).maybeSingle(),
  ]);
  if (!camp || !member) notFound();
  return { supabase, user, campaign: camp as CampaignRow, role: member.role as "master" | "player" };
}

/** Página da campanha (jogadores e Mestre): só o que é público para membros. */
export async function loadCampaignHub(id: string): Promise<CampaignHub> {
  const { supabase, user, campaign, role } = await base(id);
  const isMaster = role === "master";
  const [members, party, invite, myChars, combats, clues, reports, notes, rolls, myLinks] = await Promise.all([
    supabase.rpc("campaign_member_names", { p_campaign: id }),
    supabase.rpc("campaign_party", { p_campaign: id }),
    isMaster ? supabase.from("campaign_invites").select("code, active").eq("campaign_id", id).maybeSingle() : Promise.resolve({ data: null }),
    supabase.from("characters").select("id, name, class_id, origin_id, level").eq("owner_id", user.id).eq("status", "active").order("name"),
    supabase.from("combats").select(COMBAT_COLUMNS).eq("campaign_id", id).neq("status", "ended").order("created_at", { ascending: false }).limit(1),
    supabase.rpc("revealed_clues", { p_campaign: id }),
    supabase.from("reports").select("id, title, report_date, description, participants, events, conclusions, attachments, is_private, created_at").eq("campaign_id", id).eq("is_private", false).order("report_date", { ascending: false }),
    supabase.from("campaign_notes").select("id, title, category, content, is_private, updated_at").eq("campaign_id", id).eq("is_private", false).order("updated_at", { ascending: false }),
    supabase.from("roll_log").select(ROLL_COLUMNS).eq("campaign_id", id).order("created_at", { ascending: false }).limit(60),
    supabase.from("campaign_characters").select("character_id, status, master_can_edit, characters!inner(owner_id)").eq("campaign_id", id).eq("characters.owner_id", user.id),
  ]);
  const combat = ((combats.data ?? []) as CombatRow[])[0] ?? null;
  let combatants: PublicCombatant[] = [];
  if (combat) {
    const { data } = await supabase.from("combatants_public").select("*").eq("combat_id", combat.id);
    combatants = (data ?? []) as PublicCombatant[];
  }
  return {
    campaign,
    role,
    userId: user.id,
    members: (members.data ?? []) as MemberRow[],
    party: (party.data ?? []) as PartyRow[],
    invite: (invite.data as { code: string; active: boolean } | null) ?? null,
    myCharacters: (myChars.data ?? []) as CampaignHub["myCharacters"],
    combat,
    combatants,
    clues: (clues.data ?? []) as RevealedClue[],
    reports: (reports.data ?? []) as ReportRow[],
    notes: (notes.data ?? []) as NoteRow[],
    rolls: (rolls.data ?? []) as RollRow[],
    myLinks: ((myLinks.data ?? []) as { character_id: string; status: "pending" | "accepted"; master_can_edit: boolean }[]).map(({ character_id, status, master_can_edit }) => ({
      character_id,
      status,
      master_can_edit,
    })),
  };
}

/** Escudo do Mestre: tudo da campanha. Jogadores são redirecionados (e o RLS não entregaria os dados). */
export async function loadShield(id: string): Promise<ShieldData> {
  const { supabase, user, campaign, role } = await base(id);
  if (role !== "master") redirect(`/campanhas/${id}`);
  const [members, party, agentsQ, npcs, combats, investigations, secrets, clues, nodes, links, reports, notes, rolls, homebrew] = await Promise.all([
    supabase.rpc("campaign_member_names", { p_campaign: id }),
    supabase.rpc("campaign_party", { p_campaign: id }),
    supabase
      .from("campaign_characters")
      .select(
        "status, master_can_edit, characters!inner(id, name, player_name, class_id, origin_id, origin_path_id, level, owner_id, active_form, character_forms(id, kind, name, setup_complete, pv_current, pc_current, pv_other_bonus, pc_other_bonus, conditions, portrait_path, form_attributes(attribute, base_value, other_bonus, temp_bonus), form_skills(skill_id, points, other_bonus, temp_bonus), level_progressions(level, pv_gain, pc_gain)))",
      )
      .eq("campaign_id", id)
      .eq("status", "accepted"),
    supabase.from("npcs").select("id, kind, name, data, pv_current, pv_max, pc_current, pc_max, conditions, visible_to_players, source_homebrew_id, image_path, created_at").eq("campaign_id", id).order("created_at"),
    supabase.from("combats").select(COMBAT_COLUMNS).eq("campaign_id", id).order("created_at", { ascending: false }).limit(20),
    supabase.from("investigations").select("id, title, description, location, status, characters, visible_to_players, created_at").eq("campaign_id", id).order("created_at", { ascending: false }),
    supabase.from("investigation_secrets").select("investigation_id, master_notes"),
    supabase.from("clues").select("id, investigation_id, title, content, location, characters, image_url, attachments, revealed, revealed_at, board_x, board_y, created_at").order("created_at"),
    supabase.from("investigation_nodes").select("id, investigation_id, kind, label, x, y"),
    supabase.from("investigation_links").select("id, investigation_id, from_id, to_id, label"),
    supabase.from("reports").select("id, title, report_date, description, participants, events, conclusions, attachments, is_private, created_at").eq("campaign_id", id).order("report_date", { ascending: false }),
    supabase.from("campaign_notes").select("id, title, category, content, is_private, updated_at").eq("campaign_id", id).order("updated_at", { ascending: false }),
    supabase.from("roll_log").select(ROLL_COLUMNS).eq("campaign_id", id).order("created_at", { ascending: false }).limit(80),
    supabase.from("homebrew").select("id, kind, name, description, data, image_path").eq("owner_id", user.id).in("kind", ["npc", "monstro", "item", "arma", "item_especial", "modificador", "outro"]).order("name"),
  ]);

  const combatList = (combats.data ?? []) as CombatRow[];
  const combatIds = combatList.map((c) => c.id);
  const [combatants, logs] = combatIds.length
    ? await Promise.all([
        supabase.from("combatants").select("id, combat_id, character_id, npc_id, kind, form_id, name, initiative, sort_order, pv_current, pv_max, pc_current, pc_max, conditions, hidden, hide_stats, notes, data, image_path, homebrew_id").in("combat_id", combatIds),
        supabase.from("combat_log").select("id, combat_id, round, turn_index, kind, message, public, created_at").in("combat_id", combatIds).order("id", { ascending: false }).limit(300),
      ])
    : [{ data: [] }, { data: [] }];

  type RawAgent = { status: string; master_can_edit: boolean; characters: AgentRow["character"] & { character_forms: AgentRow["forms"][number][] } };
  const agents: AgentRow[] = ((agentsQ.data ?? []) as unknown as RawAgent[]).map((a) => {
    const { character_forms, ...character } = a.characters;
    return { character, masterCanEdit: a.master_can_edit, forms: (character_forms ?? []).map((f) => ({ ...f, conditions: f.conditions ?? [] })) };
  });
  // Segredos, pistas e quadro: o RLS entrega os de todas as campanhas que o usuário mestra; ficam só os desta.
  const invIds = new Set(((investigations.data ?? []) as InvestigationRow[]).map((i) => i.id));
  const secretBy = new Map(((secrets.data ?? []) as { investigation_id: string; master_notes: string }[]).map((s) => [s.investigation_id, s.master_notes]));

  const npcList = (npcs.data ?? []) as NpcRow[];
  const combatantList = (combatants.data ?? []) as CombatantRow[];
  const homebrewList = (homebrew.data ?? []) as ShieldHomebrew[];
  const media = await signMedia(supabase, [
    ...agents.flatMap((a) => a.forms.map((f) => f.portrait_path)),
    ...npcList.map((n) => n.image_path),
    ...combatantList.map((c) => c.image_path),
    ...homebrewList.filter((h) => h.kind === "monstro" || h.kind === "npc").map((h) => h.image_path),
  ]);

  return {
    campaign,
    userId: user.id,
    members: (members.data ?? []) as MemberRow[],
    party: (party.data ?? []) as PartyRow[],
    agents,
    media,
    npcs: npcList,
    combats: combatList,
    combatants: combatantList,
    combatLog: (logs.data ?? []) as CombatLogRow[],
    investigations: ((investigations.data ?? []) as InvestigationRow[]).map((i) => ({ ...i, secret: secretBy.get(i.id) ?? "" })),
    clues: ((clues.data ?? []) as ClueRow[]).filter((c) => invIds.has(c.investigation_id)),
    nodes: ((nodes.data ?? []) as NodeRow[]).filter((n) => invIds.has(n.investigation_id)),
    links: ((links.data ?? []) as LinkRow[]).filter((l) => invIds.has(l.investigation_id)),
    reports: (reports.data ?? []) as ReportRow[],
    notes: (notes.data ?? []) as NoteRow[],
    rolls: (rolls.data ?? []) as RollRow[],
    homebrew: homebrewList,
  };
}
