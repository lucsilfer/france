"use client";

import Link from "next/link";
import { useMemo, useState } from "react";
import { AnimatePresence, motion } from "motion/react";
import { ArrowLeft, ArrowRight, Check } from "lucide-react";
import { Button } from "@/components/ui/Button";
import { SaveIndicator } from "@/components/SaveIndicator";
import { combineStatus, useAutosave } from "@/components/useAutosave";
import { CREATION_STEPS, checkCreation, maxReachableStep, type StoredForm } from "@/rules/sheet.ts";
import { saveCreationStep, saveIdentity, saveSkillPoints, type IdentityInput, type RolledSet } from "../../actions";
import { StepAttributes } from "./StepAttributes";
import { StepOrigin } from "./StepOrigin";
import { StepClass } from "./StepClass";
import { StepSkills } from "./StepSkills";
import { StepIdentity } from "./StepIdentity";
import { FormPortrait } from "../SheetHeader";
import { StepReview } from "./StepReview";

export interface DraftCharacter extends IdentityInput {
  origin_id: string | null;
  origin_path_id: string | null;
  class_id: string | null;
  starting_kit: Record<string, string>;
}

interface Props {
  characterId: string;
  initialStep: number;
  initialCharacter: DraftCharacter;
  initialForm: StoredForm;
  initialPending: RolledSet | null;
  baseForm: { id: string; kind: "base"; portrait_path: string | null };
  portraits: Record<string, string>;
}

