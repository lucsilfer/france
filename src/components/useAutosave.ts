"use client";

import { useCallback, useEffect, useRef, useState } from "react";
import type { ActionResult } from "@/lib/types";

export type SaveStatus = "idle" | "pending" | "saving" | "saved" | "error";

/**
 * Salvamento automático com debounce. Chamadas em sequência para a mesma chave
 * são agrupadas; ao desmontar a página, o que estiver pendente é enviado.
 */
export function useAutosave<T>(save: (value: T) => Promise<ActionResult<unknown>>, delay = 700) {
  const [status, setStatus] = useState<SaveStatus>("idle");
  const [error, setError] = useState<string | null>(null);
  const timer = useRef<ReturnType<typeof setTimeout> | null>(null);
  const latest = useRef<{ value: T } | null>(null);
  const saveRef = useRef(save);
  saveRef.current = save;

  const flush = useCallback(async () => {
    if (timer.current) clearTimeout(timer.current);
    timer.current = null;
    const item = latest.current;
    if (!item) return;
    latest.current = null;
    setStatus("saving");
    const res = await saveRef.current(item.value);
    if (latest.current) return; // chegou alteração nova enquanto salvava
    if (res.ok) {
      setStatus("saved");
      setError(null);
    } else {
      setStatus("error");
      setError(res.error);
    }
  }, []);

  const schedule = useCallback(
    (value: T) => {
      latest.current = { value };
      setStatus("pending");
      if (timer.current) clearTimeout(timer.current);
      timer.current = setTimeout(() => void flush(), delay);
    },
    [delay, flush],
  );

  useEffect(() => {
    const onLeave = () => void flush();
    window.addEventListener("beforeunload", onLeave);
    return () => {
      window.removeEventListener("beforeunload", onLeave);
      void flush();
    };
  }, [flush]);

  return { schedule, flush, status, error };
}

/** Combina vários status num só indicador. */
export function combineStatus(...all: SaveStatus[]): SaveStatus {
  if (all.includes("error")) return "error";
  if (all.includes("saving")) return "saving";
  if (all.includes("pending")) return "pending";
  if (all.includes("saved")) return "saved";
  return "idle";
}
