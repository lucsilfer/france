import type { Metadata } from "next";
import { notFound } from "next/navigation";
import { PageShell } from "@/components/PageShell";
import { requireUser } from "@/lib/supabase/server";
import type { HomebrewEntry } from "@/lib/types";
import type { HomebrewInput } from "@/lib/validation";
import { HomebrewForm } from "../HomebrewForm";

export const metadata: Metadata = { title: "Editar homebrew" };

export default async function EditHomebrewPage({ params }: { params: Promise<{ id: string }> }) {
  const { id } = await params;
  if (!/^[0-9a-f-]{36}$/i.test(id)) notFound();
  const { supabase, user } = await requireUser();
  const { data } = await supabase.from("homebrew").select("id, kind, name, description, data, updated_at").eq("id", id).eq("owner_id", user.id).maybeSingle();
  if (!data) notFound();
  const e = data as HomebrewEntry;
  const d = (e.data ?? {}) as Record<string, string>;
  const defaults: HomebrewInput = {
    kind: e.kind,
    name: e.name,
    description: e.description,
    effect_dice: d.effect_dice ?? "",
    effect_kind: (["dano", "cura", "condicao", "utilidade", "personalizado", "outro"].includes(d.effect_kind) ? d.effect_kind : "") as HomebrewInput["effect_kind"],
    range: d.range ?? "",
    special_rules: d.special_rules ?? "",
  };
  return (
    <PageShell eyebrow="Homebrew" title={`Editar: ${e.name}`} back="/painel?aba=homebrew" backLabel="Voltar à biblioteca">
      <HomebrewForm id={e.id} defaults={defaults} />
    </PageShell>
  );
}
