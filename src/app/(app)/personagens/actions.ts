"use server";

import { revalidatePath } from "next/cache";
import { redirect } from "next/navigation";
import { z } from "zod";
import { requireUser } from "@/lib/supabase/server";
import { loadCharacter } from "@/lib/character";
import type { ActionResult } from "@/lib/types";
import type { RollEntry } from "@/lib/rolls";
import { ATTRIBUTE_IDS } from "@/rules/data/attributes.ts";
import { CLASS_BY_ID } from "@/rules/data/classes.ts";
import { ORIGIN_BY_ID } from "@/rules/data/origins.ts";
import { SKILL_BY_ID, SKILLS } from "@/rules/data/skills.ts";
import { checkSkillEdit } from "@/rules/character.ts";
import { rollTest, OUTCOME_LABEL } from "@/rules/d100.ts";
import { buildSheet, checkCreation, checkLendaCreation, SHEET_LIMITS } from "@/rules/sheet.ts";
import { dbMessage, fail, guard, int, logRoll, sheetContext, touch, uuid } from "./_shared";

export type { RollEntry } from "@/lib/rolls";

/** Carrega o mínimo para uma operação de criação e checa permissões (o RLS checa de novo no banco). */
async function creationContext(characterId: string, formId?: string | null) {
  if (!uuid.safeParse(characterId).success) throw new Error("Personagem inválido.");
  const { supabase, user } = await requireUser();
  const { data: ch } = await supabase.from("characters").select("id, owner_id, status, class_id, origin_id, level").eq("id", characterId).maybeSingle();
  if (!ch) throw new Error("Personagem não encontrado.");
  if (ch.owner_id !== user.id) throw new Error("Apenas o dono pode fazer isso.");
  if (formId) {
    // Assistente da forma Lenda (Artificial já finalizado).
    if (!uuid.safeParse(formId).success) throw new Error("Forma inválida.");
    const { data: form } = await supabase.from("character_forms").select("id, kind, setup_complete").eq("id", formId).eq("character_id", characterId).maybeSingle();
    if (!form || form.kind !== "lenda") throw new Error("Ficha da Lenda não encontrada.");
    if (form.setup_complete) throw new Error("A ficha da Lenda já foi concluída.");
    return { supabase, user, ch, formId: form.id as string, kind: "lenda" as const };
  }
  if (ch.status !== "draft") throw new Error("Este personagem já foi finalizado.");
  const { data: form } = await supabase.from("character_forms").select("id").eq("character_id", characterId).eq("kind", "base").single();
  if (!form) throw new Error("Ficha sem forma base.");
  return { supabase, user, ch, formId: form.id as string, kind: "base" as const };
}

// ===================================================================== Criação

export async function createCharacter(): Promise<void> {
  const { supabase, user } = await requireUser();
  const { data: profile } = await supabase.from("profiles").select("username, display_name").eq("id", user.id).single();
  const { data, error } = await supabase
    .from("characters")
    .insert({ owner_id: user.id, player_name: profile?.display_name || profile?.username || "" })
    .select("id")
    .single();
  if (error || !data) redirect("/painel?erro=criar");
  revalidatePath("/painel");
  redirect(`/personagens/${data.id}/criar`);
}

export interface RolledSet {
  id: string;
  faces: number[];
  results: number[];
  best: number;
}

export async function rollAttributes(characterId: string, formId?: string | null): Promise<ActionResult<RolledSet>> {
  return guard(async () => {
    const { supabase, formId: fid } = await creationContext(characterId, formId);
    const { data, error } = await supabase.rpc("roll_attribute_set", { p_form: fid });
    if (error || !data) return fail(error?.message.includes("já foram definidos") ? "Todos os atributos já foram definidos." : "Falha ao rolar os dados.");
    const r = data as RolledSet;
    return { ok: true, data: { id: r.id, faces: r.faces, results: r.results, best: r.best } };
  });
}

