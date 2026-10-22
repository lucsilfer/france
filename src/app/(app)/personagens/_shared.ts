import "server-only";
import { revalidatePath } from "next/cache";
import { z } from "zod";
import { requireUser } from "@/lib/supabase/server";
import { loadCharacter, pickForm, type CharacterBundle, type FormRow } from "@/lib/character";
import type { ActionResult } from "@/lib/types";
import type { RollPayload } from "@/lib/rolls";
import { buildSheet } from "@/rules/sheet.ts";

export const uuid = z.string().uuid();
export const int = (min: number, max: number) => z.number().int().min(min).max(max);

export function fail(error: string): { ok: false; error: string } {
  return { ok: false, error };
}

export async function guard<T>(fn: () => Promise<ActionResult<T>>): Promise<ActionResult<T>> {
  try {
    return await fn();
  } catch (e) {
    // redirect()/notFound() do Next.js precisam continuar subindo.
    const digest = (e as { digest?: unknown })?.digest;
    if (typeof digest === "string" && digest.startsWith("NEXT_")) throw e;
    const msg = e instanceof Error ? e.message : "";
    // Mensagens do banco (raise exception) e de validação já estão em português.
    if (/^[A-ZÁÉÍÓÚÂÊÔÃÕÇ]/.test(msg) && !msg.includes("violates")) return fail(msg);
    return fail("Não foi possível salvar. Tente novamente.");
  }
}

/**
 * Invalida só o painel (lista de personagens). A ficha aberta NÃO é recarregada:
 * a interface já aplica a mudança localmente (atualização otimista), o que evita
 * refazer todas as consultas da página a cada clique.
 */
export function touch(_id?: string) {
  revalidatePath("/painel");
}

/**
 * Contexto leve para operações simples (favoritar, remover, renomear…): só autentica.
 * A permissão é garantida pelo RLS do banco — quem não pode editar não altera nenhuma linha.
 */
export async function editContext(characterId: string) {
  if (!uuid.safeParse(characterId).success) throw new Error("Personagem inválido.");
  const { supabase, user } = await requireUser();
  return { supabase, user };
}

/** Mensagem legível de erro vindo do banco (raise exception). */
export function dbMessage(error: { message?: string } | null, fallback: string): string {
  const m = error?.message ?? "";
  if (/^[A-ZÁÉÍÓÚÂÊÔÃÕÇ]/.test(m) && !m.includes("violates") && !m.includes("permission denied")) return m;
  if (m.includes("row-level security") || m.includes("permission denied")) return "Sem permissão para alterar esta ficha.";
  return fallback;
}

/** Ficha + forma pedida + valores calculados, com checagem de permissão. */
export async function sheetContext(characterId: string, formId?: string | null, opts: { edit?: boolean; active?: boolean } = { edit: true, active: true }) {
  if (!uuid.safeParse(characterId).success) throw new Error("Personagem inválido.");
  if (formId && !uuid.safeParse(formId).success) throw new Error("Forma inválida.");
  const bundle: CharacterBundle = await loadCharacter(characterId);
  if (opts.edit && !bundle.canEdit) throw new Error("Sem permissão para alterar esta ficha.");
  if (opts.active && bundle.character.status !== "active") throw new Error("Finalize o personagem antes.");
  const form: FormRow | null = pickForm(bundle, formId);
  if (!form) throw new Error("Forma não encontrada.");
  const c = bundle.character;
  const sheet = buildSheet({ classId: c.class_id, originId: c.origin_id, level: c.level, form });
  const { supabase, user } = await requireUser();
  return { bundle, form, sheet, supabase, user };
}

export async function logRoll(characterId: string, label: string, expression: string, result: RollPayload) {
  const { supabase, user } = await requireUser();
  const { data, error } = await supabase
    .from("roll_log")
    .insert({ user_id: user.id, character_id: characterId, label, expression, result, visibility: "public" })
    .select("id, created_at")
    .single();
  if (error || !data) throw new Error("Não foi possível registrar a rolagem.");
  return { id: data.id as string, label, created_at: data.created_at as string, result };
}
