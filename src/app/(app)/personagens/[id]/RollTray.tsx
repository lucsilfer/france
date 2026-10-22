"use client";

import { useState } from "react";
import { AnimatePresence, motion, useReducedMotion } from "motion/react";
import { History, X } from "lucide-react";
import type { Outcome } from "@/rules/d100.ts";
import { payloadKind, type AttackPayload, type EffectTickPayload, type PowerPayload, type RollEntry, type TestPayload, type DiceDetail } from "@/lib/rolls";

/** Estilo por resultado: cor + brilho + texto (a classificação nunca depende só da cor). */
const TONE: Record<Outcome, { box: string; text: string }> = {
  critical_success: { box: "border-cyan shadow-[0_0_50px_-8px_rgb(115_232_255/0.9)]", text: "text-cyan text-glow" },
  extreme: { box: "border-holo shadow-[0_0_36px_-10px_rgb(72_199_255/0.8)]", text: "text-holo" },
  good: { box: "border-primary/80", text: "text-primary" },
  normal: { box: "border-line-strong", text: "text-fg" },
  failure: { box: "border-line", text: "text-fg-dim" },
  critical_failure: { box: "border-alert shadow-[0_0_40px_-10px_rgb(255_122_144/0.8)]", text: "text-alert" },
};

function testName(label: string) {
  return label.replace(/^Teste de\s+/i, "").toUpperCase();
}

/** Dado d100 holográfico girando (não exibe números durante o giro). */
function SpinningDie() {
  const reduce = useReducedMotion();
  return (
    <motion.svg
      viewBox="0 0 40 40"
      className="h-11 w-11"
      animate={reduce ? undefined : { rotate: 360 }}
      transition={{ repeat: Infinity, duration: 0.55, ease: "linear" }}
      aria-hidden
    >
      <polygon points="20,2 37,14 31,36 9,36 3,14" fill="rgb(21 155 255 / 0.12)" stroke="var(--color-holo)" strokeWidth="1.5" />
      <polygon points="20,10 29,17 26,28 14,28 11,17" fill="none" stroke="var(--color-cyan)" strokeWidth="1" opacity="0.8" />
      <line x1="20" y1="2" x2="20" y2="10" stroke="var(--color-cyan)" strokeWidth="0.8" />
    </motion.svg>
  );
}

function pad(n: number) {
  return String(n).padStart(2, "0");
}

function DiceLine({ d, label }: { d: DiceDetail; label?: string }) {
  return (
    <p className="font-mono text-[0.62rem] text-fg-dim">
      {label && <span className="text-fg-muted">{label.toUpperCase()} · </span>}
      {d.expression} → [{d.rolls.join(", ")}] = <span className="text-fg">{d.total}</span>
    </p>
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
      return { value: `−${p.cost}PC`, text: p.effects.map((e) => e.total).join(" + ") || "ATIVADO", cls: "text-cyan" };
    }
    case "effect": {
      const e = r as EffectTickPayload;
      return { value: `−${e.cost}PC`, text: `TURNO ${e.turnsPaid}/${e.turnsTotal || "∞"}`, cls: "text-holo" };
    }
    default: {
      const t = r as TestPayload;
      return { value: pad(t.natural), text: t.outcomeLabel.toUpperCase(), cls: TONE[t.outcome].text };
    }
  }
}

function TestCard({ r, label }: { r: TestPayload; label: string }) {
  const tone = TONE[r.outcome];
  return (
    <>
      <p className="font-mono text-[0.7rem] tracking-[0.25em] text-fg-dim">
        D100 {"//"} <span className="text-fg">{testName(label)}</span>
      </p>
      <div className="mt-2 flex items-end justify-between gap-3">
        <div>
          <span className="font-mono text-[0.6rem] tracking-[0.25em] text-fg-muted">RESULTADO:</span>
          <motion.span initial={{ opacity: 0, filter: "blur(6px)" }} animate={{ opacity: 1, filter: "blur(0px)" }} transition={{ duration: 0.3 }} className={`block font-display text-5xl leading-none tabular-nums ${tone.text}`}>
            {pad(r.natural)}
          </motion.span>
        </div>
        <Thresholds t={r.thresholds} />
      </div>
      {r.rollModifier !== 0 && (
        <p className="mt-1 font-mono text-[0.62rem] text-fg-dim">
          MODIFICADOR {r.rollModifier > 0 ? "+" : ""}
          {r.rollModifier} → {r.effective}
        </p>
      )}
      {r.rolls.length > 1 && <p className="font-mono text-[0.62rem] text-fg-dim">DADOS (VANTAGEM): {r.rolls.map(pad).join(" / ")}</p>}
      <Verdict text={r.outcomeLabel} cls={tone.text} />
    </>
  );
}

