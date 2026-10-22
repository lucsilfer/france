import { describe, it } from "node:test";
import assert from "node:assert/strict";
import {
  CLASSES,
  ORIGINS,
  WEAPONS,
  addDice,
  activeGains,
  baseResources,
  classifyD100,
  compatibleModifiers,
  computeAttributes,
  computePowerCost,
  computeSkills,
  cryptoRng,
  diceRange,
  finalAttributes,
  formatThresholds,
  levelDice,
  missingLevels,
  parseDice,
  powerLimits,
  prodigioExtraWeaponDice,
  resolveAttack,
  rollAttributeSet,
  rollExpression,
  rollLevelGain,
  thresholds,
  validateAttributeAssignment,
  validateSkillDistribution,
  canSpend,
  WEAPON_BY_ID,
  LEVEL_POWER_TABLE,
  type AttributeMap,
  type Rng,
} from "../index.ts";

/** RNG determinístico: devolve os valores na ordem (limitados às faces). */
function seq(values: number[]): Rng {
  let i = 0;
  return (sides) => {
    const v = values[i++ % values.length];
    if (v < 1 || v > sides) throw new Error(`valor ${v} fora de 1..${sides}`);
    return v;
  };
}

const ATTRS: AttributeMap = { FOR: 80, DEX: 50, INT: 60, CON: 45, MIT: 30, PER: 55, CAR: 40, VIG: 70 };

describe("dados", () => {
  it("interpreta expressões válidas", () => {
    assert.deepEqual(parseDice("2d8+3").terms, [
      { sign: 1, count: 2, sides: 8 },
      { sign: 1, count: 0, sides: 0, value: 3 },
    ]);
    assert.equal(parseDice("1d12+1d6").terms.length, 2);
    assert.equal(parseDice("d100").terms[0].count, 1);
    assert.equal(parseDice(" 3d6 - 2 ").terms[1].sign, -1);
  });
  it("rejeita expressões inválidas ou perigosas", () => {
    for (const bad of ["", "abc", "2d", "d1", "1d6;alert(1)", "1d6++2", "1d6 2", "1000d6", "1d99999", "process.exit()"]) {
      assert.throws(() => parseDice(bad), `deveria rejeitar "${bad}"`);
    }
  });
  it("rola e soma corretamente", () => {
    const r = rollExpression("2d8+3", seq([5, 7]));
    assert.equal(r.total, 15);
    assert.equal(rollExpression("1d12+1d6-2", seq([12, 1])).total, 11);
  });
  it("calcula faixas", () => {
    assert.deepEqual(diceRange("2d8+3"), { min: 5, max: 19 });
    assert.deepEqual(diceRange("1d6-2"), { min: -1, max: 4 });
  });
  it("adiciona dados extras", () => {
    assert.equal(addDice("2d8", 1), "3d8");
    assert.equal(addDice("1d6+2", 2, "1d6"), "1d6+2+2d6");
    assert.equal(addDice("2d12+6", 1, "1d8"), "2d12+6+1d8");
  });
  it("RNG criptográfico fica dentro das faces", () => {
    for (let i = 0; i < 2000; i++) {
      const v = cryptoRng(100);
      assert.ok(v >= 1 && v <= 100);
    }
  });
});

describe("atributos", () => {
  it("rola 3 × 3d6×5 e destaca o maior", () => {
    const r = rollAttributeSet(seq([3, 4, 4, 3, 3, 3, 6, 5, 5]));
    assert.deepEqual(r.results.map((x) => x.value), [55, 45, 80]);
    assert.equal(r.bestIndex, 2);
    assert.equal(r.best, 80);
  });
  it("valores sempre entre 15 e 90", () => {
    for (let i = 0; i < 300; i++) for (const x of rollAttributeSet().results) assert.ok(x.value >= 15 && x.value <= 90 && x.value % 5 === 0);
  });
  it("limiares 80 / 40 / 16", () => {
    assert.deepEqual(thresholds(80), { normal: 80, good: 40, extreme: 16 });
    assert.equal(formatThresholds(70), "70 / 35 / 14");
    assert.equal(formatThresholds(47), "47 / 23 / 9");
  });
  it("bônus de classe é reversível e não acumula", () => {
    const eso = computeAttributes({ baseAttributes: ATTRS, classId: "esoterico" });
    assert.equal(eso.MIT.final, 34);
    assert.equal(eso.FOR.final, 80);
    const bra = computeAttributes({ baseAttributes: ATTRS, classId: "brawler" });
    assert.equal(bra.MIT.final, 30);
    assert.equal(bra.FOR.final, 84);
    assert.equal(bra.FOR.base, 80);
    assert.equal(bra.FOR.classBonus, 4);
  });
  it("forma Lenda do Artificial não recebe bônus de classe", () => {
    const l = computeAttributes({ baseAttributes: ATTRS, classId: "brawler", applyClass: false });
    assert.equal(l.FOR.final, 80);
  });
  it("não deixa reutilizar rolagem nem atributo", () => {
    assert.equal(validateAttributeAssignment([{ rollId: "a", attribute: "FOR" }, { rollId: "a", attribute: "DEX" }]).valid, false);
    assert.equal(validateAttributeAssignment([{ rollId: "a", attribute: "FOR" }, { rollId: "b", attribute: "FOR" }]).valid, false);
  });
});

