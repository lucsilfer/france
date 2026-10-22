/** Divisor de interface: linha holográfica com marcadores. */
export function HudDivider({ className = "", label }: { className?: string; label?: string }) {
  return (
    <div className={`flex items-center gap-2 ${className}`} aria-hidden>
      <span className="h-2 w-px bg-holo" />
      <span className="h-px flex-1 bg-gradient-to-r from-holo/80 via-line to-transparent" />
      {label && <span className="font-mono text-[0.58rem] tracking-[0.3em] text-fg-muted uppercase">{label}</span>}
      <span className="h-px w-10 bg-line" />
      <span className="h-1 w-1 bg-cyan" />
    </div>
  );
}

/** Nome mantido por compatibilidade com as telas existentes. */
export const Ornament = HudDivider;

export { Wordmark } from "@/components/brand/Logo";
