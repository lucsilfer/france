"use client";

import Link from "next/link";
import { useRouter } from "next/navigation";
import { useMemo, useState, useTransition } from "react";
import { BookOpenText, CopyPlus, Eye, Ghost, Hammer, Layers, Package, Pencil, Plus, Search, Shapes, Skull, Sparkles, Trash2, UserRound } from "lucide-react";
import { HOMEBREW_KINDS, type HomebrewEntry, type HomebrewKind } from "@/lib/types";
import { entrySummary } from "@/lib/homebrew";
import { Button } from "@/components/ui/Button";
import { useToast } from "@/components/ui/Toast";
import { HoloFrame } from "@/components/media/ImageField";
import { duplicateHomebrew } from "../actions";
import { deleteHomebrewEntry } from "../homebrew/actions";
import { EmptyState, SectionHeader, useConfirmedAction } from "./shared";

const ICON: Record<HomebrewKind, React.ComponentType<{ className?: string }>> = {
  monstro: Skull,
  npc: UserRound,
  arma: Hammer,
  item: Package,
  modificador: Layers,
  item_especial: Sparkles,
  outro: Shapes,
};
const LABEL = Object.fromEntries(HOMEBREW_KINDS.map((k) => [k.id, k.label])) as Record<HomebrewKind, string>;

function normalize(s: string) {
  return s.normalize("NFD").replace(/\p{Diacritic}/gu, "").toLowerCase();
}

function CreateButtons({ only }: { only?: HomebrewKind }) {
  const kinds = only ? HOMEBREW_KINDS.filter((k) => k.id === only) : HOMEBREW_KINDS;
  return (
    <div className="flex flex-wrap gap-2">
      {kinds.map((k) => {
        const Icon = ICON[k.id];
        return (
          <Link
            key={k.id}
            href={`/homebrew/novo?tipo=${k.id}`}
            className="chamfer inline-flex items-center gap-1.5 border border-holo/50 bg-panel-2/80 px-3 py-2 font-mono text-[0.62rem] tracking-[0.15em] text-fg uppercase transition-colors hover:border-cyan hover:text-cyan"
          >
            <Plus className="h-3 w-3" aria-hidden />
            <Icon className="h-3.5 w-3.5" aria-hidden /> Criar {k.label}
          </Link>
        );
      })}
    </div>
  );
}