export async function assignAttribute(characterId: string, rollId: string, attribute: string, formId?: string | null): Promise<ActionResult> {
  return guard(async () => {
    if (!uuid.safeParse(rollId).success || !(ATTRIBUTE_IDS as string[]).includes(attribute)) return fail("Dados inválidos.");
    const { supabase } = await creationContext(characterId, formId);
    const { error } = await supabase.rpc("assign_attribute_roll", { p_roll: rollId, p_attribute: attribute });
    if (error) return fail(error.message.includes("já") ? error.message.replace(/^.*?: /, "") : "Não foi possível atribuir.");
    touch(characterId);
    return { ok: true };
  });
}

export async function saveOrigin(characterId: string, originId: string, pathId: string | null): Promise<ActionResult> {
  return guard(async () => {
    const origin = ORIGIN_BY_ID[originId];
    if (!origin) return fail("Origem inválida.");
    if (pathId && !origin.paths?.some((p) => p.id === pathId)) return fail("Caminho inválido para esta origem.");
    const { supabase } = await creationContext(characterId);
    const { error } = await supabase.from("characters").update({ origin_id: originId, origin_path_id: pathId }).eq("id", characterId);
    if (error) return fail("Não foi possível salvar a origem.");
    touch(characterId);
    return { ok: true, message: pathId ? `${origin.name} — ${origin.paths!.find((p) => p.id === pathId)!.name}` : origin.name };
  });
}

export async function saveClass(characterId: string, classId: string): Promise<ActionResult> {
  return guard(async () => {
    if (!CLASS_BY_ID[classId]) return fail("Classe inválida.");
    const { supabase } = await creationContext(characterId);
    const { error } = await supabase.from("characters").update({ class_id: classId }).eq("id", characterId);
    if (error) return fail("Não foi possível salvar a classe.");
    touch(characterId);
    return { ok: true, message: CLASS_BY_ID[classId].name };
  });
}

const pointsSchema = z.record(z.string(), int(0, SHEET_LIMITS.skillPointsMax));

/**
 * Grava a distribuição durante a criação. O limite TOTAL por perícia é conferido aqui
 * (motor) e de novo no banco; a quantidade de perícias e o total de pontos são exigidos ao finalizar.
 */
export async function saveSkillPoints(characterId: string, points: Record<string, number>, formId?: string | null): Promise<ActionResult> {
  return guard(async () => {
    const parsed = pointsSchema.safeParse(points);
    if (!parsed.success) return fail("Pontos inválidos.");
    for (const id of Object.keys(parsed.data)) if (!SKILL_BY_ID[id]) return fail("Perícia desconhecida.");
    const { supabase, formId: fid, kind } = await creationContext(characterId, formId);
    const bundle = await loadCharacter(characterId);
    const form = kind === "lenda" ? bundle.lenda! : bundle.base;
    const c = bundle.character;
    const before = buildSheet({ classId: c.class_id, originId: c.origin_id, level: c.level, form }).skills;
    const after = buildSheet({
      classId: c.class_id,
      originId: c.origin_id,
      level: c.level,
      form: {
        ...form,
        skills: SKILLS.map((s) => {
          const cur = form.skills.find((x) => x.skill_id === s.id);
          return { skill_id: s.id, points: parsed.data[s.id] ?? 0, other_bonus: cur?.other_bonus ?? 0, temp_bonus: cur?.temp_bonus ?? 0 };
        }),
      },
    }).skills;
    const capErrors = checkSkillEdit(before, after);
    if (capErrors.length) return fail(capErrors[0]);
    const rows = SKILLS.map((s) => ({ form_id: fid, skill_id: s.id, points: parsed.data[s.id] ?? 0 }));
    const { error } = await supabase.from("form_skills").upsert(rows, { onConflict: "form_id,skill_id" });
    if (error) return fail(dbMessage(error, "Não foi possível salvar as perícias."));
    return { ok: true };
  });
}

const identitySchema = z.object({
  name: z.string().trim().max(120, "Máximo de 120 caracteres."),
  player_name: z.string().trim().max(120, "Máximo de 120 caracteres."),
  story: z.string().max(20000, "Texto longo demais."),
  appearance: z.string().max(10000, "Texto longo demais."),
  extra_info: z.string().max(10000, "Texto longo demais."),
});
export type IdentityInput = z.infer<typeof identitySchema>;

