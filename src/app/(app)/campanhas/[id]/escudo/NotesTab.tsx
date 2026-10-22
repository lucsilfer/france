"use client";

import { useState } from "react";
import { Plus, Search, Share2, Trash2 } from "lucide-react";
import { Button } from "@/components/ui/Button";
import { ConfirmDialog } from "@/components/ui/ConfirmDialog";
import { SaveIndicator } from "@/components/SaveIndicator";
import { useAutosave } from "@/components/useAutosave";
import type { NoteRow } from "@/lib/campaign-types";
import { createNote, deleteNote, saveNote, type NoteInput } from "../../actions";
import { Empty, SectionTitle, useAct } from "./kit";

export function NotesTab({ campaignId, initial }: { campaignId: string; initial: NoteRow[] }) {
  const { act, busy } = useAct();
  const [notes, setNotes] = useState(initial);
  const [selected, setSelected] = useState<string | null>(initial[0]?.id ?? null);
  const [q, setQ] = useState("");
  const [cat, setCat] = useState("");
  const categories = Array.from(new Set(notes.map((n) => n.category).filter(Boolean))).sort();
  const list = notes
    .filter((n) => !cat || n.category === cat)
    .filter((n) => !q || `${n.title} ${n.content} ${n.category}`.toLowerCase().includes(q.toLowerCase()));
  const note = notes.find((n) => n.id === selected) ?? null;

  return (
    <div className="grid gap-4 lg:grid-cols-[17rem_1fr]">
      <aside className="space-y-2">
        <SectionTitle>Anotações</SectionTitle>
        <Button
          size="sm"
          className="w-full"
          loading={busy}
          onClick={() =>
            act(
              () => createNote(campaignId, { title: "Nova anotação", category: cat, content: "", is_private: true }),
              (n) => {
                if (!n) return;
                setNotes((l) => [n, ...l]);
                setSelected(n.id);
              },
              true,
            )
          }
        >
          <Plus className="h-3.5 w-3.5" aria-hidden /> Nova anotação
        </Button>
        <label className="relative block">
          <Search className="pointer-events-none absolute top-1/2 left-2.5 h-4 w-4 -translate-y-1/2 text-fg-muted" aria-hidden />
          <input className="field-input pl-8 text-sm" placeholder="Buscar…" value={q} onChange={(e) => setQ(e.target.value)} aria-label="Buscar anotações" />
        </label>
        {categories.length > 0 && (
          <select className="field-input text-sm" value={cat} onChange={(e) => setCat(e.target.value)} aria-label="Categoria">
            <option value="">Todas as categorias</option>
            {categories.map((c) => (
              <option key={c} value={c}>
                {c}
              </option>
            ))}
          </select>
        )}
        <ul className="max-h-[32rem] space-y-1 overflow-y-auto">
          {list.map((n) => (
            <li key={n.id}>
              <button
                type="button"
                onClick={() => setSelected(n.id)}
                className={`w-full border px-3 py-2 text-left text-sm ${n.id === selected ? "border-cyan bg-cyan/10 text-fg" : "border-line/60 text-fg-dim hover:border-line-strong"}`}
              >
                <span className="block truncate">{n.title || "Sem título"}</span>
                <span className="font-mono text-[0.58rem] tracking-[0.12em] text-fg-muted uppercase">
                  {n.category || "Geral"}
                  {!n.is_private && <span className="text-ok"> · compartilhada</span>}
                </span>
              </button>
            </li>
          ))}
        </ul>
      </aside>
      <section className="min-w-0">
        {note ? (
          <NoteEditor
            key={note.id}
            campaignId={campaignId}
            note={note}
            categories={categories}
            onLocal={(patch) => setNotes((l) => l.map((x) => (x.id === note.id ? { ...x, ...patch } : x)))}
            onDeleted={() => {
              setNotes((l) => l.filter((x) => x.id !== note.id));
              setSelected(null);
            }}
          />
        ) : (
          <Empty>Anotações são privadas do Mestre, a menos que você as compartilhe.</Empty>
        )}
      </section>
    </div>
  );
}

function NoteEditor({ campaignId, note, categories, onLocal, onDeleted }: { campaignId: string; note: NoteRow; categories: string[]; onLocal: (p: Partial<NoteRow>) => void; onDeleted: () => void }) {
  const { act, busy } = useAct();
  const [v, setV] = useState<NoteInput>({ title: note.title, category: note.category, content: note.content, is_private: note.is_private });
  const [confirm, setConfirm] = useState(false);
  const auto = useAutosave((value: NoteInput) => saveNote(campaignId, note.id, value));

  function change(patch: Partial<NoteInput>) {
    const next = { ...v, ...patch };
    setV(next);
    onLocal(patch);
    auto.schedule(next);
  }

  return (
    <div className="space-y-3">
      <div className="flex flex-wrap items-center gap-2">
        <input className="field-input min-w-48 flex-1 text-lg" maxLength={160} value={v.title} onChange={(e) => change({ title: e.target.value })} aria-label="Título" placeholder="Título" />
        <input
          className="field-input w-44 text-sm"
          maxLength={60}
          list="note-categories"
          value={v.category}
          onChange={(e) => change({ category: e.target.value })}
          placeholder="Categoria"
          aria-label="Categoria"
        />
        <datalist id="note-categories">
          {["NPCs", "Locais", "Ganchos", "Regras da mesa", "Segredos", ...categories].filter((c, i, a) => a.indexOf(c) === i).map((c) => (
            <option key={c} value={c} />
          ))}
        </datalist>
      </div>
      <textarea className="field-input min-h-80 font-[inherit] text-sm leading-relaxed" value={v.content} onChange={(e) => change({ content: e.target.value })} aria-label="Conteúdo" placeholder="Escreva aqui…" />
      <div className="flex flex-wrap items-center justify-between gap-2">
        <label className="flex items-center gap-2 text-sm text-fg-dim">
          <input type="checkbox" className="accent-[var(--color-holo)]" checked={!v.is_private} onChange={(e) => change({ is_private: !e.target.checked })} />
          <Share2 className="h-3.5 w-3.5" aria-hidden /> Compartilhar com os jogadores
        </label>
        <div className="flex items-center gap-3">
          <SaveIndicator status={auto.status} error={auto.error} />
          <Button size="sm" variant="ghost" onClick={() => setConfirm(true)}>
            <Trash2 className="h-3.5 w-3.5" aria-hidden /> Excluir
          </Button>
        </div>
      </div>
      <ConfirmDialog
        open={confirm}
        title="Excluir anotação?"
        description="Esta ação não pode ser desfeita."
        confirmLabel="Excluir"
        loading={busy}
        onCancel={() => setConfirm(false)}
        onConfirm={() => act(() => deleteNote(campaignId, note.id), () => (setConfirm(false), onDeleted()), true)}
      />
    </div>
  );
}
