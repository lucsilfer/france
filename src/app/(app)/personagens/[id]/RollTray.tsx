"use client";

import { useEffect, useRef, useState } from "react";
import { History, Loader2, X } from "lucide-react";
import type { Outcome } from "@/rules/d100.ts";
import type { RollSpeed } from "@/lib/types";
import { RULES_CONFIG } from "@/rules/config.ts";
import { payloadKind, type AttackPayload, type DiceDetail, type EffectTickPayload, type PowerPayload, type RollEntry, type TestPayload } from "@/lib/rolls";

/** Uma janela de rolagem: criada no clique (entry = null) e preenchida quando o servidor responde. */
export interface RollCard {
  token: string;
  label: string;
  entry: RollEntry | null;
  startedAt: number;
}

/** Estilo por resultado: cor + brilho + texto (a classificação nunca depende só da cor). */
const TONE: Record<Outcome, { box: string; text: string }> = {
  critical_success: { box: "border-cyan shadow-[0_0_40px_-10px_var(--color-cyan)]", text: "text-cyan text-glow" },
  extreme: { box: "border-holo shadow-[0_0_30px_-12px_var(--color-holo)]", text: "text-holo" },
  good: { box: "border-primary/80", text: "text-primary" },
  normal: { box: "border-line-strong", text: "text-fg" },
  failure: { box: "border-line", text: "text-fg-dim" },
  critical_failure: { box: "border-alert shadow-[0_0_30px_-12px_var(--color-alert)]", text: "text-alert" },
};

const AUTO_CLOSE_MS = 14000;

function testName(label: string) {
  return label.replace(/^Teste de\s+/i, "").toUpperCase();
}

function pad(n: number) {
  return String(n).padStart(2, "0");
}

/**
 * Revela um número: durante `ms` mostra dígitos embaralhados e depois o valor real (definido pelo servidor
 * ANTES da animação — a animação nunca muda o resultado). ms = 0 → instantâneo.
 */
function useReveal(ms: number, key: string): boolean {
  // "done" é calculado na mesma renderização em que o resultado chega (sem piscar o número final antes da animação).
  const [doneKey, setDoneKey] = useState<string | null>(null);
  useEffect(() => {
    if (ms === 0) return;
    const t = setTimeout(() => setDoneKey(key), ms);
    return () => clearTimeout(t);
  }, [ms, key]);
  return ms === 0 || doneKey === key;
}

function Scramble({ value, done, className = "", digits = 2 }: { value: number | string; done: boolean; className?: string; digits?: number }) {
  const [noise, setNoise] = useState("".padStart(digits, "0"));
  useEffect(() => {
    if (done) return;
    const t = setInterval(() => setNoise(String(Math.floor(Math.random() * 10 ** digits)).padStart(digits, "0")), 45);
    return () => clearInterval(t);
  }, [done, digits]);
  return (
    <span className={`tabular-nums ${done ? "roll-settle" : "opacity-70"} ${className}`} aria-hidden={!done}>
      {done ? value : noise}
    </span>
  );
}

function DiceLine({ d, label }: { d: DiceDetail; label?: string }) {
  return (
    <p className="min-w-0 font-mono text-[0.62rem] leading-relaxed break-words text-fg-dim">
      {label && <span className="text-fg-muted">{label.toUpperCase()} · </span>}
      {d.expression} → [{d.rolls.join(", ")}] = <span className="text-fg">{d.total}</span>
    </p>
  );
}

function Thresholds({ t }: { t: { normal: number; good: number; extreme: number } }) {
  return (
    <dl className="grid shrink-0 grid-cols-3 gap-x-2 text-right font-mono text-[0.58rem] text-fg-muted">
      <dt>NORM</dt>
      <dt>BOM</dt>
      <dt>EXT</dt>
      <dd className="text-sm text-fg tabular-nums">{t.normal}</dd>
      <dd className="text-sm text-fg tabular-nums">{t.good}</dd>
      <dd className="text-sm text-cyan tabular-nums">{t.extreme}</dd>
    </dl>
  );
}

function Verdict({ text, cls, done }: { text: string; cls: string; done: boolean }) {
  return <p className={`mt-2 border-t border-line/60 pt-2 font-head text-lg leading-tight font-bold tracking-[0.14em] break-words uppercase ${done ? cls : "text-fg-muted"}`}>{done ? text : "…"}</p>;
}

