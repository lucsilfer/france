/** Imagens (Supabase Storage). Isomórfico: usado no servidor e no navegador. */
export const MEDIA_BUCKET = "france-media";
/** Limite do arquivo final (o bucket recusa acima disso). */
export const MEDIA_MAX_BYTES = 2 * 1024 * 1024;
/** Limite do arquivo original escolhido (antes do recorte/compressão no navegador). */
export const MEDIA_MAX_INPUT_BYTES = 15 * 1024 * 1024;
export const MEDIA_INPUT_TYPES = ["image/png", "image/jpeg", "image/webp"] as const;
/** Validade dos links assinados (o bucket é privado). */
export const MEDIA_URL_TTL = 60 * 60 * 6;

export type MediaFolder = "characters" | "homebrew" | "npcs";

const FILE_RE = /^[A-Za-z0-9_-]{1,80}\.(webp|png|jpg|jpeg)$/;
const UUID_RE = /^[0-9a-f]{8}-[0-9a-f]{4}-[0-9a-f]{4}-[0-9a-f]{4}-[0-9a-f]{12}$/i;

/** Mesma regra do banco (public.is_media_path). */
export function isMediaPath(path: string | null | undefined, folder: MediaFolder, owner: string): boolean {
  if (!path) return false;
  const parts = path.split("/");
  return parts.length === 3 && parts[0] === folder && parts[1] === owner && UUID_RE.test(owner) && FILE_RE.test(parts[2]);
}

export function mediaPath(folder: MediaFolder, owner: string, prefix: string, ext: string): string {
  const rand = Math.random().toString(36).slice(2, 10) + Date.now().toString(36);
  return `${folder}/${owner}/${prefix.replace(/[^A-Za-z0-9_-]/g, "").slice(0, 20)}-${rand}.${ext}`;
}
