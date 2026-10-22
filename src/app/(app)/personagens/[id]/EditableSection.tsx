"use client";

import { Pencil, X, Check } from "lucide-react";
import { Button } from "@/components/ui/Button";

interface Props {
  title: string;
  canEdit: boolean;
  editing: boolean;
  saving?: boolean;
  onEdit: () => void;
  onCancel: () => void;
  onSave: () => void;
  hint?: string;
  children: React.ReactNode;
}

/** Seção da ficha com lápis de edição, salvar e cancelar. */
export function EditableSection({ title, canEdit, editing, saving, onEdit, onCancel, onSave, hint, children }: Props) {
  return (
    <section className={`hud-panel px-4 pt-8 pb-4 transition-[border-color,box-shadow] sm:px-5 ${editing ? "edit-mode border-holo shadow-[var(--shadow-glow)]" : ""}`} aria-label={title}>
      <span className="hud-tag">{title}</span>
      {canEdit && (
        <div className="absolute top-2 right-3 flex items-center gap-1">
          {editing ? (
            <>
              <Button size="sm" variant="ghost" onClick={onCancel} disabled={saving} aria-label={`Cancelar edição de ${title}`}>
                <X className="h-3.5 w-3.5" aria-hidden /> Cancelar
              </Button>
              <Button size="sm" onClick={onSave} loading={saving} aria-label={`Salvar ${title}`}>
                <Check className="h-3.5 w-3.5" aria-hidden /> Salvar
              </Button>
            </>
          ) : (
            <button
              onClick={onEdit}
              className="rounded-sm p-1.5 text-fg-muted transition-colors hover:bg-panel-2 hover:text-cyan"
              aria-label={`Editar ${title}`}
              title={`Editar ${title}`}
            >
              <Pencil className="h-3.5 w-3.5" />
            </button>
          )}
        </div>
      )}
      {editing && (
        <p className="mb-3 flex items-start gap-2 text-xs text-fg-dim">
          <span className="mt-1 h-1.5 w-1.5 shrink-0 animate-pulse bg-holo" aria-hidden />
          <span>
            <span className="font-mono tracking-[0.2em] text-holo uppercase">Modo de edição</span>
            {hint ? ` — ${hint}` : ""}
          </span>
        </p>
      )}
      {children}
    </section>
  );
}

export function NumberCell({ value, onChange, min, max, label, className = "" }: { value: number; onChange: (v: number) => void; min: number; max: number; label: string; className?: string }) {
  return (
    <input
      type="number"
      inputMode="numeric"
      value={Number.isFinite(value) ? value : 0}
      min={min}
      max={max}
      aria-label={label}
      onChange={(e) => {
        const n = Math.trunc(Number(e.target.value));
        onChange(Number.isFinite(n) ? Math.max(min, Math.min(max, n)) : 0);
      }}
      className={`field-input w-full px-1.5 py-1 text-center font-mono text-sm ${className}`}
    />
  );
}
