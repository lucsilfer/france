"use server";

import { randomUUID } from "node:crypto";
import { z } from "zod";
import type { ActionResult } from "@/lib/types";
import type { AttackPayload, DiceDetail, EffectTickPayload, PowerPayload, RollEntry } from "@/lib/rolls";
import { CATALOG_BY_ID } from "@/rules/catalog.ts";
import { performAttack, planAttack, planPowerUse, rollPowerEffects, type WeaponLike } from "@/rules/combat.ts";
import { OUTCOME_LABEL } from "@/rules/d100.ts";
import { WEAPON_MODIFIER_BY_ID, type WeaponTag } from "@/rules/data/equipment.ts";
import { SKILL_BY_ID } from "@/rules/data/skills.ts";
import { isValidDice, type RollResult } from "@/rules/dice.ts";
import { computePowerCost, type PowerComponent } from "@/rules/powers.ts";
import { ITEM_COLUMNS, POWER_COLUMNS, type ItemModifierRow, type ItemRow, type PowerRow } from "@/lib/character";
import { abilityStatus } from "@/rules/abilities.ts";
import { dbMessage, editContext, fail, guard, int, logRoll, sheetContext, touch, uuid } from "./_shared";

function detail(r: RollResult): DiceDetail {
  return { expression: r.expression, rolls: r.terms.flatMap((t) => t.rolls), total: r.total };
}

// ===================================================================== Dinheiro

export async function saveMoney(characterId: string, value: number): Promise<ActionResult> {
  return guard(async () => {
    if (typeof value !== "number" || !Number.isFinite(value) || value < -1e9 || value > 1e9) return fail("Valor inválido.");
    const { supabase } = await editContext(characterId);
    const { data, error } = await supabase.from("characters").update({ money: Math.round(value * 100) / 100 }).eq("id", characterId).select("id");
    if (error || !data?.length) return fail("Não foi possível salvar o dinheiro.");
    return { ok: true };
  });
}

// ===================================================================== Itens

const TAGS: WeaponTag[] = ["corpo_a_corpo", "distancia", "laminas", "perfurantes_projeteis", "pesadas", "contundentes", "foices_correntes", "arma_de_fogo"];

const itemSchema = z
  .object({
    name: z.string().trim().min(1, "Dê um nome ao item.").max(120),
    description: z.string().max(5000),
    item_type: z.enum(["arma", "armadura", "equipamento", "consumivel", "outro"]),
    category: z.string().trim().max(60),
    quantity: int(0, 9999),
    range: z.string().trim().max(60),
    effect_kind: z.enum(["dano", "cura", "condicao", "utilidade", "personalizado"]).nullable(),
    effect_dice: z
      .string()
      .trim()
      .max(60)
      .nullable()
      .refine((v) => !v || isValidDice(v), "Expressão de dados inválida (ex.: 1d6, 2d8+3, 1d10+1d6)."),
    special_rules: z.string().max(5000),
    // Arma
    attack_kind: z.enum(["melee", "ranged", "firearm"]).nullable(),
    damage_type: z.enum(["cort", "cont", "perf", "bal", "var"]).nullable(),
    skill_override: z.string().nullable(),
    tags: z.array(z.enum(TAGS as [WeaponTag, ...WeaponTag[]])).max(8),
  })
  .refine((d) => d.item_type !== "arma" || (d.attack_kind && d.effect_dice), { message: "Arma precisa de tipo de ataque e expressão de dano.", path: ["effect_dice"] })
  .refine((d) => !d.skill_override || SKILL_BY_ID[d.skill_override], { message: "Perícia inválida.", path: ["skill_override"] });

export type ItemInput = z.infer<typeof itemSchema>;

function itemRow(d: ItemInput) {
  const weapon = d.item_type === "arma";
  return {
    name: d.name,
    description: d.description,
    item_type: d.item_type,
    category: d.category,
    quantity: d.quantity,
    range: d.range,
    effect_kind: d.effect_kind,
    effect_dice: d.effect_dice || null,
    special_rules: d.special_rules,
    attack_kind: weapon ? d.attack_kind : null,
    damage_type: weapon ? d.damage_type : null,
    skill_override: weapon ? d.skill_override || null : null,
    tags: weapon ? d.tags : [],
  };
}

