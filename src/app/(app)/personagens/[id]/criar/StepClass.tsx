"use client";

import { useTransition } from "react";
import { Check } from "lucide-react";
import { Button } from "@/components/ui/Button";
import { useToast } from "@/components/ui/Toast";
import { ClassDetails } from "@/components/sheet/ClassDetails";
import { ATTRIBUTE_IDS } from "@/rules/data/attributes.ts";
import { CLASSES } from "@/rules/data/classes.ts";
import { buildSheet, type StoredForm } from "@/rules/sheet.ts";
import { levelDice } from "@/rules/progression.ts";
import { saveClass, saveKitChoices } from "../../actions";
import { KitChoices } from "@/components/sheet/KitChoices";
import { kitChoiceSlots, type KitChoices as Choices } from "@/rules/data/startingKits.ts";
import { CLASS_BY_ID } from "@/rules/data/classes.ts";

interface Props {
  characterId: string;
  classId: string | null;
  originId: string | null;
  form: StoredForm;
  kitChoices: Choices;
  track: <T extends { ok: boolean }>(p: Promise<T>) => Promise<T>;
  onSaved: (classId: string) => void;
  onKitChange: (choices: Choices) => void;
}

export function StepClass({ characterId, classId, originId, form, kitChoices, track, onSaved, onKitChange }: Props) {
  const toast = useToast();
  const [saving, start] = useTransition();
  const sheet = buildSheet({ classId, originId: null, level: 1, form });

  function select(id: string) {
    start(async () => {
      const res = await track(saveClass(characterId, id));
      if (!res.ok) return toast(res.error, "error");
      onSaved(id);
      onKitChange({}); // escolhas da classe anterior são descartadas
      toast(`Classe selecionada: ${res.message}`);
    });
  }

  return (
    <div className="space-y-6">
      <div>
        <h2 className="text-2xl text-fg">Classe</h2>
        <p className="mt-1 max-w-2xl text-sm text-fg-dim">
          A classe diz como você usa o seu poder. Os bônus são aplicados na hora e saem se você trocar de classe — nada se acumula.
        </p>
      </div>

      {/* Prévia dos valores com a classe atual */}
      <div className="hud-panel px-4 pt-7 pb-4 sm:px-6" aria-live="polite">
        <span className="hud-tag">Prévia da ficha</span>
        <div className="grid grid-cols-4 gap-2 sm:grid-cols-10">
          {ATTRIBUTE_IDS.map((id) => {
            const a = sheet.attributes[id];
            return (
              <div key={id} className="text-center">
                <span className="label-mono block text-holo">{id}</span>
                <span className="font-mono text-fg">{a.final}</span>
                {a.classBonus !== 0 && <span className="block font-mono text-[0.65rem] text-cyan">+{a.classBonus}</span>}
              </div>
            );
          })}
          <div className="text-center">
            <span className="label-mono block">PV</span>
            <span className="font-mono text-fg">{sheet.resources.pvMax}</span>
          </div>
          <div className="text-center">
            <span className="label-mono block">PC</span>
            <span className="font-mono text-fg">{sheet.resources.pcMax}</span>
          </div>
        </div>
        <p className="mt-3 text-xs text-fg-muted">PV = (FOR + CON) ÷ 3 · PC = VIG ÷ 3 (arredondados para baixo), mais benefícios da classe.</p>
      </div>

      <ul className="grid gap-4 md:grid-cols-2 xl:grid-cols-3">
        {CLASSES.map((c) => {
          const selected = classId === c.id;
          return (
            <li key={c.id} className={`hud-panel hud-card flex flex-col p-5 pt-8 ${selected ? "border-2 border-holo bg-primary/10 shadow-[0_0_40px_-12px_rgb(72_199_255/0.8)]" : ""}`}>
              {selected && (
                <span className="hud-tag flex items-center gap-1 text-cyan">
                  <Check className="h-3 w-3" aria-hidden /> Selecionada
                </span>
              )}
              <h3 className="mb-3 text-xl text-holo">{c.name}</h3>
              <div className="flex-1">
                <ClassDetails cls={c} />
              </div>
              <Button className="mt-5" variant={selected ? "secondary" : "primary"} onClick={() => select(c.id)} disabled={selected} loading={saving}>
                {selected ? "Classe selecionada" : "Selecionar classe"}
              </Button>
            </li>
          );
        })}
      </ul>
      {classId && CLASS_BY_ID[classId] && (
        <div className="hud-panel px-4 pt-8 pb-5 sm:px-6">
          <span className="hud-tag">Equipamento inicial — {CLASS_BY_ID[classId].name}</span>
          <p className="mb-4 text-sm text-fg-dim">
            {kitChoiceSlots(classId).length
              ? "Escolha os itens. Eles entram no inventário como itens reais quando você finalizar o personagem."
              : "Estes itens entram no inventário quando você finalizar o personagem."}
          </p>
          <KitChoices
            classId={classId}
            originId={originId}
            choices={kitChoices}
            onChange={(next) => {
              onKitChange(next);
              void track(saveKitChoices(characterId, next)).then((r) => {
                if (!r.ok) toast(r.error, "error");
              });
            }}
          />
        </div>
      )}
      <p className="text-xs text-fg-muted">
        Observação: a origem Prodígio substitui a evolução de PV/PC da classe ({levelDice("brawler", "prodigio").pv} PV, sem PC por nível).
      </p>
    </div>
  );
}
