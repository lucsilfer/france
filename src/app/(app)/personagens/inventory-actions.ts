"use server";

import { randomUUID } from "node:crypto";
import { z } from "zod";
import type { ActionResult } from "@/lib/types";
import { confrontFromRow, type AttackPayload, type DiceDetail, type EffectTickPayload, type PowerPayload, type RollEntry } from "@/lib/rolls";
import { CATALOG_BY_ID } from "@/rules/catalog.ts";
import { customModifierCompatible, modifierSlotsUsed, performAttack, planAttack, planPowerUse, rollPowerEffects, type CustomModifier, type WeaponLike } from "@/rules/combat.ts";
import { RULES_CONFIG } from "@/rules/config.ts";
import { customModifierData, defaultData, inventoryRowFrom, toCustomModifier, type ModifierData } from "@/lib/homebrew";
import type { HomebrewKind } from "@/lib/types";
import { OUTCOME_LABEL } from "@/rules/d100.ts";
import { WEAPON_MODIFIER_BY_ID, type WeaponTag } from "@/rules/data/equipment.ts";
import { SKILL_BY_ID } from "@/rules/data/skills.ts";
import { isValidDice, rollExpression, type RollResult } from "@/rules/dice.ts";
import { computePowerCost, type PowerComponent } from "@/rules/powers.ts";
import { ITEM_COLUMNS, POWER_COLUMNS, type ItemModifierRow, type ItemRow, type PowerRow } from "@/lib/character";
import { abilityStatus } from "@/rules/abilities.ts";
import { techniqueAttackOptions } from "@/rules/techniques.ts";
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
  return { ...i, tags: i.tags ?? [], item_modifiers: i.item_modifiers ?? [], custom_modifiers: i.custom_modifiers ?? [] };
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
    const { supabase } = await editContext(characterId);
    // O RLS entrega o modelo se ele for seu OU estiver compartilhado com uma campanha de que você participa.
    const { data: hb } = await supabase.from("homebrew").select("id, kind, name, description, data, image_path").eq("id", homebrewId).maybeSingle();
    if (!hb || !["item", "arma", "item_especial", "outro"].includes(hb.kind as string)) return fail("Item da biblioteca não encontrado.");
    let conv: ReturnType<typeof inventoryRowFrom>;
    try {
      conv = inventoryRowFrom(hb.kind as HomebrewKind, hb.name as string, (hb.description as string) ?? "", (hb.data ?? {}) as Record<string, unknown>);
    } catch {
      return fail("Este modelo está incompleto. Abra-o no Homebrew e salve de novo.");
    }
    if (!conv) return fail("Este conteúdo não vai para o inventário.");
    // Cópia independente: editar na ficha (ou o modelo depois) não altera o outro.
    const { data, error } = await supabase
      .from("items")
      .insert({ ...conv.row, character_id: characterId, source_kind: "homebrew", source_ref: homebrewId, image_path: hb.image_path ?? null })
      .select(ITEM_COLUMNS)
      .single();
    if (error || !data) return fail(dbMessage(error, "Não foi possível adicionar o item."));
    const itemId = (data as { id: string }).id;
    for (const m of conv.officialModifiers) {
      await supabase.from("item_modifiers").insert({ item_id: itemId, modifier_id: m, is_temporary: false });
    }
    const { data: fresh } = conv.officialModifiers.length ? await supabase.from("items").select(ITEM_COLUMNS).eq("id", itemId).single() : { data };
    touch(characterId);
    return { ok: true, data: normalizeItem((fresh ?? data) as unknown as ItemRow), message: `${hb.name} adicionado (cópia da biblioteca).` };
  });
}

