"use client";

import Link from "next/link";
import { useFormStatus } from "react-dom";
import { Plus, Swords, Trash2 } from "lucide-react";
import { CLASS_BY_ID } from "@/rules/data/classes.ts";
import { ORIGIN_BY_ID } from "@/rules/data/origins.ts";
import type { CharacterSummary } from "@/lib/types";
import { Button } from "@/components/ui/Button";
import { StatusDot } from "@/components/hud/Panel";
import { HoloFrame } from "@/components/media/ImageField";
import { deleteCharacter } from "../actions";
import { createCharacter } from "../personagens/actions";
import { EmptyState, SectionHeader, useConfirmedAction } from "./shared";

function SubmitCreate() {
  const { pending } = useFormStatus();
  return (
    <Button type="submit" loading={pending}>
      <Plus className="h-4 w-4" aria-hidden /> Criar personagem
    </Button>
  );
}

function CreateCharacterButton() {
  return (
    <form action={createCharacter}>
      <SubmitCreate />
    </form>
  );
}

export function CharactersPanel({ characters }: { characters: CharacterSummary[] }) {
  const { ask, dialog } = useConfirmedAction();

  if (characters.length === 0) {
    return (
      <EmptyState
        icon={<Swords className="h-10 w-10" aria-hidden />}
        title="Nenhuma unidade registrada"
        text="Crie sua primeira ficha: atributos rolados, origem, classe, perícias e história, em seis etapas. O progresso é salvo a cada passo."
      >
        <CreateCharacterButton />
      </EmptyState>
    );
  }

  return (
    <div>
      <SectionHeader title="Personagens" subtitle="Suas fichas salvas." action={<CreateCharacterButton />} />
      <ul className="grid gap-4 sm:grid-cols-2 lg:grid-cols-3">
        {characters.map((c, i) => (
          <li key={c.id} className="hud-panel hud-card flex flex-col p-4 pt-6">
            <span className="hud-tag">Unidade {String(i + 1).padStart(3, "0")}</span>
            <div className="flex gap-4">
              <div className="w-28 shrink-0 sm:w-32">
                <HoloFrame url={c.portrait_url ?? null} alt={`Foto de ${c.name || "personagem"}`} variant={c.lenda ? "corrupted" : "holo"} />
              </div>
              <div className="min-w-0 flex-1 space-y-2">
                <h3 className="truncate font-head text-xl tracking-wide text-fg">
                  <Link
                    href={c.status === "draft" ? `/personagens/${c.id}/criar` : `/personagens/${c.id}`}
                    className="after:absolute after:inset-0 hover:text-holo focus-visible:outline-none"
                  >
                    {c.name || "Sem nome"}
                  </Link>
                </h3>
                <dl className="space-y-1 font-mono text-[0.6rem] tracking-[0.16em] uppercase">
                  <div className="flex gap-2">
                    <dt className="w-14 shrink-0 text-fg-muted">Origem</dt>
                    <dd className="truncate text-xs tracking-normal text-fg normal-case">{(c.origin_id && ORIGIN_BY_ID[c.origin_id]?.name) || "—"}</dd>
                  </div>
                  <div className="flex gap-2">
                    <dt className="w-14 shrink-0 text-fg-muted">Classe</dt>
                    <dd className="truncate text-xs tracking-normal text-fg normal-case">{(c.class_id && CLASS_BY_ID[c.class_id]?.name) || "—"}</dd>
                  </div>
                  <div className="flex items-baseline gap-2">
                    <dt className="w-14 shrink-0 text-fg-muted">Nível</dt>
                    <dd className="font-display text-2xl leading-none text-holo text-glow">{String(c.level).padStart(2, "0")}</dd>
                  </div>
                </dl>
              </div>
            </div>
            <div className="mt-4 flex items-center justify-between border-t border-line pt-3">
              <StatusDot tone={c.status === "draft" ? "draft" : "online"} label={c.status === "draft" ? "Em criação" : "Ficha ativa"} />
              <Button
                className="relative z-10"
                variant="danger"
                size="sm"
                onClick={() =>
                  ask({
                    title: "Excluir personagem?",
                    description: (
                      <>
                        <strong className="text-fg">{c.name || "Sem nome"}</strong> será apagado permanentemente, com inventário,
                        poderes e histórico. Esta ação não pode ser desfeita.
                      </>
                    ),
                    confirmLabel: "Excluir",
                    run: () => deleteCharacter(c.id),
                  })
                }
              >
                <Trash2 className="h-3.5 w-3.5" aria-hidden /> Excluir
              </Button>
            </div>
          </li>
        ))}
      </ul>
      {dialog}
    </div>
  );
}