function TestBody({ r, label, done }: { r: TestPayload; label: string; done: boolean }) {
  const tone = TONE[r.outcome];
  return (
    <>
      <p className="pr-5 font-mono text-[0.66rem] tracking-[0.2em] break-words text-fg-dim">
        D100 {"//"} <span className="text-fg">{testName(label)}</span>
      </p>
      <div className="mt-2 flex items-end justify-between gap-3">
        <div className="min-w-0">
          <span className="font-mono text-[0.58rem] tracking-[0.25em] text-fg-muted">RESULTADO</span>
          <Scramble value={pad(r.natural)} done={done} className={`block font-display text-5xl leading-none ${done ? tone.text : "text-fg-dim"}`} />
        </div>
        <Thresholds t={r.thresholds} />
      </div>
      {done && r.rollModifier !== 0 && (
        <p className="mt-1 font-mono text-[0.62rem] text-fg-dim">
          MODIFICADOR {r.rollModifier > 0 ? "+" : ""}
          {r.rollModifier} → {r.effective}
        </p>
      )}
      {done && r.rolls.length > 1 && <p className="font-mono text-[0.62rem] text-fg-dim">DADOS (VANTAGEM): {r.rolls.map(pad).join(" / ")}</p>}
      <Verdict text={r.outcomeLabel} cls={tone.text} done={done} />
    </>
  );
}

function AttackBody({ r, done }: { r: AttackPayload; done: boolean }) {
  const tone = TONE[r.outcome];
  return (
    <>
      <p className="pr-5 font-mono text-[0.66rem] tracking-[0.2em] break-words text-fg-dim">
        ARMA {"//"} <span className="text-fg">{r.weapon.toUpperCase()}</span>
      </p>
      <p className="font-mono text-[0.56rem] tracking-[0.2em] text-fg-muted">PERÍCIA: {r.skillName.toUpperCase()}</p>
      <div className="mt-2 flex items-end justify-between gap-3">
        <div className="min-w-0">
          <span className="font-mono text-[0.58rem] tracking-[0.25em] text-fg-muted">D100</span>
          <Scramble value={pad(r.natural)} done={done} className={`block font-display text-5xl leading-none ${done ? tone.text : "text-fg-dim"}`} />
        </div>
        <Thresholds t={r.thresholds} />
      </div>
      {done && (r.rollModifier !== 0 || r.rolls.length > 1) && (
        <p className="mt-1 font-mono text-[0.62rem] break-words text-fg-dim">
          {r.rolls.length > 1 && <>DADOS: {r.rolls.map(pad).join(" / ")} · </>}
          {r.rollModifier !== 0 && (
            <>
              MOD {r.rollModifier > 0 ? "+" : ""}
              {r.rollModifier} → {r.effective}
            </>
          )}
        </p>
      )}
      <Verdict text={r.outcomeLabel} cls={tone.text} done={done} />
      {done &&
        (r.hit && r.damage ? (
          <div className="mt-2 space-y-1">
            <DiceLine d={r.damage} label="Dano base" />
            <div className="flex items-end justify-between gap-2 font-mono text-[0.62rem] text-fg-dim">
              <span>MULTIPLICADOR ×{r.multiplier}</span>
              <span className="text-right">
                <span className="block text-[0.55rem] tracking-[0.2em] text-fg-muted">DANO FINAL</span>
                <span className="roll-settle block font-display text-4xl leading-none text-cyan text-glow tabular-nums">{r.finalDamage}</span>
              </span>
            </div>
          </div>
        ) : (
          <p className="mt-1 font-mono text-[0.62rem] text-fg-muted">SEM DANO</p>
        ))}
      {done && r.note && <p className="mt-1 text-xs break-words text-alert">{r.note}</p>}
      {done && r.applied.length > 0 && <p className="mt-1 text-[0.68rem] break-words text-fg-dim">Aplicado: {r.applied.join(" · ")}</p>}
      {done && r.conditions.length > 0 && <p className="mt-0.5 text-[0.68rem] break-words text-cyan-dim">Condições: {r.conditions.join(" · ")}</p>}
    </>
  );
}

