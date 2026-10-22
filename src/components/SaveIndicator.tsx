"use client";

import { AlertTriangle, Check, Loader2 } from "lucide-react";
import type { SaveStatus } from "./useAutosave";

const TEXT: Record<SaveStatus, string> = {
  idle: "Tudo salvo",
  pending: "Alterações pendentes…",
  saving: "Salvando…",
  saved: "Salvo",
  error: "Erro ao salvar",
};

export function SaveIndicator({ status, error }: { status: SaveStatus; error?: string | null }) {
  return (
    <span role="status" aria-live="polite" className="label-mono inline-flex items-center gap-1.5" title={error ?? undefined}>
      {status === "saving" || status === "pending" ? (
        <Loader2 className="h-3 w-3 animate-spin text-cyan" aria-hidden />
      ) : status === "error" ? (
        <AlertTriangle className="h-3 w-3 text-alert" aria-hidden />
      ) : (
        <Check className="h-3 w-3 text-ok" aria-hidden />
      )}
      <span className={status === "error" ? "text-alert" : ""}>{status === "error" && error ? error : TEXT[status]}</span>
    </span>
  );
}
