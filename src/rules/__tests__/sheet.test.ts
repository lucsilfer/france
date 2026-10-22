import { describe, it } from "node:test";
import assert from "node:assert/strict";
import { buildSheet, checkCreation, maxReachableStep, originTraitsWithStatus, type StoredForm, type CreationState } from "../index.ts";

const attrs = (vals: Record<string, number | null>) =>
  Object.entries(vals).map(([attribute, base_value]) => ({ attribute, base_value, other_bonus: 0, temp_bonus: 0 }));

const FULL = { FOR: 80, DEX: 50, INT: 60, CON: 45, MIT: 30, PER: 55, CAR: 40, VIG: 70 };

function form(over: Partial<StoredForm> = {}): StoredForm {
  return { kind: "base", pv_current: 0, pc_current: 0, pv_other_bonus: 0, pc_other_bonus: 0, attributes: attrs(FULL), skills: [], progressions: [], ...over };
}

describe("ficha calculada", () => {
  it("aplica classe, perícias e recursos", () => {
    const s = buildSheet({ classId: "brawler", originId: "muto", level: 1, form: form({ skills: [{ skill_id: "luta", points: 30, other_bonus: 0, temp_bonus: 0 }] }) });
    assert.equal(s.attributes.FOR.final, 84);
    assert.equal(s.skills.find((x) => x.id === "luta")!.final, 42 + 30);
    assert.equal(s.resources.pvMax, 84 + 15);
    assert.equal(s.resources.pcMax, 23);
    assert.deepEqual(s.missingAttributes, []);
  });
  it("bônus temporário não altera o valor-base", () => {
    const f = form();
    f.attributes[0].temp_bonus = 10;
    const s = buildSheet({ classId: null, originId: null, level: 1, form: f });
    assert.equal(s.attributes.FOR.base, 80);
    assert.equal(s.attributes.FOR.final, 90);
    assert.equal(s.skills.find((x) => x.id === "luta")!.final, 45);
  });
  it("ganhos de nível só contam até o nível atual", () => {
    const f = form({ progressions: [{ level: 2, pv_gain: 7, pc_gain: 4 }, { level: 3, pv_gain: 5, pc_gain: 2 }], pv_other_bonus: 3 });
    assert.equal(buildSheet({ classId: null, originId: null, level: 2, form: f }).resources.pvMax, 95 + 7 + 3);
    assert.equal(buildSheet({ classId: null, originId: null, level: 1, form: f }).resources.pcMax, 23);
  });
  it("forma Lenda não recebe bônus de classe", () => {
    const s = buildSheet({ classId: "tank", originId: "artificial", level: 1, form: form({ kind: "lenda" }) });
    assert.equal(s.resources.pvMax, 95);
  });
  it("lista atributos faltantes", () => {
    const s = buildSheet({ classId: null, originId: null, level: 1, form: form({ attributes: attrs({ FOR: 80, DEX: null }) }) });
    assert.equal(s.missingAttributes.length, 7);
  });
});

describe("criação por etapas", () => {
  const complete: CreationState = {
    classId: "brawler",
    originId: "prodigio",
    originPathId: "arsenal",
    name: "Iara",
    playerName: "Luciano",
    form: form({
      skills: [
        // Brawler: Luta 42 (+33 = 75), Reflexo 25 (+50 = 75), Pontaria 25 (+50 = 75), Intuição 10 (+17)
        { skill_id: "luta", points: 33, other_bonus: 0, temp_bonus: 0 },
        { skill_id: "reflexo", points: 50, other_bonus: 0, temp_bonus: 0 },
        { skill_id: "pontaria", points: 50, other_bonus: 0, temp_bonus: 0 },
        { skill_id: "intuicao", points: 17, other_bonus: 0, temp_bonus: 0 },
      ],
    }),
  };
  it("personagem completo pode finalizar", () => {
    const c = checkCreation(complete);
    assert.ok(c.every((s) => s.complete), JSON.stringify(c));
    assert.equal(maxReachableStep(c), 6);
  });
  it("Prodígio exige Caminho", () => {
    const c = checkCreation({ ...complete, originPathId: null });
    assert.equal(c[1].complete, false);
    assert.equal(maxReachableStep(c), 2);
  });
  it("origem sem caminho não aceita caminho", () => {
    assert.equal(checkCreation({ ...complete, originId: "muto", originPathId: "arsenal" })[1].complete, false);
  });
  it("trocar para Detalhista invalida a distribuição de 150 (faltam 50)", () => {
    const c = checkCreation({ ...complete, classId: "detalhista" });
    assert.equal(c[3].complete, false);
    assert.match(c[3].errors.join(" "), /restam 50/);
  });
  it("sem atributos não passa da etapa 1", () => {
    const c = checkCreation({ ...complete, form: form({ attributes: [] }) });
    assert.equal(maxReachableStep(c), 1);
  });
  it("traços de origem marcam nível de liberação", () => {
    const t = originTraitsWithStatus("muto", null, 3);
    assert.equal(t.traits.find((x) => x.name === "Evolução de Partes")!.unlocked, false);
    assert.equal(originTraitsWithStatus("muto", null, 5).traits.find((x) => x.name === "Evolução de Partes")!.unlocked, true);
    assert.ok(originTraitsWithStatus("prodigio", "pacto", 1).traits.some((x) => x.name === "Mestre de Selos"));
  });
});