function normalizeItem(i: ItemRow): ItemRow {
  return { ...i, tags: i.tags ?? [], item_modifiers: i.item_modifiers ?? [] };
}

export async function addCatalogItem(characterId: string, catalogId: string, quantity = 1): Promise<ActionResult<ItemRow>> {
  return guard(async () => {
    const c = CATALOG_BY_ID[catalogId];
    if (!c || !Number.isInteger(quantity) || quantity < 1 || quantity > 999) return fail("Item inválido.");
    const { supabase } = await editContext(characterId);
    const { data, error } = await supabase.from("items").insert({
      character_id: characterId,
      source_kind: "catalog",
      source_ref: c.id,
      name: c.name,
      description: [c.description, c.note].filter(Boolean).join("\n"),
      item_type: c.type,
      category: c.category,
      quantity,
      effect_kind: c.effectKind,
      effect_dice: c.effectDice,
      attack_kind: c.attackKind,
      damage_type: c.damageType,
      tier: c.tier,
      range: c.range,
      special_rules: c.effectDice ? "" : c.effectText,
      tags: c.tags,
    }).select(ITEM_COLUMNS).single();
    if (error || !data) return fail(dbMessage(error, "Não foi possível adicionar o item."));
    touch(characterId);
    return { ok: true, data: normalizeItem(data as unknown as ItemRow), message: `${c.name} adicionado ao inventário.` };
  });
}

export async function addHomebrewItem(characterId: string, homebrewId: string): Promise<ActionResult<ItemRow>> {
  return guard(async () => {
    if (!uuid.safeParse(homebrewId).success) return fail("Item inválido.");
    const { supabase, user } = await editContext(characterId);
    const { data: hb } = await supabase.from("homebrew").select("kind, name, description, data").eq("id", homebrewId).eq("owner_id", user.id).maybeSingle();
    if (!hb || !["item", "arma"].includes(hb.kind as string)) return fail("Item da biblioteca não encontrado.");
    const d = (hb.data ?? {}) as Record<string, unknown>;
    const parsed = itemSchema.safeParse({
      name: hb.name,
      description: hb.description ?? "",
      item_type: (d.item_type as string) ?? (hb.kind === "arma" ? "arma" : "equipamento"),
      category: (d.category as string) ?? "",
      quantity: 1,
      range: (d.range as string) ?? "",
      // Modelos antigos usavam "outro"; hoje é "personalizado".
      effect_kind: d.effect_kind === "outro" ? "personalizado" : (d.effect_kind as string) || null,
      effect_dice: (d.effect_dice as string) || null,
      special_rules: (d.special_rules as string) ?? "",
      attack_kind: (d.attack_kind as string) || (hb.kind === "arma" ? "melee" : null),
      damage_type: (d.damage_type as string) || null,
      skill_override: (d.skill_override as string) || null,
      tags: Array.isArray(d.tags) ? d.tags : [],
    });
    if (!parsed.success) return fail(`Este modelo está incompleto: ${parsed.error.issues[0]?.message}`);
    // Cópia independente: editar na ficha não altera o modelo da biblioteca.
    const { data, error } = await supabase
      .from("items")
      .insert({ ...itemRow(parsed.data), character_id: characterId, source_kind: "homebrew", source_ref: homebrewId })
      .select(ITEM_COLUMNS)
      .single();
    if (error || !data) return fail(dbMessage(error, "Não foi possível adicionar o item."));
    touch(characterId);
    return { ok: true, data: normalizeItem(data as unknown as ItemRow), message: `${hb.name} adicionado (cópia da biblioteca).` };
  });
}

