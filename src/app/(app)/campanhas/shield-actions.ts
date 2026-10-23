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
import { normalizeCreature, rollCreatureAbility, rollCreatureAttack, testValue } from "@/rules/creatures.ts";
import { planAttack } from "@/rules/combat.ts";
import { SKILL_BY_ID } from "@/rules/data/skills.ts";
import { confrontFromRow, type ConfrontPayload } from "@/lib/rolls";
import { campaignNpcData, inventoryRowFrom, type CampaignNpcFormValue } from "@/lib/homebrew";
import type { HomebrewKind } from "@/lib/types";
import { isMediaPath } from "@/lib/media-shared";
import { removeMedia } from "@/lib/media";

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
    let official: string[] = [];
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
      const { data: hb } = await supabase.from("homebrew").select("kind, name, description, data, image_path").eq("id", source.homebrewId).eq("owner_id", user.id).maybeSingle();
      if (!hb || !["item", "arma", "item_especial", "outro"].includes(hb.kind as string)) return fail("Item da biblioteca não encontrado.");
      let conv: ReturnType<typeof inventoryRowFrom> = null;
      try {
        conv = inventoryRowFrom(hb.kind as HomebrewKind, hb.name as string, (hb.description as string) ?? "", (hb.data ?? {}) as Record<string, unknown>);
      } catch {
        return fail("Este modelo está incompleto. Abra-o no Homebrew e salve de novo.");
      }
      if (!conv) return fail("Este conteúdo não vai para o inventário.");
      row = { ...conv.row, source_kind: "homebrew", source_ref: source.homebrewId, image_path: hb.image_path ?? null };
      official = conv.officialModifiers;
    } else return fail("Escolha um item.");
    const { data: created, error } = await supabase.from("items").insert({ ...row, character_id: characterId }).select("id").single();
    if (error || !created) return fail(msg(error, "O jogador não autorizou o Mestre a editar esta ficha."));
    for (const m of official) await supabase.from("item_modifiers").insert({ item_id: created.id, modifier_id: m, is_temporary: false });
    return { ok: true, message: `${row.name} entregue ao inventário.` };
  });
}

// ===================================================================== NPCs e monstros

const npcSchema = z.object({
  kind: z.enum(["npc", "monstro"]),
  name: z.string().trim().min(1, "Dê um nome.").max(120),
  visible_to_players: z.boolean(),
  image_path: z.string().max(200).nullable(),
  data: campaignNpcData,
});
export interface NpcInput {
  kind: "npc" | "monstro";
  name: string;
  visible_to_players: boolean;
  image_path: string | null;
  data: CampaignNpcFormValue;
}

const NPC_COLUMNS = "id, kind, name, data, pv_current, pv_max, pc_current, pc_max, conditions, visible_to_players, source_homebrew_id, image_path, created_at";

export async function saveNpc(campaignId: string, input: NpcInput, id?: string | null): Promise<ActionResult<NpcRow>> {
  return run(async () => {
    const parsed = npcSchema.safeParse(input);
    if (!parsed.success) {
      const i = parsed.error.issues[0];
      return fail(i ? `${i.message}${i.path.length ? ` (${i.path.join(" › ")})` : ""}` : "Revise os campos.");
    }
    if (id && !uuid.safeParse(id).success) return fail("NPC inválido.");
    const { supabase, user } = await master(campaignId);
    const d = parsed.data;
    if (d.image_path && !isMediaPath(d.image_path, "npcs", campaignId) && !isMediaPath(d.image_path, "homebrew", user.id)) return fail("Imagem inválida.");
    const c = d.data as CampaignNpcFormValue;
    const base = { kind: d.kind, name: d.name, visible_to_players: d.visible_to_players, image_path: d.image_path, data: c, pv_max: c.pv_max, pc_max: c.pc_max };
    let prevImage: string | null = null;
    if (id) {
      const { data: prev } = await supabase.from("npcs").select("image_path").eq("id", id).eq("campaign_id", campaignId).maybeSingle();
      prevImage = (prev?.image_path as string | null) ?? null;
    }
    const q = id
      ? supabase
          .from("npcs")
          .update({ ...base, ...(c.pv_current != null ? { pv_current: Math.min(c.pv_current, c.pv_max ?? c.pv_current) } : {}), ...(c.pc_current != null ? { pc_current: Math.min(c.pc_current, c.pc_max ?? c.pc_current) } : {}) })
          .eq("id", id)
          .eq("campaign_id", campaignId)
          .select(NPC_COLUMNS)
      : supabase
          .from("npcs")
          .insert({ ...base, campaign_id: campaignId, pv_current: c.pv_current ?? c.pv_max, pc_current: c.pc_current ?? c.pc_max, conditions: (c.conditions ?? []).map((x) => ({ id: randomUUID(), name: x.name, turns: x.turns })) })
          .select(NPC_COLUMNS);
    const { data, error } = await q;
    if (error || !data?.length) return fail(msg(error, "Não foi possível salvar o NPC."));
    if (prevImage && prevImage !== d.image_path && prevImage.startsWith(`npcs/${campaignId}/`)) await removeMedia(supabase, prevImage);
    return { ok: true, data: data[0] as NpcRow, message: id ? "NPC salvo." : `${d.kind === "monstro" ? "Monstro" : "NPC"} criado.` };
  });
}

