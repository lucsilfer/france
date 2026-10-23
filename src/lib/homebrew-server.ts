import "server-only";
import { requireUser } from "@/lib/supabase/server";
import type { HomebrewEntry } from "@/lib/types";

type Sb = Awaited<ReturnType<typeof requireUser>>["supabase"];
export const HOMEBREW_COLUMNS = "id, kind, name, description, data, image_path, updated_at, owner_id";

/** Biblioteca do usuário usada pelos editores (armas para ataques, modificadores para armas, itens para inventário). */
export async function loadLibrary(supabase: Sb, userId: string): Promise<HomebrewEntry[]> {
  const { data } = await supabase
    .from("homebrew")
    .select("id, kind, name, description, data, image_path, updated_at")
    .eq("owner_id", userId)
    .in("kind", ["arma", "modificador", "item", "item_especial", "outro"])
    .order("name")
    .limit(500);
  return (data ?? []) as HomebrewEntry[];
}
