"use client";

import { useState, useTransition } from "react";
import { AnimatePresence, motion } from "motion/react";
import { ChevronsUp, ChevronsDown, History, Lock, Sparkles } from "lucide-react";
import { Button } from "@/components/ui/Button";
import { HoloDie } from "@/components/dice/HoloDie";
import { useToast } from "@/components/ui/Toast";
import { changeLevel, type LevelRow } from "../actions";
import type { SheetState } from "./Sheet";

const LEVELS = Array.from({ length: 20 }, (_, i) => i + 1);

function sidesOf(dice: string | null): number {
  const m = dice?.match(/d(\d+)/);
  return m ? Number(m[1]) : 6;
}

interface Result {
  from: number;
  to: number;
  rows: LevelRow[];
}

/**
 * Seletor de nível 1–20. Subir rola (no banco) cada nível que ainda não tem registro;
 * níveis já rolados são recuperados. Descer suspende os ganhos sem apagar.
 */
export function LevelControl({ state }: { state: SheetState }) {
  const toast = useToast();
  const { character: c } = state;
  const [pending, start] = useTransition();
  const [result, setResult] = useState<Result | null>(null);
  const [target, setTarget] = useState<number | null>(null);

  const ab = state.abilities;
  const maxLevel = ab.maxLevel;

  function apply(level: number) {
    if (level === c.level || pending) return;
    if (level > maxLevel) return; // bloqueado por habilidades pendentes (o servidor também recusa)
    setTarget(level);
    start(async () => {
      const res = await changeLevel(c.id, level);
      setTarget(null);
      if (!res.ok) return toast(res.error, "error");
      state.setCharacter({ level: res.data!.to });
      state.refresh();
      setResult(res.data!);
    });
  }

  return (
    <>
      <div className="mb-5 flex flex-wrap items-center gap-3">
        <label htmlFor="level-select" className="label-mono">
          Nível
        </label>
        {state.canEdit ? (
          <select
            id="level-select"
            value={target ?? c.level}
            disabled={pending}
            onChange={(e) => apply(Number(e.target.value))}
            className="chamfer border border-holo/70 bg-primary/10 px-3 py-1 font-display text-lg tracking-[0.15em] text-holo tabular-nums focus:outline-none focus-visible:ring-2 focus-visible:ring-cyan"
          >
            {LEVELS.map((l) => (
              <option key={l} value={l} disabled={l > maxLevel} className="bg-panel text-fg">
                {String(l).padStart(2, "0")}
                {l > maxLevel ? " — bloqueado" : ""}
              </option>
            ))}
          </select>
        ) : (
          <span id="level-select" className="chamfer border border-holo/70 bg-primary/10 px-3 py-1 font-display text-lg tracking-[0.15em] text-holo tabular-nums">
            {String(c.level).padStart(2, "0")}
          </span>
        )}
        {pending && <span className="font-mono text-[0.62rem] tracking-[0.2em] text-cyan uppercase">Processando evolução…</span>}
        <span className="h-px flex-1 bg-gradient-to-r from-line to-transparent" aria-hidden />
      </div>

      {state.canEdit && ab.blocked && (
        <div role="alert" className="mb-5 border border-alert/60 bg-alert/5 p-3">
          <p className="flex items-center gap-2 font-mono text-[0.7rem] tracking-[0.25em] text-alert uppercase">
            <Lock className="h-3.5 w-3.5" aria-hidden /> Evolução bloqueada
          </p>
          <p className="mt-1 text-sm text-fg-dim">
            Você ainda possui {state.powersTab.plural} disponíveis para criar ({ab.available}). Finalize suas {state.powersTab.plural} antes de avançar para o próximo nível.
          </p>
          <Button size="sm" variant="secondary" className="mt-2" onClick={state.openCreator}>
            <Sparkles className="h-3.5 w-3.5" aria-hidden /> Abrir criador
          </Button>
        </div>
      )}

      <AnimatePresence>{result && <LevelOverlay result={result} state={state} onClose={() => setResult(null)} />}</AnimatePresence>
    </>
  );
}

