"use client";

import { useEffect, useState } from "react";
import { createClient } from "@/lib/supabase/client";
import { MEDIA_BUCKET, MEDIA_MAX_BYTES, MEDIA_URL_TTL } from "@/lib/media-shared";

let sb: ReturnType<typeof createClient> | null = null;
const client = () => (sb ??= createClient());

type Entry = { url: string | null; exp: number };
const cache = new Map<string, Entry>();
let queue: { path: string; resolve: (u: string | null) => void }[] = [];
let timer: ReturnType<typeof setTimeout> | null = null;

/** Guarda links já assinados pelo servidor (evita pedir de novo). */
export function primeMediaUrls(urls: Record<string, string> | undefined) {
  if (!urls) return;
  const exp = Date.now() + (MEDIA_URL_TTL - 300) * 1000;
  for (const [p, u] of Object.entries(urls)) cache.set(p, { url: u, exp });
}

async function flush() {
  timer = null;
  const batch = queue;
  queue = [];
  const paths = Array.from(new Set(batch.map((b) => b.path)));
  let map: Record<string, string | null> = {};
  try {
    const { data } = await client().storage.from(MEDIA_BUCKET).createSignedUrls(paths, MEDIA_URL_TTL);
    map = Object.fromEntries(((data ?? []) as { path: string | null; signedUrl: string | null; error: string | null }[]).map((r) => [r.path ?? "", r.error ? null : r.signedUrl]));
  } catch {
    // sem rede: tenta de novo na próxima renderização
  }
  const exp = Date.now() + (MEDIA_URL_TTL - 300) * 1000;
  for (const p of paths) cache.set(p, { url: map[p] ?? null, exp: map[p] ? exp : Date.now() + 30_000 });
  for (const b of batch) b.resolve(map[b.path] ?? null);
}

/** Link assinado de uma imagem do bucket privado (pedidos agrupados; respeita as políticas do Storage). */
export function signedMediaUrl(path: string): Promise<string | null> {
  const hit = cache.get(path);
  if (hit && hit.exp > Date.now()) return Promise.resolve(hit.url);
  return new Promise((resolve) => {
    queue.push({ path, resolve });
    timer ??= setTimeout(() => void flush(), 15);
  });
}

export function useMediaUrl(path: string | null | undefined, initial?: string | null): string | null {
  const cached = path ? cache.get(path) : undefined;
  const [url, setUrl] = useState<string | null>(initial ?? (cached && cached.exp > Date.now() ? cached.url : null));
  useEffect(() => {
    let alive = true;
    if (!path) {
      setUrl(null);
      return;
    }
    if (initial) {
      cache.set(path, { url: initial, exp: Date.now() + (MEDIA_URL_TTL - 300) * 1000 });
      setUrl(initial);
      return;
    }
    void signedMediaUrl(path).then((u) => alive && setUrl(u));
    return () => {
      alive = false;
    };
  }, [path, initial]);
  return url;
}

/** Envia o arquivo já recortado/comprimido. O Storage confere se a pasta é sua. */
export async function uploadMedia(path: string, blob: Blob): Promise<{ ok: true } | { ok: false; error: string }> {
  if (blob.size > MEDIA_MAX_BYTES) return { ok: false, error: "Imagem grande demais (máx. 2 MB depois do recorte)." };
  const { error } = await client().storage.from(MEDIA_BUCKET).upload(path, blob, { contentType: blob.type || "image/webp", upsert: false, cacheControl: "3600" });
  if (error) return { ok: false, error: /row-level|policy|unauthorized|403/i.test(error.message) ? "Sem permissão para enviar esta imagem." : "Falha ao enviar a imagem. Tente de novo." };
  return { ok: true };
}

export async function discardMedia(path: string) {
  try {
    await client().storage.from(MEDIA_BUCKET).remove([path]);
  } catch {
    // ignora
  }
}
