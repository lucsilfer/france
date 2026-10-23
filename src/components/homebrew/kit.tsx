"use client";

import { useState } from "react";
import { ChevronDown, Plus, Trash2 } from "lucide-react";

/** Seção expansível do editor (evita sobrecarregar a tela, principalmente no celular). */
export function Section({ title, hint, defaultOpen = false, children, badge }: { title: string; hint?: string; defaultOpen?: boolean; children: React.ReactNode; badge?: string | number }) {
  const [open, setOpen] = useState(defaultOpen);
  return (
    <section className="border border-line/80 bg-panel/60">
      <button type="button" onClick={() => setOpen(!open)} aria-expanded={open} className="flex w-full items-center gap-3 px-4 py-3 text-left hover:bg-panel-2/60">
        <span className="h-3 w-1 bg-cyan shadow-[0_0_8px_var(--color-cyan)]" aria-hidden />
        <span className="flex-1 font-mono text-xs tracking-[0.22em] text-fg uppercase">{title}</span>
        {badge !== undefined && badge !== 0 && badge !== "" && <span className="font-mono text-[0.6rem] text-holo">{badge}</span>}
        <ChevronDown className={`h-4 w-4 text-fg-muted transition-transform ${open ? "rotate-180" : ""}`} aria-hidden />
      </button>
      {open && (
        <div className="space-y-4 border-t border-line/60 px-4 py-4">
          {hint && <p className="text-xs text-fg-muted">{hint}</p>}
          {children}
        </div>
      )}
    </section>
  );
}

export function L({ label, children, className = "" }: { label: string; children: React.ReactNode; className?: string }) {
  return (
    <label className={`block space-y-1 text-sm ${className}`}>
      <span className="label-mono block text-holo/90">{label}</span>
      {children}
    </label>
  );
}

/** Campo numérico que aceita vazio (null). */
export function NumInput({
  value,
  onChange,
  min = 0,
  max = 99999,
  placeholder,
  className = "",
  allowNegative,
  ariaLabel,
}: {
  value: number | null | undefined;
  onChange: (v: number | null) => void;
  min?: number;
  max?: number;
  placeholder?: string;
  className?: string;
  allowNegative?: boolean;
  ariaLabel?: string;
}) {
  const [raw, setRaw] = useState<string | null>(null);
  const shown = raw ?? (value == null ? "" : String(value));
  return (
    <input
      className={`field-input ${className}`}
      inputMode="numeric"
      value={shown}
      placeholder={placeholder}
      aria-label={ariaLabel}
      onChange={(e) => {
        const v = e.target.value.replace(allowNegative ? /[^\d-]/g : /\D/g, "").slice(0, 6);
        setRaw(v);
        if (v === "" || v === "-") return onChange(null);
        const n = Math.max(min, Math.min(max, Number.parseInt(v, 10)));
        if (Number.isFinite(n)) onChange(n);
      }}
      onBlur={() => setRaw(null)}
    />
  );
}

/** Lista de textos curtos editada como "a, b, c". */
export function TagsInput({ value, onChange, placeholder, ariaLabel }: { value: string[]; onChange: (v: string[]) => void; placeholder?: string; ariaLabel?: string }) {
  const [raw, setRaw] = useState<string | null>(null);
  return (
    <input
      className="field-input"
      value={raw ?? value.join(", ")}
      placeholder={placeholder}
      aria-label={ariaLabel}
      onChange={(e) => {
        setRaw(e.target.value);
        onChange(
          e.target.value
            .split(",")
            .map((x) => x.trim())
            .filter(Boolean)
            .slice(0, 30),
        );
      }}
      onBlur={() => setRaw(null)}
    />
  );
}

/** Linha repetível com botão de remover. */
export function RowCard({ title, onRemove, children, open: initialOpen = true }: { title: string; onRemove: () => void; children: React.ReactNode; open?: boolean }) {
  const [open, setOpen] = useState(initialOpen);
  return (
    <div className="border border-line/70 bg-void/40">
      <div className="flex items-center gap-2 px-3 py-2">
        <button type="button" onClick={() => setOpen(!open)} className="flex min-w-0 flex-1 items-center gap-2 text-left text-sm text-fg" aria-expanded={open}>
          <ChevronDown className={`h-3.5 w-3.5 shrink-0 text-fg-muted transition-transform ${open ? "rotate-180" : ""}`} aria-hidden />
          <span className="truncate">{title}</span>
        </button>
        <button type="button" onClick={onRemove} className="p-1 text-fg-muted hover:text-alert" aria-label={`Remover ${title}`}>
          <Trash2 className="h-4 w-4" />
        </button>
      </div>
      {open && <div className="space-y-3 border-t border-line/50 p-3">{children}</div>}
    </div>
  );
}

export function AddButton({ onClick, children, disabled }: { onClick: () => void; children: React.ReactNode; disabled?: boolean }) {
  return (
    <button
      type="button"
      onClick={onClick}
      disabled={disabled}
      className="inline-flex items-center gap-1.5 border border-dashed border-line-strong px-3 py-1.5 font-mono text-[0.62rem] tracking-[0.15em] text-fg-dim uppercase hover:border-cyan hover:text-cyan disabled:opacity-40"
    >
      <Plus className="h-3.5 w-3.5" aria-hidden /> {children}
    </button>
  );
}

export const rid = () => `r${Date.now().toString(36)}${Math.random().toString(36).slice(2, 6)}`;
