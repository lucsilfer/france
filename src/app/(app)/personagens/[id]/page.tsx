import type { Metadata } from "next";
import { redirect } from "next/navigation";
import { loadCharacter } from "@/lib/character";
import { requireUser } from "@/lib/supabase/server";
import { Sheet } from "./Sheet";
import type { RollEntry } from "@/lib/rolls";
import type { HomebrewItemRow } from "@/lib/character";
import { signMedia } from "@/lib/media";

export const metadata: Metadata = { title: "Ficha" };

export default async function CharacterPage({ params }: { params: Promise<{ id: string }> }) {
  const { id } = await params;
  const bundle = await loadCharacter(id);
  if (bundle.character.status === "draft") redirect(bundle.isOwner ? `/personagens/${id}/criar` : "/painel");

  const { supabase, user } = await requireUser();
  const [{ data: rolls }, { data: homebrew }] = await Promise.all([
    supabase
    .from("roll_log")
    .select("id, label, created_at, result")
    .eq("character_id", id)
    .is("campaign_id", null)
    .order("created_at", { ascending: false })
    .limit(15),
    // Biblioteca Homebrew: a do usuário + conteúdos que Mestres disponibilizaram nas campanhas dele (o RLS decide).
    supabase.from("homebrew").select("id, kind, name, description, data").in("kind", ["item", "arma", "item_especial", "outro", "modificador"]).order("name").limit(300),
  ]);

  // Fotos (bucket privado): links assinados com a sessão de quem abre a ficha.
  const portraits = await signMedia(supabase, [bundle.base.portrait_path, bundle.lenda?.portrait_path]);

  return <Sheet bundle={bundle} initialRolls={(rolls ?? []) as RollEntry[]} homebrew={(homebrew ?? []) as HomebrewItemRow[]} portraits={portraits} />;
}
