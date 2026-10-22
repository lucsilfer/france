import { describe, it } from "node:test";
import assert from "node:assert/strict";
import {
  TECHNIQUES,
  TECHNIQUE_BY_ID,
  abilityStatus,
  activeTechniqueEffects,
  isSuspended,
  learnErrors,
  planAttack,
  techniqueAttackOptions,
  techniqueAvailability,
  usageLabel,
  type TechniqueUse,
} from "../index.ts";

const T = (id: string) => TECHNIQUE_BY_ID[id];
const tracker = { scene: 3, session: 1, turn: 5 };
let seq = 0;
const use = (technique_id: string, over: Partial<TechniqueUse> = {}): TechniqueUse => ({ id: ++seq, technique_id, scene: 3, session: 1, turn: 5, ...over });

describe("catálogo de técnicas do livro", () => {
  it("11 técnicas, Recobrar-se uma vez só", () => {
    assert.equal(TECHNIQUES.length, 11);
    assert.equal(TECHNIQUES.filter((t) => t.name === "Recobrar-se").length, 1);
    for (const n of ["Arte do Desarme", "Arte do Contra-ataque", "Provocação", "Múltiplos Alvos", "Múltiplos Golpes", "Adrenalina", "Metavisão", "Recobrar-se", "Passos Leves", "Furtividade Rápida", "Ataque Furtivo"])
      assert.ok(TECHNIQUES.some((t) => t.name === n), n);
  });
  it("limites de uso como no livro", () => {
    assert.equal(usageLabel(T("arte_desarme").usage), "1× por cena");
    assert.equal(usageLabel(T("multiplos_golpes").usage), "1× a cada 2 turnos");
    assert.equal(usageLabel(T("recobrar_se").usage), "1× por sessão");
    assert.equal(T("passos_leves").usage.kind, "passiva");
    assert.equal(T("ataque_furtivo").usage.kind, "passiva");
    assert.equal(T("adrenalina").usage.kind, "acao");
  });
});

describe("aprender técnicas", () => {
  const base = { originId: "prodigio", pathId: "arsenal", learned: [] as string[], attributes: { DEX: 60 }, slotsAvailable: 1 };
  it("só o Arsenal aprende", () => {
    assert.ok(learnErrors({ ...base, def: T("provocacao"), pathId: "pacto" }).length > 0);
    assert.equal(learnErrors({ ...base, def: T("provocacao") }).length, 0);
  });
  it("requisitos: Furtividade Rápida exige DEX 70+ e Passos Leves", () => {
    const e = learnErrors({ ...base, def: T("furtividade_rapida") });
    assert.equal(e.length, 2);
    assert.equal(learnErrors({ ...base, def: T("furtividade_rapida"), attributes: { DEX: 70 }, learned: ["passos_leves"] }).length, 0);
  });
  it("sem vaga e repetida são recusadas", () => {
    assert.ok(learnErrors({ ...base, def: T("provocacao"), slotsAvailable: 0 }).length > 0);
    assert.ok(learnErrors({ ...base, def: T("provocacao"), learned: ["provocacao"] }).length > 0);
  });
  it("Arsenal: 1 técnica por nível par; técnicas e poderes dividem as vagas", () => {
    assert.equal(abilityStatus({ level: 1, originId: "prodigio", pathId: "arsenal", created: 0 }).granted, 0);
    assert.equal(abilityStatus({ level: 6, originId: "prodigio", pathId: "arsenal", created: 2 }).available, 1);
  });
  it("aprendida acima do nível atual fica suspensa (sem apagar)", () => {
    assert.equal(isSuspended({ technique_id: "provocacao", learned_level: 4 }, 2), true);
    assert.equal(isSuspended({ technique_id: "provocacao", learned_level: 4 }, 4), false);
  });
});

describe("uso durante o jogo", () => {
  it("1× por cena; nova cena libera", () => {
    assert.equal(techniqueAvailability(T("provocacao"), [], tracker).usable, true);
    assert.equal(techniqueAvailability(T("provocacao"), [use("provocacao")], tracker).usable, false);
    assert.equal(techniqueAvailability(T("provocacao"), [use("provocacao", { scene: 2 })], tracker).usable, true);
  });
  it("Adrenalina recarrega as técnicas por cena", () => {
    const uses = [use("provocacao"), use("adrenalina")];
    assert.equal(techniqueAvailability(T("provocacao"), uses, tracker).usable, true);
    assert.equal(techniqueAvailability(T("provocacao"), [...uses, use("provocacao")], tracker).usable, false);
  });
  it("Múltiplos Golpes: 1× a cada 2 turnos", () => {
    const uses = [use("multiplos_golpes", { turn: 4 })];
    const a = techniqueAvailability(T("multiplos_golpes"), uses, tracker);
    assert.equal(a.usable, false);
    assert.match(a.reason!, /turno 6/);
    assert.equal(techniqueAvailability(T("multiplos_golpes"), uses, { ...tracker, turn: 6 }).usable, true);
  });
  it("Recobrar-se: 1× por sessão (nova cena não libera)", () => {
    const uses = [use("recobrar_se", { scene: 1 })];
    assert.equal(techniqueAvailability(T("recobrar_se"), uses, tracker).usable, false);
    assert.equal(techniqueAvailability(T("recobrar_se"), uses, { ...tracker, session: 2 }).usable, true);
  });
  it("passivas não viram botão", () => {
    assert.equal(techniqueAvailability(T("passos_leves"), [], tracker).usable, false);
  });
  it("Metavisão: vantagem nas esquivas até o fim da rodada", () => {
    const uses = [use("metavisao")];
    assert.equal(activeTechniqueEffects(uses, tracker).length, 1);
    assert.equal(activeTechniqueEffects(uses, { ...tracker, turn: 6 }).length, 0);
  });
  it("ataque: Desarme (+1 dado, consome) e Ataque Furtivo (passiva, +1d8)", () => {
    const learned = [{ technique_id: "arte_desarme", learned_level: 2 }, { technique_id: "ataque_furtivo", learned_level: 4 }];
    const opts = techniqueAttackOptions(learned, 4, [], tracker);
    assert.deepEqual(opts.map((o) => o.key).sort(), ["tec:arte_desarme", "tec:ataque_furtivo"]);
    assert.equal(opts.find((o) => o.key === "tec:ataque_furtivo")!.consumes, false);
    assert.equal(techniqueAttackOptions(learned, 4, [use("arte_desarme")], tracker).length, 1, "desarme já usado na cena");
    assert.equal(techniqueAttackOptions(learned, 2, [], tracker).length, 1, "técnica do nível 4 suspensa no nível 2");
    const weapon = { name: "Espada curta", damage: "1d10", attackKind: "melee" as const, tags: [], modifiers: [] };
    const plan = planAttack(weapon, {
      classId: "lider",
      originId: "prodigio",
      pathId: "arsenal",
      level: 4,
      skillValues: { luta: 50 },
      options: ["tec:arte_desarme", "tec:ataque_furtivo"],
      allowedTechniques: ["arte_desarme", "ataque_furtivo"],
    });
    // Combatente de Guerra (+1 no nível 4) + Desarme (+1) = 3d10; Ataque Furtivo +1d8
    assert.equal(plan.damageExpr, "3d10+1d8");
    const notAllowed = planAttack(weapon, { classId: "lider", originId: "prodigio", pathId: "arsenal", level: 4, skillValues: {}, options: ["tec:arte_desarme"], allowedTechniques: [] });
    assert.equal(notAllowed.damageExpr, "2d10", "técnica não liberada é ignorada");
  });
});
