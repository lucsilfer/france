"use server";

import { revalidatePath } from "next/cache";
import { requireUser } from "@/lib/supabase/server";
import type { ActionResult } from "@/lib/types";
import { isMediaPath } from "@/lib/media-shared";
import { removeMedia, signMedia } from "@/lib/media";
import { fail, guard, uuid } from "./_shared";

/**
 * Grava a foto de UMA forma (humana ou Lenda: nunca se misturam).
 * O arquivo já foi enviado pelo navegador para characters/<personagem>/… — o Storage
 * só aceita se o usuário for o dono; aqui o banco confere de novo e guarda só o caminho.
 */
export async function setFormPortrait(characterId: string, formId: string, path: string): Promise<ActionResult<{ url: string | null }>> {
  return guard(async () => {
    if (!uuid.safeParse(characterId).success || !uuid.safeParse(formId).success) return fail("Dados inválidos.");
    if (!isMediaPath(path, "characters", characterId)) return fail("Arquivo inválido.");
    const { supabase, user } = await requireUser();
    const { data: ch } = await supabase.from("characters").select("owner_id").eq("id", characterId).maybeSingle();
    if (!ch || ch.owner_id !== user.id) return fail("Só o dono do personagem troca a foto.");
    const { data: form } = await supabase.from("character_forms").select("id, portrait_path").eq("id", formId).eq("character_id", characterId).maybeSingle();
    if (!form) return fail("Forma não encontrada.");
    const { error } = await supabase.from("character_forms").update({ portrait_path: path }).eq("id", formId);
    if (error) return fail("Não foi possível salvar a foto.");
    if (form.portrait_path && form.portrait_path !== path) await removeMedia(supabase, form.portrait_path as string);
    const urls = await signMedia(supabase, [path]);
    revalidatePath("/painel");
    return { ok: true, data: { url: urls[path] ?? null }, message: "Foto atualizada." };
  });
}

export async function removeFormPortrait(characterId: string, formId: string): Promise<ActionResult> {
  return guard(async () => {
    if (!uuid.safeParse(characterId).success || !uuid.safeParse(formId).success) return fail("Dados inválidos.");
    const { supabase, user } = await requireUser();
    const { data: ch } = await supabase.from("characters").select("owner_id").eq("id", characterId).maybeSingle();
    if (!ch || ch.owner_id !== user.id) return fail("Só o dono do personagem remove a foto.");
    const { data: form } = await supabase.from("character_forms").select("portrait_path").eq("id", formId).eq("character_id", characterId).maybeSingle();
    if (!form) return fail("Forma não encontrada.");
    const { error } = await supabase.from("character_forms").update({ portrait_path: null }).eq("id", formId);
    if (error) return fail("Não foi possível remover a foto.");
    await removeMedia(supabase, form.portrait_path as string | null);
    revalidatePath("/painel");
    return { ok: true, message: "Foto removida." };
  });
}
