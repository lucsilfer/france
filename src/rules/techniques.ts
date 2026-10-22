/**
 * Técnicas do Caminho do Arsenal (Prodígio): aprendizado por nível par, requisitos e
 * controle de uso por cena / sessão / turnos. A mesma conta roda no banco (use_technique).
 */
import { TECHNIQUE_BY_ID, type TechniqueDef, type TechniqueUsage } from "./data/equipment.ts";
import type { AttributeId } from "./data/attributes.ts";

export interface TechniqueTracker {
  scene: number;
  session: number;
  turn: number;
}

export interface TechniqueUse {
  id: number;
  technique_id: string;
  scene: number;
  session: number;
  turn: number;
}

export interface LearnedTechnique {
  technique_id: string;
  learned_level: number;
}

export function isArsenal(originId: string | null, pathId: string | null): boolean {
  return originId === "prodigio" && pathId === "arsenal";
}

export function usageLabel(u: TechniqueUsage): string {
  switch (u.kind) {
    case "passiva":
      return "Passiva (sempre ativa)";
    case "por_cena":
      return u.times === 1 ? "1× por cena" : `${u.times}× por cena`;
    case "por_sessao":
      return u.times === 1 ? "1× por sessão" : `${u.times}× por sessão`;
    case "a_cada_turnos":
      return `1× a cada ${u.turns} turnos`;
    case "acao":
      return u.action;
  }
}

/** Técnica aprendida num nível acima do atual fica suspensa (a escolha continua salva). */
export function isSuspended(t: LearnedTechnique, level: number): boolean {
  return t.learned_level > level;
}

/** Usos que contam no limite: só os desta cena/sessão depois da última Adrenalina (que recarrega a cena). */
function countableUses(uses: TechniqueUse[], tracker: TechniqueTracker): TechniqueUse[] {
  const inScene = uses.filter((u) => u.scene === tracker.scene && u.session === tracker.session);
  const lastAdrenaline = inScene.filter((u) => TECHNIQUE_BY_ID[u.technique_id]?.special === "recarregar_cena").reduce((m, u) => Math.max(m, u.id), 0);
  return inScene.filter((u) => u.id > lastAdrenaline);
}

export interface TechniqueAvailability {
  usable: boolean;
  reason: string | null;
  /** Texto curto do estado (ex.: "usada nesta cena", "disponível no turno 5"). */
  status: string;
}

export function techniqueAvailability(def: TechniqueDef, uses: TechniqueUse[], tracker: TechniqueTracker): TechniqueAvailability {
  const mine = uses.filter((u) => u.technique_id === def.id);
  const u = def.usage;
  switch (u.kind) {
    case "passiva":
      return { usable: false, reason: "Passiva: sempre ativa, não precisa ser usada.", status: "Passiva ativa" };
    case "acao":
      return { usable: true, reason: null, status: u.action };
    case "por_cena": {
      const n = countableUses(uses, tracker).filter((x) => x.technique_id === def.id).length;
      return n < u.times
        ? { usable: true, reason: null, status: `Disponível (${u.times - n}/${u.times} nesta cena)` }
        : { usable: false, reason: "Já usada nesta cena.", status: "Usada nesta cena" };
    }
    case "por_sessao": {
      const n = mine.filter((x) => x.session === tracker.session).length;
      return n < u.times
        ? { usable: true, reason: null, status: `Disponível (${u.times - n}/${u.times} nesta sessão)` }
        : { usable: false, reason: "Já usada nesta sessão.", status: "Usada nesta sessão" };
    }
    case "a_cada_turnos": {
      const last = mine.filter((x) => x.scene === tracker.scene && x.session === tracker.session).sort((a, b) => b.turn - a.turn)[0];
      if (!last || tracker.turn - last.turn >= u.turns) return { usable: true, reason: null, status: "Disponível" };
      const next = last.turn + u.turns;
      return { usable: false, reason: `Disponível de novo no turno ${next}.`, status: `Recarga: turno ${next}` };
    }
  }
}

/** Metavisão: vantagem nas esquivas até o fim da rodada em que foi usada (mesmo turno do contador). */
export function activeTechniqueEffects(uses: TechniqueUse[], tracker: TechniqueTracker): { technique_id: string; label: string }[] {
  return uses
    .filter((u) => TECHNIQUE_BY_ID[u.technique_id]?.special === "esquiva_rodada" && u.scene === tracker.scene && u.session === tracker.session && u.turn === tracker.turn)
    .map((u) => ({ technique_id: u.technique_id, label: "Metavisão: vantagem em todas as esquivas até o fim da rodada" }));
}

export interface LearnCheckInput {
  def: TechniqueDef;
  originId: string | null;
  pathId: string | null;
  learned: string[];
  /** Atributos permanentes (base + classe + outros; sem bônus temporário). */
  attributes: Partial<Record<AttributeId, number>>;
  slotsAvailable: number;
}

export function learnErrors(i: LearnCheckInput): string[] {
  const errors: string[] = [];
  if (!isArsenal(i.originId, i.pathId)) errors.push("Só o Prodígio do Caminho do Arsenal aprende técnicas da lista.");
  if (i.learned.includes(i.def.id)) errors.push("Técnica já aprendida.");
  for (const [attr, min] of Object.entries(i.def.requires?.attributes ?? {})) {
    if ((i.attributes[attr as AttributeId] ?? 0) < (min as number)) errors.push(`Requer ${attr} ${min}+ (atual: ${i.attributes[attr as AttributeId] ?? 0}).`);
  }
  for (const t of i.def.requires?.techniques ?? []) {
    if (!i.learned.includes(t)) errors.push(`Requer a técnica ${TECHNIQUE_BY_ID[t]?.name ?? t}.`);
  }
  if (i.slotsAvailable <= 0) errors.push("Nenhuma técnica disponível para aprender neste nível (uma a cada nível par).");
  return errors;
}

/** Opções de ataque vindas de técnicas: passivas sempre; as de uso, só se disponíveis. */
export function techniqueAttackOptions(learned: LearnedTechnique[], level: number, uses: TechniqueUse[], tracker: TechniqueTracker) {
  return learned
    .filter((t) => !isSuspended(t, level))
    .map((t) => TECHNIQUE_BY_ID[t.technique_id])
    .filter((d): d is TechniqueDef => Boolean(d?.attack))
    .filter((d) => d.usage.kind === "passiva" || techniqueAvailability(d, uses, tracker).usable)
    .map((d) => ({ key: `tec:${d.id}`, label: d.attack!.label, source: "Técnica", consumes: d.usage.kind !== "passiva", def: d }));
}
