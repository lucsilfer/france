import type { Metadata } from "next";
import { requireUser } from "@/lib/supabase/server";
import { HOMEBREW_KINDS, type HomebrewKind } from "@/lib/types";
import { defaultData } from "@/lib/homebrew";
import { loadLibrary } from "@/lib/homebrew-server";
import { EntryEditor } from "../EntryEditor";

export const metadata: Metadata = { title: "Novo homebrew" };

export default async function NewHomebrewPage({ searchParams }: { searchParams: Promise<{ tipo?: string }> }) {
  const { tipo } = await searchParams;
  const kind = (HOMEBREW_KINDS.some((k) => k.id === tipo) ? tipo : "monstro") as HomebrewKind;
  const { supabase, user } = await requireUser();
  const library = await loadLibrary(supabase, user.id);
  return <EntryEditor kind={kind} userId={user.id} library={library} initial={{ name: "", description: "", image_path: null, image_url: null, data: defaultData(kind) }} />;
}