export async function saveIdentity(characterId: string, input: Partial<IdentityInput>): Promise<ActionResult> {
  return guard(async () => {
    if (!uuid.safeParse(characterId).success) return fail("Personagem inválido.");
    const parsed = identitySchema.partial().safeParse(input);
    if (!parsed.success) return fail(parsed.error.issues[0]?.message ?? "Dados inválidos.");
    const { supabase } = await requireUser();
    const { data, error } = await supabase.from("characters").update(parsed.data).eq("id", characterId).select("id");
    if (error || !data?.length) return fail("Não foi possível salvar.");
    touch(characterId);
    return { ok: true };
  });
}

export async function saveCreationStep(characterId: string, step: number): Promise<ActionResult> {
  return guard(async () => {
    if (!Number.isInteger(step) || step < 1 || step > 6) return fail("Etapa inválida.");
    const { supabase } = await creationContext(characterId);
    await supabase.from("characters").update({ creation_step: step }).eq("id", characterId);
    return { ok: true };
  });
}

export async function finalizeCharacter(characterId: string): Promise<ActionResult> {
  const result = await guard(async () => {
    const bundle = await loadCharacter(characterId);
    const { character: c, base } = bundle;
    if (!bundle.isOwner) return fail("Apenas o dono pode finalizar.");
    if (c.status !== "draft") return fail("Este personagem já foi finalizado.");
    const checks = checkCreation({ classId: c.class_id, originId: c.origin_id, originPathId: c.origin_path_id, name: c.name, playerName: c.player_name, form: base });
    const pending = checks.filter((s) => s.step < 6 && !s.complete);
    if (pending.length) return fail(pending[0].errors[0]);

    const sheet = buildSheet({ classId: c.class_id, originId: c.origin_id, level: 1, form: base });
    const { supabase } = await requireUser();
    const { error: fErr } = await supabase
      .from("character_forms")
      .update({ pv_current: sheet.resources.pvMax, pc_current: sheet.resources.pcMax })
      .eq("id", base.id);
    if (fErr) return fail("Não foi possível calcular os recursos.");
    const { data, error } = await supabase
      .from("characters")
      .update({ status: "active", creation_step: 6, level: 1 })
      .eq("id", characterId)
      .eq("status", "draft")
      .select("id");
    if (error || !data?.length) return fail("Não foi possível finalizar.");
    touch(characterId);
    return { ok: true };
  });
  if (result.ok) redirect(`/personagens/${characterId}`);
  return result;
}

// ===================================================================== Forma Lenda (Artificial)

export async function startLendaForm(characterId: string): Promise<void> {
  const { supabase } = await requireUser();
  const { data, error } = await supabase.rpc("create_lenda_form", { p_character: characterId, p_name: "" });
  if (error || !data) redirect(`/personagens/${characterId}?erro=lenda`);
  redirect(`/personagens/${characterId}/lenda`);
}

const lendaIdentitySchema = z.object({
  name: z.string().trim().max(120, "Máximo de 120 caracteres."),
  description: z.string().max(10000, "Texto longo demais."),
  special_rules: z.string().max(10000, "Texto longo demais."),
});
export type LendaIdentityInput = z.infer<typeof lendaIdentitySchema>;

/** Nome, descrição física e informações da Lenda (na criação e depois, na ficha). */
export async function saveFormIdentity(characterId: string, formId: string, input: Partial<LendaIdentityInput>): Promise<ActionResult> {
  return guard(async () => {
    if (!uuid.safeParse(characterId).success || !uuid.safeParse(formId).success) return fail("Dados inválidos.");
    const parsed = lendaIdentitySchema.partial().safeParse(input);
    if (!parsed.success) return fail(parsed.error.issues[0]?.message ?? "Dados inválidos.");
    const { supabase } = await requireUser();
    const { data, error } = await supabase.from("character_forms").update(parsed.data).eq("id", formId).eq("character_id", characterId).select("id");
    if (error || !data?.length) return fail("Não foi possível salvar.");
    return { ok: true };
  });
}

