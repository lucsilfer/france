import "server-only";
import { cache } from "react";
import { requireUser } from "@/lib/supabase/server";
import type { CampaignSummary, CharacterSummary, HomebrewEntry, Profile } from "@/lib/types";
import { signMedia } from "@/lib/media";

/** Perfil da sessão — memorizado por requisição (layout e página compartilham a mesma consulta). */
export const getSessionProfile = cache(async function getSessionProfile() {
  const { supabase, user } = await requireUser();
  const { data } = await supabase
    .from("profiles")
    .select("id, username, display_name, avatar_url, reduce_motion, roll_speed")
    .eq("id", user.id)
    .single();
  const profile: Profile = (data as Profile | null) ?? {
    id: user.id,
    username: user.email?.split("@")[0] ?? "jogador",
    display_name: null,
    avatar_url: null,
    reduce_motion: false,
    roll_speed: "fast",
  };
  return { supabase, user, profile };
});

export async function getDashboardData() {
  const { supabase, user, profile } = await getSessionProfile();

  const [chars, camps, brews, sharedBrews] = await Promise.all([
    supabase
      .from("characters")
      .select("id, name, status, class_id, origin_id, level, updated_at, active_form, character_forms(kind, portrait_path, setup_complete)")
      .eq("owner_id", user.id)
      .order("updated_at", { ascending: false }),
    supabase
      .from("campaigns")
      .select("id, owner_id, name, description, cover_url, created_at, campaign_members(user_id, role), campaign_invites(code)")
      .order("created_at", { ascending: false }),
    supabase
      .from("homebrew")
      .select("id, kind, name, description, data, image_path, updated_at")
      .eq("owner_id", user.id)
      .order("updated_at", { ascending: false }),
    // Conteúdos que Mestres disponibilizaram nas campanhas de que participo (o RLS só devolve esses).
    supabase
      .from("homebrew")
      .select("id, kind, name, description, data, image_path, updated_at")
      .neq("owner_id", user.id)
      .order("updated_at", { ascending: false })
      .limit(200),
  ]);

  const error = chars.error ?? camps.error ?? brews.error;

  type CampRow = {
    id: string;
    owner_id: string;
    name: string;
    description: string;
    cover_url: string | null;
    created_at: string;
    campaign_members: { user_id: string; role: "master" | "player" }[];
    campaign_invites: { code: string } | { code: string }[] | null;
  };

  const campaigns: CampaignSummary[] = ((camps.data ?? []) as CampRow[]).map((c) => {
    const inv = Array.isArray(c.campaign_invites) ? c.campaign_invites[0] : c.campaign_invites;
    return {
      id: c.id,
      owner_id: c.owner_id,
      name: c.name,
      description: c.description,
      cover_url: c.cover_url,
      created_at: c.created_at,
      invite_code: inv?.code ?? null,
      role: c.campaign_members.find((m) => m.user_id === user.id)?.role ?? "player",
      member_count: c.campaign_members.length,
    };
  });

  // Foto do cartão: a da forma ativa (Lenda pronta) ou a da forma humana.
  type CharRow = Omit<CharacterSummary, "portrait_path" | "portrait_url"> & {
    active_form: "base" | "lenda";
    character_forms: { kind: "base" | "lenda"; portrait_path: string | null; setup_complete: boolean }[] | null;
  };
  const charRows = ((chars.data ?? []) as CharRow[]).map(({ character_forms, active_form, ...c }) => {
    const forms = character_forms ?? [];
    const lenda = forms.find((f) => f.kind === "lenda" && f.setup_complete);
    const base = forms.find((f) => f.kind === "base");
    const path = (active_form === "lenda" && lenda?.portrait_path) || base?.portrait_path || null;
    return { ...c, portrait_path: path, lenda: active_form === "lenda" && Boolean(lenda?.portrait_path) };
  });
  const brewRows = (brews.data ?? []) as HomebrewEntry[];
  const sharedRows = (sharedBrews.data ?? []) as HomebrewEntry[];
  const urls = await signMedia(supabase, [...charRows.map((c) => c.portrait_path), ...brewRows.map((b) => b.image_path), ...sharedRows.map((b) => b.image_path)]);

  return {
    profile,
    characters: charRows.map((c) => ({ ...c, portrait_url: c.portrait_path ? (urls[c.portrait_path] ?? null) : null })) as CharacterSummary[],
    campaigns,
    homebrew: brewRows.map((b) => ({ ...b, image_url: b.image_path ? (urls[b.image_path] ?? null) : null })),
    sharedHomebrew: sharedRows.map((b) => ({ ...b, image_url: b.image_path ? (urls[b.image_path] ?? null) : null })),
    loadError: error ? "Não foi possível carregar todos os dados. Atualize a página." : null,
  };
}