/** Aplica um modificador personalizado (Homebrew) a uma arma do inventário — copiado para a arma. */
export async function addCustomModifier(characterId: string, itemId: string, homebrewId: string): Promise<ActionResult<ItemRow>> {
  return guard(async () => {
    if (!uuid.safeParse(itemId).success || !uuid.safeParse(homebrewId).success) return fail("Dados inválidos.");
    const { supabase } = await editContext(characterId);
    const { data: hb } = await supabase.from("homebrew").select("id, kind, name, description, data").eq("id", homebrewId).maybeSingle();
    if (!hb || hb.kind !== "modificador") return fail("Modificador não encontrado.");
    const parsed = customModifierData.safeParse(defaultData("modificador", (hb.data ?? {}) as Record<string, unknown>));
    if (!parsed.success) return fail("Modificador incompleto.");
    const mod = toCustomModifier(hb.id as string, hb.name as string, parsed.data as ModifierData, (hb.description as string) ?? "");
    const { data: item } = await supabase.from("items").select("attack_kind, tags, custom_modifiers, item_modifiers(is_temporary)").eq("id", itemId).eq("character_id", characterId).maybeSingle();
    if (!item?.attack_kind) return fail("Modificadores só podem ser aplicados a armas.");
    if (!customModifierCompatible(mod, (item.tags as string[]) ?? [])) return fail("Modificador incompatível com esta arma.");
    const current = ((item.custom_modifiers ?? []) as CustomModifier[]).filter((m) => m.id !== mod.id);
    const official = ((item.item_modifiers ?? []) as { is_temporary: boolean }[]).filter((m) => !m.is_temporary).length;
    if (!mod.ignoreLimit && modifierSlotsUsed(official, current) >= RULES_CONFIG.maxWeaponModifiers) return fail(`Cada arma suporta até ${RULES_CONFIG.maxWeaponModifiers} modificações.`);
    const { error } = await supabase.from("items").update({ custom_modifiers: [...current, mod] }).eq("id", itemId).eq("character_id", characterId);
    if (error) return fail(dbMessage(error, "Não foi possível aplicar o modificador."));
    const { data: fresh } = await supabase.from("items").select(ITEM_COLUMNS).eq("id", itemId).single();
    touch(characterId);
    return { ok: true, data: normalizeItem(fresh as unknown as ItemRow), message: `${mod.name} aplicado.` };
  });
}

export async function removeCustomModifier(characterId: string, itemId: string, modId: string): Promise<ActionResult<ItemRow>> {
  return guard(async () => {
    if (!uuid.safeParse(itemId).success || typeof modId !== "string" || modId.length > 60) return fail("Dados inválidos.");
    const { supabase } = await editContext(characterId);
    const { data: item } = await supabase.from("items").select("custom_modifiers").eq("id", itemId).eq("character_id", characterId).maybeSingle();
    if (!item) return fail("Item não encontrado.");
    const next = ((item.custom_modifiers ?? []) as CustomModifier[]).filter((m) => m.id !== modId);
    const { error } = await supabase.from("items").update({ custom_modifiers: next }).eq("id", itemId).eq("character_id", characterId);
    if (error) return fail("Não foi possível remover.");
    const { data: fresh } = await supabase.from("items").select(ITEM_COLUMNS).eq("id", itemId).single();
    touch(characterId);
    return { ok: true, data: normalizeItem(fresh as unknown as ItemRow), message: "Modificador removido." };
  });
}

/**
 * Usa um item: consome 1 unidade (consumível) ou 1 uso (itens com usos) no banco, de forma atômica,
 * e aplica o efeito suportado (cura → recupera PV da forma usada; dano/outros → rolagem registrada).
 */