export async function completeLendaForm(characterId: string): Promise<ActionResult> {
  const result = await guard(async () => {
    const bundle = await loadCharacter(characterId);
    if (!bundle.isOwner) return fail("Apenas o dono pode concluir a Lenda.");
    const lenda = bundle.lenda;
    if (!lenda) return fail("Ficha da Lenda não encontrada.");
    if (lenda.setup_complete) return { ok: true };
    const c = bundle.character;
    const checks = checkLendaCreation({ name: lenda.name, form: lenda, level: 1 });
    const pending = checks.filter((s) => s.step < 4 && !s.complete);
    if (pending.length) return fail(pending[0].errors[0]);
    const { supabase } = await requireUser();
    // Recursos iniciais (nível 1) calculados pelo motor; a evolução da Lenda é rolada a seguir.
    const sheet = buildSheet({ classId: c.class_id, originId: c.origin_id, level: 1, form: lenda });
    const { error } = await supabase.rpc("complete_lenda_form", { p_form: lenda.id, p_pv: sheet.resources.pvMax, p_pc: sheet.resources.pcMax });
    if (error) return fail(dbMessage(error, "Não foi possível concluir a Lenda."));
    if (c.level > 1) {
      const { error: lvErr } = await supabase.rpc("set_character_level", { p_character: characterId, p_level: c.level });
      if (lvErr) return fail(dbMessage(lvErr, "Lenda criada, mas a evolução de nível falhou. Mude o nível para tentar de novo."));
      const after = await loadCharacter(characterId);
      const s2 = buildSheet({ classId: c.class_id, originId: c.origin_id, level: c.level, form: after.lenda! });
      await supabase.from("character_forms").update({ pv_current: s2.resources.pvMax, pc_current: s2.resources.pcMax }).eq("id", lenda.id);
    }
    await supabase.from("characters").update({ active_form: "lenda" }).eq("id", characterId);
    touch(characterId);
    return { ok: true };
  });
  if (result.ok) redirect(`/personagens/${characterId}`);
  return result;
}

export async function setActiveForm(characterId: string, kind: "base" | "lenda"): Promise<ActionResult> {
  return guard(async () => {
    if (kind !== "base" && kind !== "lenda") return fail("Forma inválida.");
    const { bundle, supabase } = await sheetContext(characterId);
    if (kind === "lenda" && !bundle.lenda?.setup_complete) return fail("A ficha da Lenda ainda não foi criada.");
    const { error } = await supabase.from("characters").update({ active_form: kind }).eq("id", characterId);
    if (error) return fail(dbMessage(error, "Não foi possível alternar a forma."));
    touch(characterId);
    return { ok: true };
  });
}

// ===================================================================== Evolução de nível

export interface LevelRow {
  form_id: string;
  kind: "base" | "lenda";
  level: number;
  pv_gain: number;
  pc_gain: number;
  pv_dice: string;
  pc_dice: string | null;
  pv_roll: { faces: number[]; bonus: number; total: number };
  pc_roll: { faces: number[]; bonus: number; total: number } | null;
  isNew: boolean;
}

export async function changeLevel(characterId: string, level: number): Promise<ActionResult<{ from: number; to: number; rows: LevelRow[] }>> {
  return guard(async () => {
    if (!Number.isInteger(level) || level < SHEET_LIMITS.levels.min || level > SHEET_LIMITS.levels.max) return fail("Nível inválido.");
    const { bundle, supabase } = await sheetContext(characterId);
    const from = bundle.character.level;
    const { data, error } = await supabase.rpc("set_character_level", { p_character: characterId, p_level: level });
    if (error || !data) return fail(dbMessage(error, "Não foi possível mudar o nível."));
    const res = data as { created: { form_id: string; level: number }[]; rows: Omit<LevelRow, "isNew">[] };
    const created = new Set(res.created.map((c) => `${c.form_id}:${c.level}`));

    // Mantém PV/PC atuais dentro dos novos máximos (descer de nível suspende ganhos).
    const after = await loadCharacter(characterId);
    const c = after.character;
    for (const form of [after.base, after.lenda].filter((f): f is NonNullable<typeof f> => Boolean(f?.setup_complete))) {
      const s = buildSheet({ classId: c.class_id, originId: c.origin_id, level: c.level, form });
      const pv = Math.min(form.pv_current, s.resources.pvMax);
      const pc = Math.min(form.pc_current, s.resources.pcMax);
      if (pv !== form.pv_current || pc !== form.pc_current) {
        await supabase.from("character_forms").update({ pv_current: pv, pc_current: pc }).eq("id", form.id);
      }
    }
    touch(characterId);
    const rows = res.rows
      .filter((r) => r.level > Math.min(from, level))
      .map((r) => ({ ...r, isNew: created.has(`${r.form_id}:${r.level}`) }));
    return { ok: true, data: { from, to: level, rows } };
  });
}