function Thresholds({ t }: { t: { normal: number; good: number; extreme: number } }) {
  return (
    <dl className="grid grid-cols-3 gap-x-2 text-right font-mono text-[0.6rem] text-fg-muted">
      <dt>NORM</dt>
      <dt>BOM</dt>
      <dt>EXT</dt>
      <dd className="text-sm text-fg tabular-nums">{t.normal}</dd>
      <dd className="text-sm text-fg tabular-nums">{t.good}</dd>
      <dd className="text-sm text-cyan tabular-nums">{t.extreme}</dd>
    </dl>
  );
}

function Verdict({ text, cls }: { text: string; cls: string }) {
  return (
    <motion.p
      initial={{ opacity: 0, letterSpacing: "0.5em" }}
      animate={{ opacity: 1, letterSpacing: "0.18em" }}
      transition={{ duration: 0.35, delay: 0.15 }}
      className={`mt-2 border-t border-line/60 pt-2 font-head text-xl font-bold uppercase ${cls}`}
    >
      {text}
    </motion.p>
  );
}

function AttackCard({ r }: { r: AttackPayload }) {
  const tone = TONE[r.outcome];
  return (
    <>
      <p className="font-mono text-[0.7rem] tracking-[0.25em] text-fg-dim">
        ARMA {"//"} <span className="text-fg">{r.weapon.toUpperCase()}</span>
      </p>
      <p className="font-mono text-[0.58rem] tracking-[0.2em] text-fg-muted">PERÍCIA: {r.skillName.toUpperCase()}</p>
      <div className="mt-2 flex items-end justify-between gap-3">
        <div>
          <span className="font-mono text-[0.6rem] tracking-[0.25em] text-fg-muted">D100:</span>
          <span className={`block font-display text-5xl leading-none tabular-nums ${tone.text}`}>{pad(r.natural)}</span>
        </div>
        <Thresholds t={r.thresholds} />
      </div>
      {(r.rollModifier !== 0 || r.rolls.length > 1) && (
        <p className="mt-1 font-mono text-[0.62rem] text-fg-dim">
          {r.rolls.length > 1 && <>DADOS: {r.rolls.map(pad).join(" / ")} · </>}
          {r.rollModifier !== 0 && (
            <>
              MOD {r.rollModifier > 0 ? "+" : ""}
              {r.rollModifier} → {r.effective}
            </>
          )}
        </p>
      )}
      <Verdict text={r.outcomeLabel} cls={tone.text} />
      {r.hit && r.damage ? (
        <div className="mt-2 space-y-1">
          <DiceLine d={r.damage} label="Dano base" />
          <div className="flex items-end justify-between font-mono text-[0.62rem] text-fg-dim">
            <span>MULTIPLICADOR ×{r.multiplier}</span>
            <span className="text-right">
              <span className="block text-[0.55rem] tracking-[0.2em] text-fg-muted">DANO FINAL</span>
              <motion.span initial={{ opacity: 0, scale: 0.6 }} animate={{ opacity: 1, scale: 1 }} transition={{ delay: 0.3 }} className="block font-display text-4xl leading-none text-cyan text-glow tabular-nums">
                {r.finalDamage}
              </motion.span>
            </span>
          </div>
        </div>
      ) : (
        <p className="mt-1 font-mono text-[0.62rem] text-fg-muted">SEM DANO</p>
      )}
      {r.note && <p className="mt-1 text-xs text-alert">{r.note}</p>}
      {r.applied.length > 0 && <p className="mt-1 text-[0.68rem] text-fg-dim">Aplicado: {r.applied.join(" · ")}</p>}
      {r.conditions.length > 0 && <p className="mt-0.5 text-[0.68rem] text-cyan-dim">Condições: {r.conditions.join(" · ")}</p>}
    </>
  );
}

function PowerCard({ r }: { r: PowerPayload | EffectTickPayload }) {
  const isTick = r.kind === "effect";
  const title = isTick ? (r as EffectTickPayload).label : (r as PowerPayload).power;
  const notes = isTick ? [] : (r as PowerPayload).notes;
  const cont = isTick ? null : (r as PowerPayload).continuous;
  return (
    <>
      <p className="font-mono text-[0.7rem] tracking-[0.25em] text-fg-dim">
        {isTick ? "TURNO" : "PODER"} {"//"} <span className="text-fg">{title.toUpperCase()}</span>
      </p>
      <p className="mt-1 font-mono text-[0.62rem] text-fg-dim">
        CUSTO −{r.cost} PC · PC RESTANTE <span className="text-fg">{r.pcAfter}</span>
      </p>
      <div className="mt-2 space-y-2">
        {r.effects.length === 0 && <p className="text-sm text-fg-dim">Efeito ativado (sem dados a rolar).</p>}
        {r.effects.map((e, i) => (
          <div key={i} className="flex items-end justify-between gap-2 border-b border-line/50 pb-1.5">
            <DiceLine d={e} label={e.label} />
            <motion.span initial={{ opacity: 0, scale: 0.6 }} animate={{ opacity: 1, scale: 1 }} transition={{ delay: 0.15 + i * 0.1 }} className="font-display text-3xl leading-none text-cyan text-glow tabular-nums">
              {e.total}
            </motion.span>
          </div>
        ))}
      </div>
      {isTick && (
        <p className="mt-2 font-mono text-[0.62rem] text-holo">
          TURNO {(r as EffectTickPayload).turnsPaid}/{(r as EffectTickPayload).turnsTotal || "∞"} {!(r as EffectTickPayload).active && "· ENCERRADO"}
        </p>
      )}
      {cont && (
        <p className="mt-2 font-mono text-[0.62rem] text-holo">
          ATIVAÇÃO CONTÍNUA · {cont.perTurn} PC/TURNO{cont.turns ? ` · ${cont.turns} TURNO(S)` : ""}
        </p>
      )}
      {notes.map((n, i) => (
        <p key={i} className="mt-1 text-[0.68rem] text-fg-dim">
          {n}
        </p>
      ))}
    </>
  );
}

