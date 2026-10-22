import "server-only";
import { requireUser } from "@/lib/supabase/server";
import type { CampaignSummary, CharacterSummary, HomebrewEntry, Profile } from "@/lib/types";

export async function getSessionProfile() {
  const { supabase, user } = await requireUser();
  const { data } = await supabase
    .from("profiles")
    .select("id, username, display_name, avatar_url, reduce_motion")
    .eq("id", user.id)
    .single();
  const profile: Profile = (data as Profile | null) ?? {
    id: user.id,
    username: user.email?.split("@")[0] ?? "jogador",
    display_name: null,
    avatar_url: null,
    reduce_motion: false,
  };
  return { supabase, user, profile };
}

export async function getDashboardData() {
  const { supabase, user, profile } = await getSessionProfile();

  const [chars, camps, brews] = await Promise.all([
    supabase
      .from("characters")
      .select("id, name, status, class_id, origin_id, level, updated_at")
      .eq("owner_id", user.id)
      .order("updated_at", { ascending: false }),
    supabase
      .from("campaigns")
      .select("id, owner_id, name, description, cover_url, created_at, campaign_members(user_id, role), campaign_invites(code)")
      .order("created_at", { ascending: false }),
    supabase
      .from("homebrew")
      .select("id, kind, name, description, data, updated_at")
      .eq("owner_id", user.id)
      .order("updated_at", { ascending: false }),
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

  return {
    profile,
    characters: (chars.data ?? []) as CharacterSummary[],
    campaigns,
    homebrew: (brews.data ?? []) as HomebrewEntry[],
    loadError: error ? "Não foi possível carregar todos os dados. Atualize a página." : null,
  };
}