// ===================================================================== Ficha (todas aceitam a forma ativa)

const attributeRowsSchema = z
  .array(
    z.object({
      attribute: z.enum(ATTRIBUTE_IDS as [string, ...string[]]),
      base_value: int(0, SHEET_LIMITS.attributeMax),
      other_bonus: int(-100, 100),
      temp_bonus: int(-100, 100),
    }),
  )
  .max(8);

export async function updateAttributes(characterId: string, rows: z.infer<typeof attributeRowsSchema>, formId?: string | null): Promise<ActionResult> {
  return guard(async () => {
    const parsed = attributeRowsSchema.safeParse(rows);
    if (!parsed.success) return fail("Valores de atributo inválidos (base 0–200, bônus −100 a 100).");
    const { form, supabase } = await sheetContext(characterId, formId);
    const { error } = await supabase
      .from("form_attributes")
      .upsert(parsed.data.map((r) => ({ ...r, form_id: form.id })), { onConflict: "form_id,attribute" });
    if (error) return fail(dbMessage(error, "Não foi possível salvar os atributos."));
    touch(characterId);
    return { ok: true, message: "Atributos salvos." };
  });
}

const skillRowsSchema = z
  .array(
    z.object({
      skill_id: z.string(),
      points: int(0, SHEET_LIMITS.skillPointsMax),
      other_bonus: int(-100, 100),
      temp_bonus: int(-100, 100),
    }),
  )
  .max(SKILLS.length);

export async function updateSkills(characterId: string, rows: z.infer<typeof skillRowsSchema>, formId?: string | null): Promise<ActionResult> {
  return guard(async () => {
    const parsed = skillRowsSchema.safeParse(rows);
    if (!parsed.success || parsed.data.some((r) => !SKILL_BY_ID[r.skill_id])) return fail("Valores de perícia inválidos.");
    const { bundle, form, sheet, supabase } = await sheetContext(characterId, formId);
    const c = bundle.character;
    // Limite TOTAL (75 / 95): não pode aumentar acima; reduzir valores antigos inválidos é permitido.
    const merged = SKILLS.map((s) => {
      const r = parsed.data.find((x) => x.skill_id === s.id);
      const cur = form.skills.find((x) => x.skill_id === s.id);
      return r ?? { skill_id: s.id, points: cur?.points ?? 0, other_bonus: cur?.other_bonus ?? 0, temp_bonus: cur?.temp_bonus ?? 0 };
    });
    const after = buildSheet({ classId: c.class_id, originId: c.origin_id, level: c.level, form: { ...form, skills: merged } }).skills;
    const capErrors = checkSkillEdit(sheet.skills, after);
    if (capErrors.length) return fail(capErrors[0]);
    const { error } = await supabase
      .from("form_skills")
      .upsert(parsed.data.map((r) => ({ ...r, form_id: form.id })), { onConflict: "form_id,skill_id" });
    if (error) return fail(dbMessage(error, "Não foi possível salvar as perícias."));
    touch(characterId);
    return { ok: true, message: "Perícias salvas." };
  });
}

const resourcesSchema = z.object({
  pv_current: int(0, 9999),
  pc_current: int(0, 9999),
  pv_other_bonus: int(-9999, 9999),
  pc_other_bonus: int(-9999, 9999),
});