export function HomebrewPanel({ entries, shared = [] }: { entries: HomebrewEntry[]; shared?: HomebrewEntry[] }) {
  const router = useRouter();
  const toast = useToast();
  const { ask, dialog } = useConfirmedAction();
  const [query, setQuery] = useState("");
  const [kind, setKind] = useState<HomebrewKind | "todos">("todos");
  const [sort, setSort] = useState<"recentes" | "antigos" | "az" | "za">("recentes");
  const [dupPending, startDup] = useTransition();

  const counts = useMemo(() => {
    const c: Record<string, number> = {};
    for (const e of entries) c[e.kind] = (c[e.kind] ?? 0) + 1;
    return c;
  }, [entries]);

  const filtered = useMemo(() => {
    const q = normalize(query.trim());
    const list = entries.filter((e) => (kind === "todos" || e.kind === kind) && (!q || normalize(`${e.name} ${e.description}`).includes(q)));
    return list.sort((a, b) =>
      sort === "az" ? a.name.localeCompare(b.name, "pt-BR") : sort === "za" ? b.name.localeCompare(a.name, "pt-BR") : sort === "antigos" ? a.updated_at.localeCompare(b.updated_at) : b.updated_at.localeCompare(a.updated_at),
    );
  }, [entries, query, kind, sort]);

  if (entries.length === 0 && shared.length === 0) {
    return (
      <>
        <EmptyState
          icon={<BookOpenText className="h-10 w-10" aria-hidden />}
          title="Sua biblioteca está vazia"
          text="Monstros, NPCs, armas, equipamentos, modificadores e itens especiais criados aqui viram modelos reutilizáveis. Fichas, campanhas e combates recebem cópias independentes."
        >
          <CreateButtons />
        </EmptyState>
        {dialog}
      </>
    );
  }

  return (
    <div className="space-y-6">
      <SectionHeader title="Homebrew" subtitle="Biblioteca de conteúdos personalizados — tudo salvo na sua conta." action={null} />
      <CreateButtons />

      <div role="tablist" aria-label="Categorias" className="flex flex-wrap gap-1.5">
        {(["todos", ...HOMEBREW_KINDS.map((k) => k.id)] as (HomebrewKind | "todos")[]).map((k) => {
          const active = kind === k;
          const n = k === "todos" ? entries.length : (counts[k] ?? 0);
          return (
            <button
              key={k}
              role="tab"
              aria-selected={active}
              onClick={() => setKind(k)}
              className={`border px-3 py-1.5 font-mono text-[0.62rem] tracking-[0.15em] uppercase transition-colors ${active ? "border-cyan bg-cyan/10 text-fg" : "border-line text-fg-muted hover:text-fg-dim"}`}
            >
              {k === "todos" ? "Todos" : HOMEBREW_KINDS.find((x) => x.id === k)!.plural} <span className="text-holo">{n}</span>
            </button>
          );
        })}
      </div>

      <div className="flex flex-col gap-3 sm:flex-row">
        <div className="relative flex-1">
          <Search className="pointer-events-none absolute top-1/2 left-3 h-4 w-4 -translate-y-1/2 text-fg-muted" aria-hidden />
          <input value={query} onChange={(e) => setQuery(e.target.value)} placeholder="Pesquisar por nome ou descrição" aria-label="Pesquisar" className="field-input pl-9" />
        </div>
        <select value={sort} onChange={(e) => setSort(e.target.value as typeof sort)} className="field-input sm:w-52" aria-label="Ordenar">
          <option value="recentes">Atualizados recentemente</option>
          <option value="antigos">Mais antigos</option>
          <option value="az">Nome (A–Z)</option>
          <option value="za">Nome (Z–A)</option>
        </select>
      </div>

      {filtered.length === 0 ? (
        <div className="space-y-3 py-8 text-center">
          <p className="text-sm text-fg-dim">Nada encontrado com esses filtros.</p>
          {kind !== "todos" && (
            <div className="flex justify-center">
              <CreateButtons only={kind} />
            </div>
          )}
        </div>
      ) : (
        <ul className="grid gap-4 sm:grid-cols-2 xl:grid-cols-3">
          {filtered.map((e) => {
            const Icon = ICON[e.kind] ?? Ghost;
            const creature = e.kind === "monstro" || e.kind === "npc";
            const summary = entrySummary(e.kind, e.data ?? {});
            return (
              <li key={e.id} className="hud-panel hud-card flex flex-col p-4 pt-6">
                <span className="hud-tag flex items-center gap-1">
                  <Icon className="h-3 w-3" aria-hidden /> {LABEL[e.kind]}
                </span>
                <div className="flex gap-3">
                  <div className="w-20 shrink-0">
                    <HoloFrame url={e.image_url ?? null} alt={e.name} aspect={creature ? "portrait" : "square"} fallback={<Icon className="h-1/3 w-1/3" />} />
                  </div>
                  <div className="min-w-0 flex-1">
                    <h3 className="truncate font-head text-lg tracking-wide text-fg">
                      <Link href={`/homebrew/${e.id}`} className="after:absolute after:inset-0 hover:text-holo focus-visible:outline-none">
                        {e.name}
                      </Link>
                    </h3>
                    {summary && <p className="truncate font-mono text-[0.62rem] text-cyan-dim">{summary}</p>}
                    <p className="mt-1 line-clamp-2 text-xs text-fg-dim">{e.description || "Sem descrição."}</p>
                  </div>
                </div>
                <p className="mt-2 font-mono text-[0.56rem] tracking-[0.15em] text-fg-muted uppercase">Atualizado {new Date(e.updated_at).toLocaleDateString("pt-BR")}</p>
                <div className="relative z-10 mt-3 flex flex-wrap gap-1.5 border-t border-line pt-3">
                  <Link href={`/homebrew/${e.id}`} className="inline-flex items-center gap-1 border border-line-strong px-2 py-1 font-mono text-[0.58rem] tracking-[0.15em] text-fg-dim uppercase hover:border-cyan hover:text-cyan">
                    <Eye className="h-3 w-3" aria-hidden /> Abrir
                  </Link>
                  <Link href={`/homebrew/${e.id}/editar`} className="inline-flex items-center gap-1 border border-line-strong px-2 py-1 font-mono text-[0.58rem] tracking-[0.15em] text-fg-dim uppercase hover:border-cyan hover:text-cyan">
                    <Pencil className="h-3 w-3" aria-hidden /> Editar
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
                    <CopyPlus className="h-3 w-3" aria-hidden /> Duplicar
                  </Button>
                  <Button
                    size="sm"
                    variant="danger"
                    onClick={() =>
                      ask({
                        title: "Excluir da biblioteca?",
                        description: (
                          <>
                            <strong className="text-fg">{e.name}</strong> sai da sua biblioteca. Cópias em fichas, campanhas e combates continuam intactas.
                          </>
                        ),
                        confirmLabel: "Excluir",
                        run: () => deleteHomebrewEntry(e.id),
                      })
                    }
                  >
                    <Trash2 className="h-3 w-3" aria-hidden />
                  </Button>
                </div>
              </li>
            );
          })}
        </ul>
      )}

      {shared.length > 0 && (
        <section className="space-y-3">
          <h3 className="label-mono text-holo">Disponibilizados pelos Mestres das suas campanhas</h3>
          <ul className="grid gap-3 sm:grid-cols-2 xl:grid-cols-3">
            {shared.map((e) => {
              const Icon = ICON[e.kind] ?? Ghost;
              return (
                <li key={e.id} className="relative flex gap-3 border border-line/70 bg-panel-2/40 p-3">
                  <div className="w-14 shrink-0">
                    <HoloFrame url={e.image_url ?? null} alt={e.name} aspect="square" fallback={<Icon className="h-1/3 w-1/3" />} />
                  </div>
                  <div className="min-w-0">
                    <Link href={`/homebrew/${e.id}`} className="block truncate text-fg after:absolute after:inset-0 hover:text-holo">
                      {e.name}
                    </Link>
                    <p className="font-mono text-[0.58rem] text-fg-muted uppercase">{LABEL[e.kind]}</p>
                  </div>
                </li>
              );
            })}
          </ul>
        </section>
      )}
      {dialog}
    </div>
  );
}
