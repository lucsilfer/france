"use server";

import { revalidatePath } from "next/cache";
import { z } from "zod";
import { requireUser } from "@/lib/supabase/server";
import type { ActionResult } from "@/lib/types";
import {
  campaignSchema,
  fieldErrorsFrom,
  homebrewSchema,
  profileSchema,
  type CampaignInput,
  type HomebrewInput,
  type ProfileInput,
} from "@/lib/validation";

const uuid = z.string().uuid();

function dbError(message: string, fallback: string): string {
  if (message.includes("duplicate key") && message.includes("username")) return "Este nome de usuário já está em uso.";
  if (message.includes("row-level security")) return "Você não tem permissão para esta ação.";
  return fallback;
}

// ---------------------------------------------------------------- Perfil
export async function updateProfile(input: ProfileInput): Promise<ActionResult> {
  const parsed = profileSchema.safeParse(input);
  if (!parsed.success) return { ok: false, error: "Revise os campos.", fieldErrors: fieldErrorsFrom(parsed.error) };
  const { supabase, user } = await requireUser();
  const { error } = await supabase
    .from("profiles")
    .update({
      username: parsed.data.username,
      display_name: parsed.data.display_name || null,
      reduce_motion: parsed.data.reduce_motion,
      roll_speed: parsed.data.roll_speed,
    })
    .eq("id", user.id);
  if (error) {
    const msg = dbError(error.message, "Não foi possível salvar o perfil.");
    return { ok: false, error: msg, fieldErrors: msg.includes("usuário") ? { username: msg } : undefined };
  }
  revalidatePath("/", "layout");
  return { ok: true, message: "Perfil salvo." };
}

// ---------------------------------------------------------------- Personagens
export async function deleteCharacter(id: string): Promise<ActionResult> {
  if (!uuid.safeParse(id).success) return { ok: false, error: "Personagem inválido." };
  const { supabase, user } = await requireUser();
  const { data, error } = await supabase.from("characters").delete().eq("id", id).eq("owner_id", user.id).select("id");
  if (error) return { ok: false, error: dbError(error.message, "Não foi possível excluir.") };
  if (!data?.length) return { ok: false, error: "Personagem não encontrado ou sem permissão." };
  revalidatePath("/painel");
  return { ok: true, message: "Personagem excluído." };
}

// ---------------------------------------------------------------- Campanhas
export async function createCampaign(input: CampaignInput): Promise<ActionResult<{ id: string }>> {
  const parsed = campaignSchema.safeParse(input);
  if (!parsed.success) return { ok: false, error: "Revise os campos.", fieldErrors: fieldErrorsFrom(parsed.error) };
  const { supabase, user } = await requireUser();
  const { data, error } = await supabase
    .from("campaigns")
    .insert({
      owner_id: user.id,
      name: parsed.data.name,
      description: parsed.data.description,
      cover_url: parsed.data.cover_url || null,
      settings: { players_see_party: parsed.data.players_see_party },
    })
    .select("id")
    .single();
  if (error || !data) return { ok: false, error: dbError(error?.message ?? "", "Não foi possível criar a campanha.") };
  if (!parsed.data.invites_enabled) await supabase.rpc("set_invite_active", { p_campaign: data.id, p_active: false });
  revalidatePath("/painel");
  return { ok: true, data: { id: data.id as string }, message: "Campanha criada. Você é o Mestre." };
}

export async function deleteCampaign(id: string): Promise<ActionResult> {
  if (!uuid.safeParse(id).success) return { ok: false, error: "Campanha inválida." };
  const { supabase, user } = await requireUser();
  const { data, error } = await supabase.from("campaigns").delete().eq("id", id).eq("owner_id", user.id).select("id");
  if (error) return { ok: false, error: dbError(error.message, "Não foi possível excluir a campanha.") };
  if (!data?.length) return { ok: false, error: "Apenas o criador pode excluir a campanha." };
  revalidatePath("/painel");
  return { ok: true, message: "Campanha excluída." };
}

export async function leaveCampaign(id: string): Promise<ActionResult> {
  if (!uuid.safeParse(id).success) return { ok: false, error: "Campanha inválida." };
  const { supabase, user } = await requireUser();
  const { data, error } = await supabase
    .from("campaign_members")
    .delete()
    .eq("campaign_id", id)
    .eq("user_id", user.id)
    .eq("role", "player")
    .select("user_id");
  if (error) return { ok: false, error: dbError(error.message, "Não foi possível sair da campanha.") };
  if (!data?.length) return { ok: false, error: "O Mestre não pode sair da própria campanha." };
  revalidatePath("/painel");
  return { ok: true, message: "Você saiu da campanha." };
}

