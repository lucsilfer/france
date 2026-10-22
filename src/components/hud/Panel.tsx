/** Painel holográfico reutilizável (vidro escuro + cantos iluminados). */
export function Panel({
  tag,
  className = "",
  interactive = false,
  children,
  as: As = "div",
  ...rest
}: {
  tag?: React.ReactNode;
  className?: string;
  interactive?: boolean;
  children: React.ReactNode;
  as?: "div" | "section" | "li" | "article";
} & Record<string, unknown>) {
  return (
    <As className={`hud-panel ${interactive ? "hud-card" : ""} ${className}`} {...rest}>
      {tag && <span className="hud-tag">{tag}</span>}
      {children}
    </As>
  );
}

type Tone = "online" | "draft" | "idle" | "alert";
const DOT: Record<Tone, string> = {
  online: "bg-cyan shadow-[0_0_8px_var(--color-cyan)]",
  draft: "bg-primary shadow-[0_0_8px_var(--color-primary)] animate-pulse",
  idle: "bg-fg-muted",
  alert: "bg-alert shadow-[0_0_8px_var(--color-alert)]",
};

/** Indicador de status: ponto luminoso + texto (nunca só cor). */
export function StatusDot({ tone, label }: { tone: Tone; label: string }) {
  return (
    <span className="inline-flex items-center gap-2 font-mono text-[0.62rem] tracking-[0.22em] text-fg-dim uppercase">
      <span className={`h-1.5 w-1.5 rounded-full ${DOT[tone]}`} aria-hidden />
      {label}
    </span>
  );
}
