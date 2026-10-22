"use server";

import { randomUUID } from "node:crypto";
import type { ActionResult } from "@/lib/types";
import type { TechniqueRow, TechniqueUseRow, TrackerRow } from "@/lib/character";
import { TECHNIQUE_BY_ID } from "@/rules/data/equipment.ts";
import { CLASS_BY_ID } from "@/rules/data/classes.ts";
import { abilityStatus } from "@/rules/abilities.ts";
import { isArsenal, learnErrors, techniqueAvailability } from "@/rules/techniques.ts";
import { dbMessage, editContext, fail, guard, logRoll, sheetContext, uuid } from "./_shared";

/** Aprende uma técnica oficial (motor confere; o banco confere de novo: Arsenal, requisitos, vaga, repetição). */
export async function learnTechnique(characterId: string, techniqueId: string): Promise<ActionResult<TechniqueRow>> {
  return guard(async () => {
    const def = TECHNIQUE_BY_ID[techniqueId];
    if (!def) return fail("Técnica desconhecida.");
    const { bundle, supabase } = await sheetContext(characterId);
    const c = bundle.character;
    const base = bundle.base;
    const attrs = Object.fromEntries(base.attributes.map((a) => [a.attribute, (a.base_value ?? 0) + a.other_bonus]));
    // bônus de atributo da classe entra (o banco faz a mesma conta)
    for (const [k, v] of Object.entries(CLASS_BY_ID[c.class_id ?? ""]?.attributeBonus ?? {})) attrs[k] = (attrs[k] ?? 0) + (v as number);
    const st = abilityStatus({ level: c.level, originId: c.origin_id, pathId: c.origin_path_id, created: bundle.powers.length + bundle.techniques.length });
    const errors = learnErrors({ def, originId: c.origin_id, pathId: c.origin_path_id, learned: bundle.techniques.map((t) => t.technique_id), attributes: attrs, slotsAvailable: st.available });
    if (errors.length) return fail(errors[0]);
    const { data: id, error } = await supabase.rpc("learn_technique", { p_character: characterId, p_technique: techniqueId });
    if (error || !id) return fail(dbMessage(error, "Não foi possível aprender a técnica."));
    return {
      ok: true,
      data: { id: id as string, technique_id: techniqueId, learned_level: c.level, created_at: new Date().toISOString() },
      message: `${def.name} aprendida.`,
    };
  });
}

export async function forgetTechnique(characterId: string, techniqueId: string): Promise<ActionResult> {
  return guard(async () => {
    if (!TECHNIQUE_BY_ID[techniqueId]) return fail("Técnica desconhecida.");
    const { supabase } = await editContext(characterId);
    const { error } = await supabase.rpc("forget_technique", { p_character: characterId, p_technique: techniqueId });
    if (error) return fail(dbMessage(error, "Não foi possível remover a técnica."));
    return { ok: true, message: "Técnica removida. A vaga voltou a ficar disponível." };
  });
}

/** Turno / cena / sessão do personagem (controla os limites de uso). */
export async function advanceTracker(characterId: string, kind: "turn" | "scene" | "session"): Promise<ActionResult<TrackerRow>> {
  return guard(async () => {
    if (!["turn", "scene", "session"].includes(kind)) return fail("Contador inválido.");
    const { supabase } = await editContext(characterId);
    const { data, error } = await supabase.rpc("advance_tracker", { p_character: characterId, p_kind: kind });
    if (error || !data) return fail(dbMessage(error, "Não foi possível avançar o contador."));
    const t = data as TrackerRow;
    return { ok: true, data: { scene: t.scene, session: t.session, turn: t.turn } };
  });
}

/**
 * Usa uma técnica: registra o uso (o banco confere o limite por cena/turno/sessão) e aplica o efeito especial.
 * Recobrar-se recebe { mode: "half", damage } ou { mode: "revive" }.
 */
export async function useTechnique(
  characterId: string,
  techniqueId: string,
  requestId: string,
  data: { mode?: "half" | "revive"; damage?: number } = {},
): Promise<ActionResult<{ use: TechniqueUseRow; pv_current?: number; form_id?: string; message: string }>> {
  return guard(async () => {
    const def = TECHNIQUE_BY_ID[techniqueId];
    if (!def || !uuid.safeParse(requestId).success) return fail("Dados inválidos.");
    if (data.damage !== undefined && (!Number.isInteger(data.damage) || data.damage < 0 || data.damage > 10000)) return fail("Dano inválido.");
    const { bundle, supabase } = await sheetContext(characterId);
    const c = bundle.character;
    if (!isArsenal(c.origin_id, c.origin_path_id)) return fail("Só o Prodígio do Arsenal usa técnicas da lista.");
    const learned = bundle.techniques.find((t) => t.technique_id === techniqueId);
    if (!learned) return fail("Técnica não aprendida.");
    const av = techniqueAvailability(def, bundle.techniqueUses, bundle.tracker);
    if (!av.usable) return fail(av.reason ?? "Indisponível agora.");
    const { data: res, error } = await supabase.rpc("use_technique", {
      p_character: characterId,
      p_technique: techniqueId,
      p_request: requestId,
      p_data: data,
    });
    if (error || !res) return fail(dbMessage(error, "Não foi possível usar a técnica."));
    const r = res as { duplicate: boolean; scene: number; session: number; turn: number; pv_current?: number; healed?: number; form_id?: string };
    if (r.duplicate) return fail("Este uso já foi registrado.");
    let message = `${def.name}: ${def.effect}`;
    if (def.special === "recobrar") message = data.mode === "revive" ? "Recobrar-se: volta com 1 de vida." : `Recobrar-se: curou ${r.healed ?? 0} PV.`;
    if (def.special === "recarregar_cena") message = "Adrenalina: técnicas de uso por cena recarregadas.";
    await logRoll(characterId, `Técnica: ${def.name}`, "—", {
      kind: "power",
      power: def.name,
      cost: 0,
      pcAfter: 0,
      effects: [],
      notes: [message],
      continuous: null,
    });
    return {
      ok: true,
      data: {
        use: { id: Date.now(), technique_id: techniqueId, scene: r.scene, session: r.session, turn: r.turn, created_at: new Date().toISOString() },
        pv_current: r.pv_current,
        form_id: r.form_id,
        message,
      },
      message,
    };
  });
}

export async function newTechniqueRequest(): Promise<string> {
  return randomUUID();
}