export async function useItem(characterId: string, itemId: string, formId?: string | null): Promise<ActionResult<{ entry: RollEntry | null; quantity: number; uses_left: number | null; pv?: number }>> {
  return guard(async () => {
    if (!uuid.safeParse(itemId).success) return fail("Item inválido.");
    const { bundle, form, sheet } = await sheetContext(characterId, formId);
    const item = bundle.items.find((i) => i.id === itemId);
    if (!item) return fail("Item não encontrado.");
    const { supabase } = await editContext(characterId);
    const { data: left, error } = await supabase.rpc("consume_item", { p_item: itemId });
    if (error) return fail(dbMessage(error, "Não foi possível usar o item."));
    const state = (left ?? {}) as { quantity: number; uses_left: number | null };
    let entry: RollEntry | null = null;
    let pv: number | undefined;
    if (item.effect_dice) {
      const r = rollExpression(item.effect_dice);
      const notes: string[] = [];
      if (item.effect_kind === "cura") {
        const { data: newPv, error: e2 } = await supabase.rpc("adjust_form_resource", { p_form: form.id, p_resource: "pv", p_delta: r.total, p_max: sheet.resources.pvMax });
        if (!e2 && typeof newPv === "number") {
          pv = newPv;
          notes.push(`Recuperou ${r.total} PV (agora ${newPv}/${sheet.resources.pvMax}).`);
        }
      } else if (item.effect_kind === "dano") notes.push(`${r.total} de dano — o Mestre aplica no alvo.`);
      if (item.special_rules) notes.push(item.special_rules);
      const label = item.effect_kind === "cura" ? "Cura" : item.effect_kind === "dano" ? "Dano" : "Efeito";
      const payload: PowerPayload = {
        kind: "power",
        power: item.name,
        cost: 0,
        pcAfter: form.pc_current,
        effects: [{ ...detail(r), label, effect: item.effect_kind ?? "personalizado" }],
        notes,
        continuous: null,
      };
      entry = await logRoll(characterId, `Usar: ${item.name}`, item.effect_dice, payload);
    }
    touch(characterId);
    return {
      ok: true,
      data: { entry, quantity: state.quantity, uses_left: state.uses_left ?? null, pv },
      message: entry ? undefined : `${item.name} usado.${item.special_rules ? ` ${item.special_rules.slice(0, 160)}` : ""}`,
    };
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

/** Monta o ataque da arma (modificadores, classe, origem, técnicas escolhidas) — a mesma conta do diálogo de ataque. */
async function buildAttack(characterId: string, itemId: string, options: string[], formId?: string | null) {
  if (!uuid.safeParse(itemId).success || !Array.isArray(options) || options.length > 20 || options.some((o) => typeof o !== "string")) throw new Error("Dados inválidos.");
  const { bundle, form, sheet } = await sheetContext(characterId, formId);
  const item = bundle.items.find((i) => i.id === itemId);
  if (!item || !item.attack_kind || !item.effect_dice) throw new Error("Este item não é uma arma.");
  const c = bundle.character;
  const weapon: WeaponLike = {
    name: item.name,
    damage: item.effect_dice,
    attackKind: item.attack_kind,
    tags: item.tags,
    skillOverride: item.skill_override,
    modifiers: item.item_modifiers.map((m) => m.modifier_id),
    customModifiers: item.custom_modifiers ?? [],
  };
  const skillValues = Object.fromEntries(sheet.skills.map((s) => [s.id, s.final]));
  // Técnicas do Arsenal: só as aprendidas, não suspensas e disponíveis nesta cena entram no ataque.
  const tecOptions = techniqueAttackOptions(bundle.techniques, c.level, bundle.techniqueUses, bundle.tracker);
  const chosenTec = tecOptions.filter((t) => options.includes(t.key));
  for (const t of chosenTec.filter((x) => x.consumes)) {
    const { supabase } = await editContext(characterId);
    const { error } = await supabase.rpc("use_technique", { p_character: characterId, p_technique: t.def.id, p_request: randomUUID(), p_data: { attack: item.name } });
    if (error) throw new Error(dbMessage(error, `Não foi possível usar ${t.def.name}.`));
  }
  const plan = planAttack(weapon, {
    classId: form.kind === "base" ? c.class_id : null,
    originId: c.origin_id,
    pathId: c.origin_path_id,
    level: c.level,
    skillValues,
    options,
    allowedTechniques: chosenTec.map((t) => t.def.id),
  });
  return { bundle, form, item, plan };
}

export async function attackWithItem(characterId: string, itemId: string, options: string[], formId?: string | null): Promise<ActionResult<RollEntry>> {
  return guard(async () => {
    const { form, item, plan } = await buildAttack(characterId, itemId, options, formId);
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

/** Combate em andamento em que o personagem participa + alvos visíveis (para o diálogo de ataque). */
export async function combatTargets(characterId: string): Promise<ActionResult<{ combatId: string; combatName: string; attackerId: string; targets: { id: string; name: string; kind: string }[] } | null>> {
  return guard(async () => {
    const { supabase } = await editContext(characterId);
    const { data: mine } = await supabase.from("combatants_public").select("id, combat_id").eq("character_id", characterId);
    const entries = (mine ?? []) as { id: string; combat_id: string }[];
    if (!entries.length) return { ok: true, data: null };
    const { data: active } = await supabase
      .from("combats")
      .select("id, name")
      .in("id", entries.map((e) => e.combat_id))
      .eq("status", "active")
      .order("created_at", { ascending: false })
      .limit(1);
    const cb = ((active ?? []) as { id: string; name: string }[])[0];
    if (!cb) return { ok: true, data: null };
    const row = { ...entries.find((e) => e.combat_id === cb.id)!, combats: { name: cb.name } };
    const { data: list } = await supabase.from("combatants_public").select("id, name, kind, sort_order").eq("combat_id", row.combat_id).order("sort_order");
    return {
      ok: true,
      data: { combatId: row.combat_id, combatName: row.combats.name, attackerId: row.id, targets: ((list ?? []) as { id: string; name: string; kind: string }[]).filter((t) => t.id !== row.id) },
    };
  });
}

/**
 * Ataque dentro do combate (Fase 6): ROLAGENS OPOSTAS no banco — o atacante e o alvo rolam 1d100,
 * vence o menor; a qualidade e o dano seguem a perícia de ataque. O dano fica para o Mestre confirmar.
 */
export async function attackInCombat(
  characterId: string,
  itemId: string,
  options: string[],
  targetId: string,
  reaction: string | null,
  formId?: string | null,
): Promise<ActionResult<RollEntry>> {
  return guard(async () => {
    if (!uuid.safeParse(targetId).success || (reaction && !SKILL_BY_ID[reaction])) return fail("Alvo inválido.");
    const ctx = await combatTargets(characterId);
    if (!ctx.ok || !ctx.data) return fail("Seu personagem não está num combate em andamento.");
    const { form, item, plan } = await buildAttack(characterId, itemId, options, formId);
    const { supabase } = await editContext(characterId);
    const { data, error } = await supabase.rpc("combat_confront", {
      p_combat: ctx.data.combatId,
      p_attacker: ctx.data.attackerId,
      p_defender: targetId,
      p_attack: {
        label: item.name,
        skill: plan.skillId,
        damage: plan.damageExpr,
        critical: plan.criticalExpr,
        modifier: plan.rollModifier,
        factor: plan.damageFactor,
        attack_kind: item.attack_kind,
        conditions: [],
      },
      p_reaction: reaction,
      p_request: randomUUID(),
      p_apply: false,
      p_public: true,
    });
    if (error || !data) return fail(dbMessage(error, "Não foi possível realizar o ataque."));
    const payload = confrontFromRow(data as Record<string, unknown>);
    const prefix = form.kind === "lenda" ? `[${form.name || "Lenda"}] ` : "";
    const entry = await logRoll(characterId, `${prefix}Confronto: ${item.name} → ${payload.defender}`, `1d100 × 1d100 + ${plan.damageExpr}`, payload);
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
      const st = abilityStatus({ level: c.level, originId: c.origin_id, pathId: c.origin_path_id, created: bundle.powers.length + bundle.techniques.length });
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

// ===================================================================== Granadas (Fase 6)

/**
 * Lança uma granada durante o combate: o banco desconta 1 unidade (uma vez por clique) e resolve um confronto
 * por alvo — Pontaria de quem lança × Reflexo do alvo, dados rolados no banco. Fora de combate, use `useItem`.
 */
export async function throwGrenade(
  characterId: string,
  itemId: string,
  targetIds: string[],
  requestId: string,
): Promise<ActionResult<{ entries: RollEntry[]; quantity: number; selfCondition: string | null }>> {
  return guard(async () => {
    if (!uuid.safeParse(itemId).success || !uuid.safeParse(requestId).success || !Array.isArray(targetIds) || targetIds.length > 12 || targetIds.some((t) => !uuid.safeParse(t).success))
      return fail("Dados inválidos.");
    const ctx = await combatTargets(characterId);
    if (!ctx.ok || !ctx.data) return fail("Seu personagem não está num combate em andamento.");
    const { supabase } = await editContext(characterId);
    const { data, error } = await supabase.rpc("combat_use_grenade", { p_combat: ctx.data.combatId, p_attacker: ctx.data.attackerId, p_item: itemId, p_targets: targetIds, p_request: requestId });
    if (error || !data) return fail(dbMessage(error, "Não foi possível lançar a granada."));
    const out = data as { grenade: string; quantity: number; confronts: Record<string, unknown>[]; self_condition: { name: string; turns: number } | null; duplicate?: boolean };
    const entries: RollEntry[] = [];
    if (!out.duplicate) {
      for (const row of out.confronts ?? []) {
        const payload = confrontFromRow(row);
        entries.push(await logRoll(characterId, `Granada: ${out.grenade} → ${payload.defender}`, `1d100 × 1d100 + ${payload.damage?.expression ?? "—"}`, payload));
      }
    }
    touch(characterId);
    return {
      ok: true,
      data: { entries, quantity: out.quantity, selfCondition: out.self_condition ? `${out.self_condition.name} (${out.self_condition.turns} turnos)` : null },
      message: out.self_condition ? `${out.grenade}: ${out.self_condition.name} por ${out.self_condition.turns} turnos.` : undefined,
    };
  });
}