describe("d100", () => {
  it("classifica com prioridade correta", () => {
    assert.equal(classifyD100(1, 0), "critical_success");
    assert.equal(classifyD100(100, 200), "critical_failure");
    assert.equal(classifyD100(14, 80), "extreme");
    assert.equal(classifyD100(16, 80), "extreme");
    assert.equal(classifyD100(17, 80), "good");
    assert.equal(classifyD100(40, 80), "good");
    assert.equal(classifyD100(80, 80), "normal");
    assert.equal(classifyD100(81, 80), "failure");
  });
  it("reproduz a tabela do livro (50/25/10)", () => {
    assert.equal(classifyD100(99, 50), "failure");
    assert.equal(classifyD100(51, 50), "failure");
    assert.equal(classifyD100(50, 50), "normal");
    assert.equal(classifyD100(26, 50), "normal");
    assert.equal(classifyD100(25, 50), "good");
    assert.equal(classifyD100(11, 50), "good");
    assert.equal(classifyD100(10, 50), "extreme");
    assert.equal(classifyD100(2, 50), "extreme");
  });
  it("modificador de rolagem (−15 ajuda)", () => {
    assert.equal(classifyD100(30, 50, -15), "good");
    assert.equal(classifyD100(45, 50, 10), "failure");
  });
  it("rejeita valores fora de 1..100", () => {
    assert.throws(() => classifyD100(0, 50));
    assert.throws(() => classifyD100(101, 50));
  });
});

describe("recursos e perícias", () => {
  it("PV = (FOR + CON)÷3 e PC = VIG÷3 (para baixo)", () => {
    const r = baseResources(ATTRS, null);
    assert.equal(r.pv, Math.floor((80 + 45) / 3)); // 41 — nunca FOR + CON÷3 (= 95)
    assert.equal(r.pc, 23);
  });
  it("Tank recebe +20 PV no nível 1; Brawler muda PV via FOR", () => {
    assert.equal(baseResources(ATTRS, "tank").pv, 41 + 20);
    const f = finalAttributes(computeAttributes({ baseAttributes: ATTRS, classId: "brawler" }));
    assert.equal(baseResources(f, "brawler").pv, Math.floor((84 + 45) / 3));
  });
  it("perícias derivadas acompanham atributos", () => {
    const s = Object.fromEntries(computeSkills({ baseAttributes: ATTRS, classId: null, skillPoints: { luta: 30 } }).map((x) => [x.id, x]));
    assert.equal(s.luta.base, 40);
    assert.equal(s.luta.final, 70);
    assert.equal(s.reflexo.final, 25);
    assert.equal(s.conhecimento_belico.final, 30);
    assert.equal(s.pilotagem.final, 5);
    const b = Object.fromEntries(computeSkills({ baseAttributes: ATTRS, classId: "brawler", skillPoints: { luta: 30 } }).map((x) => [x.id, x]));
    assert.equal(b.luta.final, 72);
  });
  it("bônus de classe em perícia fica separado dos pontos", () => {
    const s = computeSkills({ baseAttributes: ATTRS, classId: "atirador", skillPoints: {} }).find((x) => x.id === "arma_de_fogo")!;
    assert.equal(s.points, 0);
    assert.equal(s.classBonus, 25);
    assert.equal(s.final, 45);
  });
  it("valida distribuição padrão: 4 perícias, 150 pontos, máx 75", () => {
    assert.equal(validateSkillDistribution({ luta: 75, reflexo: 25, pontaria: 25, intuicao: 25 }).canFinalize, true);
    assert.equal(validateSkillDistribution({ luta: 76, reflexo: 74 }).valid, false);
    assert.equal(validateSkillDistribution({ luta: 50, reflexo: 50, pontaria: 25, intuicao: 20, pilotagem: 5 }).valid, false);
    const partial = validateSkillDistribution({ luta: 50 });
    assert.equal(partial.valid, true);
    assert.equal(partial.canFinalize, false);
    assert.equal(partial.remaining, 100);
  });
  it("Detalhista: 200 pontos e máximo 95", () => {
    const ok = validateSkillDistribution({ investigacao: 95, intuicao: 95, enganacao: 5, furtividade: 5 }, "detalhista");
    assert.equal(ok.canFinalize, true);
    assert.equal(ok.budget.totalPoints, 200);
    assert.equal(validateSkillDistribution({ investigacao: 96 }, "detalhista").valid, false);
  });
});

