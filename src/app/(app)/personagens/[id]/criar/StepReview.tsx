"use client";

import { useTransition } from "react";
import { AlertTriangle, ScrollText } from "lucide-react";
import { Button } from "@/components/ui/Button";
import { useToast } from "@/components/ui/Toast";
import { ClassDetails } from "@/components/sheet/ClassDetails";
import { TraitList } from "@/components/sheet/TraitList";
import { ATTRIBUTES } from "@/rules/data/attributes.ts";
import { CLASS_BY_ID } from "@/rules/data/classes.ts";
import { formatThresholds } from "@/rules/d100.ts";
import { buildSheet, originTraitsWithStatus, CREATION_STEPS, type StepCheck, type StoredForm } from "@/rules/sheet.ts";
import { finalizeCharacter } from "../../actions";
import type { DraftCharacter } from "./Wizard";

interface Props {
  characterId: string;
  character: DraftCharacter;
  form: StoredForm;
  checks: StepCheck[];
  goTo: (step: number) => void;
  beforeFinalize: () => Promise<unknown>;
}

function Block({ title, step, goTo, children }: { title: string; step: number; goTo: (s: number) => void; children: React.ReactNode }) {
  return (
    <section className="hud-panel px-5 pt-7 pb-5 sm:px-6">
      <span className="hud-tag">{title}</span>
      <button onClick={() => goTo(step)} className="absolute top-3 right-4 text-xs text-fg-dim underline-offset-4 hover:text-cyan hover:underline">
        Editar
      </button>
      {children}
    </section>
  );
}

export function StepReview({ characterId, character, form, checks, goTo, beforeFinalize }: Props) {
  const toast = useToast();
  const [pending, start] = useTransition();
  const sheet = buildSheet({ classId: character.class_id, originId: character.origin_id, level: 1, form });
  const cls = character.class_id ? CLASS_BY_ID[character.class_id] : undefined;
  const { origin, path, traits } = originTraitsWithStatus(character.origin_id, character.origin_path_id, 1);
  const problems = checks.filter((c) => c.step < 6 && !c.complete);
  const chosenSkills = sheet.skills.filter((s) => s.points > 0 || s.classBonus !== 0);

  function finalize() {
    start(async () => {
      await beforeFinalize();
      const res = await finalizeCharacter(characterId);
      // Sucesso redireciona para a ficha; aqui só chega em erro.
      if (res && !res.ok) toast(res.error, "error");
    });
  }

  return (
    <div className="space-y-6">
      <div>
        <h2 className="text-2xl text-fg">Revisão</h2>
        <p className="mt-1 text-sm text-fg-dim">Confira tudo antes de finalizar. Depois disso, as alterações são feitas pela ficha.</p>
      </div>

      {problems.length > 0 && (
        <div role="alert" className="space-y-2 rounded-sm border border-alert/50 bg-alert/10 px-4 py-3 text-sm">
          {problems.map((p) => (
            <p key={p.step} className="flex items-start gap-2 text-alert">
              <AlertTriangle className="mt-0.5 h-4 w-4 shrink-0" aria-hidden />
              <span>
                {CREATION_STEPS[p.step - 1].label}: {p.errors[0]}{" "}
                <button className="underline" onClick={() => goTo(p.step)}>
                  corrigir
                </button>
              </span>
            </p>
          ))}
        </div>
      )}

      <Block title="Identidade" step={5} goTo={goTo}>
        <h3 className="text-2xl text-fg">{character.name || "Sem nome"}</h3>
        <p className="text-sm text-fg-dim">Jogador: {character.player_name || "—"}</p>
        <p className="mt-2 text-sm text-fg">
          {cls?.name ?? "Sem classe"} · {origin?.name ?? "Sem origem"}
          {path ? ` — ${path.name}` : ""} · Nível 1
        </p>
      </Block>

      <div className="grid gap-6 lg:grid-cols-2">
        <Block title="Atributos" step={1} goTo={goTo}>
          <ul className="grid grid-cols-2 gap-x-6 gap-y-2">
            {ATTRIBUTES.map((a) => {
              const v = sheet.attributes[a.id];
              return (
                <li key={a.id} className="flex items-baseline justify-between gap-2 border-b border-line/60 pb-1">
                  <span className="font-display text-sm text-holo">{a.id}</span>
                  <span className="font-mono text-fg">
                    {formatThresholds(v.final)}
                    {v.classBonus !== 0 && <span className="ml-1 text-xs text-cyan">(+{v.classBonus})</span>}
                  </span>
                </li>
              );
            })}
          </ul>
          <div className="mt-4 grid grid-cols-2 gap-3 text-center">
            <div className="rounded-sm border border-primary-deep/60 bg-primary-deep/15 py-2">
              <span className="label-mono block">PV</span>
              <span className="font-display text-2xl text-fg">{sheet.resources.pvMax}</span>
            </div>
            <div className="rounded-sm border border-cyan-dim/60 bg-cyan/5 py-2">
              <span className="label-mono block">PC</span>
              <span className="font-display text-2xl text-fg">{sheet.resources.pcMax}</span>
            </div>
          </div>
        </Block>

        <Block title="Perícias" step={4} goTo={goTo}>
          <ul className="space-y-1.5">
            {sheet.skills.map((s) => (
              <li key={s.id} className={`flex justify-between gap-2 text-sm ${chosenSkills.includes(s) ? "text-fg" : "text-fg-muted"}`}>
                <span>
                  {s.name}
                  {s.points > 0 && <span className="ml-2 font-mono text-xs text-cyan">+{s.points} pts</span>}
                  {s.classBonus !== 0 && <span className="ml-2 font-mono text-xs text-cyan">+{s.classBonus} classe</span>}
                </span>
                <span className="font-mono">{formatThresholds(s.final)}</span>
              </li>
            ))}
          </ul>
        </Block>
      </div>

      {origin && (
        <Block title={`Origem — ${origin.name}${path ? ` · ${path.name}` : ""}`} step={2} goTo={goTo}>
          <TraitList traits={traits} level={1} />
        </Block>
      )}
      {cls && (
        <Block title={`Classe — ${cls.name}`} step={3} goTo={goTo}>
          <ClassDetails cls={cls} />
        </Block>
      )}

      {(character.story || character.appearance) && (
        <Block title="História" step={5} goTo={goTo}>
          {character.story && <p className="text-sm leading-relaxed whitespace-pre-line text-fg-dim">{character.story}</p>}
          {character.appearance && (
            <>
              <p className="label-mono mt-4">Descrição física</p>
              <p className="mt-1 text-sm leading-relaxed whitespace-pre-line text-fg-dim">{character.appearance}</p>
            </>
          )}
        </Block>
      )}

      <div className="flex flex-col items-center gap-3 border-t border-line pt-8">
        <Button onClick={finalize} loading={pending} disabled={problems.length > 0} className="px-8 py-3">
          <ScrollText className="h-4 w-4" aria-hidden /> Finalizar personagem
        </Button>
        <p className="text-xs text-fg-muted">PV e PC atuais começam cheios. O servidor confere todas as regras antes de salvar.</p>
      </div>
    </div>
  );
}
