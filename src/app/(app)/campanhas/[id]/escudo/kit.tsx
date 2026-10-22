"use client";

import { useState, useTransition } from "react";
import { useToast } from "@/components/ui/Toast";
import type { ActionResult } from "@/lib/types";

/** Executa uma ação do servidor mostrando erro/mensagem; devolve os dados em caso de sucesso. */
export function useAct() {
  const toast = useToast();
  const [busy, start] = useTransition();
  function act<T>(fn: () => Promise<ActionResult<T>>, onOk?: (data: T | undefined) => void, quiet = false) {
    start(async () => {
      const r = await fn();
      if (!r.ok) {
        toast(r.error ?? "Erro.", "error");
        return;
      }
      if (r.message && !quiet) toast(r.message);
      onOk?.(r.data);
    });
  }
  return { act, busy };
}

export function newId(): string {
  try {
    return crypto.randomUUID();
  } catch {
    return "10000000-1000-4000-8000-100000000000".replace(/[018]/g, (c) => (Number(c) ^ (Math.random() * 16) >> (Number(c) / 4)).toString(16));
  }
}

export function Meter({ label, cur, max, tone = "pv" }: { label: string; cur: number | null; max: number | null; tone?: "pv" | "pc" }) {
  if (cur == null) return null;
  const pct = max && max > 0 ? Math.max(0, Math.min(100, (cur / max) * 100)) : 100;
  const low = max ? cur / max <= 0.25 : false;
  return (
    <div className="space-y-0.5">
      <div className="flex justify-between font-mono text-[0.6rem] tracking-[0.15em] uppercase">
        <span className="text-fg-muted">{label}</span>
        <span className={`tabular-nums ${low && tone === "pv" ? "text-alert" : "text-fg"}`}>
          {cur}
          {max != null && <span className="text-fg-muted">/{max}</span>}
        </span>
      </div>
      <div className="relative h-1.5 overflow-hidden border border-line bg-panel-3" aria-hidden>
        <div className={`absolute inset-y-0 left-0 transition-[width] ${tone === "pv" ? (low ? "bg-alert" : "bg-gradient-to-r from-primary to-cyan") : "bg-holo/70"}`} style={{ width: `${pct}%` }} />
      </div>
    </div>
  );
}

/** Campo numérico + botões de ajuste rápido (dano/cura, gastar/recuperar). */
export function Adjuster({
  onApply,
  disabled,
  minusLabel,
  plusLabel,
}: {
  onApply: (delta: number) => void;
  disabled?: boolean;
  minusLabel: string;
  plusLabel: string;
}) {
  const [v, setV] = useState("");
  const n = Number.parseInt(v, 10);
  const ok = Number.isInteger(n) && n > 0 && n <= 99999;
  const btn = "border border-line-strong px-2 py-1 font-mono text-[0.62rem] tracking-[0.1em] uppercase disabled:opacity-40";
  return (
    <div className="flex flex-wrap items-center gap-1">
      <button type="button" className={`${btn} hover:border-alert hover:text-alert`} disabled={disabled} onClick={() => onApply(-1)} aria-label={`${minusLabel} 1`}>
        −1
      </button>
      <button type="button" className={`${btn} hover:border-cyan hover:text-cyan`} disabled={disabled} onClick={() => onApply(1)} aria-label={`${plusLabel} 1`}>
        +1
      </button>
      <input
        className="field-input w-16 px-2 py-1 text-xs"
        inputMode="numeric"
        value={v}
        onChange={(e) => setV(e.target.value.replace(/\D/g, "").slice(0, 5))}
        placeholder="nº"
        aria-label="Quantidade"
        disabled={disabled}
      />
      <button
        type="button"
        className={`${btn} hover:border-alert hover:text-alert`}
        disabled={disabled || !ok}
        onClick={() => {
          onApply(-n);
          setV("");
        }}
      >
        {minusLabel}
      </button>
      <button
        type="button"
        className={`${btn} hover:border-cyan hover:text-cyan`}
        disabled={disabled || !ok}
        onClick={() => {
          onApply(n);
          setV("");
        }}
      >
        {plusLabel}
      </button>
    </div>
  );
}

export function Empty({ children }: { children: React.ReactNode }) {
  return <p className="border border-dashed border-line p-5 text-center text-sm text-fg-muted">{children}</p>;
}

export function SectionTitle({ children, right }: { children: React.ReactNode; right?: React.ReactNode }) {
  return (
    <div className="mb-3 flex flex-wrap items-center justify-between gap-2 border-b border-line/70 pb-2">
      <h2 className="font-mono text-xs tracking-[0.25em] text-holo uppercase">{children}</h2>
      {right}
    </div>
  );
}

/** Texto "uma linha por item" ⇄ lista. */
export const lines = (s: string) =>
  s
    .split("\n")
    .map((x) => x.trim())
    .filter(Boolean);
