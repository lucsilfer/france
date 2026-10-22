import { Lock } from "lucide-react";
import type { OriginTrait, TraitKind } from "@/rules/data/origins.ts";

export const TRAIT_KIND_LABEL: Record<TraitKind, string> = {
  habilidade: "Habilidade",
  passiva: "Passiva",
  progressao: "Progressão",
  limitacao: "Limitação",
  regra: "Regra especial",
};

/** Lista de traços de origem/caminho, com cadeado quando o nível ainda não libera. */
export function TraitList({ traits, compact = false, level }: { traits: (OriginTrait & { unlocked?: boolean })[]; compact?: boolean; level?: number }) {
  return (
    <ul className={compact ? "space-y-2" : "grid gap-3 md:grid-cols-3"}>
      {traits.map((t) => {
        const locked = level !== undefined && t.unlocked === false;
        return (
          <li key={t.name} className={`${compact ? "" : "border-l-2 border-primary-deep pl-3"} ${locked ? "opacity-60" : ""}`}>
            <p className="flex flex-wrap items-center gap-2">
              <span className={`font-display ${compact ? "text-xs text-cyan-dim" : "text-sm text-fg"}`}>{t.name}</span>
              {!compact && <span className="label-mono text-[0.55rem]">{TRAIT_KIND_LABEL[t.kind]}</span>}
              {t.minLevel && (
                <span className={`label-mono flex items-center gap-1 text-[0.55rem] ${locked ? "text-alert" : "text-ok"}`}>
                  {locked && <Lock className="h-2.5 w-2.5" aria-hidden />}
                  {locked ? `bloqueada até o nível ${t.minLevel}` : `nível ${t.minLevel}+`}
                </span>
              )}
            </p>
            <p className={`mt-1 leading-relaxed text-fg-dim ${compact ? "text-xs" : "text-sm"}`}>{t.text}</p>
          </li>
        );
      })}
    </ul>
  );
}