describe("progressão de nível", () => {
  it("usa dados da classe e prioriza Prodígio", () => {
    assert.deepEqual(levelDice("brawler", "muto"), { pv: "1d10", pc: "1d6", source: "Classe: Brawler" });
    assert.deepEqual(levelDice("esoterico", null).pc, "1d12");
    const p = levelDice("esoterico", "prodigio");
    assert.equal(p.pv, "1d12+2");
    assert.equal(p.pc, null);
  });
  it("todas as classes têm dados válidos", () => {
    for (const c of CLASSES) {
      parseDice(c.progression.pv);
      parseDice(c.progression.pc);
    }
  });
  it("nunca rola de novo um nível registrado", () => {
    assert.deepEqual(missingLevels([], 5), [2, 3, 4, 5]);
    assert.deepEqual(missingLevels([2, 3], 5), [4, 5]);
    assert.deepEqual(missingLevels([2, 3, 4, 5], 2), []);
    assert.throws(() => missingLevels([], 21));
  });
  it("descer de nível desativa sem apagar; subir reaproveita", () => {
    const recorded = [
      { level: 2, pvGain: 7, pcGain: 4 },
      { level: 3, pvGain: 5, pcGain: 2 },
    ];
    assert.deepEqual(activeGains(recorded, 3), { pv: 12, pc: 6 });
    assert.deepEqual(activeGains(recorded, 1), { pv: 0, pc: 0 });
    assert.deepEqual(activeGains(recorded, 2), { pv: 7, pc: 4 });
  });
  it("Prodígio rola só PV (1d12+2)", () => {
    const g = rollLevelGain(2, levelDice("tank", "prodigio"), seq([10]));
    assert.equal(g.pvGain, 12);
    assert.equal(g.pcGain, 0);
    assert.equal(g.pcRoll, null);
  });
  it("limite de PC linear (15 + 3×(nível−1)) e dados extras por patamar", () => {
    assert.deepEqual(powerLimits(1), { maxPc: 15, maxExtraDice: 1 });
    assert.deepEqual(powerLimits(3), { maxPc: 21, maxExtraDice: 1 });
    assert.deepEqual(powerLimits(9), { maxPc: 39, maxExtraDice: 4 });
    assert.deepEqual(powerLimits(14), { maxPc: 54, maxExtraDice: 5 });
    assert.deepEqual(powerLimits(20), { maxPc: 72, maxExtraDice: 10 });
  });
  it("a fórmula linear coincide com todos os pontos da tabela do livro", () => {
    for (const row of LEVEL_POWER_TABLE) assert.equal(powerLimits(row.level).maxPc, row.maxPc);
  });
  it("Combatente de Guerra cresce a cada 5 níveis", () => {
    assert.equal(prodigioExtraWeaponDice(1), 1);
    assert.equal(prodigioExtraWeaponDice(4), 1);
    assert.equal(prodigioExtraWeaponDice(5), 2);
    assert.equal(prodigioExtraWeaponDice(10), 3);
  });
});

