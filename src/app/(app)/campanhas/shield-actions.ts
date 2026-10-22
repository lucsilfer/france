"use server";

import { randomUUID } from "node:crypto";
import { z } from "zod";
import { requireUser } from "@/lib/supabase/server";
import { loadCharacter } from "@/lib/character";
import type { ActionResult } from "@/lib/types";
import type { ClueRow, CombatantRow, CombatRow, Condition, InvestigationRow, LinkRow, NodeRow, NpcRow } from "@/lib/campaign-types";
import { CATALOG_BY_ID } from "@/rules/catalog.ts";
import { OUTCOME_LABEL, rollTest, isSuccess } from "@/rules/d100.ts";
import { isValidDice, rollExpression } from "@/rules/dice.ts";
import { RULES_CONFIG } from "@/rules/config.ts";
import { buildSheet } from "@/rules/sheet.ts";

const uuid = z.string().uuid();

function fail(error: string): { ok: false; error: string } {
  return { ok: false, error };
}
function msg(error: { message?: string } | null | undefined, fallback: string): string {
  const m = error?.message ?? "";
  if (/^[A-ZÁÉÍÓÚÂÊÔÃÕÇ(]/.test(m) && !m.includes("violates") && !m.includes("permission denied")) return m;
  if (m.includes("row-level security") || m.includes("permission denied")) return "Apenas o Mestre pode fazer isso.";
  return fallback;
}
async function run<T>(fn: () => Promise<ActionResult<T>>): Promise<ActionResult<T>> {
  try {
    return await fn();
  } catch (e) {
    const digest = (e as { digest?: unknown })?.digest;
    if (typeof digest === "string" && digest.startsWith("NEXT_")) throw e;
    return fail(e instanceof Error && /^[A-ZÁÉÍÓÚ]/.test(e.message) ? e.message : "Não foi possível concluir. Tente novamente.");
  }
}
async function master(campaignId: string) {
  if (!uuid.safeParse(campaignId).success) throw new Error("Campanha inválida.");
  const { supabase, user } = await requireUser();
  const { data } = await supabase.rpc("is_campaign_master", { p_campaign: campaignId });
  if (!data) throw new Error("Apenas o Mestre pode fazer isso.");
  return { supabase, user };
}

const conditionInput = z.object({ name: z.string().trim().min(1).max(80), turns: z.number().int().min(1).max(100).nullable() });

// ===================================================================== Agentes (fichas dos jogadores)

/** ±PV/PC, dano e cura numa ficha. O máximo vem do motor e o banco limita o PV de novo pelo próprio cálculo. */
export async function agentAdjust(campaignId: string, characterId: string, formId: string, resource: "pv" | "pc", delta: number): Promise<ActionResult<{ value: number }>> {
  return run(async () => {
    if (!uuid.safeParse(characterId).success || !uuid.safeParse(formId).success) return fail("Dados inválidos.");
    if ((resource !== "pv" && resource !== "pc") || !Number.isInteger(delta) || Math.abs(delta) > 10000) return fail("Valor inválido.");
    const { supabase } = await master(campaignId);
    const bundle = await loadCharacter(characterId);
    if (!bundle.canEdit) return fail("O jogador não autorizou o Mestre a editar esta ficha.");
    const form = [bundle.base, bundle.lenda].find((f) => f?.id === formId);
    if (!form) return fail("Forma não encontrada.");
    const c = bundle.character;
    if (resource === "pc" && c.origin_id === "prodigio") return fail("Prodígios não usam PC.");
    const sheet = buildSheet({ classId: c.class_id, originId: c.origin_id, level: c.level, form });
    const max = resource === "pv" ? sheet.resources.pvMax : sheet.resources.pcMax;
    const { data, error } = await supabase.rpc("adjust_form_resource", { p_form: formId, p_resource: resource, p_delta: delta, p_max: max });
    if (error) return fail(msg(error, "Não foi possível ajustar."));
    return { ok: true, data: { value: data as number } };
  });
}

export async function agentCondition(campaignId: string, formId: string, action: "add" | "remove", input: { name?: string; turns?: number | null; id?: string }): Promise<ActionResult<Condition[]>> {
  return run(async () => {
    if (!uuid.safeParse(formId).success || !["add", "remove"].includes(action)) return fail("Dados inválidos.");
    if (action === "add" && !conditionInput.safeParse({ name: input.name, turns: input.turns ?? null }).success) return fail("Condição inválida (nome até 80 caracteres; 1–100 turnos).");
    const { supabase } = await master(campaignId);
    const { data, error } = await supabase.rpc("form_condition", {
      p_form: formId,
      p_action: action,
      p_name: input.name ?? null,
      p_turns: input.turns ?? null,
      p_id: input.id ?? null,
    });
    if (error) return fail(msg(error, "Não foi possível alterar a condição."));
    return { ok: true, data: (data ?? []) as Condition[] };
  });
}

/** Entrega um item (catálogo oficial ou Homebrew do Mestre) ao inventário de um personagem da campanha. */
export async function giveItem(campaignId: string, characterId: string, source: { catalogId?: string; homebrewId?: string }): Promise<ActionResult> {
  return run(async () => {
    if (!uuid.safeParse(characterId).success) return fail("Personagem inválido.");
    const { supabase, user } = await master(campaignId);
    let row: Record<string, unknown> | null = null;
    if (source.catalogId) {
      const c = CATALOG_BY_ID[source.catalogId];
      if (!c) return fail("Item inválido.");
      row = {
        source_kind: "catalog",
        source_ref: c.id,
        name: c.name,
        description: c.description,
        item_type: c.type,
        category: c.category,
        effect_kind: c.effectKind,
        effect_dice: c.effectDice,
        attack_kind: c.attackKind,
        damage_type: c.damageType,
        tier: c.tier,
        range: c.range,
        special_rules: c.effectDice ? "" : c.effectText,
        tags: c.tags,
      };
    } else if (source.homebrewId && uuid.safeParse(source.homebrewId).success) {
      const { data: hb } = await supabase.from("homebrew").select("kind, name, description, data").eq("id", source.homebrewId).eq("owner_id", user.id).maybeSingle();
      if (!hb || !["item", "arma"].includes(hb.kind as string)) return fail("Item da biblioteca não encontrado.");
      const d = (hb.data ?? {}) as Record<string, unknown>;
      const dice = typeof d.effect_dice === "string" && isValidDice(d.effect_dice) ? d.effect_dice : null;
      const weapon = hb.kind === "arma" || d.item_type === "arma";
      row = {
        source_kind: "homebrew",
        source_ref: source.homebrewId,
        name: hb.name,
        description: hb.description ?? "",
        item_type: weapon ? "arma" : ((d.item_type as string) ?? "equipamento"),
        category: (d.category as string) ?? "",
        effect_kind: d.effect_kind === "outro" ? "personalizado" : ((d.effect_kind as string) || (weapon ? "dano" : null)),
        effect_dice: dice,
        attack_kind: weapon ? ((d.attack_kind as string) || "melee") : null,
        damage_type: weapon ? ((d.damage_type as string) || null) : null,
        range: (d.range as string) ?? "",
        special_rules: (d.special_rules as string) ?? "",
        tags: weapon && Array.isArray(d.tags) ? d.tags : [],
      };
      if (weapon && !dice) return fail("Esta arma da biblioteca não tem dano válido.");
    } else return fail("Escolha um item.");
    const { error } = await supabase.from("items").insert({ ...row, character_id: characterId });
    if (error) return fail(msg(error, "O jogador não autorizou o Mestre a editar esta ficha."));
    return { ok: true, message: `${row.name} entregue ao inventário.` };
  });
}

// ===================================================================== NPCs e monstros

const npcSchema = z.object({
  kind: z.enum(["npc", "monstro"]),
  name: z.string().trim().min(1, "Dê um nome.").max(120),
  pv_max: z.number().int().min(0).max(99999).nullable(),
  pc_max: z.number().int().min(0).max(99999).nullable(),
  visible_to_players: z.boolean(),
  data: z.object({
    description: z.string().max(10000).optional(),
    attributes: z.record(z.string(), z.number().int().min(0).max(300)).optional(),
    attacks: z
      .array(z.object({ name: z.string().trim().min(1).max(80), skill: z.number().int().min(0).max(200), damage: z.string().trim().max(60).refine((v) => isValidDice(v), "Dano inválido (ex.: 1d8+2).") }))
      .max(12)
      .optional(),
    abilities: z.string().max(10000).optional(),
    notes: z.string().max(10000).optional(),
  }),
});
export type NpcInput = z.infer<typeof npcSchema>;

const NPC_COLUMNS = "id, kind, name, data, pv_current, pv_max, pc_current, pc_max, conditions, visible_to_players, source_homebrew_id, created_at";

export async function saveNpc(campaignId: string, input: NpcInput, id?: string | null): Promise<ActionResult<NpcRow>> {
  return run(async () => {
    const parsed = npcSchema.safeParse(input);
    if (!parsed.success) return fail(parsed.error.issues[0]?.message ?? "Revise os campos.");
    if (id && !uuid.safeParse(id).success) return fail("NPC inválido.");
    const { supabase } = await master(campaignId);
    const d = parsed.data;
    const q = id
      ? supabase.from("npcs").update({ ...d }).eq("id", id).eq("campaign_id", campaignId).select(NPC_COLUMNS)
      : supabase.from("npcs").insert({ ...d, campaign_id: campaignId, pv_current: d.pv_max, pc_current: d.pc_max }).select(NPC_COLUMNS);
    const { data, error } = await q;
    if (error || !data?.length) return fail(msg(error, "Não foi possível salvar o NPC."));
    return { ok: true, data: data[0] as NpcRow, message: id ? "NPC salvo." : `${d.kind === "monstro" ? "Monstro" : "NPC"} criado.` };
  });
}

/** Instância independente a partir de um modelo do Homebrew (o modelo não muda). */
export async function npcFromHomebrew(campaignId: string, homebrewId: string): Promise<ActionResult<NpcRow>> {
  return run(async () => {
    if (!uuid.safeParse(homebrewId).success) return fail("Modelo inválido.");
    const { supabase, user } = await master(campaignId);
    const { data: hb } = await supabase.from("homebrew").select("id, kind, name, description, data").eq("id", homebrewId).eq("owner_id", user.id).maybeSingle();
    if (!hb || !["npc", "monstro"].includes(hb.kind as string)) return fail("Modelo de NPC/monstro não encontrado.");
    const d = (hb.data ?? {}) as Record<string, unknown>;
    const pv = Number.isInteger(d.pv_max) ? (d.pv_max as number) : Number.isInteger(d.pv) ? (d.pv as number) : null;
    const pc = Number.isInteger(d.pc_max) ? (d.pc_max as number) : Number.isInteger(d.pc) ? (d.pc as number) : null;
    const { data, error } = await supabase
      .from("npcs")
      .insert({
        campaign_id: campaignId,
        source_homebrew_id: hb.id,
        kind: hb.kind,
        name: hb.name,
        data: { ...d, description: hb.description ?? "" },
        pv_max: pv,
        pv_current: pv,
        pc_max: pc,
        pc_current: pc,
      })
      .select(NPC_COLUMNS)
      .single();
    if (error || !data) return fail(msg(error, "Não foi possível adicionar."));
    return { ok: true, data: data as NpcRow, message: `${hb.name} adicionado à campanha (cópia do modelo).` };
  });
}

export async function deleteNpc(campaignId: string, id: string): Promise<ActionResult> {
  return run(async () => {
    if (!uuid.safeParse(id).success) return fail("NPC inválido.");
    const { supabase } = await master(campaignId);
    const { data, error } = await supabase.from("npcs").delete().eq("id", id).eq("campaign_id", campaignId).select("id");
    if (error || !data?.length) return fail(msg(error, "Não foi possível excluir."));
    return { ok: true, message: "Excluído." };
  });
}

export async function npcAdjust(campaignId: string, id: string, resource: "pv" | "pc", delta: number): Promise<ActionResult<NpcRow>> {
  return run(async () => {
    if (!uuid.safeParse(id).success || !Number.isInteger(delta) || Math.abs(delta) > 100000) return fail("Dados inválidos.");
    const { supabase } = await master(campaignId);
    const { data: n } = await supabase.from("npcs").select(NPC_COLUMNS).eq("id", id).eq("campaign_id", campaignId).maybeSingle();
    if (!n) return fail("NPC não encontrado.");
    const npc = n as NpcRow;
    const cur = (resource === "pv" ? npc.pv_current : npc.pc_current) ?? 0;
    const max = resource === "pv" ? npc.pv_max : npc.pc_max;
    const next = Math.max(0, max == null ? cur + delta : Math.min(max, cur + delta));
    const { data, error } = await supabase.from("npcs").update(resource === "pv" ? { pv_current: next } : { pc_current: next }).eq("id", id).select(NPC_COLUMNS);
    if (error || !data?.length) return fail(msg(error, "Não foi possível ajustar."));
    return { ok: true, data: data[0] as NpcRow };
  });
}

export async function npcCondition(campaignId: string, id: string, action: "add" | "remove", input: { name?: string; turns?: number | null; id?: string }): Promise<ActionResult<NpcRow>> {
  return run(async () => {
    if (!uuid.safeParse(id).success) return fail("NPC inválido.");
    const { supabase } = await master(campaignId);
    const { data: n } = await supabase.from("npcs").select("conditions").eq("id", id).eq("campaign_id", campaignId).maybeSingle();
    if (!n) return fail("NPC não encontrado.");
    let list = (n.conditions ?? []) as Condition[];
    if (action === "add") {
      const p = conditionInput.safeParse({ name: input.name, turns: input.turns ?? null });
      if (!p.success) return fail("Condição inválida.");
      list = [...list, { id: randomUUID(), name: p.data.name, turns: p.data.turns }];
    } else list = list.filter((c) => c.id !== input.id);
    const { data, error } = await supabase.from("npcs").update({ conditions: list }).eq("id", id).select(NPC_COLUMNS);
    if (error || !data?.length) return fail(msg(error, "Não foi possível alterar."));
    return { ok: true, data: data[0] as NpcRow };
  });
}

/** Ataque de NPC/monstro: d100 contra o valor do ataque, dano rolado no servidor e registrado (privado do Mestre). */
export async function npcAttack(campaignId: string, npcName: string, attack: { name: string; skill: number; damage: string }, combatId?: string | null, publicLog = false) {
  return run(async () => {
    if (!attack || !isValidDice(attack.damage) || !Number.isInteger(attack.skill) || attack.skill < 0 || attack.skill > 200) return fail("Ataque inválido.");
    if (combatId && !uuid.safeParse(combatId).success) return fail("Combate inválido.");
    const { supabase, user } = await master(campaignId);
    const test = rollTest(`${npcName}: ${attack.name}`, attack.skill);
    const hit = isSuccess(test.outcome);
    const dmg = hit ? rollExpression(attack.damage) : null;
    const mult = test.outcome === "critical_success" ? RULES_CONFIG.damageMultiplier.critical : test.outcome === "extreme" ? RULES_CONFIG.damageMultiplier.extreme : 1;
    const finalDamage = dmg ? dmg.total * mult : 0;
    const result = {
      kind: "attack",
      weapon: attack.name,
      skillName: npcName,
      natural: test.natural,
      rolls: test.rolls,
      effective: test.effective,
      rollModifier: test.rollModifier,
      thresholds: test.thresholds,
      outcome: test.outcome,
      outcomeLabel: OUTCOME_LABEL[test.outcome],
      hit,
      damage: dmg ? { expression: dmg.expression, rolls: dmg.terms.flatMap((t) => t.rolls), total: dmg.total } : null,
      multiplier: mult,
      finalDamage,
      applied: [],
      conditions: [],
      note: test.outcome === "critical_failure" ? "Falha crítica: o Mestre decide a consequência." : null,
    };
    const { data, error } = await supabase
      .from("roll_log")
      .insert({ user_id: user.id, campaign_id: campaignId, label: `${npcName}: ${attack.name}`, expression: `1d100 + ${attack.damage}`, result, visibility: publicLog ? "public" : "self" })
      .select("id, user_id, character_id, label, expression, result, visibility, created_at")
      .single();
    if (error || !data) return fail(msg(error, "Não foi possível registrar o ataque."));
    if (combatId) {
      await supabase.rpc("combat_note", {
        p_combat: combatId,
        p_kind: "ataque",
        p_message: `${npcName} — ${attack.name}: ${test.natural} (${OUTCOME_LABEL[test.outcome]})${hit ? `, ${finalDamage} de dano` : ", sem dano"}.`,
        p_data: { roll: data.id },
        p_public: publicLog,
        p_request: null,
      });
    }
    return { ok: true, data };
  });
}

// ===================================================================== Combates

const COMBAT_COLUMNS = "id, name, status, round, turn_index, version, initiative_mode, started_at, ended_at, created_at";
const COMBATANT_COLUMNS = "id, combat_id, character_id, npc_id, kind, form_id, name, initiative, sort_order, pv_current, pv_max, pc_current, pc_max, conditions, hidden, hide_stats, notes";

export async function createCombat(campaignId: string, name: string, mode: "manual" | "reflexo" | "d20"): Promise<ActionResult<CombatRow>> {
  return run(async () => {
    if (!["manual", "reflexo", "d20"].includes(mode)) return fail("Modo de iniciativa inválido.");
    const { supabase } = await master(campaignId);
    const { data, error } = await supabase
      .from("combats")
      .insert({ campaign_id: campaignId, name: (name || "Combate").trim().slice(0, 120), status: "paused", initiative_mode: mode })
      .select(COMBAT_COLUMNS)
      .single();
    if (error || !data) return fail(msg(error, "Não foi possível criar o combate."));
    return { ok: true, data: data as CombatRow, message: "Combate criado. Adicione os participantes e inicie." };
  });
}

export async function deleteCombat(campaignId: string, combatId: string): Promise<ActionResult> {
  return run(async () => {
    if (!uuid.safeParse(combatId).success) return fail("Combate inválido.");
    const { supabase } = await master(campaignId);
    const { data, error } = await supabase.from("combats").delete().eq("id", combatId).eq("campaign_id", campaignId).select("id");
    if (error || !data?.length) return fail(msg(error, "Não foi possível excluir."));
    return { ok: true, message: "Combate excluído." };
  });
}

export async function addCombatant(
  campaignId: string,
  combatId: string,
  who: { characterId?: string; npcId?: string; name?: string; pv?: number | null; pc?: number | null },
  initiative: number | null,
): Promise<ActionResult<CombatantRow>> {
  return run(async () => {
    if (!uuid.safeParse(combatId).success) return fail("Combate inválido.");
    if (initiative !== null && (!Number.isInteger(initiative) || Math.abs(initiative) > 10000)) return fail("Iniciativa inválida.");
    const { supabase } = await master(campaignId);
    const { count } = await supabase.from("combatants").select("id", { count: "exact", head: true }).eq("combat_id", combatId);
    let row: Record<string, unknown>;
    if (who.characterId && uuid.safeParse(who.characterId).success) {
      const { data: ch } = await supabase.from("characters").select("name").eq("id", who.characterId).maybeSingle();
      if (!ch) return fail("Personagem não encontrado (precisa estar aceito na campanha).");
      row = { character_id: who.characterId, name: ch.name };
    } else if (who.npcId && uuid.safeParse(who.npcId).success) {
      // Instância independente: copia os valores do NPC; o modelo não muda.
      const { data: n } = await supabase.from("npcs").select("id, kind, name, pv_max, pc_max").eq("id", who.npcId).eq("campaign_id", campaignId).maybeSingle();
      if (!n) return fail("NPC não encontrado.");
      const same = await supabase.from("combatants").select("id", { count: "exact", head: true }).eq("combat_id", combatId).eq("npc_id", n.id);
      const suffix = (same.count ?? 0) > 0 ? ` ${(same.count ?? 0) + 1}` : "";
      row = { npc_id: n.id, kind: n.kind, name: `${n.name}${suffix}`, pv_max: n.pv_max, pv_current: n.pv_max, pc_max: n.pc_max, pc_current: n.pc_max };
    } else {
      const name = (who.name ?? "").trim();
      if (!name || name.length > 120) return fail("Dê um nome ao participante.");
      row = { kind: "other", name, pv_max: who.pv ?? null, pv_current: who.pv ?? null, pc_max: who.pc ?? null, pc_current: who.pc ?? null };
    }
    const { data, error } = await supabase
      .from("combatants")
      .insert({ ...row, combat_id: combatId, initiative, sort_order: count ?? 0 })
      .select(COMBATANT_COLUMNS)
      .single();
    if (error || !data) return fail(msg(error, "Não foi possível adicionar."));
    return { ok: true, data: data as CombatantRow };
  });
}

const combatantPatch = z.object({
  name: z.string().trim().min(1).max(120).optional(),
  initiative: z.number().int().min(-10000).max(10000).nullable().optional(),
  hidden: z.boolean().optional(),
  hide_stats: z.boolean().optional(),
  notes: z.string().max(2000).optional(),
  pv_max: z.number().int().min(0).max(99999).nullable().optional(),
  pc_max: z.number().int().min(0).max(99999).nullable().optional(),
});

export async function updateCombatant(campaignId: string, id: string, patch: z.infer<typeof combatantPatch>): Promise<ActionResult<CombatantRow>> {
  return run(async () => {
    if (!uuid.safeParse(id).success) return fail("Participante inválido.");
    const parsed = combatantPatch.safeParse(patch);
    if (!parsed.success) return fail("Valores inválidos.");
    const { supabase } = await master(campaignId);
    const { data, error } = await supabase.from("combatants").update(parsed.data).eq("id", id).select(COMBATANT_COLUMNS);
    if (error || !data?.length) return fail(msg(error, "Não foi possível salvar."));
    return { ok: true, data: data[0] as CombatantRow };
  });
}

export async function removeCombatant(campaignId: string, id: string): Promise<ActionResult> {
  return run(async () => {
    if (!uuid.safeParse(id).success) return fail("Participante inválido.");
    const { supabase } = await master(campaignId);
    const { data, error } = await supabase.from("combatants").delete().eq("id", id).select("id");
    if (error || !data?.length) return fail(msg(error, "Não foi possível remover."));
    return { ok: true };
  });
}

/** Define a ordem dos turnos (lista de ids). */
export async function setCombatOrder(campaignId: string, combatId: string, ids: string[]): Promise<ActionResult> {
  return run(async () => {
    if (!uuid.safeParse(combatId).success || !Array.isArray(ids) || ids.length > 100 || ids.some((i) => !uuid.safeParse(i).success)) return fail("Ordem inválida.");
    const { supabase } = await master(campaignId);
    for (let i = 0; i < ids.length; i++) {
      const { error } = await supabase.from("combatants").update({ sort_order: i }).eq("id", ids[i]).eq("combat_id", combatId);
      if (error) return fail(msg(error, "Não foi possível ordenar."));
    }
    return { ok: true };
  });
}

/**
 * Iniciativa automática (regra da MESA — o livro não define iniciativa):
 *  - "reflexo": valor da perícia Reflexo dos personagens (NPCs mantêm a iniciativa informada);
 *  - "d20": 1d20 para cada participante.
 * Ordena do maior para o menor; o Mestre ainda pode reordenar à mão.
 */
export async function rollInitiative(campaignId: string, combatId: string): Promise<ActionResult<CombatantRow[]>> {
  return run(async () => {
    if (!uuid.safeParse(combatId).success) return fail("Combate inválido.");
    const { supabase } = await master(campaignId);
    const { data: cb } = await supabase.from("combats").select("initiative_mode").eq("id", combatId).maybeSingle();
    if (!cb) return fail("Combate não encontrado.");
    const { data: list } = await supabase.from("combatants").select(COMBATANT_COLUMNS).eq("combat_id", combatId);
    const rows = (list ?? []) as CombatantRow[];
    for (const r of rows) {
      let ini = r.initiative;
      if (cb.initiative_mode === "d20") ini = rollExpression("1d20").total;
      else if (cb.initiative_mode === "reflexo" && r.character_id) {
        const b = await loadCharacter(r.character_id);
        const form = [b.base, b.lenda].find((f) => f?.id === r.form_id) ?? b.base;
        const s = buildSheet({ classId: b.character.class_id, originId: b.character.origin_id, level: b.character.level, form });
        ini = s.skills.find((x) => x.id === "reflexo")?.final ?? ini;
      }
      r.initiative = ini;
    }
    rows.sort((a, b) => (b.initiative ?? -1e9) - (a.initiative ?? -1e9) || a.name.localeCompare(b.name));
    for (let i = 0; i < rows.length; i++) {
      rows[i].sort_order = i;
      await supabase.from("combatants").update({ initiative: rows[i].initiative, sort_order: i }).eq("id", rows[i].id);
    }
    return { ok: true, data: rows, message: cb.initiative_mode === "manual" ? "Ordenado pela iniciativa informada." : "Iniciativa rolada e ordem atualizada." };
  });
}

export async function combatControl(campaignId: string, combatId: string, action: "start" | "next" | "prev" | "new_round" | "pause" | "end" | "reopen", version: number): Promise<ActionResult<CombatRow>> {
  return run(async () => {
    if (!uuid.safeParse(combatId).success || !Number.isInteger(version)) return fail("Dados inválidos.");
    const { supabase } = await master(campaignId);
    const { data, error } = await supabase.rpc("combat_control", { p_combat: combatId, p_action: action, p_version: version });
    if (error || !data) return fail(msg(error, "Não foi possível atualizar o combate."));
    return { ok: true, data: data as CombatRow };
  });
}

export async function combatApply(campaignId: string, combatantId: string, kind: "damage" | "heal" | "pc_spend" | "pc_gain", amount: number, requestId: string, note = ""): Promise<ActionResult<{ before: number; after: number }>> {
  return run(async () => {
    if (!uuid.safeParse(combatantId).success || !uuid.safeParse(requestId).success || !Number.isInteger(amount)) return fail("Dados inválidos.");
    const { supabase } = await master(campaignId);
    const { data, error } = await supabase.rpc("combat_apply", { p_combatant: combatantId, p_kind: kind, p_amount: amount, p_request: requestId, p_note: String(note).slice(0, 200) });
    if (error || !data) return fail(msg(error, "Não foi possível aplicar."));
    const r = data as { duplicate: boolean; before: number; after: number };
    if (r.duplicate) return fail("Esta ação já foi aplicada.");
    return { ok: true, data: { before: r.before, after: r.after } };
  });
}

export async function combatCondition(campaignId: string, combatantId: string, action: "add" | "remove", input: { name?: string; turns?: number | null; id?: string }): Promise<ActionResult<Condition[]>> {
  return run(async () => {
    if (!uuid.safeParse(combatantId).success) return fail("Participante inválido.");
    if (action === "add" && !conditionInput.safeParse({ name: input.name, turns: input.turns ?? null }).success) return fail("Condição inválida.");
    const { supabase } = await master(campaignId);
    const { data, error } = await supabase.rpc("combat_condition", { p_combatant: combatantId, p_action: action, p_name: input.name ?? null, p_turns: input.turns ?? null, p_id: input.id ?? null });
    if (error) return fail(msg(error, "Não foi possível alterar a condição."));
    return { ok: true, data: (data ?? []) as Condition[] };
  });
}

export async function combatNote(campaignId: string, combatId: string, kind: "ataque" | "poder" | "efeito" | "nota", message: string, isPublic: boolean): Promise<ActionResult> {
  return run(async () => {
    if (!uuid.safeParse(combatId).success || !message.trim() || message.length > 500) return fail("Registro inválido.");
    const { supabase } = await master(campaignId);
    const { error } = await supabase.rpc("combat_note", { p_combat: combatId, p_kind: kind, p_message: message.trim(), p_data: {}, p_public: Boolean(isPublic), p_request: randomUUID() });
    if (error) return fail(msg(error, "Não foi possível registrar."));
    return { ok: true };
  });
}

/** Estado atual de um combate (para recarregar após mudanças vindas de outro aparelho). */
export async function fetchCombat(campaignId: string, combatId: string) {
  return run(async () => {
    if (!uuid.safeParse(combatId).success) return fail("Combate inválido.");
    const { supabase } = await master(campaignId);
    const [cb, list, log] = await Promise.all([
      supabase.from("combats").select(COMBAT_COLUMNS).eq("id", combatId).maybeSingle(),
      supabase.from("combatants").select(COMBATANT_COLUMNS).eq("combat_id", combatId),
      supabase.from("combat_log").select("id, combat_id, round, turn_index, kind, message, public, created_at").eq("combat_id", combatId).order("id", { ascending: false }).limit(150),
    ]);
    if (!cb.data) return fail("Combate não encontrado.");
    return { ok: true, data: { combat: cb.data as CombatRow, combatants: (list.data ?? []) as CombatantRow[], log: log.data ?? [] } };
  });
}

// ===================================================================== Investigação

const investigationSchema = z.object({
  title: z.string().trim().min(1, "Dê um nome à investigação.").max(160),
  description: z.string().max(20000),
  location: z.string().trim().max(160),
  status: z.enum(["aberta", "em_andamento", "resolvida", "arquivada"]),
  characters: z.array(z.string().max(120)).max(40),
  visible_to_players: z.boolean(),
  secret: z.string().max(20000),
});
export type InvestigationInput = z.infer<typeof investigationSchema>;
const INV_COLUMNS = "id, title, description, location, status, characters, visible_to_players, created_at";

export async function saveInvestigation(campaignId: string, input: InvestigationInput, id?: string | null): Promise<ActionResult<InvestigationRow>> {
  return run(async () => {
    const parsed = investigationSchema.safeParse(input);
    if (!parsed.success) return fail(parsed.error.issues[0]?.message ?? "Revise os campos.");
    if (id && !uuid.safeParse(id).success) return fail("Investigação inválida.");
    const { supabase } = await master(campaignId);
    const { secret, ...row } = parsed.data;
    const q = id
      ? supabase.from("investigations").update(row).eq("id", id).eq("campaign_id", campaignId).select(INV_COLUMNS)
      : supabase.from("investigations").insert({ ...row, campaign_id: campaignId }).select(INV_COLUMNS);
    const { data, error } = await q;
    if (error || !data?.length) return fail(msg(error, "Não foi possível salvar a investigação."));
    const inv = data[0] as InvestigationRow;
    const { error: sErr } = await supabase.from("investigation_secrets").upsert({ investigation_id: inv.id, master_notes: secret }, { onConflict: "investigation_id" });
    if (sErr) return fail("Investigação salva, mas as informações secretas não.");
    return { ok: true, data: { ...inv, secret }, message: "Investigação salva." };
  });
}

export async function deleteInvestigation(campaignId: string, id: string): Promise<ActionResult> {
  return run(async () => {
    if (!uuid.safeParse(id).success) return fail("Investigação inválida.");
    const { supabase } = await master(campaignId);
    const { data, error } = await supabase.from("investigations").delete().eq("id", id).eq("campaign_id", campaignId).select("id");
    if (error || !data?.length) return fail(msg(error, "Não foi possível excluir."));
    return { ok: true, message: "Investigação excluída." };
  });
}

const clueSchema = z.object({
  title: z.string().trim().min(1, "Dê um nome à pista.").max(160),
  content: z.string().max(20000),
  location: z.string().trim().max(160),
  characters: z.array(z.string().max(120)).max(40),
  image_url: z.string().trim().max(500).refine((v) => v === "" || /^https:\/\/\S+$/.test(v), "Imagem: use um link https://."),
  attachments: z.array(z.string().max(500).regex(/^https:\/\/\S+$/, "Arquivos: use links https://")).max(10),
  revealed: z.boolean(),
});
export type ClueInput = z.infer<typeof clueSchema>;
const CLUE_COLUMNS = "id, investigation_id, title, content, location, characters, image_url, attachments, revealed, revealed_at, board_x, board_y, created_at";

export async function saveClue(campaignId: string, investigationId: string, input: ClueInput, id?: string | null): Promise<ActionResult<ClueRow>> {
  return run(async () => {
    const parsed = clueSchema.safeParse(input);
    if (!parsed.success) return fail(parsed.error.issues[0]?.message ?? "Revise os campos.");
    if (!uuid.safeParse(investigationId).success || (id && !uuid.safeParse(id).success)) return fail("Dados inválidos.");
    const { supabase } = await master(campaignId);
    const row = { ...parsed.data, image_url: parsed.data.image_url || null };
    const q = id
      ? supabase.from("clues").update(row).eq("id", id).eq("investigation_id", investigationId).select(CLUE_COLUMNS)
      : supabase.from("clues").insert({ ...row, investigation_id: investigationId }).select(CLUE_COLUMNS);
    const { data, error } = await q;
    if (error || !data?.length) return fail(msg(error, "Não foi possível salvar a pista."));
    return { ok: true, data: data[0] as ClueRow, message: "Pista salva." };
  });
}

export async function setClueRevealed(campaignId: string, id: string, revealed: boolean): Promise<ActionResult<ClueRow>> {
  return run(async () => {
    if (!uuid.safeParse(id).success) return fail("Pista inválida.");
    const { supabase } = await master(campaignId);
    const { data, error } = await supabase.from("clues").update({ revealed: Boolean(revealed) }).eq("id", id).select(CLUE_COLUMNS);
    if (error || !data?.length) return fail(msg(error, "Não foi possível alterar a pista."));
    return { ok: true, data: data[0] as ClueRow, message: revealed ? "Pista revelada aos jogadores." : "Pista voltou a ser secreta." };
  });
}

export async function deleteClue(campaignId: string, id: string): Promise<ActionResult> {
  return run(async () => {
    if (!uuid.safeParse(id).success) return fail("Pista inválida.");
    const { supabase } = await master(campaignId);
    const { data, error } = await supabase.from("clues").delete().eq("id", id).select("id");
    if (error || !data?.length) return fail(msg(error, "Não foi possível excluir."));
    await supabase.from("investigation_links").delete().or(`from_id.eq.${id},to_id.eq.${id}`);
    return { ok: true, message: "Pista excluída." };
  });
}

// Quadro de investigação
export async function addBoardNode(campaignId: string, investigationId: string, kind: "place" | "character" | "note", label: string, x: number, y: number): Promise<ActionResult<NodeRow>> {
  return run(async () => {
    if (!uuid.safeParse(investigationId).success || !["place", "character", "note"].includes(kind) || !label.trim() || label.length > 120) return fail("Dados inválidos.");
    const { supabase } = await master(campaignId);
    const { data, error } = await supabase
      .from("investigation_nodes")
      .insert({ investigation_id: investigationId, kind, label: label.trim(), x: Math.round(x), y: Math.round(y) })
      .select("id, investigation_id, kind, label, x, y")
      .single();
    if (error || !data) return fail(msg(error, "Não foi possível adicionar."));
    return { ok: true, data: data as NodeRow };
  });
}

export async function moveBoardItem(campaignId: string, kind: "node" | "clue", id: string, x: number, y: number): Promise<ActionResult> {
  return run(async () => {
    if (!uuid.safeParse(id).success || !Number.isFinite(x) || !Number.isFinite(y)) return fail("Dados inválidos.");
    const { supabase } = await master(campaignId);
    const q =
      kind === "node"
        ? supabase.from("investigation_nodes").update({ x: Math.round(x), y: Math.round(y) }).eq("id", id).select("id")
        : supabase.from("clues").update({ board_x: Math.round(x), board_y: Math.round(y) }).eq("id", id).select("id");
    const { data, error } = await q;
    if (error || !data?.length) return fail(msg(error, "Não foi possível salvar a posição."));
    return { ok: true };
  });
}

export async function deleteBoardNode(campaignId: string, id: string): Promise<ActionResult> {
  return run(async () => {
    if (!uuid.safeParse(id).success) return fail("Item inválido.");
    const { supabase } = await master(campaignId);
    const { error } = await supabase.from("investigation_nodes").delete().eq("id", id);
    if (error) return fail(msg(error, "Não foi possível excluir."));
    await supabase.from("investigation_links").delete().or(`from_id.eq.${id},to_id.eq.${id}`);
    return { ok: true };
  });
}

export async function addBoardLink(campaignId: string, investigationId: string, fromId: string, toId: string, label = ""): Promise<ActionResult<LinkRow>> {
  return run(async () => {
    if (![investigationId, fromId, toId].every((v) => uuid.safeParse(v).success) || fromId === toId || label.length > 80) return fail("Ligação inválida.");
    const { supabase } = await master(campaignId);
    const { data, error } = await supabase
      .from("investigation_links")
      .insert({ investigation_id: investigationId, from_id: fromId, to_id: toId, label })
      .select("id, investigation_id, from_id, to_id, label")
      .single();
    if (error || !data) return fail(error?.code === "23505" ? "Essa ligação já existe." : msg(error, "Não foi possível ligar."));
    return { ok: true, data: data as LinkRow };
  });
}

export async function deleteBoardLink(campaignId: string, id: string): Promise<ActionResult> {
  return run(async () => {
    if (!uuid.safeParse(id).success) return fail("Ligação inválida.");
    const { supabase } = await master(campaignId);
    const { error } = await supabase.from("investigation_links").delete().eq("id", id);
    if (error) return fail(msg(error, "Não foi possível remover."));
    return { ok: true };
  });
}

export async function newRequestId(): Promise<string> {
  return randomUUID();
}
