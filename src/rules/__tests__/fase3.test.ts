import { describe, it } from "node:test";
import assert from "node:assert/strict";
import {
  adjustWeaponDice,
  attackOptions,
  buildSheet,
  checkCreation,
  checkLendaCreation,
  checkSkillEdit,
  compatibleModifiers,
  computePowerCost,
  computeSkills,
  levelUnlocks,
  performAttack,
  planAttack,
  planPowerUse,
  powerLimits,
  rollPowerEffects,
  validateSkillDistribution,
  WEAPON_BY_ID,
  type AttributeMap,
  type Rng,
  type StoredForm,
  type WeaponLike,
} from "../index.ts";

function seq(values: number[]): Rng {
  let i = 0;
  return (sides) => {
    const v = values[i++ % values.length];
    if (v < 1 || v > sides) throw new Error(`valor ${v} fora de 1..${sides}`);
    return v;
  };
}

const ATTRS: AttributeMap = { FOR: 80, DEX: 50, INT: 60, CON: 45, MIT: 30, PER: 55, CAR: 40, VIG: 70 };
const skillsOf = (classId: string | null, points: Record<string, number> = {}, applyClass = true) =>
  Object.fromEntries(computeSkills({ baseAttributes: ATTRS, classId, skillPoints: points, applyClass }).map((s) => [s.id, s]));

describe("limite TOTAL das perícias (correção da Fase 3)", () => {
  it("Investigação (base 20) aceita no máximo 55 pontos", () => {
    const s = skillsOf(null);
    assert.equal(s.investigacao.maxPoints, 55);
    assert.equal(validateSkillDistribution({ investigacao: 55 }, null, { investigacao: 20 }).valid, true);
    assert.equal(validateSkillDistribution({ investigacao: 56 }, null, { investigacao: 20 }).valid, false);
  });
  it("Enganação (base 15) aceita no máximo 60", () => {
    assert.equal(skillsOf(null).enganacao.maxPoints, 60);
  });
  it("Luta com FOR 80 começa em 40 e aceita no máximo 35", () => {
    const s = skillsOf(null);
    assert.equal(s.luta.permanentBase, 40);
    assert.equal(s.luta.maxPoints, 35);
  });
  it("bônus de classe conta no limite (Atirador: 20 + 25 → máximo 30 pontos)", () => {
    const s = skillsOf("atirador");
    assert.equal(s.arma_de_fogo.classBonus, 25);
    assert.equal(s.arma_de_fogo.maxPoints, 30);
    const over = skillsOf("atirador", { arma_de_fogo: 31 });
    assert.equal(over.arma_de_fogo.overCap, true);
  });
  it("Brawler: +4 FOR aumenta a base de Luta e reduz o que pode ser investido", () => {
    assert.equal(skillsOf("brawler").luta.permanentBase, 42);
    assert.equal(skillsOf("brawler").luta.maxPoints, 33);
  });
  it("Detalhista: limite total 95 e 200 pontos", () => {
    const s = skillsOf("detalhista");
    assert.equal(s.investigacao.cap, 95);
    assert.equal(s.investigacao.maxPoints, 75);
    const d = validateSkillDistribution({ investigacao: 75, intuicao: 85, enganacao: 20, furtividade: 20 }, "detalhista", { investigacao: 20, intuicao: 10, enganacao: 15, furtividade: 20 });
    assert.equal(d.canFinalize, true, d.errors.join(" "));
    assert.equal(validateSkillDistribution({ investigacao: 76 }, "detalhista", { investigacao: 20 }).valid, false);
  });
  it("forma Lenda não herda o limite do Detalhista", () => {
    assert.equal(skillsOf("detalhista", {}, false).investigacao.cap, 75);
  });
  it("bônus temporário não conta para o limite", () => {
    const s = computeSkills({ baseAttributes: ATTRS, classId: null, skillPoints: { investigacao: 55 }, skillTemporary: { investigacao: 10 } });
    const inv = s.find((x) => x.id === "investigacao")!;
    assert.equal(inv.final, 85);
    assert.equal(inv.overCap, false);
  });
  it("edição: não deixa aumentar acima do limite, mas deixa reduzir valor antigo inválido", () => {
    const before = computeSkills({ baseAttributes: ATTRS, classId: null, skillPoints: { investigacao: 70 } });
    const worse = computeSkills({ baseAttributes: ATTRS, classId: null, skillPoints: { investigacao: 71 } });
    const better = computeSkills({ baseAttributes: ATTRS, classId: null, skillPoints: { investigacao: 60 } });
    assert.equal(checkSkillEdit(before, worse).length, 1);
    assert.equal(checkSkillEdit(before, better).length, 0);
    const ok = computeSkills({ baseAttributes: ATTRS, classId: null, skillPoints: { investigacao: 10 } });
    assert.equal(checkSkillEdit(ok, computeSkills({ baseAttributes: ATTRS, classId: null, skillPoints: { investigacao: 56 } })).length, 1);
  });
  it("criação bloqueia distribuição acima do limite total", () => {
    const attrs = Object.entries(ATTRS).map(([attribute, base_value]) => ({ attribute, base_value, other_bonus: 0, temp_bonus: 0 }));
    const form: StoredForm = {
      kind: "base", pv_current: 0, pc_current: 0, pv_other_bonus: 0, pc_other_bonus: 0, progressions: [], attributes: attrs,
      skills: [
        { skill_id: "luta", points: 75, other_bonus: 0, temp_bonus: 0 }, // 40 + 75 = 115 > 75
        { skill_id: "reflexo", points: 25, other_bonus: 0, temp_bonus: 0 },
        { skill_id: "pontaria", points: 25, other_bonus: 0, temp_bonus: 0 },
        { skill_id: "intuicao", points: 25, other_bonus: 0, temp_bonus: 0 },
      ],
    };
    const c = checkCreation({ classId: "tank", originId: "muto", originPathId: null, name: "X", playerName: "Y", form });
    assert.equal(c[3].complete, false);
    assert.match(c[3].errors.join(" "), /Luta: total 115/);
  });
});