describe("criador de poderes", () => {
  it("dano contra 1 alvo segue a tabela", () => {
    for (const [tier, cost] of [[0, 3], [1, 6], [2, 9], [3, 12], [4, 15]]) {
      assert.equal(computePowerCost([{ type: "damage", tier, extraDice: 0, area: "alvo" }], 1).initial, cost);
    }
  });
  it("dano em área soma tabela própria e tamanho", () => {
    const c = computePowerCost([{ type: "damage", tier: 0, extraDice: 0, area: "grande" }], 4);
    assert.equal(c.initial, 6 + 6);
    assert.equal(c.valid, true);
  });
  it("dados extras custam +3 e respeitam o limite do nível", () => {
    const ok = computePowerCost([{ type: "damage", tier: 1, extraDice: 1, area: "alvo" }], 1);
    assert.equal(ok.initial, 9);
    assert.equal(ok.components[0].dice, "3d6");
    const tooMany = computePowerCost([{ type: "damage", tier: 0, extraDice: 2, area: "alvo" }], 1);
    assert.equal(tooMany.valid, false);
  });
  it("bloqueia custo acima do limite", () => {
    const c = computePowerCost([{ type: "damage", tier: 4, extraDice: 1, area: "alvo" }], 1);
    assert.equal(c.initial, 18);
    assert.equal(c.valid, false);
    assert.ok(c.errors[0].includes("15 PC"));
    assert.equal(computePowerCost([{ type: "damage", tier: 4, extraDice: 1, area: "alvo" }], 2).valid, true);
  });
  it("cura, cura em área, contínua e escudo", () => {
    assert.equal(computePowerCost([{ type: "heal", tier: 1, extraDice: 0, area: "media" }], 2).initial, 6 + 9);
    const cont = computePowerCost([{ type: "heal_continuous", tier: 2 }], 1);
    assert.equal(cont.initial, 0);
    assert.equal(cont.perTurn, 4);
    const sh = computePowerCost([{ type: "shield", tier: 2, extraDice: 1, duration: "cena" }], 6);
    assert.equal(sh.initial, 9 + 3 + 6);
    assert.equal(sh.components[0].dice, "2d8+4+1d8");
  });
  it("condições e melhorias têm custo inicial e por turno", () => {
    const c = computePowerCost([{ type: "condition", intensity: "severa" }, { type: "buff", buff: "teste_1" }], 2);
    assert.equal(c.initial, 15);
    assert.equal(c.perTurn, 5);
  });
  it("Amaldiçoado paga metade e ganha +1d6 a cada 2 dados", () => {
    const c = computePowerCost([{ type: "damage", tier: 2, extraDice: 0, area: "alvo" }], 1, "amaldicoado");
    assert.equal(c.fullInitial, 9);
    assert.equal(c.initial, 5);
    assert.equal(c.bonusDamageDice, "1d6");
  });
  it("rejeita entradas inválidas sem quebrar", () => {
    const c = computePowerCost([{ type: "damage", tier: 9, extraDice: 0, area: "alvo" }], 1);
    assert.equal(c.valid, false);
    assert.equal(computePowerCost([], 1).valid, false);
  });
  it("gasto de PC", () => {
    assert.equal(canSpend(10, 9), true);
    assert.equal(canSpend(8, 9), false);
    assert.equal(canSpend(8, -1), false);
  });
});

describe("ataque", () => {
  const skills = { luta: 70, pontaria: 40, arma_de_fogo: 60 };
  it("acerto extremo multiplica dano por 1,5", () => {
    const r = resolveAttack({ name: "Espada curta", damage: "1d10", attackKind: "melee", skillValues: skills, rng: seq([8, 7]) });
    assert.equal(r.skillId, "luta");
    assert.equal(r.test.outcome, "extreme");
    assert.equal(r.finalDamage, 10.5);
  });
  it("crítico dobra, falha não causa dano", () => {
    assert.equal(resolveAttack({ name: "x", damage: "1d10", attackKind: "melee", skillValues: skills, rng: seq([1, 6]) }).finalDamage, 12);
    const miss = resolveAttack({ name: "x", damage: "1d10", attackKind: "melee", skillValues: skills, rng: seq([95]) });
    assert.equal(miss.hit, false);
    assert.equal(miss.finalDamage, 0);
  });
  it("longa distância usa Pontaria; armas de fogo usam Arma de Fogo", () => {
    assert.equal(resolveAttack({ name: "Arco", damage: "1d8", attackKind: "ranged", skillValues: skills, rng: seq([30, 3]) }).skillId, "pontaria");
    const gun = resolveAttack({ name: "Revólver", damage: "1d12+1d6", attackKind: "firearm", skillValues: skills, rng: seq([55, 5, 5]) });
    assert.equal(gun.skillId, "arma_de_fogo");
    assert.equal(gun.test.outcome, "normal"); // 55 erraria com Pontaria (40), acerta com Arma de Fogo (60)
    assert.equal(gun.finalDamage, 10);
  });
});

describe("dados do livro", () => {
  it("9 origens e 9 classes", () => {
    assert.equal(ORIGINS.length, 9);
    assert.equal(CLASSES.length, 9);
    assert.equal(ORIGINS.find((o) => o.id === "prodigio")!.paths!.length, 3);
  });
  it("todas as armas têm dano válido", () => {
    for (const w of WEAPONS) parseDice(w.damage);
  });
  it("modificadores compatíveis por categoria", () => {
    const ids = compatibleModifiers(WEAPON_BY_ID.espada_curta.tags).map((m) => m.id);
    assert.ok(ids.includes("afiada"));
    assert.ok(!ids.includes("rajada"));
    const gun = compatibleModifiers(WEAPON_BY_ID.revolver.tags).map((m) => m.id);
    assert.ok(gun.includes("rajada"));
    assert.ok(!gun.includes("afiada"));
  });
});