/** Cria item personalizado: vai para a ficha E para a biblioteca Homebrew. */
export async function createCustomItem(characterId: string, input: ItemInput): Promise<ActionResult<{ item: ItemRow; homebrew: { id: string; kind: "item" | "arma"; name: string; description: string; data: Record<string, unknown> } }>> {
  return guard(async () => {
    const parsed = itemSchema.safeParse(input);
    if (!parsed.success) return fail(parsed.error.issues[0]?.message ?? "Revise os campos.");
    const { supabase, user } = await editContext(characterId);
    const row = itemRow(parsed.data);
    const { data: hb, error: hbErr } = await supabase
      .from("homebrew")
      .insert({
        owner_id: user.id,
        kind: row.item_type === "arma" ? "arma" : "item",
        name: row.name,
        description: row.description,
        data: { ...row, name: undefined, description: undefined },
      })
      .select("id")
      .single();
    if (hbErr || !hb) return fail("Não foi possível salvar na biblioteca Homebrew.");
    const { data, error } = await supabase
      .from("items")
      .insert({ ...row, character_id: characterId, source_kind: "homebrew", source_ref: hb.id })
      .select(ITEM_COLUMNS)
      .single();
    if (error || !data) return fail(dbMessage(error, "Não foi possível adicionar o item."));
    touch(characterId);
    const kind = row.item_type === "arma" ? "arma" : "item";
    return {
      ok: true,
      data: { item: normalizeItem(data as unknown as ItemRow), homebrew: { id: hb.id as string, kind, name: row.name, description: row.description, data: { ...row } } },
      message: "Item criado, adicionado à ficha e salvo na sua biblioteca.",
    };
  });
}

export async function updateItem(characterId: string, itemId: string, input: ItemInput): Promise<ActionResult<ItemRow>> {
  return guard(async () => {
    if (!uuid.safeParse(itemId).success) return fail("Item inválido.");
    const parsed = itemSchema.safeParse(input);
    if (!parsed.success) return fail(parsed.error.issues[0]?.message ?? "Revise os campos.");
    const { supabase } = await editContext(characterId);
    const { data, error } = await supabase.from("items").update(itemRow(parsed.data)).eq("id", itemId).eq("character_id", characterId).select("id");
    if (error || !data?.length) return fail(dbMessage(error, "Não foi possível salvar o item."));
    // Modificadores que ficaram incompatíveis com as novas categorias são removidos.
    const { data: mods } = await supabase.from("item_modifiers").select("id, modifier_id").eq("item_id", itemId);
    const bad = (mods ?? []).filter((m) => !parsed.data.tags.includes(WEAPON_MODIFIER_BY_ID[m.modifier_id as string]?.requires));
    if (bad.length) await supabase.from("item_modifiers").delete().in("id", bad.map((m) => m.id));
    const { data: fresh } = await supabase.from("items").select(ITEM_COLUMNS).eq("id", itemId).single();
    touch(characterId);
    return {
      ok: true,
      data: fresh ? normalizeItem(fresh as unknown as ItemRow) : undefined,
      message: bad.length ? "Item salvo. Modificadores incompatíveis foram removidos." : "Item salvo.",
    };
  });
}

export async function removeItem(characterId: string, itemId: string): Promise<ActionResult> {
  return guard(async () => {
    if (!uuid.safeParse(itemId).success) return fail("Item inválido.");
    const { supabase } = await editContext(characterId);
    const { data, error } = await supabase.from("items").delete().eq("id", itemId).eq("character_id", characterId).select("id");
    if (error || !data?.length) return fail("Não foi possível remover.");
    touch(characterId);
    return { ok: true, message: "Item removido." };
  });
}

export async function setQuickAccess(characterId: string, kind: "item" | "power", id: string, value: boolean): Promise<ActionResult> {
  return guard(async () => {
    if (!uuid.safeParse(id).success || typeof value !== "boolean") return fail("Dados inválidos.");
    const { supabase } = await editContext(characterId);
    const table = kind === "item" ? "items" : "powers";
    const { data, error } = await supabase.from(table).update({ quick_access: value }).eq("id", id).eq("character_id", characterId).select("id");
    if (error || !data?.length) return fail("Não foi possível atualizar o Inventário Rápido.");
    touch(characterId);
    return { ok: true };
  });
}

