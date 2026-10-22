import type { Metadata } from "next";
import { redirect } from "next/navigation";
import { loadCharacter } from "@/lib/character";
import { Wizard } from "./Wizard";

export const metadata: Metadata = { title: "Criar personagem" };

export default async function CreatePage({ params }: { params: Promise<{ id: string }> }) {
  const { id } = await params;
  const bundle = await loadCharacter(id);
  if (bundle.character.status === "active") redirect(`/personagens/${id}`);
  if (!bundle.isOwner) redirect("/painel");
  const c = bundle.character;
  return (
    <Wizard
      characterId={c.id}
      initialStep={c.creation_step}
      initialCharacter={{
        name: c.name,
        player_name: c.player_name,
        story: c.story,
        appearance: c.appearance,
        extra_info: c.extra_info,
        origin_id: c.origin_id,
        origin_path_id: c.origin_path_id,
        class_id: c.class_id,
      }}
      initialForm={bundle.base}
      initialPending={bundle.pendingRoll ? { id: bundle.pendingRoll.id, faces: bundle.pendingRoll.faces, results: bundle.pendingRoll.results, best: bundle.pendingRoll.best } : null}
    />
  );
}
