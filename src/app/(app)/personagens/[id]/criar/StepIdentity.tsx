"use client";

import { Field } from "@/components/ui/Field";
import type { IdentityInput } from "../../actions";
import type { DraftCharacter } from "./Wizard";

export function StepIdentity({ character, onChange }: { character: DraftCharacter; onChange: (patch: Partial<IdentityInput>) => void }) {
  const nameError = character.name.trim() ? undefined : "Obrigatório para finalizar.";
  const playerError = character.player_name.trim() ? undefined : "Obrigatório para finalizar.";
  return (
    <div className="space-y-6">
      <div>
        <h2 className="text-2xl text-fg">Identidade e história</h2>
        <p className="mt-1 text-sm text-fg-dim">Tudo é salvo automaticamente enquanto você escreve.</p>
      </div>
      <div className="hud-panel space-y-5 px-5 pt-7 pb-6 sm:px-8">
        <span className="hud-tag">Registro</span>
        <div className="grid gap-5 sm:grid-cols-2">
          <Field label="Nome do personagem" error={nameError}>
            <input className="field-input" value={character.name} maxLength={120} onChange={(e) => onChange({ name: e.target.value })} />
          </Field>
          <Field label="Nome do jogador" error={playerError}>
            <input className="field-input" value={character.player_name} maxLength={120} onChange={(e) => onChange({ player_name: e.target.value })} />
          </Field>
        </div>
        <Field label="História do personagem">
          <textarea rows={8} className="field-input resize-y leading-relaxed" value={character.story} maxLength={20000} onChange={(e) => onChange({ story: e.target.value })} />
        </Field>
        <Field label="Descrição física">
          <textarea rows={5} className="field-input resize-y leading-relaxed" value={character.appearance} maxLength={10000} onChange={(e) => onChange({ appearance: e.target.value })} />
        </Field>
        <Field label="Informações adicionais (opcional)">
          <textarea rows={4} className="field-input resize-y leading-relaxed" value={character.extra_info} maxLength={10000} onChange={(e) => onChange({ extra_info: e.target.value })} />
        </Field>
      </div>
    </div>
  );
}