export async function addModifier(characterId: string, itemId: string, modifierId: string, temporary = false): Promise<ActionResult<ItemModifierRow>> {
  return guard(async () => {
    if (!uuid.safeParse(itemId).success || !WEAPON_MODIFIER_BY_ID[modifierId]) return fail("Modificador inválido.");
    const { supabase } = await editContext(characterId);
    const { data: item } = await supabase.from("items").select("attack_kind, tags").eq("id", itemId).eq("character_id", characterId).maybeSingle();
    if (!item?.attack_kind) return fail("Modificadores só podem ser aplicados a armas.");
    if (!(item.tags as string[]).includes(WEAPON_MODIFIER_BY_ID[modifierId].requires)) return fail("Modificador incompatível com esta arma.");
    const { data, error } = await supabase
      .from("item_modifiers")
      .insert({ item_id: itemId, modifier_id: modifierId, is_temporary: temporary })
      .select("id, modifier_id, is_temporary")
      .single();
    if (error || !data) return fail(error?.code === "23505" ? "Este modificador já está na arma." : dbMessage(error, "Não foi possível adicionar o modificador."));
    touch(characterId);
    return { ok: true, data: data as ItemModifierRow, message: `${WEAPON_MODIFIER_BY_ID[modifierId].name} adicionado.` };
  });
}

export async function removeModifier(characterId: string, itemModifierId: string): Promise<ActionResult> {
  return guard(async () => {
    if (!uuid.safeParse(itemModifierId).success) return fail("Modificador inválido.");
    const { supabase } = await editContext(characterId);
    const { data, error } = await supabase.from("item_modifiers").delete().eq("id", itemModifierId).select("id");
    if (error || !data?.length) return fail("Não foi possível remover o modificador.");
    touch(characterId);
    return { ok: true, message: "Modificador removido." };
  });
}

// ===================================================================== Ataques

export async function attackWithItem(characterId: string, itemId: string, options: string[], formId?: string | null): Promise<ActionResult<RollEntry>> {
  return guard(async () => {
    if (!uuid.safeParse(itemId).success || !Array.isArray(options) || options.length > 20 || options.some((o) => typeof o !== "string")) return fail("Dados inválidos.");
    const { bundle, form, sheet } = await sheetContext(characterId, formId);
    const item = bundle.items.find((i) => i.id === itemId);
    if (!item || !item.attack_kind || !item.effect_dice) return fail("Este item não é uma arma.");
    const c = bundle.character;
    const weapon: WeaponLike = {
      name: item.name,
      damage: item.effect_dice,
      attackKind: item.attack_kind,
      tags: item.tags,
      skillOverride: item.skill_override,
      modifiers: item.item_modifiers.map((m) => m.modifier_id),
    };
    const skillValues = Object.fromEntries(sheet.skills.map((s) => [s.id, s.final]));
    const plan = planAttack(weapon, { classId: form.kind === "base" ? c.class_id : null, originId: c.origin_id, pathId: c.origin_path_id, level: c.level, skillValues, options });
    const out = performAttack(plan);
    const payload: AttackPayload = {
      kind: "attack",
      weapon: item.name,
      skillName: SKILL_BY_ID[plan.skillId]?.name ?? plan.skillId,
      natural: out.test.natural,
      rolls: out.test.rolls,
      effective: out.test.effective,
      rollModifier: out.test.rollModifier,
      thresholds: out.test.thresholds,
      outcome: out.test.outcome,
      outcomeLabel: OUTCOME_LABEL[out.test.outcome],
      hit: out.hit,
      damage: out.damageRoll ? detail(out.damageRoll) : null,
      multiplier: out.multiplier,
      finalDamage: out.finalDamage,
      applied: plan.applied,
      conditions: plan.conditions,
      note: out.note,
    };
    const prefix = form.kind === "lenda" ? `[${form.name || "Lenda"}] ` : "";
    const entry = await logRoll(characterId, `${prefix}Ataque: ${item.name}`, `1d100 + ${plan.damageExpr}`, payload);
    return { ok: true, data: entry };
  });
}

// ===================================================================== Poderes

const componentSchema: z.ZodType<PowerComponent> = z.union([
  z.object({ type: z.literal("damage"), tier: int(0, 4), extraDice: int(0, 20), area: z.enum(["alvo", "pequena", "media", "grande", "enorme"]) }),
  z.object({ type: z.literal("heal"), tier: int(0, 4), extraDice: int(0, 20), area: z.enum(["alvo", "pequena", "media", "grande", "enorme"]) }),
  z.object({ type: z.literal("heal_continuous"), tier: int(0, 4) }),
  z.object({ type: z.literal("shield"), tier: int(0, 4), extraDice: int(0, 20), duration: z.string().max(10) }),
  z.object({ type: z.literal("condition"), intensity: z.string().max(20) }),
  z.object({ type: z.literal("buff"), buff: z.string().max(20) }),
]) as z.ZodType<PowerComponent>;

