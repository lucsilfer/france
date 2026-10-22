"use client";

import { useState, useTransition } from "react";
import { Field } from "@/components/ui/Field";
import { useToast } from "@/components/ui/Toast";
import { CLASS_BY_ID } from "@/rules/data/classes.ts";
import { ORIGIN_BY_ID } from "@/rules/data/origins.ts";
import { saveFormIdentity, saveIdentity } from "../actions";
import { EditableSection } from "./EditableSection";
import type { SheetState } from "./Sheet";

export function IdentityCard({ state }: { state: SheetState }) {
  const toast = useToast();
  const { character: c, form, isLenda } = state;
  const [editing, setEditing] = useState(false);
  const [draft, setDraft] = useState({ name: c.name, player_name: c.player_name, lenda_name: form.name });
  const [saving, start] = useTransition();
  const origin = c.origin_id ? ORIGIN_BY_ID[c.origin_id] : undefined;
  const path = origin?.paths?.find((p) => p.id === c.origin_path_id);

  function save() {
    if (!draft.name.trim()) return toast("O personagem precisa de um nome.", "error");
    start(async () => {
      if (isLenda) {
        const r = await saveFormIdentity(c.id, form.id, { name: draft.lenda_name.trim() });
        if (!r.ok) return toast(r.error, "error");
        state.setForm({ name: draft.lenda_name.trim() });
      }
      const res = await saveIdentity(c.id, { name: draft.name.trim(), player_name: draft.player_name.trim() });
      if (!res.ok) return toast(res.error, "error");
      state.setCharacter({ name: draft.name.trim(), player_name: draft.player_name.trim() });
      setEditing(false);
      toast("Identidade salva.");
    });
  }

  return (
    <EditableSection
      title="Registro"
      canEdit={state.canEdit}
      editing={editing}
      saving={saving}
      onEdit={() => {
        setDraft({ name: c.name, player_name: c.player_name, lenda_name: form.name });
        setEditing(true);
      }}
      onCancel={() => setEditing(false)}
      onSave={save}
    >
      {editing ? (
        <div className="grid gap-4 sm:grid-cols-2">
          <Field label="Nome do personagem">
            <input className="field-input" value={draft.name} maxLength={120} onChange={(e) => setDraft({ ...draft, name: e.target.value })} />
          </Field>
          <Field label="Nome do jogador">
            <input className="field-input" value={draft.player_name} maxLength={120} onChange={(e) => setDraft({ ...draft, player_name: e.target.value })} />
          </Field>
          {isLenda && (
            <Field label="Nome da Lenda">
              <input className="field-input" value={draft.lenda_name} maxLength={120} onChange={(e) => setDraft({ ...draft, lenda_name: e.target.value })} />
            </Field>
          )}
        </div>
      ) : (
        <div>
          {isLenda && <p className="label-mono text-cyan">Forma Lenda ativa</p>}
          <h1 className="text-3xl leading-tight tracking-[0.06em] text-fg uppercase text-glow">{isLenda ? form.name || "Lenda" : c.name}</h1>
          <p className="mt-1 text-sm text-fg-dim">
            {isLenda && <>Forma humana: {c.name} · </>}Jogador: {c.player_name || "—"}
          </p>
          <dl className="mt-4 grid grid-cols-2 gap-3 text-sm">
            <div>
              <dt className="label-mono">Classe</dt>
              <dd className="text-fg">
                {(c.class_id && CLASS_BY_ID[c.class_id]?.name) || "—"}
                {isLenda && <span className="block text-xs text-fg-muted">Bônus de classe não se aplicam à Lenda</span>}
              </dd>
            </div>
            <div>
              <dt className="label-mono">Origem</dt>
              <dd className="text-fg">
                {origin?.name ?? "—"}
                {path && <span className="block text-xs text-cyan-dim">{path.name}</span>}
              </dd>
            </div>
          </dl>
        </div>
      )}
    </EditableSection>
  );
}
