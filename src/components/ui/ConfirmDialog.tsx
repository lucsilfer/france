"use client";

import { useEffect, useRef } from "react";
import { motion } from "motion/react";
import { AlertTriangle } from "lucide-react";
import { Button } from "./Button";

interface ConfirmDialogProps {
  open: boolean;
  title: string;
  description: React.ReactNode;
  confirmLabel?: string;
  tone?: "danger" | "primary";
  loading?: boolean;
  onConfirm: () => void;
  onCancel: () => void;
}

/** Janela modal nativa (foco preso, Esc fecha) com abertura holográfica. */
export function ConfirmDialog({ open, title, description, confirmLabel = "Confirmar", tone = "danger", loading, onConfirm, onCancel }: ConfirmDialogProps) {
  const ref = useRef<HTMLDialogElement>(null);

  useEffect(() => {
    const d = ref.current;
    if (!d) return;
    if (open && !d.open) d.showModal();
    if (!open && d.open) d.close();
  }, [open]);

  return (
    <dialog
      ref={ref}
      onCancel={(e) => {
        e.preventDefault();
        if (!loading) onCancel();
      }}
      aria-labelledby="confirm-title"
      className="m-auto w-[min(92vw,28rem)] overflow-visible bg-transparent p-0 text-fg backdrop:bg-void/80 backdrop:backdrop-blur-sm"
    >
      {open && (
        <motion.div
          initial={{ opacity: 0, scaleY: 0.05, scaleX: 0.9 }}
          animate={{ opacity: 1, scaleY: 1, scaleX: 1 }}
          transition={{ duration: 0.28, ease: [0.2, 0.8, 0.2, 1] }}
          className="hud-panel space-y-4 border-holo/50 px-6 pt-9 pb-6 shadow-[0_0_60px_-20px_rgb(72_199_255/0.7)]"
        >
          <span className="hud-tag">{tone === "danger" ? "Confirmação crítica" : "Confirmação"}</span>
          <h2 id="confirm-title" className="flex items-center gap-2 text-xl text-fg">
            {tone === "danger" && <AlertTriangle className="h-5 w-5 text-alert" aria-hidden />}
            {title}
          </h2>
          <div className="text-sm leading-relaxed text-fg-dim">{description}</div>
          <div className="flex justify-end gap-2 pt-2">
            <Button variant="ghost" onClick={onCancel} disabled={loading}>
              Cancelar
            </Button>
            <Button variant={tone === "danger" ? "danger" : "primary"} onClick={onConfirm} loading={loading} autoFocus>
              {confirmLabel}
            </Button>
          </div>
        </motion.div>
      )}
    </dialog>
  );
}
