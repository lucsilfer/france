"use server";

import { revalidatePath } from "next/cache";
import { z } from "zod";
import { requireUser } from "@/lib/supabase/server";
import type { ActionResult, HomebrewKind } from "@/lib/types";
import { SHAREABLE_KINDS } from "@/lib/types";
import { DATA_SCHEMAS, entryBase } from "@/lib/homebrew";
import { isMediaPath } from "@/lib/media-shared";
import { removeMedia } from "@/lib/media";

const uuid = z.string().uuid();
const KINDS = Object.keys(DATA_SCHEMAS) as HomebrewKind[];

function firstIssue(e: z.ZodError): string {
  const i = e.issues[0];
  return i ? `${i.message}${i.path.length ? ` (${i.path.join(" › ")})` : ""}` : "Revise os campos.";
}

/** Apaga a imagem antiga se nenhum outro conteúdo (ex.: uma cópia duplicada) ainda a usa. */
async function dropImageIfUnused(supabase: Awaited<ReturnType<typeof requireUser>>["supabase"], path: string | null | undefined) {
  if (!path) return;
  const [{ count: hb }, { count: npc }, { count: cbt }, { count: it }] = await Promise.all([
    supabase.from("homebrew").select("id", { count: "exact", head: true }).eq("image_path", path),
    supabase.from("npcs").select("id", { count: "exact", head: true }).eq("image_path", path),
    supabase.from("combatants").select("id", { count: "exact", head: true }).eq("image_path", path),
    supabase.from("items").select("id", { count: "exact", head: true }).eq("image_path", path),
  ]);
  if (!hb && !npc && !cbt && !it) await removeMedia(supabase, path);
}

/** Cria ou salva um conteúdo da biblioteca (dados validados por categoria). */
export async function saveHomebrewEntry(
  kind: HomebrewKind,
  base: { name: string; description: string; image_path: string | null },
  data: Record<string, unknown>,
  id?: string | null,
): Promise<ActionResult<{ id: string; updated_at: string }>> {
  if (!KINDS.includes(kind)) return { ok: false, error: "Categoria inválida." };
  const b = entryBase.safeParse(base);
  if (!b.success) return { ok: false, error: firstIssue(b.error) };
  const d = DATA_SCHEMAS[kind].safeParse(data);
  if (!d.success) return { ok: false, error: firstIssue(d.error) };
  const { supabase, user } = await requireUser();
  if (b.data.image_path && !isMediaPath(b.data.image_path, "homebrew", user.id)) return { ok: false, error: "Imagem inválida." };
  const row = { kind, name: b.data.name, description: b.data.description, image_path: b.data.image_path, data: d.data };
  if (id) {
    if (!uuid.safeParse(id).success) return { ok: false, error: "Conteúdo inválido." };
    const { data: prev } = await supabase.from("homebrew").select("image_path").eq("id", id).eq("owner_id", user.id).maybeSingle();
    if (!prev) return { ok: false, error: "Conteúdo não encontrado." };
    const { data: saved, error } = await supabase.from("homebrew").update(row).eq("id", id).eq("owner_id", user.id).select("id, updated_at").single();
    if (error || !saved) return { ok: false, error: /size/.test(error?.message ?? "") ? "Conteúdo grande demais." : "Não foi possível salvar." };
    if (prev.image_path && prev.image_path !== row.image_path) await dropImageIfUnused(supabase, prev.image_path as string);
    revalidatePath("/painel");
    revalidatePath(`/homebrew/${id}`);
    return { ok: true, data: saved as { id: string; updated_at: string }, message: "Alterações salvas." };
  }
  const { data: created, error } = await supabase.from("homebrew").insert({ ...row, owner_id: user.id }).select("id, updated_at").single();
  if (error || !created) return { ok: false, error: "Não foi possível criar o conteúdo." };
  revalidatePath("/painel");
  return { ok: true, data: created as { id: string; updated_at: string }, message: "Salvo na sua biblioteca." };
}

/** Disponibiliza (ou retira) um conteúdo para os jogadores de uma campanha que você mestra. */
export async function setHomebrewShare(homebrewId: string, campaignId: string, shared: boolean): Promise<ActionResult> {
  if (!uuid.safeParse(homebrewId).success || !uuid.safeParse(campaignId).success) return { ok: false, error: "Dados inválidos." };
  const { supabase, user } = await requireUser();
  const { data: hb } = await supabase.from("homebrew").select("kind").eq("id", homebrewId).eq("owner_id", user.id).maybeSingle();
  if (!hb) return { ok: false, error: "Conteúdo não encontrado." };
  if (!SHAREABLE_KINDS.includes(hb.kind as HomebrewKind)) return { ok: false, error: "Monstros e NPCs ficam com o Mestre (use-os pelo Escudo)." };
  if (shared) {
    const { error } = await supabase.from("homebrew_shares").upsert({ homebrew_id: homebrewId, campaign_id: campaignId, shared_by: user.id }, { onConflict: "homebrew_id,campaign_id", ignoreDuplicates: true });
    if (error) return { ok: false, error: /Mestre/.test(error.message) ? "Só o Mestre da campanha disponibiliza conteúdos nela." : "Não foi possível compartilhar." };
  } else {
    const { error } = await supabase.from("homebrew_shares").delete().eq("homebrew_id", homebrewId).eq("campaign_id", campaignId);
    if (error) return { ok: false, error: "Não foi possível retirar." };
  }
  revalidatePath(`/homebrew/${homebrewId}`);
  return { ok: true, message: shared ? "Disponível para os jogadores da campanha." : "Retirado da campanha." };
}

export async function deleteHomebrewEntry(id: string): Promise<ActionResult> {
  if (!uuid.safeParse(id).success) return { ok: false, error: "Conteúdo inválido." };
  const { supabase, user } = await requireUser();
  const { data, error } = await supabase.from("homebrew").delete().eq("id", id).eq("owner_id", user.id).select("image_path");
  if (error || !data?.length) return { ok: false, error: "Não foi possível excluir." };
  await dropImageIfUnused(supabase, data[0].image_path as string | null);
  revalidatePath("/painel");
  return { ok: true, message: "Conteúdo excluído. Cópias já colocadas em fichas, campanhas e combates continuam intactas." };
}
