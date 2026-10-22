"use client";

import { motion, useReducedMotion } from "motion/react";

/**
 * Dado holográfico genérico (d4…d100). O valor vem do servidor antes da animação;
 * o giro é só visual e nunca altera o número.
 */
export function HoloDie({ value, sides, delay = 0, size = 52, dim = false }: { value: number; sides: number; delay?: number; size?: number; dim?: boolean }) {
  const reduce = useReducedMotion();
  return (
    <motion.div
      className="relative inline-flex shrink-0 items-center justify-center"
      style={{ width: size, height: size }}
      initial={reduce ? { opacity: 0 } : { opacity: 0, rotate: -220, scale: 0.4 }}
      animate={{ opacity: 1, rotate: 0, scale: 1 }}
      transition={{ duration: reduce ? 0.15 : 0.7, delay, ease: [0.2, 0.8, 0.2, 1] }}
      aria-label={`d${sides}: ${value}`}
      role="img"
    >
      <svg viewBox="0 0 40 40" className="absolute inset-0 h-full w-full" aria-hidden>
        <polygon
          points="20,2 36,11 36,29 20,38 4,29 4,11"
          fill={dim ? "rgb(11 22 38 / 0.9)" : "rgb(21 155 255 / 0.14)"}
          stroke={dim ? "var(--color-line-strong)" : "var(--color-holo)"}
          strokeWidth="1.4"
        />
        <polygon points="20,8 31,14 31,26 20,32 9,26 9,14" fill="none" stroke={dim ? "var(--color-line)" : "var(--color-cyan)"} strokeWidth="0.6" opacity="0.6" />
      </svg>
      <span className={`relative font-display text-lg tabular-nums ${dim ? "text-fg-muted" : "text-fg text-glow"}`}>{value}</span>
      <span className="absolute -bottom-3 font-mono text-[0.55rem] tracking-[0.15em] text-fg-muted">d{sides}</span>
    </motion.div>
  );
}