const espada: WeaponLike = { name: "Espada curta", damage: "1d10", attackKind: "melee", tags: WEAPON_BY_ID.espada_curta.tags, modifiers: [] };
const ctx = { classId: null, originId: null, pathId: null, level: 1, skillValues: { luta: 70, pontaria: 40, arma_de_fogo: 60 } };

describe("ataques", () => {
  it("extremo ×1,5 com dados mostrados", () => {
    const r = performAttack(planAttack(espada, ctx), seq([8, 8]));
    assert.equal(r.test.outcome, "extreme");
    assert.equal(r.rolledDamage, 8);
    assert.equal(r.multiplier, 1.5);
    assert.equal(r.finalDamage, 12);
  });
  it("bom e normal não multiplicam; crítico ×2 sem somar o ×1,5", () => {
    assert.equal(performAttack(planAttack(espada, ctx), seq([30, 6])).multiplier, 1);
    const c = performAttack(planAttack(espada, ctx), seq([1, 6]));
    assert.equal(c.multiplier, 2);
    assert.equal(c.finalDamage, 12);
  });
  it("falha e falha crítica não causam dano", () => {
    const f = performAttack(planAttack(espada, ctx), seq([100]));
    assert.equal(f.finalDamage, 0);
    assert.match(f.note!, /Falha crítica/);
  });
  it("perícia por tipo: Luta / Pontaria / Arma de Fogo / perícia definida no item", () => {
    assert.equal(planAttack(espada, ctx).skillId, "luta");
    assert.equal(planAttack({ ...espada, attackKind: "ranged" }, ctx).skillId, "pontaria");
    assert.equal(planAttack({ ...espada, attackKind: "firearm" }, ctx).skillId, "arma_de_fogo");
    assert.equal(planAttack({ ...espada, skillOverride: "reflexo" }, ctx).skillId, "reflexo");
  });
  it("modificadores: Equilibrada +5 no ataque; Pesada −10 e +1d6", () => {
    const eq = planAttack({ ...espada, modifiers: ["equilibrada"] }, ctx);
    assert.equal(eq.rollModifier, -5);
    const grande: WeaponLike = { name: "Espada grande", damage: "2d8", attackKind: "melee", tags: WEAPON_BY_ID.espada_grande.tags, modifiers: ["pesada", "brutal"] };
    const p = planAttack(grande, ctx);
    assert.equal(p.rollModifier, 10);
    assert.equal(p.damageExpr, "2d8+1d6");
    assert.equal(p.criticalExpr, "3d8+1d6");
  });
  it("modificador incompatível é ignorado", () => {
    const p = planAttack({ ...espada, modifiers: ["rajada"] }, ctx);
    assert.equal(p.applied.length, 0);
  });
  it("opções situacionais só valem quando marcadas", () => {
    const rev: WeaponLike = { name: "Revólver", damage: "1d12+1d6", attackKind: "firearm", tags: WEAPON_BY_ID.revolver.tags, modifiers: ["rajada", "dispersao"] };
    assert.equal(planAttack(rev, ctx).damageExpr, "1d12+1d6");
    const p = planAttack(rev, { ...ctx, options: ["mod:rajada:rajada", "mod:dispersao:perto"] });
    assert.equal(p.damageExpr, "3d12+1d6");
    assert.equal(p.rollModifier, 10);
    assert.ok(attackOptions(rev, ctx).some((o) => o.key === "mod:dispersao:longe"));
  });
  it("Prodígio: +1 dado no nível 1, +2 no 5; Brawler +1d4 não acumula com Prodígio", () => {
    assert.equal(planAttack(espada, { ...ctx, originId: "prodigio" }).damageExpr, "2d10");
    assert.equal(planAttack(espada, { ...ctx, originId: "prodigio", level: 5 }).damageExpr, "3d10");
    assert.equal(planAttack(espada, { ...ctx, classId: "brawler" }).damageExpr, "1d10+1d4");
    assert.equal(planAttack(espada, { ...ctx, classId: "brawler", originId: "prodigio" }).damageExpr, "2d10");
  });
  it("Engrenagem: −15 no dado de ataque", () => {
    assert.equal(planAttack(espada, { ...ctx, originId: "prodigio", pathId: "engrenagem" }).rollModifier, -15);
  });
  it("ajuste de dados nunca fica abaixo de 1 dado", () => {
    assert.equal(adjustWeaponDice("1d12+1d6", -1), "1d12+1d6");
    assert.equal(adjustWeaponDice("2d8", -1), "1d8");
  });
  it("lista só modificadores compatíveis", () => {
    const ids = compatibleModifiers(WEAPON_BY_ID.foice_grande.tags).map((m) => m.id);
    for (const id of ["afiada", "serrilhada", "gancho", "pesada", "brutal", "equilibrada", "executora"]) assert.ok(ids.includes(id), id);
    assert.ok(!ids.includes("precisa"));
  });
});

