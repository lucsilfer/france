"use client";

import Link from "next/link";
import { useMemo, useState, useTransition } from "react";
import { AnimatePresence, motion } from "motion/react";
import { ArrowLeft, ArrowRight, Check, Sparkles } from "lucide-react";
import { Button } from "@/components/ui/Button";
import { Field } from "@/components/ui/Field";
import { SaveIndicator } from "@/components/SaveIndicator";
import { combineStatus, useAutosave } from "@/components/useAutosave";
import { useToast } from "@/components/ui/Toast";
import type { FormRow } from "@/lib/character";
import { ATTRIBUTES } from "@/rules/data/attributes.ts";
import { formatThresholds } from "@/rules/d100.ts";
import { LENDA_STEPS, buildSheet, checkLendaCreation, maxReachableStep } from "@/rules/sheet.ts";
import { completeLendaForm, saveFormIdentity, saveSkillPoints, type LendaIdentityInput, type RolledSet } from "../../actions";
import { StepAttributes } from "../criar/StepAttributes";
import { StepSkills } from "../criar/StepSkills";

interface Props {
  characterId: string;
  characterName: string;
  level: number;
  initialForm: FormRow;
  initialPending: RolledSet | null;
}

export function LendaWizard({ characterId, characterName, level, initialForm, initialPending }: Props) {
  const toast = useToast();
  const [form, setFormState] = useState(initialForm);
  const [pending, setPending] = useState(initialPending);
  const [identity, setIdentity] = useState<LendaIdentityInput>({ name: initialForm.name, description: initialForm.description, special_rules: initialForm.special_rules });
  const [finishing, startFinish] = useTransition();

  const checks = useMemo(() => checkLendaCreation({ name: identity.name, form, level: 1 }), [identity.name, form]);
  const reach = maxReachableStep(checks);
  const [step, setStep] = useState(1);
  const last = LENDA_STEPS.length;

  const identitySave = useAutosave((v: Partial<LendaIdentityInput>) => saveFormIdentity(characterId, form.id, v));
  const skillsSave = useAutosave((v: Record<string, number>) => saveSkillPoints(characterId, v, form.id), 500);
  const [quickStatus, setQuickStatus] = useState<"idle" | "saving" | "saved" | "error">("idle");
  const status = combineStatus(identitySave.status, skillsSave.status, quickStatus);

  async function track<T extends { ok: boolean }>(p: Promise<T>): Promise<T> {
    setQuickStatus("saving");
    const r = await p;
    setQuickStatus(r.ok ? "saved" : "error");
    return r;
  }

  async function go(target: number) {
    if (target < 1 || target > last || target > reach) return;
    await Promise.all([identitySave.flush(), skillsSave.flush()]);
    setStep(target);
    window.scrollTo({ top: 0, behavior: "smooth" });
  }

  function setForm(f: (prev: FormRow) => FormRow) {
    setFormState(f);
  }

  function updateSkills(points: Record<string, number>) {
    setFormState((f) => ({
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

  function updateIdentity(patch: Partial<LendaIdentityInput>) {
    const next = { ...identity, ...patch };
    setIdentity(next);
    identitySave.schedule(next);
  }

  function finish() {
    startFinish(async () => {
      await Promise.all([identitySave.flush(), skillsSave.flush()]);
      const res = await completeLendaForm(characterId);
      // Em sucesso o servidor redireciona para a ficha.
      if (res && !res.ok) toast(res.error, "error");
    });
  }

  const current = checks[step - 1];
  const sheet = buildSheet({ classId: null, originId: "artificial", level: 1, form });

  return (
    <div className="space-y-8">
      <div className="flex flex-wrap items-center justify-between gap-3">
        <Link href={`/personagens/${characterId}`} className="inline-flex items-center gap-2 text-sm text-fg-dim hover:text-cyan">
          <ArrowLeft className="h-4 w-4" aria-hidden /> Voltar à ficha
        </Link>
        <SaveIndicator status={status} error={identitySave.error ?? skillsSave.error} />
      </div>

      <header className="space-y-2">
        <p className="label-mono flex items-center gap-1.5 text-cyan">
          <Sparkles className="h-3.5 w-3.5" aria-hidden /> Forma secundária {"//"} {characterName}
        </p>
        <h1 className="text-3xl tracking-[0.06em] text-fg uppercase">{identity.name.trim() || "Lenda sem nome"}</h1>
        <p className="max-w-2xl text-sm text-fg-dim">
          A Lenda tem atributos, perícias, PV, PC, nome e descrição próprios. Inventário e poderes são compartilhados com a forma humana. Não há
          escolha de origem nem de classe, e bônus de classe não se aplicam.
        </p>
      </header>

      <nav aria-label="Etapas da Lenda">
        <ol className="grid grid-cols-4 gap-2">
          {LENDA_STEPS.map((s, i) => {
            const done = checks[i].complete && s.step < last;
            const active = step === s.step;
            const reachable = s.step <= reach;
            return (
              <li key={s.id}>
                <button
                  onClick={() => go(s.step)}
                  disabled={!reachable}
                  aria-current={active ? "step" : undefined}
                  className={`chamfer flex w-full flex-col gap-1 border px-3 py-2 text-left disabled:cursor-not-allowed ${
                    active ? "border-holo bg-primary/15 shadow-[var(--shadow-glow)]" : done ? "border-cyan-dim/60 bg-panel/70 hover:border-holo" : reachable ? "border-line bg-panel/60 hover:border-holo" : "border-line/50 bg-panel-3/50 opacity-50"
                  }`}
                >
                  <span className="flex items-center justify-between font-mono text-[0.6rem] tracking-[0.2em] text-fg-muted">
                    {String(s.step).padStart(2, "0")}
                    {done && <Check className="h-3 w-3 text-cyan" aria-label="concluída" />}
                  </span>
                  <span className={`font-head text-sm font-semibold tracking-[0.12em] uppercase ${active ? "text-fg" : "text-fg-dim"}`}>{s.label}</span>
                </button>
              </li>
            );
          })}
        </ol>
      </nav>

      <AnimatePresence mode="wait">
        <motion.section key={step} initial={{ opacity: 0, x: 16 }} animate={{ opacity: 1, x: 0 }} exit={{ opacity: 0, x: -16 }} transition={{ duration: 0.2 }}>
          {step === 1 && (
            <StepAttributes
              characterId={characterId}
              formId={form.id}
              form={form}
              pending={pending}
              setPending={setPending}
              setForm={(f) => setForm((prev) => ({ ...prev, ...f(prev) }))}
              track={track}
            />
          )}
          {step === 2 && <StepSkills classId={null} form={form} onChange={updateSkills} />}
          {step === 3 && (
            <div className="space-y-5">
              <h2 className="text-2xl text-fg">Identidade da Lenda</h2>
              <Field label="Nome da Lenda">
                <input className="field-input" maxLength={120} value={identity.name} onChange={(e) => updateIdentity({ name: e.target.value })} />
              </Field>
              <Field label="Descrição física">
                <textarea rows={5} className="field-input resize-y" maxLength={10000} value={identity.description} onChange={(e) => updateIdentity({ description: e.target.value })} />
              </Field>
              <Field label="Informações da Lenda" hint="Opcional: comportamento, aparência ao transformar, observações.">
                <textarea rows={3} className="field-input resize-y" maxLength={10000} value={identity.special_rules} onChange={(e) => updateIdentity({ special_rules: e.target.value })} />
              </Field>
            </div>
          )}
          {step === 4 && (
            <div className="space-y-6">
              <h2 className="text-2xl text-fg">Revisão</h2>
              <div className="hud-panel grid gap-4 p-5 sm:grid-cols-3">
                <div>
                  <p className="label-mono">PV iniciais</p>
                  <p className="font-display text-3xl text-cyan">{sheet.resources.pvMax}</p>
                </div>
                <div>
                  <p className="label-mono">PC iniciais</p>
                  <p className="font-display text-3xl text-cyan">{sheet.resources.pcMax}</p>
                </div>
                <div>
                  <p className="label-mono">Nível do personagem</p>
                  <p className="font-display text-3xl text-fg">{level}</p>
                  {level > 1 && <p className="text-xs text-fg-muted">Os níveis 2–{level} da Lenda serão rolados ao concluir.</p>}
                </div>
              </div>
              <div className="hud-panel p-5">
                <p className="label-mono mb-3">Atributos</p>
                <ul className="grid grid-cols-2 gap-2 sm:grid-cols-4">
                  {ATTRIBUTES.map((a) => (
                    <li key={a.id} className="text-sm">
                      <span className="text-fg-dim">{a.name}</span> <span className="font-mono text-fg">{sheet.attributes[a.id].final}</span>
                    </li>
                  ))}
                </ul>
              </div>
              <div className="hud-panel p-5">
                <p className="label-mono mb-3">Perícias treinadas</p>
                <ul className="grid gap-1 sm:grid-cols-2">
                  {sheet.skills
                    .filter((s) => s.points > 0)
                    .map((s) => (
                      <li key={s.id} className="text-sm">
                        <span className="text-fg-dim">{s.name}</span> <span className="font-mono text-fg">{formatThresholds(s.final)}</span>
                      </li>
                    ))}
                </ul>
              </div>
              {!checks[last - 1].complete && <p className="text-sm text-alert">{checks.find((c) => !c.complete)?.errors[0]}</p>}
              <div className="flex justify-end">
                <Button onClick={finish} loading={finishing} disabled={!checks[last - 1].complete}>
                  <Sparkles className="h-4 w-4" aria-hidden /> Concluir Lenda
                </Button>
              </div>
            </div>
          )}
        </motion.section>
      </AnimatePresence>

      {step < last && (
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