const powerSchema = z.object({
  name: z.string().trim().min(1, "Dê um nome ao poder.").max(120),
  description: z.string().max(5000),
  ability_type: z.string().trim().max(60),
  target: z.string().trim().max(120),
  range: z.string().trim().max(60),
  duration: z.string().trim().max(60),
  // Mínimo de efeitos é decidido pelo motor (Prodígio pode registrar técnica só de texto).
  components: z.array(componentSchema).max(10, "Efeitos demais."),
});
export type PowerInput = z.infer<typeof powerSchema>;

/** Salva o poder. O motor valida aqui; o banco recalcula o custo e valida de novo. */
export async function savePower(characterId: string, input: PowerInput, powerId?: string | null): Promise<ActionResult<PowerRow>> {
  return guard(async () => {
    const parsed = powerSchema.safeParse(input);
    if (!parsed.success) return fail(parsed.error.issues[0]?.message ?? "Revise os campos.");
    if (powerId && !uuid.safeParse(powerId).success) return fail("Poder inválido.");
    const { bundle, supabase } = await sheetContext(characterId);
    const c = bundle.character;
    const cost = computePowerCost(parsed.data.components, c.level, c.origin_id);
    if (!cost.valid) return fail(cost.errors[0]);
    if (!powerId) {
      // Vagas de habilidades (o banco confere de novo no trigger).
      const st = abilityStatus({ level: c.level, originId: c.origin_id, pathId: c.origin_path_id, created: bundle.powers.length });
      if (!st.canCreate) return fail(`Sem habilidades disponíveis: ${st.created} de ${st.granted} já criadas no nível ${c.level}.`);
    }
    const effectDice = cost.components.map((x) => x.dice).filter(Boolean).join(" + ") || null;
    const row = { ...parsed.data, initial_cost: cost.initial, per_turn_cost: cost.perTurn, effect_dice: effectDice };
    const q = powerId
      ? supabase.from("powers").update(row).eq("id", powerId).eq("character_id", characterId).select(POWER_COLUMNS)
      : supabase.from("powers").insert({ ...row, character_id: characterId }).select(POWER_COLUMNS);
    const { data, error } = await q;
    if (error || !data?.length) return fail(dbMessage(error, "Não foi possível salvar o poder."));
    touch(characterId);
    const costText = c.origin_id === "prodigio" ? "sem custo de PC" : `${cost.initial} PC${cost.perTurn ? ` + ${cost.perTurn} PC/turno` : ""}`;
    return { ok: true, data: data[0] as unknown as PowerRow, message: powerId ? "Salvo." : `Criado: ${costText}.` };
  });
}

export async function deletePower(characterId: string, powerId: string): Promise<ActionResult> {
  return guard(async () => {
    if (!uuid.safeParse(powerId).success) return fail("Poder inválido.");
    const { supabase } = await editContext(characterId);
    const { data, error } = await supabase.from("powers").delete().eq("id", powerId).eq("character_id", characterId).select("id");
    if (error || !data?.length) return fail("Não foi possível excluir.");
    touch(characterId);
    return { ok: true, message: "Poder excluído." };
  });
}

/**
 * Usa o poder: confere e desconta PC no banco (uma vez por requestId), rola SÓ os dados de efeito
 * (sem teste de acerto) e registra o resultado.
 */