describe("poderes", () => {
  it("custo automático e limites independentes de PC e de dados extras", () => {
    const ok = computePowerCost([{ type: "damage", tier: 2, extraDice: 1, area: "media" }], 3);
    assert.equal(ok.initial, 12 + 3 + 3);
    assert.equal(ok.limits.maxPc, 21);
    assert.equal(ok.valid, true);
    const tooMuchDice = computePowerCost([{ type: "damage", tier: 0, extraDice: 2, area: "alvo" }], 3);
    assert.equal(tooMuchDice.valid, false);
    assert.match(tooMuchDice.errors.join(" "), /dados extras/);
    assert.equal(powerLimits(5).maxPc, 27);
    assert.equal(powerLimits(5).maxExtraDice, 2);
  });
  it("uso rola só os dados de efeito, com bônus de classe/origem", () => {
    const plan = planPowerUse([{ type: "damage", tier: 1, extraDice: 0, area: "alvo" }, { type: "condition", intensity: "leve" }], { classId: "esoterico", originId: "amaldicoado", options: ["alvo_lenda"] });
    assert.equal(plan.effects.length, 1);
    assert.equal(plan.effects[0].expression, "2d6+1d6+1d6");
    const rolled = rollPowerEffects(plan, seq([1, 2, 3, 4]));
    assert.equal(rolled[0].roll.total, 10);
    const heal = planPowerUse([{ type: "heal", tier: 0, extraDice: 0, area: "alvo" }], { classId: "healer", originId: null });
    assert.equal(heal.effects[0].expression, "1d4+1d6");
  });
});

describe("evolução e Artificial", () => {
  const attrs = Object.entries(ATTRS).map(([attribute, base_value]) => ({ attribute, base_value, other_bonus: 0, temp_bonus: 0 }));
  it("forma Lenda: recursos próprios, sem bônus de classe", () => {
    const lenda: StoredForm = { kind: "lenda", pv_current: 0, pc_current: 0, pv_other_bonus: 0, pc_other_bonus: 0, attributes: attrs, skills: [], progressions: [{ level: 2, pv_gain: 5, pc_gain: 3 }] };
    const base = { ...lenda, kind: "base" as const, progressions: [] };
    assert.equal(buildSheet({ classId: "tank", originId: "artificial", level: 2, form: lenda }).resources.pvMax, 95 + 5);
    assert.equal(buildSheet({ classId: "tank", originId: "artificial", level: 2, form: base }).resources.pvMax, 115);
  });
  it("assistente da Lenda: sem origem e classe; exige atributos, perícias e nome", () => {
    const form: StoredForm = { kind: "lenda", pv_current: 0, pc_current: 0, pv_other_bonus: 0, pc_other_bonus: 0, attributes: attrs, skills: [
      { skill_id: "investigacao", points: 55, other_bonus: 0, temp_bonus: 0 },
      { skill_id: "enganacao", points: 60, other_bonus: 0, temp_bonus: 0 },
      { skill_id: "intuicao", points: 30, other_bonus: 0, temp_bonus: 0 },
      { skill_id: "pilotagem", points: 5, other_bonus: 0, temp_bonus: 0 },
    ], progressions: [] };
    const c = checkLendaCreation({ name: "Boitatá", form, level: 1 });
    assert.ok(c.every((x) => x.complete), JSON.stringify(c));
    assert.equal(checkLendaCreation({ name: "", form, level: 1 })[2].complete, false);
  });
  it("desbloqueios por nível", () => {
    assert.match(levelUnlocks("muto", null, 4)[0].value, /até 4/);
    assert.match(levelUnlocks("remanescente", null, 6)[2].value, /libera no nível 7/);
    assert.match(levelUnlocks("prodigio", "arsenal", 6)[1].value, /3 técnica/);
  });
});
