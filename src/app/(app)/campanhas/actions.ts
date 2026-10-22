"use server";

import { revalidatePath } from "next/cache";
import { z } from "zod";
import { requireUser } from "@/lib/supabase/server";
import type { ActionResult } from "@/lib/types";
import type { NoteRow, ReportRow, RollRow } from "@/lib/campaign-types";
import { ATTRIBUTE_IDS } from "@/rules/data/attributes.ts";
import { OUTCOME_LABEL, rollTest } from "@/rules/d100.ts";
import { isValidDice } from "@/rules/dice.ts";
import { loadCharacter } from "@/lib/character";
import { buildSheet } from "@/rules/sheet.ts";

const uuid = z.string().uuid();
const ROLL_COLUMNS = "id, user_id, character_id, label, expression, result, visibility, created_at";

function fail(error: string): { ok: false; error: string } {
  return { ok: false, error };
}

/** Mensagem do banco (raise exception em português) ou genérica. */
function msg(error: { message?: string } | null | undefined, fallback: string): string {
  const m = error?.message ?? "";
  if (/^[A-ZÁÉÍÓÚÂÊÔÃÕÇ(]/.test(m) && !m.includes("violates") && !m.includes("permission denied")) return m;
  if (m.includes("row-level security") || m.includes("permission denied")) return "Sem permissão para isso nesta campanha.";
  return fallback;
}

async function ctx(campaignId: string) {
  if (!uuid.safeParse(campaignId).success) throw new Error("Campanha inválida.");
  return requireUser();
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

// ===================================================================== Campanha e convites

const settingsSchema = z.object({
  name: z.string().trim().min(1, "Dê um nome à campanha.").max(120),
  description: z.string().trim().max(5000),
  cover_url: z.string().trim().max(500).refine((v) => v === "" || /^https:\/\/\S+$/.test(v), "Use um link https://."),
  players_see_party: z.boolean(),
});

export async function updateCampaign(campaignId: string, input: z.infer<typeof settingsSchema>): Promise<ActionResult> {
  return run(async () => {
    const parsed = settingsSchema.safeParse(input);
    if (!parsed.success) return fail(parsed.error.issues[0]?.message ?? "Revise os campos.");
    const { supabase } = await ctx(campaignId);
    const { data, error } = await supabase
      .from("campaigns")
      .update({
        name: parsed.data.name,
        description: parsed.data.description,
        cover_url: parsed.data.cover_url || null,
        settings: { players_see_party: parsed.data.players_see_party },
      })
      .eq("id", campaignId)
      .select("id");
    if (error || !data?.length) return fail(msg(error, "Apenas o Mestre altera a campanha."));
    revalidatePath("/painel");
    return { ok: true, message: "Campanha atualizada." };
  });
}

export async function setInviteActive(campaignId: string, active: boolean): Promise<ActionResult> {
  return run(async () => {
    const { supabase } = await ctx(campaignId);
    const { error } = await supabase.rpc("set_invite_active", { p_campaign: campaignId, p_active: Boolean(active) });
    if (error) return fail(msg(error, "Apenas o Mestre altera o convite."));
    return { ok: true, message: active ? "Convite ativado." : "Convite desativado: o link deixou de funcionar." };
  });
}

export async function removeMember(campaignId: string, userId: string): Promise<ActionResult> {
  return run(async () => {
    if (!uuid.safeParse(userId).success) return fail("Jogador inválido.");
    const { supabase } = await ctx(campaignId);
    const { data, error } = await supabase.from("campaign_members").delete().eq("campaign_id", campaignId).eq("user_id", userId).eq("role", "player").select("user_id");
    if (error || !data?.length) return fail(msg(error, "Não foi possível remover o jogador."));
    // Os personagens dele saem da campanha (as fichas continuam com o jogador).
    const { data: chars } = await supabase.from("campaign_characters").select("character_id, characters!inner(owner_id)").eq("campaign_id", campaignId);
    const mine = ((chars ?? []) as unknown as { character_id: string; characters: { owner_id: string } }[]).filter((c) => c.characters.owner_id === userId);
    for (const c of mine) await supabase.from("campaign_characters").delete().eq("campaign_id", campaignId).eq("character_id", c.character_id);
    return { ok: true, message: "Jogador removido da campanha." };
  });
}

// ===================================================================== Personagens na campanha

export async function linkCharacter(campaignId: string, characterId: string): Promise<ActionResult<{ status: "pending" | "accepted" }>> {
  return run(async () => {
    if (!uuid.safeParse(characterId).success) return fail("Personagem inválido.");
    const { supabase, user } = await ctx(campaignId);
    const { data, error } = await supabase
      .from("campaign_characters")
      .insert({ campaign_id: campaignId, character_id: characterId, added_by: user.id })
      .select("status")
      .single();
    if (error || !data) return fail(error?.code === "23505" ? "Este personagem já está na campanha." : msg(error, "Não foi possível vincular o personagem."));
    const status = data.status as "pending" | "accepted";
    return { ok: true, data: { status }, message: status === "pending" ? "Personagem enviado: aguardando o Mestre aceitar." : "Personagem adicionado à campanha." };
  });
}

export async function unlinkCharacter(campaignId: string, characterId: string): Promise<ActionResult> {
  return run(async () => {
    if (!uuid.safeParse(characterId).success) return fail("Personagem inválido.");
    const { supabase } = await ctx(campaignId);
    const { data, error } = await supabase.from("campaign_characters").delete().eq("campaign_id", campaignId).eq("character_id", characterId).select("character_id");
    if (error || !data?.length) return fail(msg(error, "Não foi possível remover o personagem."));
    return { ok: true, message: "Personagem removido da campanha. A ficha continua com o jogador." };
  });
}

export async function reviewCharacter(campaignId: string, characterId: string, accept: boolean): Promise<ActionResult> {
  return run(async () => {
    if (!uuid.safeParse(characterId).success) return fail("Personagem inválido.");
    const { supabase } = await ctx(campaignId);
    const { error } = await supabase.rpc("review_campaign_character", { p_campaign: campaignId, p_character: characterId, p_accept: Boolean(accept) });
    if (error) return fail(msg(error, "Apenas o Mestre aceita personagens."));
    return { ok: true, message: accept ? "Personagem aceito na campanha." : "Pedido recusado." };
  });
}

/** O jogador decide se o Mestre pode editar a ficha (PV, PC, condições…). */
export async function setMasterCanEdit(campaignId: string, characterId: string, value: boolean): Promise<ActionResult> {
  return run(async () => {
    if (!uuid.safeParse(characterId).success) return fail("Personagem inválido.");
    const { supabase } = await ctx(campaignId);
    const { data, error } = await supabase
      .from("campaign_characters")
      .update({ master_can_edit: Boolean(value) })
      .eq("campaign_id", campaignId)
      .eq("character_id", characterId)
      .select("character_id");
    if (error || !data?.length) return fail(msg(error, "Só o dono do personagem muda essa permissão."));
    return { ok: true, message: value ? "O Mestre pode editar recursos e condições desta ficha." : "O Mestre passa a só visualizar esta ficha." };
  });
}

// ===================================================================== Dados

const visibility = z.enum(["public", "master", "self"]);

/** Rolagem livre: o banco sorteia (ninguém escolhe o número). */
export async function rollDice(campaignId: string, expression: string, vis: "public" | "master" | "self", label = ""): Promise<ActionResult<RollRow>> {
  return run(async () => {
    if (!visibility.safeParse(vis).success) return fail("Visibilidade inválida.");
    if (typeof expression !== "string" || !isValidDice(expression.trim())) return fail("Expressão inválida (ex.: 2d6+3, 1d100, 2d12+1d6).");
    const { supabase } = await ctx(campaignId);
    const { data, error } = await supabase.rpc("roll_dice", { p_campaign: campaignId, p_expression: expression.trim(), p_visibility: vis, p_label: String(label).slice(0, 120) });
    if (error || !data) return fail(msg(error, "Não foi possível rolar."));
    return { ok: true, data: data as RollRow };
  });
}

/** Teste de ficha (d100 do F.R.A.N.C.E) com os valores do personagem, registrado na campanha. */
export async function rollSheetTest(
  campaignId: string,
  characterId: string,
  kind: "attribute" | "skill",
  id: string,
  vis: "public" | "master" | "self",
): Promise<ActionResult<RollRow>> {
  return run(async () => {
    if (!uuid.safeParse(characterId).success || !visibility.safeParse(vis).success) return fail("Dados inválidos.");
    const { supabase, user } = await ctx(campaignId);
    const bundle = await loadCharacter(characterId);
    if (!bundle.canEdit) return fail("Só quem pode editar a ficha rola por ela.");
    const c = bundle.character;
    const form = c.active_form === "lenda" && bundle.lenda?.setup_complete ? bundle.lenda : bundle.base;
    const sheet = buildSheet({ classId: c.class_id, originId: c.origin_id, level: c.level, form });
    let label: string;
    let value: number;
    if (kind === "attribute") {
      if (!(ATTRIBUTE_IDS as string[]).includes(id)) return fail("Atributo inválido.");
      value = sheet.finalAttributes[id as keyof typeof sheet.finalAttributes];
      label = `${c.name}: Teste de ${id}`;
    } else {
      const s = sheet.skills.find((x) => x.id === id);
      if (!s) return fail("Perícia inválida.");
      value = s.final;
      label = `${c.name}: Teste de ${s.name}`;
    }
    const test = rollTest(label, value);
    const { data, error } = await supabase
      .from("roll_log")
      .insert({
        user_id: user.id,
        character_id: characterId,
        campaign_id: campaignId,
        label,
        expression: "1d100",
        result: { ...test, kind: "test", outcomeLabel: OUTCOME_LABEL[test.outcome] },
        visibility: vis,
      })
      .select(ROLL_COLUMNS)
      .single();
    if (error || !data) return fail(msg(error, "Não foi possível registrar a rolagem."));
    return { ok: true, data: data as RollRow };
  });
}

// ===================================================================== Relatórios

const reportSchema = z.object({
  title: z.string().trim().min(1, "Dê um título.").max(160),
  report_date: z.string().regex(/^\d{4}-\d{2}-\d{2}$/, "Data inválida."),
  description: z.string().max(20000),
  participants: z.array(z.string().max(120)).max(40),
  events: z.array(z.string().max(500)).max(60),
  conclusions: z.string().max(10000),
  attachments: z.array(z.string().max(500).regex(/^https:\/\/\S+$/, "Anexos precisam ser links https://")).max(20),
  is_private: z.boolean(),
});
export type ReportInput = z.infer<typeof reportSchema>;

export async function saveReport(campaignId: string, input: ReportInput, id?: string | null): Promise<ActionResult<ReportRow>> {
  return run(async () => {
    const parsed = reportSchema.safeParse(input);
    if (!parsed.success) return fail(parsed.error.issues[0]?.message ?? "Revise os campos.");
    if (id && !uuid.safeParse(id).success) return fail("Relatório inválido.");
    const { supabase } = await ctx(campaignId);
    const cols = "id, title, report_date, description, participants, events, conclusions, attachments, is_private, created_at";
    const q = id
      ? supabase.from("reports").update(parsed.data).eq("id", id).eq("campaign_id", campaignId).select(cols)
      : supabase.from("reports").insert({ ...parsed.data, campaign_id: campaignId }).select(cols);
    const { data, error } = await q;
    if (error || !data?.length) return fail(msg(error, "Apenas o Mestre registra relatórios."));
    return { ok: true, data: data[0] as ReportRow, message: "Relatório salvo." };
  });
}

export async function deleteReport(campaignId: string, id: string): Promise<ActionResult> {
  return run(async () => {
    if (!uuid.safeParse(id).success) return fail("Relatório inválido.");
    const { supabase } = await ctx(campaignId);
    const { data, error } = await supabase.from("reports").delete().eq("id", id).eq("campaign_id", campaignId).select("id");
    if (error || !data?.length) return fail(msg(error, "Não foi possível excluir."));
    return { ok: true, message: "Relatório excluído." };
  });
}

// ===================================================================== Anotações

const noteSchema = z.object({
  title: z.string().trim().max(160),
  category: z.string().trim().max(60),
  content: z.string().max(50000),
  is_private: z.boolean(),
});
export type NoteInput = z.infer<typeof noteSchema>;

export async function createNote(campaignId: string, input: NoteInput): Promise<ActionResult<NoteRow>> {
  return run(async () => {
    const parsed = noteSchema.safeParse(input);
    if (!parsed.success) return fail("Revise os campos.");
    const { supabase, user } = await ctx(campaignId);
    const { data, error } = await supabase
      .from("campaign_notes")
      .insert({ ...parsed.data, title: parsed.data.title || "Sem título", campaign_id: campaignId, author_id: user.id })
      .select("id, title, category, content, is_private, updated_at")
      .single();
    if (error || !data) return fail(msg(error, "Apenas o Mestre cria anotações."));
    return { ok: true, data: data as NoteRow };
  });
}

export async function saveNote(campaignId: string, id: string, input: Partial<NoteInput>): Promise<ActionResult<{ updated_at: string }>> {
  return run(async () => {
    if (!uuid.safeParse(id).success) return fail("Anotação inválida.");
    const parsed = noteSchema.partial().safeParse(input);
    if (!parsed.success) return fail("Revise os campos.");
    const { supabase } = await ctx(campaignId);
    const { data, error } = await supabase.from("campaign_notes").update(parsed.data).eq("id", id).eq("campaign_id", campaignId).select("updated_at");
    if (error || !data?.length) return fail(msg(error, "Não foi possível salvar a anotação."));
    return { ok: true, data: { updated_at: data[0].updated_at as string } };
  });
}

export async function deleteNote(campaignId: string, id: string): Promise<ActionResult> {
  return run(async () => {
    if (!uuid.safeParse(id).success) return fail("Anotação inválida.");
    const { supabase } = await ctx(campaignId);
    const { data, error } = await supabase.from("campaign_notes").delete().eq("id", id).eq("campaign_id", campaignId).select("id");
    if (error || !data?.length) return fail(msg(error, "Não foi possível excluir."));
    return { ok: true, message: "Anotação excluída." };
  });
}