export async function usePower(
  characterId: string,
  powerId: string,
  requestId: string,
  opts: { turns?: number; options?: string[]; formId?: string | null } = {},
): Promise<ActionResult<RollEntry>> {
  return guard(async () => {
    if (!uuid.safeParse(powerId).success || !uuid.safeParse(requestId).success) return fail("Dados inválidos.");
    const turns = opts.turns ?? 0;
    if (!Number.isInteger(turns) || turns < 0 || turns > 100) return fail("Duração inválida.");
    const { bundle, form, supabase } = await sheetContext(characterId, opts.formId);
    const power = bundle.powers.find((p) => p.id === powerId);
    if (!power) return fail("Poder não encontrado.");
    const { data, error } = await supabase.rpc("use_power", { p_power: powerId, p_form: form.id, p_request: requestId, p_turns: turns });
    if (error || !data) return fail(dbMessage(error, "Não foi possível usar o poder."));
    const r = data as { pc_current: number; effect_id: string | null; duplicate: boolean; cost: number };
    const c = bundle.character;
    const plan = planPowerUse(power.components, { classId: form.kind === "base" ? c.class_id : null, originId: c.origin_id, options: opts.options });
    // Cura contínua rola a cada turno de manutenção, não na ativação.
    const rolled = rollPowerEffects({ ...plan, effects: plan.effects.filter((e) => e.kind !== "cura_continua") });
    const payload: PowerPayload = {
      kind: "power",
      power: power.name,
      cost: r.cost,
      pcAfter: r.pc_current,
      effects: rolled.map((e) => ({ ...detail(e.roll), label: e.label, effect: e.kind })),
      notes: plan.notes,
      continuous: r.effect_id ? { effectId: r.effect_id, perTurn: power.per_turn_cost, turns } : null,
    };
    touch(characterId);
    if (r.duplicate) return fail("Este uso já foi registrado.");
    const entry = await logRoll(characterId, `Poder: ${power.name}`, payload.effects.map((e) => e.expression).join(" + ") || "—", payload);
    return { ok: true, data: entry };
  });
}

/** Paga mais um turno de um efeito contínuo (uma vez por requestId). */
export async function advanceEffect(characterId: string, effectId: string, requestId: string): Promise<ActionResult<RollEntry>> {
  return guard(async () => {
    if (!uuid.safeParse(effectId).success || !uuid.safeParse(requestId).success) return fail("Dados inválidos.");
    const { bundle, supabase } = await sheetContext(characterId, null, { edit: true, active: true });
    const eff = bundle.effects.find((e) => e.id === effectId);
    if (!eff) return fail("Efeito não encontrado ou já encerrado.");
    const { data, error } = await supabase.rpc("advance_effect", { p_effect: effectId, p_request: requestId });
    if (error || !data) return fail(dbMessage(error, "Não foi possível manter o efeito."));
    const r = data as { pc_current: number; turns_paid: number; turns_total: number; active: boolean; duplicate: boolean };
    if (r.duplicate) return fail("Este turno já foi cobrado.");
    const power = bundle.powers.find((p) => p.id === eff.power_id);
    const c = bundle.character;
    const ticks = power ? planPowerUse(power.components, { classId: c.class_id, originId: c.origin_id }).effects.filter((e) => e.kind === "cura_continua") : [];
    const rolled = rollPowerEffects({ effects: ticks, notes: [] });
    const payload: EffectTickPayload = {
      kind: "effect",
      label: eff.label,
      cost: eff.per_turn_cost,
      pcAfter: r.pc_current,
      turnsPaid: r.turns_paid,
      turnsTotal: r.turns_total,
      active: r.active,
      effects: rolled.map((e) => ({ ...detail(e.roll), label: e.label, effect: e.kind })),
    };
    touch(characterId);
    const entry = await logRoll(characterId, `Turno: ${eff.label}`, payload.effects.map((e) => e.expression).join(" + ") || "—", payload);
    return { ok: true, data: entry };
  });
}

export async function endEffect(characterId: string, effectId: string): Promise<ActionResult> {
  return guard(async () => {
    if (!uuid.safeParse(effectId).success) return fail("Efeito inválido.");
    const { supabase } = await editContext(characterId);
    const { error } = await supabase.rpc("end_effect", { p_effect: effectId });
    if (error) return fail(dbMessage(error, "Não foi possível encerrar."));
    touch(characterId);
    return { ok: true, message: "Efeito encerrado. Os custos por turno pararam." };
  });
}

/** Gera um identificador de requisição no servidor (para clientes sem crypto.randomUUID). */
export async function newRequestId(): Promise<string> {
  return randomUUID();
}
