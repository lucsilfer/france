"use client";

import { useEffect, useMemo, useRef, useState } from "react";
import { createClient } from "@/lib/supabase/client";

export interface RealtimeSub {
  table: string;
  /** Filtro do Supabase Realtime, ex.: "campaign_id=eq.<id>" ou "character_id=in.(a,b)". */
  filter?: string;
  event?: "INSERT" | "UPDATE" | "DELETE" | "*";
}

export type RealtimeStatus = "connecting" | "live" | "offline";

export interface RealtimeChange {
  table: string;
  eventType: "INSERT" | "UPDATE" | "DELETE";
  new: Record<string, unknown>;
  old: Record<string, unknown>;
}

let shared: ReturnType<typeof createClient> | null = null;
function client() {
  if (!shared) shared = createClient();
  return shared;
}

/**
 * Assina mudanças do banco (Supabase Realtime, que respeita o RLS: cada um só recebe o que pode ler).
 * Quando a conexão volta depois de cair, chama `onResync` para buscar o estado salvo de novo.
 */
export function useRealtime(name: string, subs: RealtimeSub[], onChange: (c: RealtimeChange) => void, onResync?: () => void, enabled = true): RealtimeStatus {
  const [status, setStatus] = useState<RealtimeStatus>("connecting");
  const changeRef = useRef(onChange);
  const resyncRef = useRef(onResync);
  changeRef.current = onChange;
  resyncRef.current = onResync;
  const key = useMemo(() => JSON.stringify(subs), [subs]);

  useEffect(() => {
    if (!enabled) return;
    let wasLive = false;
    let dropped = false;
    const sb = client();
    let channel = sb.channel(`${name}:${Math.random().toString(36).slice(2, 8)}`);
    for (const s of JSON.parse(key) as RealtimeSub[]) {
      channel = channel.on(
        "postgres_changes" as never,
        { event: s.event ?? "*", schema: "public", table: s.table, ...(s.filter ? { filter: s.filter } : {}) } as never,
        ((payload: { table: string; eventType: RealtimeChange["eventType"]; new: Record<string, unknown>; old: Record<string, unknown> }) =>
          changeRef.current({ table: payload.table, eventType: payload.eventType, new: payload.new ?? {}, old: payload.old ?? {} })) as never,
      );
    }
    channel.subscribe((st: string) => {
      if (st === "SUBSCRIBED") {
        setStatus("live");
        if (wasLive && dropped) resyncRef.current?.();
        wasLive = true;
        dropped = false;
      } else if (st === "CHANNEL_ERROR" || st === "TIMED_OUT" || st === "CLOSED") {
        setStatus("offline");
        dropped = true;
      }
    });
    // Ao voltar para a aba (celular dormindo, rede trocada), confere o estado salvo.
    const onVisible = () => {
      if (document.visibilityState === "visible" && dropped) resyncRef.current?.();
    };
    document.addEventListener("visibilitychange", onVisible);
    return () => {
      document.removeEventListener("visibilitychange", onVisible);
      void sb.removeChannel(channel);
    };
  }, [name, key, enabled]);

  return status;
}

/** Selo "AO VIVO / RECONECTANDO". */
export function liveLabel(status: RealtimeStatus): { text: string; cls: string } {
  if (status === "live") return { text: "Ao vivo", cls: "text-ok" };
  if (status === "offline") return { text: "Reconectando…", cls: "text-alert" };
  return { text: "Conectando…", cls: "text-fg-muted" };
}
