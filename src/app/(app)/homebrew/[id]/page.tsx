import type { Metadata } from "next";
import { notFound } from "next/navigation";
import { requireUser } from "@/lib/supabase/server";
import type { HomebrewEntry } from "@/lib/types";
import { HOMEBREW_COLUMNS } from "@/lib/homebrew-server";
import { signMedia } from "@/lib/media";
import { EntryView } from "./EntryView";

export const metadata: Metadata = { title: "Homebrew" };

export default async function HomebrewDetailPage({ params }: { params: Promise<{ id: string }> }) {
  const { id } = await params;
  if (!/^[0-9a-f-]{36}$/i.test(id)) notFound();
  const { supabase, user } = await requireUser();
  // O RLS entrega o conteúdo se ele for seu ou estiver compartilhado com uma campanha de que você participa.
  const { data } = await supabase.from("homebrew").select(HOMEBREW_COLUMNS).eq("id", id).maybeSingle();
  if (!data) notFound();
  const entry = data as HomebrewEntry & { owner_id: string };
  const isOwner = entry.owner_id === user.id;
  const [urls, camps, shares, chars] = await Promise.all([
    signMedia(supabase, [entry.image_path]),
    supabase.from("campaigns").select("id, name").eq("owner_id", user.id).order("created_at", { ascending: false }),
    isOwner ? supabase.from("homebrew_shares").select("campaign_id").eq("homebrew_id", id) : Promise.resolve({ data: [] }),
    supabase.from("characters").select("id, name").eq("owner_id", user.id).eq("status", "active").order("updated_at", { ascending: false }),
  ]);
  return (
    <EntryView
      entry={{ ...entry, image_url: entry.image_path ? (urls[entry.image_path] ?? null) : null }}
      isOwner={isOwner}
      campaigns={(camps.data ?? []) as { id: string; name: string }[]}
      sharedWith={((shares.data ?? []) as { campaign_id: string }[]).map((s) => s.campaign_id)}
      characters={(chars.data ?? []) as { id: string; name: string }[]}
    />
  );
}
