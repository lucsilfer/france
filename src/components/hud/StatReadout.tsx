import { thresholds } from "@/rules/d100.ts";

/** Leitura digital de um valor de teste: normal (grande) + bom e extremo. */
export function StatReadout({ code, name, value, placeholder }: { code: string; name: string; value: number | null; placeholder?: string }) {
  const t = value === null ? null : thresholds(value);
  return (
    <span className="flex w-full flex-col items-center gap-0.5">
      <span className="flex w-full items-center justify-between">
        <span className="font-display text-sm tracking-[0.25em] text-holo">{code}</span>
        <span className="h-1 w-1 bg-cyan/70" aria-hidden />
      </span>
      <span className="w-full text-left font-mono text-[0.6rem] tracking-[0.18em] text-fg-muted uppercase">{name}</span>
      <span className={`mt-1 font-display text-3xl tabular-nums ${t ? "text-fg" : "text-fg-muted/60"}`}>{t ? t.normal : placeholder ?? "--"}</span>
      <span className="grid w-full grid-cols-2 gap-1 border-t border-line/70 pt-1.5 font-mono text-[0.62rem]">
        <span className="text-left text-fg-dim">
          <span className="text-fg-muted">BOM </span>
          <span className="tabular-nums text-fg">{t ? t.good : "--"}</span>
        </span>
        <span className="text-right text-fg-dim">
          <span className="text-fg-muted">EXT </span>
          <span className="tabular-nums text-cyan">{t ? t.extreme : "--"}</span>
        </span>
      </span>
    </span>
  );
}
