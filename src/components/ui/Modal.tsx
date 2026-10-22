"use client";

import { useEffect, useRef } from "react";
import { motion } from "motion/react";
import { X } from "lucide-react";

interface ModalProps {
  open: boolean;
  onClose: () => void;
  title: string;
  tag?: string;
  size?: "md" | "lg" | "xl";
  /** Conteúdo fixo no topo (ex.: indicador de custo). */
  header?: React.ReactNode;
  footer?: React.ReactNode;
  children: React.ReactNode;
}

const WIDTH = { md: "w-[min(94vw,32rem)]", lg: "w-[min(94vw,46rem)]", xl: "w-[min(96vw,64rem)]" };

/** Janela holográfica (dialog nativo: foco preso, Esc fecha). */
export function Modal({ open, onClose, title, tag, size = "lg", header, footer, children }: ModalProps) {
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
        onClose();
      }}
      aria-label={title}
      className={`m-auto max-h-[92dvh] ${WIDTH[size]} overflow-visible bg-transparent p-0 text-fg backdrop:bg-void/85 backdrop:backdrop-blur-sm`}
    >
      {open && (
        <motion.div
          initial={{ opacity: 0, scaleY: 0.04, scaleX: 0.92 }}
          animate={{ opacity: 1, scaleY: 1, scaleX: 1 }}
          transition={{ duration: 0.26, ease: [0.2, 0.8, 0.2, 1] }}
          className="hud-panel flex max-h-[92dvh] flex-col border-holo/50 bg-panel/95 shadow-[0_0_80px_-30px_rgb(72_199_255/0.8)]"
        >
          <div className="flex items-start justify-between gap-3 border-b border-line/70 px-5 pt-8 pb-3 sm:px-6">
            {tag && <span className="hud-tag">{tag}</span>}
            <h2 className="text-xl tracking-[0.06em] text-fg uppercase">{title}</h2>
            <button onClick={onClose} className="rounded-sm p-1 text-fg-muted hover:bg-panel-2 hover:text-cyan" aria-label="Fechar">
              <X className="h-4 w-4" />
            </button>
          </div>
          {header && <div className="border-b border-line/70 px-5 py-3 sm:px-6">{header}</div>}
          <div className="flex-1 overflow-y-auto px-5 py-4 sm:px-6">{children}</div>
          {footer && <div className="flex flex-wrap items-center justify-end gap-2 border-t border-line/70 px-5 py-3 sm:px-6">{footer}</div>}
        </motion.div>
      )}
    </dialog>
  );
}
