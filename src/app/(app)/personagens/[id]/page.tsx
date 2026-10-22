import type { Metadata } from "next";
import { redirect } from "next/navigation";
import { loadCharacter } from "@/lib/character";
import { requireUser } from "@/lib/supabase/server";
import { Sheet } from "./Sheet";
import type { RollEntry } from "@/lib/rolls";
import type { HomebrewItemRow } from "@/lib/character";

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
    // Biblioteca Homebrew do próprio usuário (itens e armas reutilizáveis).
    supabase.from("homebrew").select("id, kind, name, description, data").eq("owner_id", user.id).in("kind", ["item", "arma"]).order("name").limit(200),
  ]);

  return <Sheet bundle={bundle} initialRolls={(rolls ?? []) as RollEntry[]} homebrew={(homebrew ?? []) as HomebrewItemRow[]} />;
}