/** Instância independente a partir de um modelo do Homebrew (o modelo não muda). */
export async function npcFromHomebrew(campaignId: string, homebrewId: string): Promise<ActionResult<NpcRow>> {
  return run(async () => {
    if (!uuid.safeParse(homebrewId).success) return fail("Modelo inválido.");
    const { supabase, user } = await master(campaignId);
    const { data: hb } = await supabase.from("homebrew").select("id, kind, name, description, data, image_path").eq("id", homebrewId).eq("owner_id", user.id).maybeSingle();
    if (!hb || !["npc", "monstro"].includes(hb.kind as string)) return fail("Modelo de NPC/monstro não encontrado.");
    const raw = (hb.data ?? {}) as Record<string, unknown>;
    const c = normalizeCreature(raw);
    const { data, error } = await supabase
      .from("npcs")
      .insert({
        campaign_id: campaignId,
        source_homebrew_id: hb.id,
        kind: hb.kind,
        name: hb.name,
        image_path: hb.image_path ?? null,
        data: { ...raw, ...c, description: hb.description ?? "" },
        pv_max: c.pv_max,
        pv_current: c.pv_current ?? c.pv_max,
        pc_max: c.pc_max,
        pc_current: c.pc_current ?? c.pc_max,
        conditions: c.conditions.map((x) => ({ id: randomUUID(), name: x.name, turns: x.turns })),
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
const COMBATANT_COLUMNS = "id, combat_id, character_id, npc_id, kind, form_id, name, initiative, sort_order, pv_current, pv_max, pc_current, pc_max, conditions, hidden, hide_stats, notes, data, image_path, homebrew_id";

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

/** Snapshot da ficha da criatura para a instância de combate (independente do modelo). */
function creatureSnapshot(raw: Record<string, unknown>, description: string) {
  const c = normalizeCreature(raw);
  return {
    sheet: c,
    data: {
      description: description.slice(0, 4000),
      attributes: c.attributes,
      skills: c.skills,
      defense: c.defense,
      resistances: c.resistances,
      vulnerabilities: c.vulnerabilities,
      immunities: c.immunities,
      movement: c.movement,
      attacks: c.attacks,
      abilities: c.abilities,
    },
  };
}

/**
 * Adiciona participantes. Monstros/NPCs (do Homebrew ou da campanha) viram INSTÂNCIAS:
 * cada cópia tem PV, PC, condições e iniciativa próprios ("Leshy 1", "Leshy 2"…).
 */
export async function addCombatant(
  campaignId: string,
  combatId: string,
  who: { characterId?: string; npcId?: string; homebrewId?: string; name?: string; pv?: number | null; pc?: number | null },
  initiative: number | null,
  quantity = 1,
): Promise<ActionResult<CombatantRow[]>> {
  return run(async () => {
    if (!uuid.safeParse(combatId).success) return fail("Combate inválido.");
    if (initiative !== null && (!Number.isInteger(initiative) || Math.abs(initiative) > 10000)) return fail("Iniciativa inválida.");
    if (!Number.isInteger(quantity) || quantity < 1 || quantity > 20) return fail("Quantidade entre 1 e 20.");
    const { supabase, user } = await master(campaignId);
    const { data: cb } = await supabase.from("combats").select("id").eq("id", combatId).eq("campaign_id", campaignId).maybeSingle();
    if (!cb) return fail("Combate não encontrado.");
    const { count } = await supabase.from("combatants").select("id", { count: "exact", head: true }).eq("combat_id", combatId);
    let rows: Record<string, unknown>[] = [];
    if (who.characterId && uuid.safeParse(who.characterId).success) {
      const { data: ch } = await supabase.from("characters").select("name").eq("id", who.characterId).maybeSingle();
      if (!ch) return fail("Personagem não encontrado (precisa estar aceito na campanha).");
      rows = [{ character_id: who.characterId, name: ch.name }];
    } else if ((who.npcId && uuid.safeParse(who.npcId).success) || (who.homebrewId && uuid.safeParse(who.homebrewId).success)) {
      let base: { name: string; kind: string; pv_max: number | null; pc_max: number | null; pv_current: number | null; pc_current: number | null; image_path: string | null; data: Record<string, unknown>; conditions: unknown[] };
      let link: Record<string, unknown>;
      if (who.npcId) {
        const { data: n } = await supabase.from("npcs").select("id, kind, name, data, pv_max, pv_current, pc_max, pc_current, image_path, conditions").eq("id", who.npcId).eq("campaign_id", campaignId).maybeSingle();
        if (!n) return fail("NPC não encontrado.");
        const snap = creatureSnapshot((n.data ?? {}) as Record<string, unknown>, String((n.data as Record<string, unknown>)?.description ?? ""));
        base = { name: n.name as string, kind: n.kind as string, pv_max: n.pv_max as number | null, pc_max: n.pc_max as number | null, pv_current: n.pv_current as number | null, pc_current: n.pc_current as number | null, image_path: (n.image_path as string | null) ?? null, data: snap.data, conditions: (n.conditions as unknown[]) ?? [] };
        link = { npc_id: n.id };
      } else {
        const { data: hb } = await supabase.from("homebrew").select("id, kind, name, description, data, image_path").eq("id", who.homebrewId!).eq("owner_id", user.id).maybeSingle();
        if (!hb || !["monstro", "npc"].includes(hb.kind as string)) return fail("Monstro do Homebrew não encontrado.");
        const snap = creatureSnapshot((hb.data ?? {}) as Record<string, unknown>, (hb.description as string) ?? "");
        base = {
          name: hb.name as string,
          kind: hb.kind as string,
          pv_max: snap.sheet.pv_max,
          pc_max: snap.sheet.pc_max,
          pv_current: snap.sheet.pv_current ?? snap.sheet.pv_max,
          pc_current: snap.sheet.pc_current ?? snap.sheet.pc_max,
          image_path: (hb.image_path as string | null) ?? null,
          data: snap.data,
          conditions: snap.sheet.conditions.map((x) => ({ id: randomUUID(), name: x.name, turns: x.turns })),
        };
        link = { homebrew_id: hb.id };
      }
      // Numeração continua a partir das cópias que já estão no combate.
      const sameQ = supabase.from("combatants").select("id", { count: "exact", head: true }).eq("combat_id", combatId);
      const same = await (who.npcId ? sameQ.eq("npc_id", who.npcId) : sameQ.eq("homebrew_id", who.homebrewId!));
      const already = same.count ?? 0;
      const numbered = quantity > 1 || already > 0 || Boolean(who.homebrewId);
      for (let k = 0; k < quantity; k++) {
        rows.push({
          ...link,
          kind: base.kind,
          name: numbered ? `${base.name} ${already + k + 1}`.slice(0, 120) : base.name,
          pv_max: base.pv_max,
          pv_current: base.pv_current ?? base.pv_max,
          pc_max: base.pc_max,
          pc_current: base.pc_current ?? base.pc_max,
          image_path: base.image_path,
          data: base.data,
          conditions: (base.conditions as { id: string }[]).map((x) => ({ ...x, id: randomUUID() })),
        });
      }
    } else {
      const name = (who.name ?? "").trim();
      if (!name || name.length > 120) return fail("Dê um nome ao participante.");
      rows = [{ kind: "other", name, pv_max: who.pv ?? null, pv_current: who.pv ?? null, pc_max: who.pc ?? null, pc_current: who.pc ?? null }];
    }
    const { data, error } = await supabase
      .from("combatants")
      .insert(rows.map((r, i) => ({ ...r, combat_id: combatId, initiative, sort_order: (count ?? 0) + i })))
      .select(COMBATANT_COLUMNS);
    if (error || !data?.length) return fail(msg(error, "Não foi possível adicionar."));
    return { ok: true, data: data as CombatantRow[], message: rows.length > 1 ? `${rows.length} participantes adicionados.` : undefined };
  });
}

/** Ficha da instância (snapshot); combatentes antigos (Fase 4) usam a ficha do NPC. */
async function combatantSheet(supabase: Awaited<ReturnType<typeof master>>["supabase"], c: { data: Record<string, unknown> | null; npc_id: string | null }) {
  let sheet = normalizeCreature(c.data ?? {});
  if (sheet.attacks.length === 0 && sheet.abilities.length === 0 && c.npc_id) {
    const { data: n } = await supabase.from("npcs").select("data").eq("id", c.npc_id).maybeSingle();
    if (n) sheet = normalizeCreature(n.data ?? {});
  }
  return sheet;
}

/** Ataque de uma instância (monstro/NPC) direto do Escudo: d100 + dano rolados no servidor. Aplicar no alvo é um passo à parte. */
export async function combatantAttack(campaignId: string, combatantId: string, attackId: string, publicLog = false) {
  return run(async () => {
    if (!uuid.safeParse(combatantId).success || typeof attackId !== "string" || attackId.length > 40) return fail("Dados inválidos.");
    const { supabase, user } = await master(campaignId);
    const { data: c } = await supabase.from("combatants").select("id, combat_id, name, npc_id, data, hidden").eq("id", combatantId).maybeSingle();
    if (!c) return fail("Participante não encontrado.");
    const sheet = await combatantSheet(supabase, c as { data: Record<string, unknown>; npc_id: string | null });
    const atk = sheet.attacks.find((a) => a.id === attackId);
    if (!atk) return fail("Ataque não encontrado.");
    const r = rollCreatureAttack(sheet, atk);
    const result = {
      kind: "attack",
      weapon: atk.name,
      skillName: c.name,
      natural: r.test.natural,
      rolls: r.test.rolls,
      effective: r.test.effective,
      rollModifier: r.test.rollModifier,
      thresholds: r.test.thresholds,
      outcome: r.test.outcome,
      outcomeLabel: r.outcomeLabel,
      hit: r.hit,
      damage: r.damage ? { expression: r.damage.expression, rolls: r.damage.terms.flatMap((t) => t.rolls), total: r.damage.total } : null,
      multiplier: r.multiplier,
      finalDamage: r.finalDamage,
      applied: [],
      conditions: r.conditions.map((x) => `${x.name}${x.turns ? ` (${x.turns} turnos)` : ""}`),
      note: r.test.outcome === "critical_failure" ? "Falha crítica: o Mestre decide a consequência." : null,
    };
    const visible = publicLog && !c.hidden;
    await supabase
      .from("roll_log")
      .insert({ user_id: user.id, campaign_id: campaignId, label: `${c.name}: ${atk.name}`, expression: `1d100 + ${atk.damage}`, result, visibility: visible ? "public" : "self" });
    await supabase.rpc("combat_note", {
      p_combat: c.combat_id,
      p_kind: "ataque",
      p_message: `${c.name} — ${atk.name}: ${r.test.natural} contra ${r.value} (${r.outcomeLabel})${r.hit ? `, ${r.finalDamage} de dano` : ", sem dano"}.`,
      p_data: {},
      p_public: visible,
      p_request: null,
    });
    return {
      ok: true as const,
      data: { attack: atk.name, value: r.value, natural: r.test.natural, outcomeLabel: r.outcomeLabel, hit: r.hit, damage: result.damage, multiplier: r.multiplier, finalDamage: r.finalDamage, conditions: r.conditions },
    };
  });
}

/** Habilidade de uma instância: cobra o PC (recusa se faltar), rola dano/cura e devolve a condição para aplicar. */
export async function combatantAbility(campaignId: string, combatantId: string, abilityId: string, requestId: string, publicLog = false) {
  return run(async () => {
    if (!uuid.safeParse(combatantId).success || !uuid.safeParse(requestId).success || typeof abilityId !== "string" || abilityId.length > 40) return fail("Dados inválidos.");
    const { supabase, user } = await master(campaignId);
    const { data: c } = await supabase.from("combatants").select("id, combat_id, name, npc_id, data, hidden, character_id").eq("id", combatantId).maybeSingle();
    if (!c || c.character_id) return fail("Participante não encontrado.");
    const sheet = await combatantSheet(supabase, c as { data: Record<string, unknown>; npc_id: string | null });
    const ab = sheet.abilities.find((a) => a.id === abilityId);
    if (!ab) return fail("Habilidade não encontrada.");
    if (ab.pc_cost) {
      const { error } = await supabase.rpc("combatant_spend_pc", { p_combatant: combatantId, p_amount: ab.pc_cost, p_request: requestId, p_note: ab.name });
      if (error) return fail(msg(error, "Não foi possível pagar o custo."));
    }
    const r = rollCreatureAbility(sheet, ab);
    const parts = [
      r.test ? `${r.test.natural} (${r.outcomeLabel})` : "",
      r.damage ? `${r.damage.total} de dano` : "",
      r.heal ? `${r.heal.total} de cura` : "",
      r.condition ? `condição ${r.condition.name}` : "",
      ab.pc_cost ? `−${ab.pc_cost} PC` : "",
      r.manual ? "efeito manual" : "",
    ].filter(Boolean);
    const visible = publicLog && !c.hidden;
    const detail = (x: typeof r.damage) => (x ? { expression: x.expression, rolls: x.terms.flatMap((t) => t.rolls), total: x.total } : null);
    await supabase.from("roll_log").insert({
      user_id: user.id,
      campaign_id: campaignId,
      label: `${c.name}: ${ab.name}`,
      expression: [ab.damage, ab.heal].filter(Boolean).join(" / ") || "—",
      result: {
        kind: "power",
        power: ab.name,
        cost: ab.pc_cost ?? 0,
        pcAfter: 0,
        effects: [r.damage && { ...detail(r.damage), label: "Dano", effect: "dano" }, r.heal && { ...detail(r.heal), label: "Cura", effect: "cura" }].filter(Boolean),
        notes: [ab.description, ab.special, r.condition && `Condição: ${r.condition.name}`].filter(Boolean),
        continuous: null,
      },
      visibility: visible ? "public" : "self",
    });
    await supabase.rpc("combat_note", { p_combat: c.combat_id, p_kind: "poder", p_message: `${c.name} usa ${ab.name}${parts.length ? `: ${parts.join(", ")}` : ""}.`, p_data: {}, p_public: visible, p_request: null });
    return {
      ok: true as const,
      data: { ability: ab.name, success: r.success, outcomeLabel: r.outcomeLabel, natural: r.test?.natural ?? null, damage: detail(r.damage), heal: detail(r.heal), condition: r.condition, manual: r.manual, pcCost: ab.pc_cost ?? 0, text: [ab.description, ab.special].filter(Boolean).join("\n") },
    };
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
    const [cb, list, log, conf] = await Promise.all([
      supabase.from("combats").select(COMBAT_COLUMNS).eq("id", combatId).maybeSingle(),
      supabase.from("combatants").select(COMBATANT_COLUMNS).eq("combat_id", combatId),
      supabase.from("combat_log").select("id, combat_id, round, turn_index, kind, message, public, created_at").eq("combat_id", combatId).order("id", { ascending: false }).limit(150),
      supabase.from("combat_confrontations").select("*").eq("combat_id", combatId).order("created_at", { ascending: false }).limit(30),
    ]);
    if (!cb.data) return fail("Combate não encontrado.");
    return {
      ok: true,
      data: {
        combat: cb.data as CombatRow,
        combatants: (list.data ?? []) as CombatantRow[],
        log: log.data ?? [],
        confrontations: ((conf.data ?? []) as Record<string, unknown>[]).map(confrontFromRow),
      },
    };
  });
}

// ===================================================================== Confrontos (rolagens opostas — Fase 6)

export type ConfrontAttack =
  | { kind: "creature"; attackId: string }
  | { kind: "weapon"; itemId: string }
  | { kind: "free"; label: string; skill: string; damage: string; attackKind: "melee" | "ranged" | "firearm" };

/**
 * Confronto entre dois participantes: atacante e defensor rolam 1d100 NO BANCO, vence o maior.
 * O Mestre conduz qualquer confronto (criatura × agente, agente × criatura, PvP, NPC × NPC).
 */
export async function combatConfront(
  campaignId: string,
  combatId: string,
  attackerId: string,
  defenderId: string,
  attack: ConfrontAttack,
  reaction: string | null,
  apply = true,
  publicLog = true,
): Promise<ActionResult<ConfrontPayload>> {
  return run(async () => {
    if (![combatId, attackerId, defenderId].every((x) => uuid.safeParse(x).success)) return fail("Dados inválidos.");
    if (reaction && !SKILL_BY_ID[reaction]) return fail("Reação inválida.");
    const { supabase } = await master(campaignId);
    const { data: att } = await supabase.from("combatants").select("id, combat_id, name, npc_id, data, character_id, form_id").eq("id", attackerId).eq("combat_id", combatId).maybeSingle();
    if (!att) return fail("Atacante não encontrado.");
    let p: Record<string, unknown>;
    if (attack.kind === "creature") {
      const sheet = await combatantSheet(supabase, att as { data: Record<string, unknown>; npc_id: string | null });
      const a = sheet.attacks.find((x) => x.id === attack.attackId);
      if (!a) return fail("Ataque não encontrado.");
      const [k, ...rest] = (a.uses ?? "valor").split(":");
      const sk = rest.join(":");
      const official = k === "skill" && SKILL_BY_ID[sk];
      p = {
        label: a.name,
        skill: official ? sk : null,
        value: official ? null : testValue(sheet, a.uses, a.value),
        damage: a.damage,
        attack_kind: /\d/.test(a.range ?? "") && !/corpo/i.test(a.range ?? "") ? "ranged" : "melee",
        conditions: (a.conditions ?? []).map((c) => ({ name: c.name, turns: c.turns, automatic: true })),
      };
    } else if (attack.kind === "weapon") {
      if (!att.character_id || !uuid.safeParse(attack.itemId).success) return fail("Arma inválida.");
      const b = await loadCharacter(att.character_id as string);
      const form = [b.base, b.lenda].find((f) => f?.id === att.form_id) ?? b.base;
      const item = b.items.find((i) => i.id === attack.itemId);
      if (!item?.attack_kind || !item.effect_dice) return fail("Esta arma não está na ficha do agente.");
      const sheet = buildSheet({ classId: b.character.class_id, originId: b.character.origin_id, level: b.character.level, form });
      const plan = planAttack(
        { name: item.name, damage: item.effect_dice, attackKind: item.attack_kind, tags: item.tags, skillOverride: item.skill_override, modifiers: item.item_modifiers.map((m) => m.modifier_id), customModifiers: item.custom_modifiers ?? [] },
        { classId: form.kind === "base" ? b.character.class_id : null, originId: b.character.origin_id, pathId: b.character.origin_path_id, level: b.character.level, skillValues: Object.fromEntries(sheet.skills.map((s) => [s.id, s.final])) },
      );
      p = { label: item.name, skill: plan.skillId, damage: plan.damageExpr, critical: plan.criticalExpr, modifier: plan.rollModifier, factor: plan.damageFactor, attack_kind: item.attack_kind, conditions: [] };
    } else {
      const label = (attack.label ?? "").trim().slice(0, 120) || "Ataque";
      if (!SKILL_BY_ID[attack.skill] || (attack.damage && !isValidDice(attack.damage)) || !["melee", "ranged", "firearm"].includes(attack.attackKind)) return fail("Ataque livre inválido.");
      p = { label, skill: attack.skill, damage: attack.damage || null, attack_kind: attack.attackKind, conditions: [] };
    }
    const { data, error } = await supabase.rpc("combat_confront", {
      p_combat: combatId,
      p_attacker: attackerId,
      p_defender: defenderId,
      p_attack: p,
      p_reaction: reaction,
      p_request: randomUUID(),
      p_apply: apply,
      p_public: publicLog,
    });
    if (error || !data) return fail(msg(error, "Não foi possível resolver o confronto."));
    return { ok: true, data: confrontFromRow(data as Record<string, unknown>) };
  });
}

/** Confirma o dano (e as condições) de um confronto vencido — ex.: ataque feito por um jogador. Aplica uma vez só. */
export async function applyConfront(campaignId: string, confrontId: string): Promise<ActionResult<ConfrontPayload>> {
  return run(async () => {
    if (!uuid.safeParse(confrontId).success) return fail("Confronto inválido.");
    const { supabase } = await master(campaignId);
    const { data, error } = await supabase.rpc("combat_confront_apply", { p_confront: confrontId });
    if (error || !data) return fail(msg(error, "Não foi possível aplicar."));
    return { ok: true, data: confrontFromRow(data as Record<string, unknown>), message: "Dano aplicado." };
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
