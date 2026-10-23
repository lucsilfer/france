"use client";

import { useEffect, useState } from "react";
import { ShieldCheck, Swords } from "lucide-react";
import type { ConfrontPayload } from "@/lib/rolls";
import { OUTCOME_LABEL, type Outcome } from "@/rules/d100.ts";
import { SKILL_BY_ID } from "@/rules/data/skills.ts";
import { TIE_BREAK_LABEL } from "@/rules/opposed.ts";

const QUALITY_TONE: Record<Outcome, string> = {
  critical_success: "text-cyan text-glow",
  extreme: "text-holo",
  good: "text-primary",
  normal: "text-fg",
  failure: "text-fg-dim",
  critical_failure: "text-alert",
};

const pad = (n: number) => String(n).padStart(2, "0");
const skillName = (id: string | null) => (id ? (SKILL_BY_ID[id]?.name ?? id) : "—");

/** Número que "rola" rapidamente até revelar o valor (respeita reduzir movimento: ms = 0). */
function Spin({ value, ms, className }: { value: number; ms: number; className?: string }) {
  const [done, setDone] = useState(ms <= 0);
  const [noise, setNoise] = useState(value);
  useEffect(() => {
    if (ms <= 0) {
      setDone(true);
      return;
    }
    setDone(false);
    const t1 = setInterval(() => setNoise(1 + Math.floor(Math.random() * 100)), 40);
    const t2 = setTimeout(() => setDone(true), ms);
    return () => {
      clearInterval(t1);
      clearTimeout(t2);
    };
  }, [value, ms]);
  return <span className={`tabular-nums ${className ?? ""}`}>{pad(done ? value : noise)}</span>;
}

/**
 * Resultado de um confronto: atacante × defensor, os dois d100, perícias, vencedor, qualidade e dano.
 * `ms` controla a animação (0 = instantâneo).
 */
export function ConfrontCard({ r, ms = 500, compact = false, actions }: { r: ConfrontPayload; ms?: number; compact?: boolean; actions?: React.ReactNode }) {
  const [revealed, setRevealed] = useState(ms <= 0);
  useEffect(() => {
    if (ms <= 0) return setRevealed(true);
    setRevealed(false);
    const t = setTimeout(() => setRevealed(true), ms);
    return () => clearTimeout(t);
  }, [r.id, ms]);
  const hit = r.winner === "attacker";
  return (
    <div className="space-y-2" aria-live="polite">
      <p className="font-mono text-[0.62rem] tracking-[0.18em] break-words text-fg-dim uppercase">
        Confronto {"//"} <span className="text-fg">{r.label}</span>
      </p>
      <div className="grid grid-cols-[1fr_auto_1fr] items-center gap-2">
        <div className={`min-w-0 border p-2 ${revealed && hit ? "border-cyan/70 bg-cyan/5" : "border-line/70"}`}>
          <p className="truncate text-xs text-fg" title={r.attacker}>
            {r.attacker}
          </p>
          <p className="truncate font-mono text-[0.55rem] text-fg-muted uppercase">
            {skillName(r.attackSkill)} {r.attackValue}
          </p>
          <Spin value={r.attackRoll} ms={ms} className={`block font-display ${compact ? "text-3xl" : "text-4xl"} leading-none ${revealed ? QUALITY_TONE[r.quality] : "text-fg-dim"}`} />
        </div>
        <Swords className="h-4 w-4 text-holo" aria-label="contra" />
        <div className={`min-w-0 border p-2 text-right ${revealed && !hit ? "border-cyan/70 bg-cyan/5" : "border-line/70"}`}>
          <p className="truncate text-xs text-fg" title={r.defender}>
            {r.defender}
          </p>
          <p className="truncate font-mono text-[0.55rem] text-fg-muted uppercase">
            {skillName(r.reactionSkill)} {r.defenseValue}
          </p>
          <Spin value={r.defendRoll} ms={ms} className={`block font-display ${compact ? "text-3xl" : "text-4xl"} leading-none ${revealed ? "text-fg" : "text-fg-dim"}`} />
        </div>
      </div>
      {revealed && (
        <div className="space-y-1 roll-settle">
          <p className={`flex items-center gap-1.5 font-mono text-xs tracking-[0.12em] uppercase ${hit ? "text-cyan" : "text-fg-dim"}`}>
            {hit ? <Swords className="h-3.5 w-3.5" aria-hidden /> : <ShieldCheck className="h-3.5 w-3.5" aria-hidden />}
            {hit ? `${r.attacker} venceu — acertou` : `${r.defender} venceu — defendeu`}
          </p>
          {r.tieBreak !== "none" && <p className="font-mono text-[0.6rem] text-holo uppercase">{TIE_BREAK_LABEL[r.tieBreak]}</p>}
          {r.rounds.length > 1 && (
            <p className="font-mono text-[0.58rem] text-fg-muted">
              Rodadas: {r.rounds.map((x) => `${pad(x.attack)}×${pad(x.defend)}`).join(" · ")}
            </p>
          )}
          <p className="text-xs text-fg-dim">
            Qualidade: <span className={QUALITY_TONE[r.quality]}>{OUTCOME_LABEL[r.quality]}</span>
            {hit && r.multiplier > 1 && <span className="text-cyan"> · dano ×{r.multiplier}</span>}
          </p>
          {hit && r.damage && (
            <div className="flex items-end justify-between gap-2 border-t border-line/50 pt-1">
              <span className="min-w-0 font-mono text-[0.6rem] break-words text-fg-dim">
                {r.damage.expression} [{r.damage.rolls.join(", ")}] = {r.damage.total}
              </span>
              <span className="shrink-0 text-right">
                <span className="block font-mono text-[0.52rem] tracking-[0.2em] text-fg-muted">DANO FINAL</span>
                <span className="block font-display text-3xl leading-none text-cyan text-glow tabular-nums">{r.finalDamage}</span>
              </span>
            </div>
          )}
          {hit && r.damage && <p className="font-mono text-[0.58rem] text-fg-muted">{r.applied ? `${r.appliedDamage} aplicado no PV` : "Dano ainda não aplicado (o Mestre confirma)"}</p>}
          {hit && r.conditions.length > 0 && (
            <p className="text-[0.68rem] break-words text-cyan-dim">Condições: {r.conditions.map((c) => `${c.name}${c.turns ? ` (${c.turns}t)` : ""}`).join(" · ")}</p>
          )}
          {actions}
        </div>
      )}
    </div>
  );
}
