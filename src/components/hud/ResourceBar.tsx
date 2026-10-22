"use client";

import { motion } from "motion/react";

/**
 * Indicador de recurso segmentado (PV/PC). Atualiza na hora; o preenchimento
 * diminui visualmente conforme o valor cai.
 */
export function ResourceBar({ label, short, current, max, tone }: { label: string; short: string; current: number; max: number; tone: "pv" | "pc" }) {
  const pct = max > 0 ? Math.max(0, Math.min(100, (current / max) * 100)) : 0;
  const low = pct <= 25;
  const color = tone === "pv" ? "var(--color-holo)" : "var(--color-cyan)";
  return (
    <div>
      <div className="mb-1.5 flex items-end justify-between gap-2">
        <span className="flex items-baseline gap-2">
          <span className="font-display text-sm tracking-[0.2em]" style={{ color }}>
            {short}
          </span>
          <span className="font-mono text-[0.6rem] tracking-[0.2em] text-fg-muted uppercase">{label}</span>
        </span>
        <span className="font-mono tabular-nums">
          <span className="text-2xl text-fg">{current}</span>
          <span className="text-sm text-fg-muted"> / {max}</span>
          {low && <span className="ml-2 font-mono text-[0.6rem] tracking-[0.2em] text-alert uppercase">baixo</span>}
        </span>
      </div>
      <div
        className="relative h-3.5 overflow-hidden border border-line bg-panel-3"
        role="meter"
        aria-label={label}
        aria-valuemin={0}
        aria-valuemax={max}
        aria-valuenow={current}
        aria-valuetext={`${current} de ${max}`}
      >
        <motion.div
          className="absolute inset-y-0 left-0"
          style={{ background: `linear-gradient(90deg, ${tone === "pv" ? "var(--color-primary)" : "var(--color-cyan-dim)"}, ${color})`, boxShadow: `0 0 12px ${color}` }}
          initial={false}
          animate={{ width: `${pct}%` }}
          transition={{ type: "spring", stiffness: 220, damping: 30 }}
        />
        {/* segmentos */}
        <div
          className="pointer-events-none absolute inset-0"
          style={{ backgroundImage: "repeating-linear-gradient(90deg, transparent 0 calc(5% - 1px), rgb(5 10 18 / 0.85) calc(5% - 1px) 5%)" }}
          aria-hidden
        />
      </div>
    </div>
  );
}