export function Wizard({ characterId, initialStep, initialCharacter, initialForm, initialPending, baseForm, portraits }: Props) {
  const [character, setCharacter] = useState(initialCharacter);
  const [form, setForm] = useState(initialForm);
  const [pending, setPending] = useState(initialPending);
  const [portrait, setPortrait] = useState(baseForm);

  const checks = useMemo(
    () =>
      checkCreation({
        classId: character.class_id,
        originId: character.origin_id,
        originPathId: character.origin_path_id,
        name: character.name,
        playerName: character.player_name,
        form,
        kitChoices: character.starting_kit,
      }),
    [character, form],
  );
  const reach = maxReachableStep(checks);
  const [step, setStep] = useState(Math.min(Math.max(1, initialStep), reach));

  const identitySave = useAutosave((v: Partial<IdentityInput>) => saveIdentity(characterId, v));
  const skillsSave = useAutosave((v: Record<string, number>) => saveSkillPoints(characterId, v), 500);
  const [quickStatus, setQuickStatus] = useState<"idle" | "saving" | "saved" | "error">("idle");
  const status = combineStatus(identitySave.status, skillsSave.status, quickStatus);

  async function go(target: number) {
    if (target < 1 || target > 6 || target > reach) return;
    await Promise.all([identitySave.flush(), skillsSave.flush()]);
    setStep(target);
    window.scrollTo({ top: 0, behavior: "smooth" });
    void saveCreationStep(characterId, target);
  }

  /** Para ações imediatas (origem, classe, atributos), mostra o estado no indicador. */
  async function track<T extends { ok: boolean }>(p: Promise<T>): Promise<T> {
    setQuickStatus("saving");
    const r = await p;
    setQuickStatus(r.ok ? "saved" : "error");
    return r;
  }

  function updateIdentity(patch: Partial<IdentityInput>) {
    setCharacter((c) => ({ ...c, ...patch }));
    identitySave.schedule({ ...pickIdentity(character), ...patch });
  }

  function updateSkills(points: Record<string, number>) {
    setForm((f) => ({
      ...f,
      skills: Object.entries(points).map(([skill_id, p]) => ({
        skill_id,
        points: p,
        other_bonus: f.skills.find((s) => s.skill_id === skill_id)?.other_bonus ?? 0,
        temp_bonus: 0,
      })),
    }));
    skillsSave.schedule(points);
  }

  const current = checks[step - 1];

  return (
    <div className="space-y-8">
      <div className="flex flex-wrap items-center justify-between gap-3">
        <Link href="/painel" className="inline-flex items-center gap-2 text-sm text-fg-dim hover:text-cyan">
          <ArrowLeft className="h-4 w-4" aria-hidden /> Painel
        </Link>
        <SaveIndicator status={status} error={identitySave.error ?? skillsSave.error} />
      </div>

      <header className="space-y-2">
        <p className="label-mono">Módulo de criação {"//"} nova unidade</p>
        <h1 className="text-3xl tracking-[0.06em] text-fg uppercase">{character.name.trim() || "Personagem sem nome"}</h1>
      </header>

      <nav aria-label="Etapas da criação">
        <ol className="grid grid-cols-6 gap-1.5 sm:gap-2">
          {CREATION_STEPS.map((s, i) => {
            const done = checks[i].complete && s.step < 6;
            const active = step === s.step;
            const reachable = s.step <= reach;
            return (
              <li key={s.id}>
                <button
                  onClick={() => go(s.step)}
                  disabled={!reachable}
                  aria-current={active ? "step" : undefined}
                  className={`group chamfer flex w-full flex-col gap-1 border px-2 py-2 text-left transition-[border-color,background,box-shadow] disabled:cursor-not-allowed sm:px-3 ${
                    active
                      ? "border-holo bg-primary/15 shadow-[var(--shadow-glow)]"
                      : done
                        ? "border-cyan-dim/60 bg-panel/70 hover:border-holo"
                        : reachable
                          ? "border-line bg-panel/60 hover:border-holo"
                          : "border-line/50 bg-panel-3/50 opacity-50"
                  }`}
                >
                  <span className="flex items-center justify-between font-mono text-[0.6rem] tracking-[0.2em] text-fg-muted">
                    {String(s.step).padStart(2, "0")}
                    {done && <Check className="h-3 w-3 text-cyan" aria-label="concluída" />}
                  </span>
                  <span className={`hidden font-head text-sm font-semibold tracking-[0.12em] uppercase sm:block ${active ? "text-fg" : "text-fg-dim group-hover:text-cyan"}`}>
                    {s.label}
                  </span>
                  <span className={`h-0.5 w-full ${active ? "bg-cyan shadow-[0_0_8px_var(--color-cyan)]" : done ? "bg-cyan-dim" : "bg-line"}`} aria-hidden />
                </button>
              </li>
            );
          })}
        </ol>
        <p className="mt-3 text-sm text-fg-dim sm:hidden">
          Etapa {step} de 6 — <span className="text-fg">{CREATION_STEPS[step - 1].label}</span>
        </p>
      </nav>

      <AnimatePresence mode="wait">
        <motion.section key={step} initial={{ opacity: 0, x: 16 }} animate={{ opacity: 1, x: 0 }} exit={{ opacity: 0, x: -16 }} transition={{ duration: 0.2 }}>
          {step === 1 && (
            <StepAttributes characterId={characterId} form={form} pending={pending} setPending={setPending} setForm={setForm} track={track} />
          )}
          {step === 2 && (
            <StepOrigin
              characterId={characterId}
              originId={character.origin_id}
              pathId={character.origin_path_id}
              track={track}
              onSaved={(origin_id, origin_path_id) => setCharacter((c) => ({ ...c, origin_id, origin_path_id }))}
            />
          )}
          {step === 3 && (
            <StepClass
              characterId={characterId}
              classId={character.class_id}
              originId={character.origin_id}
              form={form}
              kitChoices={character.starting_kit}
              track={track}
              onSaved={(class_id) => setCharacter((c) => ({ ...c, class_id, starting_kit: {} }))}
              onKitChange={(starting_kit) => setCharacter((c) => ({ ...c, starting_kit }))}
            />
          )}
          {step === 4 && <StepSkills classId={character.class_id} form={form} onChange={updateSkills} />}
          {step === 5 && (
            <StepIdentity
              character={character}
              onChange={updateIdentity}
              photo={<FormPortrait characterId={characterId} form={portrait} label="Foto do personagem" portraits={portraits} onChange={(_id, p) => setPortrait((f) => ({ ...f, ...p }))} />}
            />
          )}
          {step === 6 && <StepReview characterId={characterId} character={character} form={form} checks={checks} goTo={go} beforeFinalize={() => Promise.all([identitySave.flush(), skillsSave.flush()])} />}
        </motion.section>
      </AnimatePresence>

      {step < 6 && (
        <div className="flex flex-col-reverse items-stretch justify-between gap-3 border-t border-line pt-6 sm:flex-row sm:items-center">
          <Button variant="ghost" onClick={() => go(step - 1)} disabled={step === 1}>
            <ArrowLeft className="h-4 w-4" aria-hidden /> Voltar
          </Button>
          <div className="flex flex-col items-stretch gap-2 sm:items-end">
            {!current.complete && current.errors[0] && <p className="text-sm text-fg-dim">{current.errors[0]}</p>}
            <Button onClick={() => go(step + 1)} disabled={!current.complete}>
              Próximo <ArrowRight className="h-4 w-4" aria-hidden />
            </Button>
          </div>
        </div>
      )}
    </div>
  );
}

function pickIdentity(c: DraftCharacter): IdentityInput {
  return { name: c.name, player_name: c.player_name, story: c.story, appearance: c.appearance, extra_info: c.extra_info };
}