export async function regenerateInvite(id: string): Promise<ActionResult<{ code: string }>> {
  if (!uuid.safeParse(id).success) return { ok: false, error: "Campanha inválida." };
  const { supabase } = await requireUser();
  const { data, error } = await supabase.rpc("regenerate_invite", { p_campaign: id });
  if (error) return { ok: false, error: "Apenas o Mestre pode gerar convites." };
  revalidatePath("/painel");
  return { ok: true, data: { code: data as string }, message: "Novo link gerado. O anterior deixou de funcionar." };
}

export async function joinCampaign(code: string): Promise<ActionResult<{ id: string }>> {
  if (!/^[a-f0-9]{18}$/.test(code)) return { ok: false, error: "Convite inválido." };
  const { supabase } = await requireUser();
  const { data, error } = await supabase.rpc("join_campaign", { p_code: code });
  if (error) return { ok: false, error: "Convite inválido ou expirado." };
  revalidatePath("/painel");
  return { ok: true, data: { id: data as string }, message: "Você entrou na campanha como Jogador." };
}

// ---------------------------------------------------------------- Homebrew
function homebrewRow(d: HomebrewInput) {
  const data: Record<string, string> = {};
  if (d.effect_dice) data.effect_dice = d.effect_dice;
  if (d.effect_kind) data.effect_kind = d.effect_kind;
  if (d.range) data.range = d.range;
  if (d.special_rules) data.special_rules = d.special_rules;
  return { kind: d.kind, name: d.name, description: d.description, data };
}

export async function saveHomebrew(input: HomebrewInput, id?: string): Promise<ActionResult<{ id: string }>> {
  const parsed = homebrewSchema.safeParse(input);
  if (!parsed.success) return { ok: false, error: "Revise os campos.", fieldErrors: fieldErrorsFrom(parsed.error) };
  const { supabase, user } = await requireUser();
  const row = homebrewRow(parsed.data);
  if (id) {
    if (!uuid.safeParse(id).success) return { ok: false, error: "Conteúdo inválido." };
    // Preserva campos que este formulário não edita (ex.: tipo de item, categorias de arma criadas na ficha).
    const { data: current } = await supabase.from("homebrew").select("data").eq("id", id).eq("owner_id", user.id).maybeSingle();
    const prev = (current?.data ?? {}) as Record<string, unknown>;
    const merged = { ...prev, ...row.data };
    for (const k of ["effect_dice", "effect_kind", "range", "special_rules"]) if (!(k in row.data)) delete merged[k];
    const { data, error } = await supabase.from("homebrew").update({ ...row, data: merged }).eq("id", id).eq("owner_id", user.id).select("id");
    if (error || !data?.length) return { ok: false, error: "Não foi possível salvar." };
    revalidatePath("/painel");
    return { ok: true, data: { id }, message: "Alterações salvas." };
  }
  const { data, error } = await supabase.from("homebrew").insert({ ...row, owner_id: user.id }).select("id").single();
  if (error || !data) return { ok: false, error: "Não foi possível criar o conteúdo." };
  revalidatePath("/painel");
  return { ok: true, data: { id: data.id as string }, message: "Conteúdo salvo na sua biblioteca." };
}

export async function deleteHomebrew(id: string): Promise<ActionResult> {
  if (!uuid.safeParse(id).success) return { ok: false, error: "Conteúdo inválido." };
  const { supabase, user } = await requireUser();
  const { data, error } = await supabase.from("homebrew").delete().eq("id", id).eq("owner_id", user.id).select("id");
  if (error || !data?.length) return { ok: false, error: "Não foi possível excluir." };
  revalidatePath("/painel");
  return { ok: true, message: "Conteúdo excluído. Cópias já colocadas em fichas não são afetadas." };
}

export async function duplicateHomebrew(id: string): Promise<ActionResult<{ id: string }>> {
  if (!uuid.safeParse(id).success) return { ok: false, error: "Conteúdo inválido." };
  const { supabase, user } = await requireUser();
  const { data: src, error } = await supabase.from("homebrew").select("kind, name, description, data, image_path").eq("id", id).eq("owner_id", user.id).single();
  if (error || !src) return { ok: false, error: "Conteúdo não encontrado." };
  const { data, error: insErr } = await supabase
    .from("homebrew")
    .insert({ ...src, name: `${String(src.name).slice(0, 110)} (cópia)`, owner_id: user.id })
    .select("id")
    .single();
  if (insErr || !data) return { ok: false, error: "Não foi possível duplicar." };
  revalidatePath("/painel");
  return { ok: true, data: { id: data.id as string }, message: "Cópia criada." };
}