function LevelOverlay({ result, state, onClose }: { result: Result; state: SheetState; onClose: () => void }) {
  const up = result.to > result.from;
  const forms = [state.base, state.lenda].filter((f): f is NonNullable<typeof f> => Boolean(f));
  const byForm = forms
    .map((f) => ({ form: f, rows: result.rows.filter((r) => r.form_id === f.id).sort((a, b) => a.level - b.level) }))
    .filter((g) => g.rows.length > 0);

  return (
    <motion.div
      className="fixed inset-0 z-50 flex items-center justify-center bg-void/90 p-4 backdrop-blur-sm"
      initial={{ opacity: 0 }}
      animate={{ opacity: 1 }}
      exit={{ opacity: 0 }}
      role="dialog"
      aria-modal="true"
      aria-label={`Nível ${result.to}`}
      onKeyDown={(e) => e.key === "Escape" && onClose()}
    >
      <motion.div
        initial={{ scaleY: 0.05, opacity: 0 }}
        animate={{ scaleY: 1, opacity: 1 }}
        transition={{ duration: 0.35, ease: [0.2, 0.8, 0.2, 1] }}
        className="hud-panel relative max-h-[90dvh] w-[min(94vw,40rem)] overflow-y-auto bg-panel/95 px-6 pt-9 pb-6 shadow-[0_0_90px_-30px_rgb(72_199_255/0.9)]"
      >
        <div className="scanline" aria-hidden />
        <span className="hud-tag">{up ? "Evolução" : "Ganhos suspensos"}</span>
        <div className="flex items-center gap-4">
          {up ? <ChevronsUp className="h-8 w-8 text-cyan" aria-hidden /> : <ChevronsDown className="h-8 w-8 text-fg-dim" aria-hidden />}
          <div>
            <p className="font-mono text-xs tracking-[0.25em] text-fg-dim">
              NÍVEL {String(result.from).padStart(2, "0")} → <span className="text-cyan">{String(result.to).padStart(2, "0")}</span>
            </p>
            <motion.p
              initial={{ letterSpacing: "0.6em", opacity: 0 }}
              animate={{ letterSpacing: "0.12em", opacity: 1 }}
              transition={{ delay: 0.2, duration: 0.4 }}
              className="font-display text-4xl text-fg text-glow"
            >
              {up ? `NÍVEL ${result.to}` : `VOLTOU AO NÍVEL ${result.to}`}
            </motion.p>
          </div>
        </div>

        {!up && (
          <p className="mt-4 text-sm text-fg-dim">
            Os ganhos dos níveis {result.to + 1}–{result.from} ficam guardados e voltam exatamente iguais se o personagem subir de novo. Nada foi apagado.
          </p>
        )}

        {up &&
          byForm.map(({ form, rows }) => {
            let pv = 0;
            let pc = 0;
            return (
              <section key={form.id} className="mt-6">
                <h3 className="label-mono mb-3 text-holo">{form.kind === "lenda" ? `Lenda${form.name ? ` — ${form.name}` : ""}` : "Forma principal"}</h3>
                <ol className="space-y-4">
                  {rows.map((r, i) => {
                    pv += r.pv_gain;
                    pc += r.pc_gain;
                    const delay = 0.35 + i * 0.25;
                    return (
                      <li key={`${r.form_id}:${r.level}`} className="border-b border-line/60 pb-4">
                        <div className="mb-3 flex items-center justify-between gap-2">
                          <span className="font-mono text-xs tracking-[0.2em] text-fg">NÍVEL {String(r.level).padStart(2, "0")}</span>
                          {!r.isNew && (
                            <span className="flex items-center gap-1 font-mono text-[0.6rem] tracking-[0.15em] text-fg-muted uppercase">
                              <History className="h-3 w-3" aria-hidden /> registro recuperado
                            </span>
                          )}
                        </div>
                        <div className="flex flex-wrap items-end gap-6">
                          <div className="flex items-end gap-2">
                            <span className="label-mono mr-1">PV</span>
                            {r.pv_roll.faces.map((f, k) => (
                              <HoloDie key={k} value={f} sides={sidesOf(r.pv_dice)} delay={delay} dim={!r.isNew} />
                            ))}
                            {r.pv_roll.bonus !== 0 && <span className="pb-3 font-mono text-sm text-fg-dim">+{r.pv_roll.bonus}</span>}
                            <span className="pb-3 font-display text-xl text-cyan">= {r.pv_gain}</span>
                          </div>
                          <div className="flex items-end gap-2">
                            <span className="label-mono mr-1">PC</span>
                            {r.pc_roll ? (
                              <>
                                {r.pc_roll.faces.map((f, k) => (
                                  <HoloDie key={k} value={f} sides={sidesOf(r.pc_dice)} delay={delay + 0.1} dim={!r.isNew} />
                                ))}
                                {r.pc_roll.bonus !== 0 && <span className="pb-3 font-mono text-sm text-fg-dim">+{r.pc_roll.bonus}</span>}
                                <span className="pb-3 font-display text-xl text-cyan">= {r.pc_gain}</span>
                              </>
                            ) : (
                              <span className="pb-1 text-sm text-fg-muted">sem PC por nível</span>
                            )}
                          </div>
                        </div>
                        <p className="mt-2 font-mono text-[0.62rem] text-fg-muted">
                          ACUMULADO NESTA SUBIDA: +{pv} PV · +{pc} PC
                        </p>
                      </li>
                    );
                  })}
                </ol>
              </section>
            );
          })}

        {up && byForm.length === 0 && <p className="mt-4 text-sm text-fg-dim">Nenhum ganho novo a mostrar.</p>}

        <div className="mt-6 flex justify-end">
          <Button onClick={onClose} autoFocus>
            Continuar
          </Button>
        </div>
      </motion.div>
    </motion.div>
  );
}
