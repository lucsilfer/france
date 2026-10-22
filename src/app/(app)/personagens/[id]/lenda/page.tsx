import type { Metadata } from "next";
import { redirect } from "next/navigation";
import { loadCharacter, type AttributeRollRow } from "@/lib/character";
import { requireUser } from "@/lib/supabase/server";
import { LendaWizard } from "./LendaWizard";

export const metadata: Metadata = { title: "Criar Lenda" };

/** Assistente da ficha secundária do Artificial (atributos, perícias, identidade — sem origem e sem classe). */
export default async function LendaPage({ params }: { params: Promise<{ id: string }> }) {
  const { id } = await params;
  const bundle = await loadCharacter(id);
  const c = bundle.character;
  if (c.status === "draft") redirect(`/personagens/${id}/criar`);
  if (!bundle.isOwner || c.origin_id !== "artificial") redirect(`/personagens/${id}`);
  if (!bundle.lenda || bundle.lenda.setup_complete) redirect(`/personagens/${id}`);

  const { supabase } = await requireUser();
  // A rolagem pendente da Lenda é separada da forma principal.
  const { data: pending } = await supabase
    .from("attribute_rolls")
    .select("id, faces, results, best, assigned_attribute, created_at")
    .eq("form_id", bundle.lenda.id)
    .is("assigned_attribute", null)
    .maybeSingle();
  const p = pending as AttributeRollRow | null;

  return (
    <LendaWizard
      characterId={c.id}
      characterName={c.name}
      level={c.level}
      initialForm={bundle.lenda}
      initialPending={p ? { id: p.id, faces: p.faces, results: p.results, best: p.best } : null}
    />
  );
}
