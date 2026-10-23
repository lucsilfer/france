import type { Metadata } from "next";
import { notFound } from "next/navigation";
import { requireUser } from "@/lib/supabase/server";
import type { HomebrewEntry } from "@/lib/types";
import { defaultData } from "@/lib/homebrew";
import { HOMEBREW_COLUMNS, loadLibrary } from "@/lib/homebrew-server";
import { signMedia } from "@/lib/media";
import { EntryEditor } from "../../EntryEditor";

export const metadata: Metadata = { title: "Editar homebrew" };

export default async function EditHomebrewPage({ params }: { params: Promise<{ id: string }> }) {
  const { id } = await params;
  if (!/^[0-9a-f-]{36}$/i.test(id)) notFound();
  const { supabase, user } = await requireUser();
  const { data } = await supabase.from("homebrew").select(HOMEBREW_COLUMNS).eq("id", id).eq("owner_id", user.id).maybeSingle();
  if (!data) notFound();
  const e = data as HomebrewEntry;
  const [library, urls] = await Promise.all([loadLibrary(supabase, user.id), signMedia(supabase, [e.image_path])]);
  return (
    <EntryEditor
      kind={e.kind}
      id={e.id}
      userId={user.id}
      library={library.filter((x) => x.id !== e.id)}
      initial={{ name: e.name, description: e.description, image_path: e.image_path ?? null, image_url: e.image_path ? (urls[e.image_path] ?? null) : null, data: defaultData(e.kind, e.data) }}
    />
  );
}
