import "server-only";
import type { requireUser } from "@/lib/supabase/server";
import { MEDIA_BUCKET, MEDIA_URL_TTL } from "./media-shared";

type SupabaseClient = Awaited<ReturnType<typeof requireUser>>["supabase"];

/**
 * Gera links assinados com a sessão do usuário: o Storage aplica as políticas
 * (quem não pode ler a imagem simplesmente não recebe o link).
 */
export async function signMedia(supabase: SupabaseClient, paths: (string | null | undefined)[]): Promise<Record<string, string>> {
  const unique = Array.from(new Set(paths.filter((p): p is string => typeof p === "string" && p.length > 0)));
  if (unique.length === 0) return {};
  const { data } = await supabase.storage.from(MEDIA_BUCKET).createSignedUrls(unique, MEDIA_URL_TTL);
  const out: Record<string, string> = {};
  for (const row of data ?? []) if (row.path && row.signedUrl && !row.error) out[row.path] = row.signedUrl;
  return out;
}

/** Apaga um arquivo (ignora falhas: o registro no banco é o que importa). */
export async function removeMedia(supabase: SupabaseClient, path: string | null | undefined) {
  if (!path) return;
  try {
    await supabase.storage.from(MEDIA_BUCKET).remove([path]);
  } catch {
    // arquivo órfão não quebra nada
  }
}
