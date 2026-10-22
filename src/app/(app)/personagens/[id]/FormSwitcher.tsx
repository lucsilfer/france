"use client";

import Link from "next/link";
import { useTransition } from "react";
import { Repeat2, Sparkles } from "lucide-react";
import { Button } from "@/components/ui/Button";
import { useToast } from "@/components/ui/Toast";
import { setActiveForm, startLendaForm } from "../actions";
import type { SheetState } from "./Sheet";

/** Botão "ALTERNAR FORMA — LENDA" (só Artificial). Na primeira vez abre a criação da Lenda. */
export function FormSwitcher({ state }: { state: SheetState }) {
  const toast = useToast();
  const [pending, start] = useTransition();
  const { character: c, lenda, isLenda } = state;

  if (!lenda) {
    if (!state.isOwner) return null;
    return (
      <form action={startLendaForm.bind(null, c.id)}>
        <Button type="submit" size="sm" variant="secondary">
          <Sparkles className="h-3.5 w-3.5" aria-hidden /> Alternar forma — Lenda
        </Button>
      </form>
    );
  }

  if (!lenda.setup_complete) {
    if (!state.isOwner) return null;
    return (
      <Link
        href={`/personagens/${c.id}/lenda`}
        className="chamfer inline-flex items-center gap-2 border border-line-strong bg-panel-2/80 px-3 py-1.5 font-mono text-[0.64rem] tracking-[0.18em] text-fg uppercase hover:border-holo hover:text-cyan"
      >
        <Sparkles className="h-3.5 w-3.5" aria-hidden /> Continuar criação da Lenda
      </Link>
    );
  }

  function toggle() {
    const next = isLenda ? "base" : "lenda";
    start(async () => {
      const res = await setActiveForm(c.id, next);
      if (!res.ok) return toast(res.error, "error");
      state.setCharacter({ active_form: next });
      toast(next === "lenda" ? `Forma Lenda ativa${lenda?.name ? `: ${lenda.name}` : ""}.` : "Forma humana ativa.");
    });
  }

  return (
    <Button size="sm" variant={isLenda ? "primary" : "secondary"} onClick={toggle} loading={pending} disabled={!state.canEdit} aria-pressed={isLenda}>
      <Repeat2 className="h-3.5 w-3.5" aria-hidden /> Alternar forma — {isLenda ? "Humana" : "Lenda"}
    </Button>
  );
}