function PowerBody({ r, done }: { r: PowerPayload | EffectTickPayload; done: boolean }) {
  const isTick = r.kind === "effect";
  const title = isTick ? (r as EffectTickPayload).label : (r as PowerPayload).power;
  const notes = isTick ? [] : (r as PowerPayload).notes;
  const cont = isTick ? null : (r as PowerPayload).continuous;
  return (
    <>
      <p className="pr-5 font-mono text-[0.66rem] tracking-[0.2em] break-words text-fg-dim">
        {isTick ? "TURNO" : "PODER"} {"//"} <span className="text-fg">{title.toUpperCase()}</span>
      </p>
      {r.cost > 0 && (
        <p className="mt-1 font-mono text-[0.62rem] text-fg-dim">
          CUSTO −{r.cost} PC · PC RESTANTE <span className="text-fg">{r.pcAfter}</span>
        </p>
      )}
      <div className="mt-2 space-y-2">
        {r.effects.length === 0 && <p className="text-sm text-fg-dim">Efeito ativado (sem dados a rolar).</p>}
        {r.effects.map((e, i) => (
          <div key={i} className="flex items-end justify-between gap-2 border-b border-line/50 pb-1.5">
            <DiceLine d={e} label={e.label} />
            <Scramble value={e.total} done={done} digits={2} className={`shrink-0 font-display text-3xl leading-none ${done ? "text-cyan text-glow" : "text-fg-dim"}`} />
          </div>
        ))}
      </div>
      {done && isTick && (
        <p className="mt-2 font-mono text-[0.62rem] text-holo">
          TURNO {(r as EffectTickPayload).turnsPaid}/{(r as EffectTickPayload).turnsTotal || "∞"} {!(r as EffectTickPayload).active && "· ENCERRADO"}
        </p>
      )}
      {done && cont && (
        <p className="mt-2 font-mono text-[0.62rem] break-words text-holo">
          ATIVAÇÃO CONTÍNUA{cont.perTurn ? ` · ${cont.perTurn} PC/TURNO` : ""}
          {cont.turns ? ` · ${cont.turns} TURNO(S)` : ""}
        </p>
      )}
      {done &&
        notes.map((n, i) => (
          <p key={i} className="mt-1 text-[0.68rem] break-words text-fg-dim">
            {n}
          </p>
        ))}
    </>
  );
}

function cardTone(r: RollEntry["result"]) {
  const k = payloadKind(r);
  if (k === "test" || k === "attack") return TONE[(r as TestPayload).outcome].box;
  return "border-holo/70";
}

function Card({ card, speed, onClose, compact }: { card: RollCard; speed: RollSpeed; onClose: (token: string) => void; compact: boolean }) {
  const ms = card.entry ? RULES_CONFIG.rollSpeeds[speed] : 0;
  const done = useReveal(ms, card.entry?.id ?? card.token);
  const time = new Date(card.startedAt).toLocaleTimeString("pt-BR", { hour: "2-digit", minute: "2-digit", second: "2-digit" });
  const closeRef = useRef(onClose);
  closeRef.current = onClose;

  // Fecha sozinha depois de um tempo (o histórico guarda tudo).
  useEffect(() => {
    if (!card.entry) return;
    const t = setTimeout(() => closeRef.current(card.token), AUTO_CLOSE_MS);
    return () => clearTimeout(t);
  }, [card.entry, card.token]);

  const r = card.entry?.result;
  const kind = r ? payloadKind(r) : null;
  if (compact && r && done) {
    // Resultados anteriores ficam em uma linha (com nome e hora) para não cobrir a ficha.
    const line = historyLine(card.entry!);
    return (
      <li className={`roll-card hud-panel relative flex w-full items-center gap-2 bg-panel/95 py-2 pr-8 pl-3 ${cardTone(r)}`} role="status" aria-label={card.label}>
        <span className="min-w-0 flex-1 truncate font-mono text-[0.62rem] tracking-[0.15em] text-fg-dim" title={card.entry!.label}>
          {testName(card.entry!.label)} <span className="text-fg-muted">· {time}</span>
        </span>
        <span className="shrink-0 font-mono text-[0.66rem] tabular-nums">
          <span className="text-fg">{line.value}</span> <span className={line.cls}>{line.text}</span>
        </span>
        <button onClick={() => onClose(card.token)} className="absolute top-1/2 right-1.5 -translate-y-1/2 rounded-sm p-1 text-fg-muted hover:text-cyan" aria-label={`Fechar resultado: ${card.label}`}>
          <X className="h-3.5 w-3.5" />
        </button>
      </li>
    );
  }
  return (
    <li
      className={`roll-card hud-panel relative w-full bg-panel/95 px-4 pt-3 pb-3 ${r && done ? cardTone(r) : "border-line-strong"}`}
      role="status"
      aria-busy={!done || !r}
      aria-label={card.label}
    >
      <button onClick={() => onClose(card.token)} className="absolute top-1.5 right-1.5 rounded-sm p-1 text-fg-muted hover:text-cyan" aria-label={`Fechar resultado: ${card.label}`}>
        <X className="h-3.5 w-3.5" />
      </button>
      <span className="absolute right-8 top-2.5 font-mono text-[0.52rem] tracking-[0.15em] text-fg-muted">{time}</span>
      {!r ? (
        <div className="flex items-center gap-3 py-1 pr-16">
          <Loader2 className="h-6 w-6 shrink-0 animate-spin text-holo" aria-hidden />
          <div className="min-w-0">
            <p className="font-mono text-[0.66rem] tracking-[0.2em] break-words text-fg">{testName(card.label)}</p>
            <p className="font-mono text-[0.58rem] tracking-[0.25em] text-holo uppercase">Rolando…</p>
          </div>
        </div>
      ) : kind === "attack" ? (
        <AttackBody r={r as AttackPayload} done={done} />
      ) : kind === "power" || kind === "effect" ? (
        <PowerBody r={r as PowerPayload | EffectTickPayload} done={done} />
      ) : (
        <TestBody r={r as TestPayload} label={card.entry!.label} done={done} />
      )}
    </li>
  );
}

