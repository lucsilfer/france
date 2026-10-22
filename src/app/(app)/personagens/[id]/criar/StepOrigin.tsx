"use client";

import { useState, useTransition } from "react";
import { AnimatePresence, motion } from "motion/react";
import { Check, ChevronDown } from "lucide-react";
import { Button } from "@/components/ui/Button";
import { useToast } from "@/components/ui/Toast";
import { ORIGINS, type OriginTrait } from "@/rules/data/origins.ts";
import { saveOrigin } from "../../actions";
import { TraitList } from "@/components/sheet/TraitList";

interface Props {
  characterId: string;
  originId: string | null;
  pathId: string | null;
  track: <T extends { ok: boolean }>(p: Promise<T>) => Promise<T>;
  onSaved: (originId: string, pathId: string | null) => void;
}

export function StepOrigin({ characterId, originId, pathId, track, onSaved }: Props) {
  const toast = useToast();
  const [open, setOpen] = useState<string | null>(originId);
  const [pinned, setPinned] = useState<string | null>(null);
  const [draftPath, setDraftPath] = useState<Record<string, string | null>>(originId ? { [originId]: pathId } : {});
  const [saving, start] = useTransition();

  function select(id: string, path: string | null) {
    start(async () => {
      const res = await track(saveOrigin(characterId, id, path));
      if (!res.ok) return toast(res.error, "error");
      onSaved(id, path);
      toast(`Origem selecionada: ${res.message}`);
    });
  }

  return (
    <div className="space-y-6">
      <div>
        <h2 className="text-2xl text-fg">Origem</h2>
        <p className="mt-1 max-w-2xl text-sm text-fg-dim">
          A origem responde de onde vem o poder do seu personagem. Passe o mouse (ou toque) para ver os detalhes e escolha uma.
        </p>
      </div>

      <ul className="space-y-3">
        {ORIGINS.map((o) => {
          const expanded = open === o.id;
          const selected = originId === o.id;
          const chosenPath = draftPath[o.id] ?? null;
          const needsPath = Boolean(o.paths?.length);
          const isCurrent = selected && (!needsPath || chosenPath === pathId);
          return (
            <li
              key={o.id}
              onMouseEnter={() => !pinned && setOpen(o.id)}
              onMouseLeave={() => !pinned && setOpen(originId)}
              className={`hud-panel hud-card overflow-hidden ${expanded ? "border-holo/70 bg-primary/[0.06] shadow-[var(--shadow-glow)]" : ""} ${selected ? "border-holo" : ""}`}
            >
              <button
                className="flex w-full items-center gap-4 px-5 py-4 text-left"
                aria-expanded={expanded}
                aria-controls={`origin-${o.id}`}
                onClick={() => {
                  const next = expanded && pinned === o.id ? null : o.id;
                  setPinned(next);
                  setOpen(next ?? originId);
                }}
              >
                <div className="min-w-0 flex-1">
                  <div className="flex items-center gap-2">
                    <h3 className="text-lg text-fg">{o.name}</h3>
                    {selected && (
                      <span className="label-mono flex items-center gap-1 text-cyan">
                        <Check className="h-3 w-3" aria-hidden /> selecionada
                      </span>
                    )}
                  </div>
                  <p className="text-sm text-fg-dim">{o.summary}</p>
                </div>
                <ChevronDown className={`h-4 w-4 shrink-0 text-fg-muted transition-transform ${expanded ? "rotate-180" : ""}`} aria-hidden />
              </button>

              <AnimatePresence initial={false}>
                {expanded && (
                  <motion.div
                    id={`origin-${o.id}`}
                    initial={{ height: 0, opacity: 0 }}
                    animate={{ height: "auto", opacity: 1 }}
                    exit={{ height: 0, opacity: 0 }}
                    transition={{ duration: 0.22 }}
                    className="overflow-hidden"
                  >
                    <div className="space-y-5 border-t border-line px-5 pt-4 pb-5">
                      {o.description.map((p, i) => (
                        <p key={i} className="text-sm leading-relaxed text-fg-dim">
                          {p}
                        </p>
                      ))}
                      <TraitList traits={o.traits as OriginTrait[]} />

                      {o.paths && (
                        <fieldset className="space-y-3">
                          <legend className="label-mono mb-2 text-holo">Escolha o Caminho</legend>
                          <div className="grid gap-3 md:grid-cols-3">
                            {o.paths.map((p) => {
                              const on = chosenPath === p.id;
                              return (
                                <label
                                  key={p.id}
                                  className={`flex cursor-pointer flex-col gap-2 rounded-sm border p-4 transition-colors ${
                                    on ? "border-cyan bg-cyan/5" : "border-line bg-void/40 hover:border-line-strong"
                                  }`}
                                >
                                  <span className="flex items-center gap-2">
                                    <input
                                      type="radio"
                                      name={`path-${o.id}`}
                                      checked={on}
                                      onChange={() => setDraftPath((d) => ({ ...d, [o.id]: p.id }))}
                                      className="accent-[var(--color-primary)]"
                                    />
                                    <span className="font-display text-sm text-fg">{p.name}</span>
                                  </span>
                                  <TraitList traits={p.traits} compact />
                                </label>
                              );
                            })}
                          </div>
                        </fieldset>
                      )}

                      <div className="flex justify-end">
                        <Button
                          onClick={() => select(o.id, needsPath ? chosenPath : null)}
                          loading={saving}
                          disabled={isCurrent || (needsPath && !chosenPath)}
                        >
                          {isCurrent ? "Origem selecionada" : needsPath && !chosenPath ? "Escolha um Caminho" : "Selecionar origem"}
                        </Button>
                      </div>
                    </div>
                  </motion.div>
                )}
              </AnimatePresence>
            </li>
          );
        })}
      </ul>
    </div>
  );
}
