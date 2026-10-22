"use client";

import { useEffect, useState, useTransition } from "react";
import { motion, useReducedMotion } from "motion/react";
import { Dices } from "lucide-react";
import { Button } from "@/components/ui/Button";
import { useToast } from "@/components/ui/Toast";
import { D6 } from "@/components/dice/D6";
import { StatReadout } from "@/components/hud/StatReadout";
import { ATTRIBUTES } from "@/rules/data/attributes.ts";
import { formatThresholds } from "@/rules/d100.ts";
import type { StoredForm } from "@/rules/sheet.ts";
import { assignAttribute, rollAttributes, type RolledSet } from "../../actions";

interface Props {
  characterId: string;
  /** Forma que recebe os atributos (Lenda do Artificial); vazio = forma principal. */
  formId?: string | null;
  form: StoredForm;
  pending: RolledSet | null;
  setPending: (r: RolledSet | null) => void;
  setForm: (f: (prev: StoredForm) => StoredForm) => void;
  track: <T extends { ok: boolean }>(p: Promise<T>) => Promise<T>;
}

const DIE_STAGGER = 0.12;

export function StepAttributes({ characterId, formId, form, pending, setPending, setForm, track }: Props) {
  const toast = useToast();
  const [rolling, startRoll] = useTransition();
  const [assigning, startAssign] = useTransition();
  /** Rolagem que deve animar (nova). Rolagens já pendentes ao abrir a página aparecem prontas. */
  const [animatingId, setAnimatingId] = useState<string | null>(null);
  const [revealed, setRevealed] = useState<number>(pending ? 3 : 0);
  const reduceMotion = useReducedMotion();

  const values = new Map(form.attributes.filter((a) => a.base_value != null).map((a) => [a.attribute, a.base_value as number]));
  const filled = values.size;
  const done = filled === ATTRIBUTES.length;
  const ready = pending !== null && revealed >= 3;

  // Revela os três resultados um a um enquanto os dados assentam.
  useEffect(() => {
    if (!pending || animatingId !== pending.id) return;
    if (reduceMotion) {
      setRevealed(3);
      return;
    }
    setRevealed(0);
    const timers = [0, 1, 2].map((g) => setTimeout(() => setRevealed(g + 1), (1.05 + (g * 3 + 2) * DIE_STAGGER) * 1000));
    return () => timers.forEach(clearTimeout);
  }, [pending, animatingId, reduceMotion]);

  function roll() {
    startRoll(async () => {
      const res = await track(rollAttributes(characterId, formId));
      if (!res.ok) return toast(res.error, "error");
      setAnimatingId(res.data!.id);
      setPending(res.data!);
    });
  }

  function assign(attr: string) {
    if (!pending || !ready || values.has(attr)) return;
    const roll = pending;
    startAssign(async () => {
      const res = await track(assignAttribute(characterId, roll.id, attr, formId));
      if (!res.ok) return toast(res.error, "error");
      setForm((f) => {
        const others = f.attributes.filter((a) => a.attribute !== attr);
        return { ...f, attributes: [...others, { attribute: attr, base_value: roll.best, other_bonus: 0, temp_bonus: 0 }] };
      });
      setPending(null);
      setAnimatingId(null);
      setRevealed(0);
    });
  }

  const bestIndex = pending ? pending.results.indexOf(pending.best) : -1;

  return (
    <div className="space-y-8">
      <div>
        <h2 className="text-2xl text-fg">Atributos</h2>
        <p className="mt-1 max-w-2xl text-sm text-fg-dim">
          Cada rolagem faz três lançamentos de <span className="font-mono text-fg">3d6 × 5</span>. O maior fica; os outros dois são
          descartados. Atribua o resultado a um atributo vazio e repita até preencher os oito. As rolagens acontecem no servidor e ficam
          gravadas — recarregar a página não rola de novo.
        </p>
      </div>

      {/* Mesa de dados */}
      <div className="hud-panel overflow-hidden px-4 pt-7 pb-6 sm:px-8">
        <span className="hud-tag">Módulo de rolagem {"//"} 3d6 × 5</span>
        <div className="scanline" aria-hidden />
        {pending ? (
          <div className="grid gap-4 sm:grid-cols-3" aria-live="polite">
            {[0, 1, 2].map((g) => {
              const faces = pending.faces.slice(g * 3, g * 3 + 3);
              const shown = revealed > g;
              const best = shown && ready && g === bestIndex;
              const discarded = ready && g !== bestIndex;
              return (
                <motion.div
                  key={`${pending.id}-${g}`}
                  animate={{ opacity: discarded ? 0.4 : 1, scale: best ? 1.03 : 1 }}
                  className={`flex flex-col items-center gap-4 rounded-sm border px-3 py-5 transition-colors ${
                    best ? "border-cyan bg-cyan/5 shadow-[0_0_30px_-8px_rgb(72_199_255/0.5)]" : "border-line bg-void/40"
                  }`}
                >
                  <div className="flex gap-3">
                    {faces.map((v, i) => (
                      <D6
                        key={i}
                        value={v}
                        rollKey={`${pending.id}-${g}-${i}`}
                        animate={animatingId === pending.id}
                        delay={(g * 3 + i) * DIE_STAGGER}
                        dim={discarded}
                      />
                    ))}
                  </div>
                  <div className="text-center">
                    <span className="label-mono block">
                      Lançamento {g + 1}
                      {best && " · escolhido"}
                      {discarded && " · descartado"}
                    </span>
                    <span className={`font-display text-3xl ${best ? "text-cyan" : discarded ? "text-fg-muted line-through" : "text-fg"}`}>
                      {shown ? pending.results[g] : "··"}
                    </span>
                    {shown && <span className="block font-mono text-[0.65rem] text-fg-muted">({faces.join(" + ")}) × 5</span>}
                  </div>
                </motion.div>
              );
            })}
          </div>
        ) : (
          <div className="flex flex-col items-center gap-3 py-8 text-center text-fg-dim">
            <Dices className="h-10 w-10 text-cyan-dim" aria-hidden />
            <p>{done ? "Os oito atributos estão definidos." : "Role os dados para gerar o próximo atributo."}</p>
          </div>
        )}
        <div className="mt-6 flex flex-col items-center gap-2">
          {!done && (
            <Button onClick={roll} loading={rolling} disabled={pending !== null}>
              <Dices className="h-4 w-4" aria-hidden /> Rolar atributos
            </Button>
          )}
          {pending && ready && (
            <p className="text-sm text-fg" role="status">
              Escolha um atributo vazio para receber <strong className="text-cyan">{pending.best}</strong>.
            </p>
          )}
          <p className="label-mono">{filled} de 8 definidos</p>
        </div>
      </div>

      {/* Atributos */}
      <ul className="grid grid-cols-2 gap-3 sm:grid-cols-4">
        {ATTRIBUTES.map((a) => {
          const v = values.get(a.id);
          const clickable = v === undefined && ready && !assigning;
          return (
            <li key={a.id}>
              <button
                onClick={() => assign(a.id)}
                disabled={!clickable}
                aria-label={v !== undefined ? `${a.name}: ${formatThresholds(v)}` : clickable ? `Atribuir ${pending?.best} a ${a.name}` : `${a.name}: vazio`}
                className={`hud-panel flex h-full w-full px-3 pt-3 pb-2.5 transition-all ${
                  v !== undefined
                    ? "border-line-strong"
                    : clickable
                      ? "cursor-pointer border-dashed border-holo bg-primary/10 hover:bg-primary/20 hover:shadow-[var(--shadow-glow)]"
                      : "border-dashed opacity-70"
                }`}
              >
                <StatReadout code={a.id} name={a.name} value={v ?? null} placeholder={clickable ? `+${pending?.best}` : undefined} />
              </button>
            </li>
          );
        })}
      </ul>
      <p className="text-xs text-fg-muted">Valor grande: acerto normal · BOM: ÷2 · EXT (extremo): ÷5 — arredondados para baixo.</p>
    </div>
  );
}