function historyLine(h: RollEntry): { value: string; text: string; cls: string } {
  const r = h.result;
  switch (payloadKind(r)) {
    case "attack": {
      const a = r as AttackPayload;
      return { value: pad(a.natural), text: a.hit ? `${a.finalDamage} DANO` : a.outcomeLabel.toUpperCase(), cls: TONE[a.outcome].text };
    }
    case "power": {
      const p = r as PowerPayload;
      return { value: p.cost ? `−${p.cost}PC` : "—", text: p.effects.map((e) => e.total).join(" + ") || "ATIVADO", cls: "text-cyan" };
    }
    case "effect": {
      const e = r as EffectTickPayload;
      return { value: e.cost ? `−${e.cost}PC` : "—", text: `TURNO ${e.turnsPaid}/${e.turnsTotal || "∞"}`, cls: "text-holo" };
    }
    default: {
      const t = r as TestPayload;
      return { value: pad(t.natural), text: t.outcomeLabel.toUpperCase(), cls: TONE[t.outcome].text };
    }
  }
}

/** Janelas de resultado empilhadas (até 3, mais nova em cima) + histórico. Nunca bloqueiam a ficha. */
export function RollStack({ cards, history, speed, onClose }: { cards: RollCard[]; history: RollEntry[]; speed: RollSpeed; onClose: (token: string) => void }) {
  const [showHistory, setShowHistory] = useState(false);
  return (
    <div className="pointer-events-none fixed right-3 bottom-3 z-30 flex w-[min(calc(100vw-1.5rem),22rem)] flex-col items-end gap-2 sm:right-4 sm:bottom-4">
      {showHistory && (
        <div className="hud-panel pointer-events-auto w-full bg-panel/95 px-3 pt-8 pb-3">
          <span className="hud-tag">Registro de rolagens</span>
          {history.length === 0 ? (
            <p className="text-sm text-fg-muted">Nenhuma rolagem ainda. Clique num atributo, perícia, arma ou poder.</p>
          ) : (
            <ul className="max-h-[min(18rem,45dvh)] space-y-1.5 overflow-x-hidden overflow-y-auto pr-1">
              {history.map((h) => {
                const line = historyLine(h);
                return (
                  <li key={h.id} className="flex items-center justify-between gap-2 border-b border-line/50 pb-1 font-mono text-[0.66rem]">
                    <span className="min-w-0 truncate text-fg-dim" title={h.label}>
                      {testName(h.label)}
                    </span>
                    <span className="shrink-0 tabular-nums">
                      <span className="text-fg">{line.value}</span> <span className={line.cls}>{line.text}</span>
                    </span>
                  </li>
                );
              })}
            </ul>
          )}
        </div>
      )}

      <ol className="pointer-events-auto flex w-full flex-col gap-2" aria-live="polite">
        {cards.map((c, i) => (
          <Card key={c.token} card={c} speed={speed} onClose={onClose} compact={i > 0} />
        ))}
      </ol>

      <button
        onClick={() => setShowHistory((s) => !s)}
        aria-expanded={showHistory}
        className="pointer-events-auto flex items-center gap-2 border border-line bg-panel/90 px-3 py-1.5 font-mono text-[0.62rem] tracking-[0.18em] text-fg-dim uppercase backdrop-blur hover:border-holo hover:text-cyan"
      >
        <History className="h-3.5 w-3.5" aria-hidden /> Histórico ({history.length})
      </button>
    </div>
  );
}