function cardTone(r: RollEntry["result"]) {
  const k = payloadKind(r);
  if (k === "test" || k === "attack") return TONE[(r as TestPayload).outcome].box;
  return "border-holo/70 shadow-[0_0_36px_-12px_rgb(72_199_255/0.8)]";
}

export function RollTray({ latest, rolling, history, onClose }: { latest: RollEntry | null; rolling: boolean; history: RollEntry[]; onClose: () => void }) {
  const [showHistory, setShowHistory] = useState(false);
  const r = latest?.result;

  return (
    <div className="fixed right-3 bottom-3 z-30 flex w-[min(94vw,22rem)] flex-col items-end gap-2 sm:right-4 sm:bottom-4" aria-live="polite">
      <AnimatePresence>
        {showHistory && (
          <motion.div
            initial={{ opacity: 0, scaleY: 0.2, originY: 1 }}
            animate={{ opacity: 1, scaleY: 1 }}
            exit={{ opacity: 0, scaleY: 0.2 }}
            className="hud-panel max-h-72 w-full overflow-y-auto bg-panel/95 px-3 pt-8 pb-3"
          >
            <span className="hud-tag">Registro de rolagens</span>
            {history.length === 0 ? (
              <p className="text-sm text-fg-muted">Nenhuma rolagem ainda. Clique num atributo, perícia, arma ou poder.</p>
            ) : (
              <ul className="space-y-1.5">
                {history.map((h) => {
                  const line = historyLine(h);
                  return (
                    <li key={h.id} className="flex items-center justify-between gap-2 border-b border-line/50 pb-1 font-mono text-[0.68rem]">
                      <span className="truncate text-fg-dim">{testName(h.label)}</span>
                      <span className="shrink-0 tabular-nums">
                        <span className="text-fg">{line.value}</span> <span className={line.cls}>{line.text}</span>
                      </span>
                    </li>
                  );
                })}
              </ul>
            )}
          </motion.div>
        )}
      </AnimatePresence>

      <AnimatePresence mode="wait">
        {rolling && (
          <motion.div key="rolling" initial={{ opacity: 0, scaleX: 0.3 }} animate={{ opacity: 1, scaleX: 1 }} exit={{ opacity: 0 }} className="hud-panel flex w-full items-center gap-3 bg-panel/95 px-4 py-3">
            <SpinningDie />
            <span className="font-mono text-xs tracking-[0.25em] text-holo uppercase">Dados // processando…</span>
          </motion.div>
        )}
        {!rolling && r && latest && (
          <motion.div
            key={latest.id}
            initial={{ opacity: 0, scaleY: 0.1, y: 10 }}
            animate={{ opacity: 1, scaleY: 1, y: 0 }}
            exit={{ opacity: 0, x: 30 }}
            transition={{ duration: 0.28, ease: [0.2, 0.8, 0.2, 1] }}
            className={`hud-panel relative max-h-[70dvh] w-full overflow-y-auto bg-panel/95 px-4 pt-3 pb-3.5 ${cardTone(r)}`}
            role="status"
          >
            <div className="scanline" aria-hidden />
            <button onClick={onClose} className="absolute top-2 right-2 text-fg-muted hover:text-cyan" aria-label="Fechar resultado">
              <X className="h-3.5 w-3.5" />
            </button>
            {payloadKind(r) === "attack" ? (
              <AttackCard r={r as AttackPayload} />
            ) : payloadKind(r) === "power" || payloadKind(r) === "effect" ? (
              <PowerCard r={r as PowerPayload | EffectTickPayload} />
            ) : (
              <TestCard r={r as TestPayload} label={(r as TestPayload).label ?? latest.label} />
            )}
          </motion.div>
        )}
      </AnimatePresence>

      <button
        onClick={() => setShowHistory((s) => !s)}
        aria-expanded={showHistory}
        className="flex items-center gap-2 border border-line bg-panel/90 px-3 py-1.5 font-mono text-[0.62rem] tracking-[0.18em] text-fg-dim uppercase backdrop-blur hover:border-holo hover:text-cyan"
      >
        <History className="h-3.5 w-3.5" aria-hidden /> Histórico ({history.length})
      </button>
    </div>
  );
}