export async function updateResources(characterId: string, input: z.infer<typeof resourcesSchema>, formId?: string | null): Promise<ActionResult<{ clamped: boolean }>> {
  return guard(async () => {
    const parsed = resourcesSchema.safeParse(input);
    if (!parsed.success) return fail("Valores inválidos.");
    const { bundle, form, supabase } = await sheetContext(characterId, formId);
    const c = bundle.character;
    const sheet = buildSheet({
      classId: c.class_id,
      originId: c.origin_id,
      level: c.level,
      form: { ...form, pv_other_bonus: parsed.data.pv_other_bonus, pc_other_bonus: parsed.data.pc_other_bonus },
    });
    const pv = Math.min(parsed.data.pv_current, sheet.resources.pvMax);
    const pc = Math.min(parsed.data.pc_current, sheet.resources.pcMax);
    const { data, error } = await supabase
      .from("character_forms")
      .update({ ...parsed.data, pv_current: pv, pc_current: pc })
      .eq("id", form.id)
      .select("id");
    if (error || !data?.length) return fail("Não foi possível salvar PV e PC.");
    touch(characterId);
    const clamped = pv !== parsed.data.pv_current || pc !== parsed.data.pc_current;
    return { ok: true, data: { clamped }, message: clamped ? "Salvo. Valores atuais ajustados ao máximo." : "PV e PC salvos." };
  });
}

export async function adjustResource(characterId: string, resource: "pv" | "pc", delta: number, formId?: string | null): Promise<ActionResult<{ value: number }>> {
  return guard(async () => {
    if ((resource !== "pv" && resource !== "pc") || !Number.isInteger(delta) || Math.abs(delta) > 9999) return fail("Valor inválido.");
    const { form, sheet, supabase } = await sheetContext(characterId, formId);
    const max = resource === "pv" ? sheet.resources.pvMax : sheet.resources.pcMax;
    const { data, error } = await supabase.rpc("adjust_form_resource", { p_form: form.id, p_resource: resource, p_delta: delta, p_max: max });
    if (error) return fail("Não foi possível ajustar.");
    touch(characterId);
    return { ok: true, data: { value: data as number } };
  });
}

const TEXT_FIELDS = ["story", "appearance", "personal_notes", "extra_info"] as const;

export async function saveText(characterId: string, field: (typeof TEXT_FIELDS)[number], value: string): Promise<ActionResult> {
  return guard(async () => {
    if (!uuid.safeParse(characterId).success) return fail("Personagem inválido.");
    if (!TEXT_FIELDS.includes(field) || typeof value !== "string" || value.length > 20000) return fail("Texto inválido.");
    const { supabase } = await requireUser();
    const { data, error } = await supabase.from("characters").update({ [field]: value }).eq("id", characterId).select("id");
    if (error || !data?.length) return fail("Não foi possível salvar.");
    return { ok: true };
  });
}

/** Teste d100 feito NO SERVIDOR com o valor atual da forma ativa; registrado no histórico. */
export async function rollCheck(characterId: string, kind: "attribute" | "skill", id: string, formId?: string | null): Promise<ActionResult<RollEntry>> {
  return guard(async () => {
    const { form, sheet } = await sheetContext(characterId, formId);
    const prefix = form.kind === "lenda" ? `[${form.name || "Lenda"}] ` : "";
    let label: string;
    let value: number;
    if (kind === "attribute") {
      if (!(ATTRIBUTE_IDS as string[]).includes(id)) return fail("Atributo inválido.");
      label = `${prefix}Teste de ${id}`;
      value = sheet.finalAttributes[id as keyof typeof sheet.finalAttributes];
    } else {
      const s = sheet.skills.find((x) => x.id === id);
      if (!s) return fail("Perícia inválida.");
      label = `${prefix}Teste de ${s.name}`;
      value = s.final;
    }
    const test = rollTest(label, value);
    const entry = await logRoll(characterId, label, "1d100", { ...test, kind: "test", outcomeLabel: OUTCOME_LABEL[test.outcome] });
    return { ok: true, data: entry };
  });
}

