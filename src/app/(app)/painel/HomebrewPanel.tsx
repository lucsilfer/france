"use client";

import Link from "next/link";
import { useRouter } from "next/navigation";
import { useMemo, useState, useTransition } from "react";
import { BookOpenText, ChevronDown, CopyPlus, Pencil, Plus, Search, Trash2 } from "lucide-react";
import { HOMEBREW_KINDS, type HomebrewEntry } from "@/lib/types";
import { Button } from "@/components/ui/Button";
import { useToast } from "@/components/ui/Toast";
import { deleteHomebrew, duplicateHomebrew } from "../actions";
import { EmptyState, SectionHeader, useConfirmedAction } from "./shared";

const KIND_LABEL = Object.fromEntries(HOMEBREW_KINDS.map((k) => [k.id, k.label])) as Record<string, string>;
const DATA_LABEL: Record<string, string> = { effect_dice: "Dado de efeito", effect_kind: "Tipo de efeito", range: "Alcance", special_rules: "Regras especiais" };

function normalize(s: string) {
  return s.normalize("NFD").replace(/\p{Diacritic}/gu, "").toLowerCase();
}

const createLink = (
  <Link
    href="/homebrew/novo"
    className="chamfer inline-flex items-center gap-2 border border-holo/60 bg-gradient-to-r from-primary-deep to-primary/80 px-5 py-2.5 font-mono text-xs font-medium tracking-[0.18em] text-fg uppercase transition-[background,color] hover:from-primary/90 hover:to-holo/90 hover:text-white"
  >
    <Plus className="h-4 w-4" aria-hidden /> Criar conteúdo
  </Link>
);

export function HomebrewPanel({ entries }: { entries: HomebrewEntry[] }) {
  const router = useRouter();
  const toast = useToast();
  const { ask, dialog } = useConfirmedAction();
  const [query, setQuery] = useState("");
  const [kind, setKind] = useState<string>("todos");
  const [open, setOpen] = useState<string | null>(null);
  const [dupPending, startDup] = useTransition();

  const filtered = useMemo(() => {
    const q = normalize(query.trim());
    return entries.filter((e) => (kind === "todos" || e.kind === kind) && (!q || normalize(`${e.name} ${e.description}`).includes(q)));
  }, [entries, query, kind]);

  if (entries.length === 0) {
    return (
      <>
        <EmptyState
          icon={<BookOpenText className="h-10 w-10" aria-hidden />}
          title="Sua biblioteca está vazia"
          text="Itens, armas, modificadores, monstros e NPCs criados aqui viram modelos reutilizáveis. Ao colocar um modelo numa ficha, ela recebe uma cópia independente."
        >
          {createLink}
        </EmptyState>
        {dialog}
      </>
    );
  }

  return (
    <div>
      <SectionHeader title="Homebrew" subtitle="Sua biblioteca de modelos personalizados." action={createLink} />

      <div className="mb-5 flex flex-col gap-3 sm:flex-row">
        <div className="relative flex-1">
          <Search className="pointer-events-none absolute top-1/2 left-3 h-4 w-4 -translate-y-1/2 text-fg-muted" aria-hidden />
          <label htmlFor="hb-search" className="sr-only">
            Pesquisar
          </label>
          <input
            id="hb-search"
            value={query}
            onChange={(e) => setQuery(e.target.value)}
            placeholder="Pesquisar por nome ou descrição"
            className="field-input pl-9"
          />
        </div>
        <label htmlFor="hb-kind" className="sr-only">
          Filtrar por categoria
        </label>
        <select id="hb-kind" value={kind} onChange={(e) => setKind(e.target.value)} className="field-input sm:w-48">
          <option value="todos">Todas as categorias</option>
          {HOMEBREW_KINDS.map((k) => (
            <option key={k.id} value={k.id}>
              {k.label}
            </option>
          ))}
        </select>
      </div>

      {filtered.length === 0 ? (
        <p className="py-10 text-center text-sm text-fg-dim">Nada encontrado com esses filtros.</p>
      ) : (
        <ul className="divide-y divide-line rounded-sm border border-line bg-panel/80">
          {filtered.map((e) => {
            const expanded = open === e.id;
            const extras = Object.entries(e.data ?? {}).filter(([, v]) => typeof v === "string" && v);
            return (
              <li key={e.id}>
                <button
                  className="flex w-full items-center gap-4 px-4 py-3.5 text-left transition-colors hover:bg-panel-2/60"
                  aria-expanded={expanded}
                  aria-controls={`hb-${e.id}`}
                  onClick={() => setOpen(expanded ? null : e.id)}
                >
                  <span className="label-mono w-24 shrink-0 text-cyan-dim">{KIND_LABEL[e.kind] ?? e.kind}</span>
                  <span className="flex-1 truncate text-fg">{e.name}</span>
                  <ChevronDown className={`h-4 w-4 text-fg-muted transition-transform ${expanded ? "rotate-180" : ""}`} aria-hidden />
                </button>
                {expanded && (
                  <div id={`hb-${e.id}`} className="space-y-4 border-t border-line bg-void/40 px-4 py-4">
                    {e.description ? (
                      <p className="text-sm whitespace-pre-line text-fg-dim">{e.description}</p>
                    ) : (
                      <p className="text-sm text-fg-muted italic">Sem descrição.</p>
                    )}
                    {extras.length > 0 && (
                      <dl className="grid gap-2 text-sm sm:grid-cols-2">
                        {extras.map(([k, v]) => (
                          <div key={k}>
                            <dt className="label-mono">{DATA_LABEL[k] ?? k}</dt>
                            <dd className="text-fg">{String(v)}</dd>
                          </div>
                        ))}
                      </dl>
                    )}
                    <div className="flex flex-wrap gap-2">
                      <Link
                        href={`/homebrew/${e.id}`}
                        className="inline-flex items-center gap-2 rounded-sm border border-line-strong bg-panel-2 px-3 py-1.5 font-mono text-[0.65rem] tracking-[0.18em] uppercase hover:border-cyan hover:text-cyan"
                      >
                        <Pencil className="h-3.5 w-3.5" aria-hidden /> Editar
                      </Link>
                      <Button
                        size="sm"
                        variant="ghost"
                        loading={dupPending}
                        onClick={() =>
                          startDup(async () => {
                            const res = await duplicateHomebrew(e.id);
                            if (res.ok) {
                              toast(res.message ?? "Cópia criada.");
                              router.refresh();
                            } else toast(res.error, "error");
                          })
                        }
                      >
                        <CopyPlus className="h-3.5 w-3.5" aria-hidden /> Duplicar
                      </Button>
                      <Button
                        size="sm"
                        variant="danger"
                        onClick={() =>
                          ask({
                            title: "Excluir da biblioteca?",
                            description: (
                              <>
                                <strong className="text-fg">{e.name}</strong> sai da sua biblioteca. Cópias já adicionadas a fichas continuam
                                intactas.
                              </>
                            ),
                            confirmLabel: "Excluir",
                            run: () => deleteHomebrew(e.id),
                          })
                        }
                      >
                        <Trash2 className="h-3.5 w-3.5" aria-hidden /> Excluir
                      </Button>
                    </div>
                  </div>
                )}
              </li>
            );
          })}
        </ul>
      )}
      {dialog}
    </div>
  );
}
